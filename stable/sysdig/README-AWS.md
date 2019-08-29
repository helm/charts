## Deploying the AWS Marketplace Sysdig agent image

This is an use case similar to pulling images from a private registry. First you
need to get the authorization token for the AWS Marketplace ECS image registry:

```bash
aws ecr --region=us-east-1 get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2
```

And then use it to create the Secret. Don't forget to replace TOKEN and EMAIL
with your own values:

```bash
kubectl create secret docker-registry aws-marketplace-credentials \
 --docker-server=217273820646.dkr.ecr.us-east-1.amazonaws.com \
 --docker-username=AWS \
 --docker-password="TOKEN" \
 --docker-email="EMAIL"
```

Next you need to create a values YAML file to pass the specific ECS registry
configuration (you will find these values when you activate the software from
the AWS Marketplace):

```yaml
sysdig:
  accessKey: XxxXXxXXxXXxxx

image:
  registry: 217273820646.dkr.ecr.us-east-1.amazonaws.com
  repository: 2df5da52-6fa2-46f6-b164-5b879e86fd85/cg-3361214151/agent
  tag: 0.85.1-latest
  pullSecrets:
    - name: aws-marketplace-credentials
```

Finally, set the accessKey value and you are ready to deploy the Sysdig agent
using the Helm chart:

```bash
helm install --name sysdig-agent -f aws-marketplace-values.yaml stable/sysdig
```

