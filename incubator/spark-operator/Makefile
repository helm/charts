.PHONY: template
template:
	helm template . > template.yaml
	cat ./template.yaml

template-crd:
	helm template --set env.crd=true .
	cat ./template.yaml
