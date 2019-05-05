## v6.0.0:

- added the ability to create worker only and web-only deployments using `web.enabled` and `worker.enabled`
- **[breaking]** worker and web secrets are now separated into 2 different templates, `worker-secrets.yaml` and `web-secrets.yaml`. Users bringing their own secrets will have to split them into 2 different k8s objects.
