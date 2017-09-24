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
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/sets"
	"k8s.io/client-go/kubernetes"
	v1 "k8s.io/client-go/pkg/api/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	//"github.com/davecgh/go-spew/spew"
)

const (
	pollPeriod = 1 * time.Second
)

var (
	onChange   = flag.String("on-change", "", "Script to run on change, must accept a new line separated list of peers via stdin.")
	onStart    = flag.String("on-start", "", "Script to run on start, must accept a new line separated list of peers via stdin.")
	selector   = flag.String("selector", "", "Selector to get the set of services ")
	namespace  = flag.String("ns", "", "The namespace this pod is running in. If unspecified, the POD_NAMESPACE env var is used.")
	kubeconfig = flag.String("kubeconfig", "", "Path to a kubeconfig file")
)

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
	if ns == "" {
		ns = os.Getenv("POD_NAMESPACE")
	}

	if *selector == "" || (*onChange == "" && *onStart == "") {
		log.Fatalf("Incomplete args, require -on-change and/or -on-start, -selector and -ns or an env var for POD_NAMESPACE.")
	}

	script := *onStart
	if script == "" {
		script = *onChange
		log.Printf("No on-start supplied, on-change %v will be applied on start.", script)
	}

	for newPeers, peers := sets.NewString(), sets.NewString(); script != ""; time.Sleep(pollPeriod) {
		services, err := servicesByLabel(client, *namespace, *selector)
		if err != nil {
			log.Printf("I could not find services with the selector %s. I am assuming they are not ready yet", selector)
			log.Printf("%v", err)
			continue
		}

		nodes, err := nodes(client)
		newPeers, err = publicHostnames(nodes, services)
		if err != nil {
			log.Printf("%s", err)
			continue
		}

		peerList := newPeers.List()
		sort.Strings(peerList)
		log.Printf("Peer list updated\nwas %v\nnow %v", peers.List(), newPeers.List())
		shellOut(strings.Join(peerList, "\n"), script)
		peers = newPeers
		script = *onChange
	}
	// TODO: Exit if there's no on-change?
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

// just fetch all services, marshal them into JSON, and print
// their public IPs or domain names
func publicHostnames(nodes *v1.NodeList, services *v1.ServiceList) (sets.String, error) {

	hostnames := sets.NewString()
	hostname := ""

	for _, service := range services.Items {

		if service.Spec.Type == "NodePort" {
			nodeIP := nodes.Items[0].Status.Addresses[0].Address
			port := service.Spec.Ports[0].NodePort
			hostname = fmt.Sprintf("%s:%d", nodeIP, port)
		} else if service.Spec.Type == "LoadBalancer" {
			host := service.Status.LoadBalancer.Ingress[0].Hostname
			port := service.Spec.Ports[0].Port
			hostname = fmt.Sprintf("%s:%d", host, port)
		}

		if len(hostname) == 0 {
			continue
		}

		hostnames.Insert(hostname)
		fmt.Println(hostname)
	}

	if hostnames.Len() <= 0 {
		return nil, fmt.Errorf("The list of public hostnames is empty. I'll try again in a moment")
	}

	return hostnames, nil
}
