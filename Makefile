.PHONY: build test lint docker run-local clean

build:
	go build -o bin/policy ./cmd/policy

test:
	go test ./... -v

lint:
	golangci-lint run ./...

docker:
	docker build -t gigvault/policy:local .

run-local: docker
	../infra/scripts/deploy-local.sh policy

clean:
	rm -rf bin/
	go clean
