# Claude Guide: Inclusive Vision System (IVS)

## 🛠 Useful Commands

### Monorepo Makefile
- `make proto` - Generate Protobuf Go stubs
- `make test` - Run all backend, AI, and mobile tests
- `make build` - Build all binaries
- `make docker-up` - Start full containerized stack

### Service-Specific Commands
- `cd services/gateway && go test -v ./...`
- `cd services/ai-engine && pytest -v`
- `cd clients/mobile && flutter test`
- `cd clients/web-dashboard && npm run build`

## 📜 Canonical Architecture

- `services/gateway/`: Low-latency Ingress Gateway & Session Manager in Go 1.24+
- `services/ai-engine/`: Cognitive Vision with Gemini 1.5 Flash in Python 3.12+
- `clients/mobile/`: Flutter Edge Client with 3D Spatial Audio and Haptic Safety Loop
- `clients/web-dashboard/`: Angular 19 Web Dashboard
- `proto/`: Shared bidirectional gRPC contracts
