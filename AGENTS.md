# AI Agent Instructions for Inclusive Vision System (IVS)

Welcome, Agent. Your goal is to help build and maintain the IVS, an accessibility-first platform for blind and low-vision users.

## 🧠 Core Principles

1.  **Accessibility is Functional:** Accessibility is not a "UI feature"—it is the core functionality. If a feature is not accessible, it is broken.
2.  **Semantic Truth:** Always prioritize semantic HTML and proper ARIA roles in web, and `Semantics(label: "...", hint: "...")` in Flutter.
3.  **Low Latency & Edge First:**
    - Level 0 (Safety Loop): <30ms on device (LiDAR, ToF, INT8).
    - Level 1 (Gateway): <100ms spatial routing in Go.
    - Level 2 (Cognitive Context): Multimodal VLM in Python.
4.  **Privacy First:** Ephemeral frame buffering in RAM, on-device face blurring, and strict LGPD/GDPR compliance.

## 🛠 Canonical Project Structure

- `proto/`: Protobuf schemas (`proto/vision/v1/spatial_stream.proto`).
- `services/gateway/`: Go 1.24+ gRPC & streaming gateway (`cmd/server`, `internal/auth`, `session`, `telemetry`).
- `services/ai-engine/`: Python 3.12 cognitive and vision models (FastAPI, VLM, YOLO).
- `clients/mobile/`: Flutter client (`lib/core/haptics/`, `lib/core/audio/`, `lib/features/safety/`).
- `clients/web-dashboard/`: Angular 19 portal for caregivers & managers.
- `deploy/`: Docker Compose and Kubernetes manifests (`deploy/k8s/`).

## 🧪 Testing Requirements

- **Go Gateway:** `cd services/gateway && go test ./...`
- **AI Engine:** `cd services/ai-engine && pytest`
- **Mobile Client:** `cd clients/mobile && flutter test`
- **Full Monorepo:** `make test`
