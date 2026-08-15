BINARY := omnibus-ztaa
CMD := ./cmd
VERSION := $(shell git describe --tags --always 2>/dev/null || echo dev)
COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo none)
LDFLAGS := -X main.version=$(VERSION) -X main.commit=$(COMMIT)

.DEFAULT_GOAL := help

build:
	go build -ldflags "$(LDFLAGS)" -o bin/$(BINARY) $(CMD)

run:
	go run $(CMD)

test:
	go test ./...

test-cover:
	go test -cover -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

vet:
	go vet ./...

tidy:
	go mod tidy
	cd sdk && go mod tidy

ci-check-w:
	set "GOWORK=off" && go build ./...

ci-check-l:
	GOWORK=off go build ./...

clean:
	rm -rf bin coverage.out

# 도움말
help:
	@echo "ztaa 명령어"
	@echo "  make build       - 바이너리 빌드"
	@echo "  make run         - 로컬 실행"
	@echo "  make test        - 테스트"
	@echo "  make tidy        - go.mod 정리"
	@echo "  make ci-check-w    - workspace 없이 빌드 검증(Window)"
	@echo "  make ci-check-l    - workspace 없이 빌드 검증(Linux)"

.PHONY: build run test test-cover vet tidy ci-check-w ci-check-l clean help
