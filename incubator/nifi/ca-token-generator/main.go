package main

import (
	"fmt"
	"os"
	"strings"

	"k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"

	uuid "github.com/nu7hatch/gouuid"
)

func main() {

	release := os.Args[1]
	namespace := os.Args[2]
	secretName := os.Args[3]
	key := os.Args[4]

	config, err := rest.InClusterConfig()
	if err != nil {
		panic(err)
	}

	client, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	secret := v1.Secret{}
	secret.SetLabels(map[string]string{
		"release": release,
	})
	secret.SetName(secretName)

	u4, err := uuid.NewV4()
	if err != nil {
		fmt.Println("error:", err)
		return
	}
	secret.StringData = map[string]string{
		key: u4.String(),
	}

	secret.Type = v1.SecretTypeOpaque

	_, err = client.CoreV1().Secrets(namespace).Create(&secret)
	if err != nil {
		if strings.Contains(err.Error(), "already exists") {
			fmt.Println(err)
		} else {
			panic(err)
		}
	}
}
