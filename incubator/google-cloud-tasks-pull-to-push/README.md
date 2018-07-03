# google-cloud-tasks-pull-to-push

Google Cloud Tasks Push queue emulation for arbitrary destination URLs (if you need it, you know).

See [github:tclift/google-cloud-tasks-pull-to-push](https://github.com/tclift/google-cloud-tasks-pull-to-push).


## GCP Authentication

It is best to use a service account with a JSON credentials file rather than the Application Default Credentials, as the
ADC belong to the cluster, and giving the cluster's service account permissions to Cloud Tasks is likely both
undesirable and (at time of writing) requires creation of a new node pool to modify.

Create a secret with key `credentials.json`, and put the secret name in `credentialsSecret` in `values.yaml`.

    kubectl create secret generic google-cloud-tasks-pull-to-push-credentials \
      --from-file=credentials.json=./my-credentials.json
