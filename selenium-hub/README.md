# selenium

This Chart deploys a scalable [Selnium Grid](http://www.seleniumhq.org) to your Kubernetes cluster using the official Selenium [Docker images](https://github.com/SeleniumHQ/docker-selenium).

Once deployed, you can hit the UI as follows:
```console
export NODEPORT=`kubectl get svc --selector='app=selenium-hub' --output=template --template="{{ with index .items 0}}{{with index .spec.ports 0 }}{{.nodePort}}{{end}}{{end}}"`
export NODE=`kubectl get nodes --output=template --template="{{with index .items 0 }}{{.metadata.name}}{{end}}"`

curl http://$NODE:$NODEPORT
```

If your Kubernetes nodes are not reachable from your network:
```console
export PODNAME=`kubectl get pods --selector="app=selenium-hub" --output=template --template="{{with index .items 0}}{{.metadata.name}}{{end}}"`
kubectl port-forward --pod=$PODNAME 4444:4444
```
Then surf to <http://localhost:4444>.

If you need to run more tests concurrently, scale the amount of Firefox and Chrome workers:
```console
kubectl scale rc selenium-node-firefox --replicas=10
kubectl scale rc selenium-node-chrome --replicas=10
```

To debug a worker using VNC:
```console
kubectl port-forward --pod=POD_NAME 5900:5900
```

Then connect to localhost:5900 using your prefered VNC client, the default password is "secret".

Enjoy!
