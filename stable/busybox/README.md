#busybox - the sanity chart

###Sometimes it is about the system rather than the chart.  Need to: Test your CI?  Test a deployment process? Verify the cluster is running? Or just do something to invoke your cluster? Busybox can help.

### This chart runs a dummy process 'tail -f /dev/null' to run endlessly

```bash
helm repo add stable http://storage.googleapis.com/kubernetes-charts-incubator 
helm install stable/busybox
```

### now get busy, busy, busy...
