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
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
	"text/template"
	"time"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	v1 "k8s.io/client-go/pkg/api/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

const (
	pollPeriod = 1 * time.Second
)

var (
	onStart    = flag.String("on-start", "", "Script to run on start, must accept a new line separated list of peers via stdin.")
	selector   = flag.String("selector", "", "Selector to get the set of services ")
	namespace  = flag.String("ns", "", "The namespace this pod is running in. If unspecified, the POD_NAMESPACE env var is used.")
	kubeconfig = flag.String("kubeconfig", "", "Path to a kubeconfig file")
	// TODO: find configmap through tags
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
	stub := make(map[string][]string)
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
		log.Fatalf("Incomplete args, -namespace flag required")
	}

	if *selector == "" || *onStart == "" {
		log.Fatalf("Incomplete args, require -on-start and -selector")
	}

	script := *onStart

	for peers := make([]string, 3); script != ""; time.Sleep(pollPeriod) {
		configmapContents := ""
		kubeDNSConfigMapData := make(map[string]string)

		podServicesSelector := fmt.Sprintf("name,%s", *selector)
		services, err := servicesByLabel(client, ns, podServicesSelector)
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

		hosts, err = hostsInfo(nodes, services, ns)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		peers, err = publicHostnames(hosts)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		configmapContents, err = prepareCoreDNSConfigFile(hosts)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		err = updateConfigMap(client, ns, cm, configmapContents)
		if err != nil {
			log.Printf("%s", err)
			continue
		}
		coreDNSSelector := fmt.Sprintf("layer=dns,%s", *selector)
		coreDNSServices, err := servicesByLabel(client, ns, coreDNSSelector)

		stubIPs, err := coreDNSServiceIPs(coreDNSServices)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		domain, err := parentDomain(hosts)
		stub[domain] = stubIPs
		kubeDNSConfigMapData, err = prepareKubeDNSData(stub)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		//err = updateKubeDNSConfigMap(client, "kube-system", "kube-dns", kubeDNSConfigMapData)
		kubeDNSConfigMap := newConfigMap("kube-system", "kube-dns", kubeDNSConfigMapData)
		err = CreateOrUpdateConfigMap(client, kubeDNSConfigMap)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		shellOut(strings.Join(peers, "\n"), script)
		break
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

// updateKubeDNSConfigMap updates KubeDNS configmap
func updateKubeDNSConfigMap(cl *kubernetes.Clientset, namespace string, name string, configMapData string) error {
	configMap, err := cl.CoreV1().ConfigMaps(namespace).Get(name, metav1.GetOptions{})
	if err != nil {
		return err
	}

	configMap.Data = map[string]string{"stubDomains": configMapData}
	_, err = cl.CoreV1().ConfigMaps(namespace).Update(configMap)
	return err
}

// CreateOrUpdateConfigMap creates a ConfigMap if the target resource doesn't exist.
// If the resource exists already, this function will update the resource instead.
func CreateOrUpdateConfigMap(cl *kubernetes.Clientset, cm *v1.ConfigMap) error {
	if _, err := cl.CoreV1().ConfigMaps(cm.ObjectMeta.Namespace).Create(cm); err != nil {
		if !apierrors.IsAlreadyExists(err) {
			return fmt.Errorf("unable to create configmap: %v", err)
		}

		if _, err := cl.CoreV1().ConfigMaps(cm.ObjectMeta.Namespace).Update(cm); err != nil {
			return fmt.Errorf("unable to update configmap: %v", err)
		}
	}
	return nil
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

func newConfigMap(namespace string, name string, data map[string]string) *v1.ConfigMap {
	return &v1.ConfigMap{
		ObjectMeta: metav1.ObjectMeta{
			Name:      name,
			Namespace: namespace,
		},
		Data: data,
	}
}

// prepareData feeds configContents configmap with public hostnames
// init containers can not have rediness checks so we need to make think
// the bootstrap container that is connecting to the k8s service otherwise
// MongoDB initialization will fail
func prepareCoreDNSConfigFile(hosts []hostDetails) (configContents string, err error) {
	config := new(bytes.Buffer)

	t := template.New("configmap")
	t, err = t.Parse(`.:53 {
  errors
  log stdout
  health
  {{- range . }}
  rewrite name {{ .PublicHostname }} {{ .PrivateHostname }}
  {{- end }}
  proxy . /etc/resolv.conf
}`)
	if err != nil {
		return "", fmt.Errorf("Failed to parse config template. %v", err)
	}

	err = t.Execute(config, hosts)
	if err != nil {
		return "", fmt.Errorf("Failed to render CoreDNS configmap template. %v", err)
	}

	return config.String(), nil
}

// prepareData feeds configContents configmap with public hostnames
func prepareKubeDNSData(stub map[string][]string) (stubConfigMapData map[string]string, err error) {
	data, err := json.Marshal(stub)
	if err != nil {
		return nil, fmt.Errorf("Failed to create stub domain: %v", err)
	}
	return map[string]string{"stubDomains": string(data[:])}, nil
}

func coreDNSServiceIPs(coreDNSServices *v1.ServiceList) (ips []string, err error) {
	for _, service := range coreDNSServices.Items {
		ips = append(ips, service.Spec.ClusterIP)
	}

	if err != nil {
		return nil, fmt.Errorf("Failed to render config: %v", err)
	}
	return ips, nil
}

func hostsInfo(nodes *v1.NodeList, services *v1.ServiceList, namespace string) (hosts []hostDetails, err error) {
	var host hostDetails

	for _, service := range services.Items {
		serviceName := service.ObjectMeta.Name

		if service.Spec.Type == "NodePort" {
			// just get the name of the first node
			// a NodePort service is only useful on development mode
			host.PublicHostname = nodes.Items[0].ObjectMeta.Name
			host.port = service.Spec.Ports[0].NodePort
		} else if service.Spec.Type == "LoadBalancer" {
			host.PublicHostname = service.Status.LoadBalancer.Ingress[0].Hostname
			host.port = service.Spec.Ports[0].Port
		}
		host.PrivateHostname = fmt.Sprintf("%s.%s.%s.svc.cluster.local", serviceName, serviceName[:len(serviceName)-2], namespace)

		if len(host.PrivateHostname) == 0 {
			return nil, fmt.Errorf("Could not get service name")
		}

		if len(host.PublicHostname) == 0 || host.port <= 0 {
			return nil, fmt.Errorf("One or more services do not have a public hostname yet")
		}
		hosts = append(hosts, host)
	}

	return hosts, nil
}

// publicHostnames format the slice of domains to satisfy MongoDB
func publicHostnames(hosts []hostDetails) (hostnames []string, err error) {

	for _, host := range hosts {
		if len(host.PublicHostname) == 0 || host.port <= 0 {
			continue
		}
		hostnames = append(hostnames, fmt.Sprintf("%s:%d", host.PublicHostname, host.port))
	}

	if len(hostnames) == 0 {
		return nil, fmt.Errorf("The list of public hostnames is empty")
	}

	fmt.Printf("%+v", hostnames)
	return hostnames, nil
}

// parentDomain return the common parent domain from a list of hostnames
// compare the first parent domain with the rest of the list
// and throws and error if they do not match
func parentDomain(hosts []hostDetails) (domain string, err error) {
	parent := ""
	for _, host := range hosts {
		domain = host.PublicHostname
		components := strings.Split(domain, ".")
		if len(parent) == 0 {
			parent = strings.Join(components[1:], ".")
		} else {
			if !isSubdomain(domain, parent) {
				return "", fmt.Errorf("The public domain names do not have a common parent")
			}
		}
	}

	return parent, nil
}

// isSubdomain reports if sub is a subdomain of the parent domain.
//
// Both domains must already be in canonical form.
func isSubdomain(sub, parent string) bool {
	// If sub is "foo.example.com" and parent is "example.com",
	// that means sub must end in "."+parent.
	// Do it without allocating.
	if !strings.HasSuffix(sub, parent) {
		return false
	}

	return sub[len(sub)-len(parent)-1] == '.'
}
