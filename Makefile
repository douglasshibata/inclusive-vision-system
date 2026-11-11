.PHONY: all proto test-gateway test-ai test-mobile test build run-gateway run-ai docker-up help

all: proto test build

proto:
	@echo "Generating protobuf code..."
	protoc --proto_path=proto \
		--go_out=. \
		--go-grpc_out=. \
		proto/vision/v1/spatial_stream.proto

test-gateway:
	@echo "Running Gateway tests..."
	cd services/gateway && go test -v ./...

test-ai:
	@echo "Running AI Engine tests..."
	cd services/ai-engine && pytest -v

test-mobile:
	@echo "Running Mobile Client tests..."
	cd clients/mobile && flutter test

test: test-gateway test-ai test-mobile

build-gateway:
	@echo "Building Go Gateway..."
	cd services/gateway && go build -v ./cmd/server

build: build-gateway

run-gateway:
	@echo "Starting Ingress Gateway on :50051..."
	cd services/gateway && go run cmd/server/main.go

run-ai:
	@echo "Starting Cognitive AI Engine on :8000..."
	cd services/ai-engine && uvicorn app.main:app --host 0.0.0.0 --port 8000

docker-up:
	@echo "Starting services via Docker Compose..."
	docker compose -f deploy/docker-compose.yml up -d --build

help:
	@echo "IVS Monorepo Makefile commands:"
	@echo "  make proto        - Generate gRPC Protobuf code"
	@echo "  make test         - Run all test suites (Go, Python, Flutter)"
	@echo "  make build        - Compile service binaries"
	@echo "  make run-gateway  - Start Go gateway locally"
	@echo "  make run-ai       - Start Python AI Engine locally"
	@echo "  make docker-up    - Run stack with Docker Compose"
