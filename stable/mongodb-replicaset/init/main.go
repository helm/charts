/*
Copyright 2017 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// A small utility program to get the external hostnames in a set of services.
package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"sort"
	"strings"
	"text/template"
	"time"

	"bytes"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/sets"
	"k8s.io/client-go/kubernetes"
	v1 "k8s.io/client-go/pkg/api/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

const (
	pollPeriod = 1 * time.Second
)

var (
	onChange         = flag.String("on-change", "", "Script to run on change, must accept a new line separated list of peers via stdin.")
	onStart          = flag.String("on-start", "", "Script to run on start, must accept a new line separated list of peers via stdin.")
	selector         = flag.String("selector", "", "Selector to get the set of services ")
	namespace        = flag.String("ns", "", "The namespace this pod is running in. If unspecified, the POD_NAMESPACE env var is used.")
	kubeconfig       = flag.String("kubeconfig", "", "Path to a kubeconfig file")
	coreDNSConfigMap = flag.String("coredns-configmap", "", "Path to a kubeconfig file")
)

type hostDetails struct {
	PrivateHostname string
	PublicHostname  string
	port            int32
}

func getClientConfig(kubeconfig string) (*rest.Config, error) {
	if kubeconfig != "" {
		return clientcmd.BuildConfigFromFlags("", kubeconfig)
	}
	return rest.InClusterConfig()
}

func shellOut(sendStdin, script string) {
	log.Printf("execing: %v with stdin: %v", script, sendStdin)
	// TODO: Switch to sending stdin from go
	out, err := exec.Command("bash", "-c", fmt.Sprintf("echo -e '%v' | %v", sendStdin, script)).CombinedOutput()
	if err != nil {
		log.Fatalf("Failed to execute %v: %v, err: %v", script, string(out), err)
	}
	log.Print(string(out))
}

func main() {

	var hosts []hostDetails
	// When running as a pod in-cluster, a kubeconfig is not needed. Instead this will make use of the service account injected into the pod.
	// However, allow the use of a local kubeconfig as this can make local development & testing easier.

	// We log to stderr because glog will default to logging to a file.
	// By setting this debugging is easier via `kubectl logs`
	flag.Set("logtostderr", "true")
	flag.Parse()

	// Build the client config - optionally using a provided kubeconfig file.
	config, err := getClientConfig(*kubeconfig)
	if err != nil {
		log.Fatalf("Failed to load client config: %v", err)
	}

	// Construct the Kubernetes client
	client, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatalf("Failed to create kubernetes client: %v", err)
	}

	ns := *namespace
	if ns == "" && len(os.Getenv("POD_NAMESPACE")) > 0 {
		ns = os.Getenv("POD_NAMESPACE")
	} else if ns == "" {
		log.Fatalf("Incomplete args, require -ns flag or POD_NAMESPACE env var")
	}

	cm := *coreDNSConfigMap
	if cm == "" {
		log.Fatalf("Incomplete args, require -namespace flag")
	}

	if *selector == "" || (*onChange == "" && *onStart == "") {
		log.Fatalf("Incomplete args, require -on-change and/or -on-start, -selector")
	}

	script := *onStart
	if script == "" {
		script = *onChange
		log.Printf("No on-start supplied, on-change %v will be applied on start.", script)
	}

	for newPeers, peers := sets.NewString(), sets.NewString(); script != ""; time.Sleep(pollPeriod) {
		configmapContents := ""
		services, err := servicesByLabel(client, *namespace, *selector)
		if err != nil {
			log.Printf("I could not find services with the selector %s. I am assuming they are not ready yet", *selector)
			log.Printf("%v", err)
			continue
		}

		nodes, err := nodes(client)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		hosts, err = hostsInfo(nodes, services)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		newPeers, err = publicHostnames(hosts)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		peerList := newPeers.List()
		sort.Strings(peerList)
		log.Printf("Peer list updated\nwas %v\nnow %v", peers.List(), newPeers.List())
		configmapContents, err = prepareCoreDNSConfigFile(hosts)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		err = updateConfigMap(client, *namespace, cm, configmapContents)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		shellOut(strings.Join(peerList, "\n"), script)
		peers = newPeers
		script = *onChange
	}
	log.Printf("Peer finder exiting")
}

func nodes(cl *kubernetes.Clientset) (nodes *v1.NodeList, err error) {
	listOptions := metav1.ListOptions{}
	nodes, err = cl.CoreV1().Nodes().List(listOptions)

	if err != nil {
		return nil, err
	}

	return nodes, nil
}

func servicesByLabel(cl *kubernetes.Clientset, namespace string, labelSelector string) (services *v1.ServiceList, err error) {

	listOptions := metav1.ListOptions{LabelSelector: labelSelector}
	services, err = cl.CoreV1().Services(namespace).List(listOptions)
	if err != nil {
		return nil, err
	}

	return services, nil
}

// updateConfigMap updates CoreDNS configmap
func updateConfigMap(cl *kubernetes.Clientset, namespace string, name string, configFile string) error {
	configMap, err := cl.CoreV1().ConfigMaps(namespace).Get(name, metav1.GetOptions{})
	if err != nil {
		return err
	}

	configMap.Data = map[string]string{"Corefile": configFile}
	_, err = cl.CoreV1().ConfigMaps(namespace).Update(configMap)
	return err
}

// prepareData feeds configContents configmap with public hostnames
func prepareCoreDNSConfigFile(hosts []hostDetails) (configContents string, err error) {
	config := new(bytes.Buffer)
	tmpl := `.:53 {
  errors
  log stdout
  health
  {{- range . }}
  rewrite name {{ .PrivateHostname }} {{ .PublicHostname }}
  {{- end }}
}`

	t := template.New("configmap")
	t, err = t.Parse(tmpl)
	if err != nil {
		return "", fmt.Errorf("Failed to render config: %v", err)
	}

	err = t.Execute(config, hosts)
	if err != nil {
		return "", fmt.Errorf("Failed to render config: %v", err)
	}

	return config.String(), nil
}

func hostsInfo(nodes *v1.NodeList, services *v1.ServiceList) (hosts []hostDetails, err error) {
	var host hostDetails

	for _, service := range services.Items {
		if service.Spec.Type == "NodePort" {
			// just get the name of the first node
			// a NodePort is only useful on development mode
			host.PublicHostname = nodes.Items[0].ObjectMeta.Name
			host.port = service.Spec.Ports[0].NodePort
		} else if service.Spec.Type == "LoadBalancer" {
			host.PublicHostname = service.Status.LoadBalancer.Ingress[0].Hostname
			host.port = service.Spec.Ports[0].Port
		}
		host.PrivateHostname = service.ObjectMeta.Name

		if len(host.PrivateHostname) == 0 || host.port <= 0 {
			return nil, fmt.Errorf("Could not get service name")
		}

		if len(host.PublicHostname) == 0 || host.port <= 0 {
			return nil, fmt.Errorf("One or more services do not have a public hostname yet")
		}
		hosts = append(hosts, host)
	}

	return hosts, nil
}

// just fetch all services, marshal them into JSON, and print
// their public IPs or domain names
func publicHostnames(hosts []hostDetails) (sets.String, error) {

	hostnames := sets.NewString()
	for _, host := range hosts {
		if len(host.PublicHostname) == 0 || host.port <= 0 {
			continue
		}
		hostnames.Insert(fmt.Sprintf("%s:%d", host.PublicHostname, host.port))
	}

	if hostnames.Len() <= 0 {
		return nil, fmt.Errorf("The list of public hostnames is empty")
	}

	return hostnames, nil
}
