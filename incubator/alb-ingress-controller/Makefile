update-from-upstream:
	mv README.md README-tmp.md
	curl https://codeload.github.com/kubernetes-sigs/aws-alb-ingress-controller/tar.gz/master | \
		tar -xz --strip=2 aws-alb-ingress-controller-master/alb-ingress-controller-helm
	mv README.md README-upstream.md
	mv README-tmp.md README.md
	sed -i '' \
		-e 's/Kraig Amador/bigkraig/g' \
		-e 's/Andrew Tandoc/andrewtandoc/g' \
		-e 's/name: alb-ingress-controller-helm/name: alb-ingress-controller/' \
		Chart.yaml
