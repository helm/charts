.PHONY: build
build:
	GOOS=linux go build -o build/ca-token-generator main.go
	docker build -t pepov/ca-token-generator .
	docker push pepov/ca-token-generator
