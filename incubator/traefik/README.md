# Traefik

[Traefik](https://traefik.io/) is a modern HTTP reverse proxy and load balancer made to deploy
microservices with ease.

## Introduction

This chart bootstraps Traefik as a Kubernetes ingress controller with optional support for SSL and
Let's Encrypt.

# Prerequisites

- Kubernetes 1.10+ 
- You are deploying the chart to a cluster with a cloud provider capable of provisioning an
external load balancer (e.g. AWS or GKE)
- You control DNS for the domain(s) you intend to route through Traefik
- __Suggested:__ PV provisioner support in the underlying infrastructure

NOTE: THIS CHART IS IN INCUBATOR STATUS, AND USES AN ALPHA RELEASE OF TRAEFIK.
DO NOT USE IN A PRODUCTION ENVIRONMENT
