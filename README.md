# 👁️ Inclusive Vision System (IVS)
### Enterprise Edge-Cloud Assistive Vision & Spatial Intelligence Ecosystem

O **Inclusive Vision System (IVS)** é um ecossistema distribuído de computação assistiva projetado para conceder autonomia e mobilidade espacial para pessoas cegas e com baixa visão. O sistema combina detecção de obstáculos na borda (*On-Device Safety Loop*) com inteligência cognitiva multimodal (*Scene Description Agent*) desacoplada via gRPC e WebSockets.

---

## 🏛️ 1. Topologia e Arquitetura do Sistema

O sistema opera em uma topologia híbrida Edge-Cloud de Baixa Latência:

```
+-------------------------------------------------------------------------------+
|                       EDGE LAYER (Wearable / Mobile)                          |
|                                                                               |
|   [Câmera / LiDAR / IMU] ──► [Edge Safety Loop (Flutter/TFLite/NCNN)]         |
|                                     │                                         |
|                 ┌───────────────────┴───────────────────┐                     |
|                 ▼                                       ▼                     |
|      [Obstáculo < 1.5m]                      [Fluxo Contínuo / Dúvida]        |
|      Alerta Háptico + Som 3D (Sub-20ms)      gRPC Streaming (WebRTC / QUIC)   |
+─────────────────────────────────────────────────────────┬─────────────────────+
                                                          │
                                                          ▼
+-------------------------------------------------------------------------------+
|                   INGRESS GATEWAY & COORDINATOR (Go)                          |
|                                                                               |
|   - Terminação de Sessões gRPC Bidirecionais / WebSockets                      |
|   - Autenticação e Gestão de Sessão (OAuth2 / OIDC + PASETO Tokens)           |
|   - Engine de Roteamento Espacial e Priorização de Tráfego                     |
+─────────────────────────────┬─────────────────────────────────────────────────+
                              │
                              ▼
+-------------------------------------------------------------------------------+
|                   COGNITIVE AI BACKEND (Python FastAPI)                       |
|                                                                               |
|   ┌─────────────────────────┐                 ┌─────────────────────────┐     |
|   │ YOLOv11 TensorRT Engine │ ──────────────► │ Scene Comprehension     │     |
|   │ (Detecção Semântica)    │                 │ (CLIP + Gemini / VLM)   │     |
|   └─────────────────────────┘                 └───────────┬─────────────┘     |
|                                                           │                   |
|                   [Filtro de Relevância / Áudio TTS] ◄────┘                   |
|                   Priorização: Perigo > Rota > Ambiente                       |
+-------------------------------------------------------------------------------+
```

### Divisão de Responsabilidades
- **Nível 0 (On-Device Safety - <30 ms)**: Detecção de degraus, quedas, postes e veículos em aproximação usando sensores ToF/LiDAR e modelos quantizados INT8 locais.
- **Nível 1 (Spatial Navigation - Go Gateway - <100 ms)**: Triangulação espacial, dead-reckoning (odometria inercial) e despacho de coordenadas vetoriais.
- **Nível 2 (Cognitive Context - Python Engine - 300-800 ms)**: Resumo contextual sob demanda ("Onde está a fila?", "Leia esta placa", "Descreva o cruzamento").

---

## 📁 2. Estrutura Canônica do Monorepo

```
inclusive-vision-system/
├── deploy/
│   ├── docker-compose.yml
│   └── k8s/
│       ├── gateway-deployment.yaml
│       └── ai-engine-deployment.yaml
├── services/
│   ├── gateway/                  # Ingress, Auth & Routing (Go 1.24+)
│   │   ├── cmd/server/
│   │   ├── internal/
│   │   │   ├── auth/
│   │   │   ├── session/
│   │   │   └── telemetry/
│   │   ├── pkg/api/v1/           # Generated gRPC Stubs
│   │   ├── Dockerfile
│   │   ├── go.mod
│   │   └── go.sum
│   └── ai-engine/                # Cognitive Vision & Multi-modal VLM (Python 3.12)
│       ├── app/
│       │   ├── api/
│       │   ├── core/
│       │   ├── models/           # YOLOv11, CLIP, Wrappers Gemini
│       │   └── pipelines/
│       ├── tests/
│       ├── Dockerfile
│       ├── pyproject.toml
│       └── requirements.txt
├── clients/
│   ├── mobile/                   # Wearable & Mobile Client (Flutter)
│   │   ├── lib/
│   │   │   ├── core/haptics/     # Drivers táteis para bengalas/smartphones
│   │   │   ├── core/audio/       # Áudio binaural 3D
│   │   │   └── features/
│   │   ├── test/
│   │   └── pubspec.yaml
│   └── web-dashboard/            # Admin & Cuidador Portal (Angular 19)
│       ├── src/
│       │   ├── app/
│       │   └── index.html
│       ├── package.json
│       └── tsconfig.json
├── proto/
│   └── vision/v1/
│       └── spatial_stream.proto  # Contrato gRPC bidirecional
├── README.md
├── AGENTS.md
├── CLAUDE.md
└── Makefile
```

---

## 🔌 3. Contrato de Comunicação gRPC (`proto/vision/v1/spatial_stream.proto`)

O contrato unifica o fluxo em tempo real entre o cliente móvel, o Gateway em Go e o Motor Cognitivo:

```protobuf
syntax = "proto3";

package vision.v1;

option go_package = "services/gateway/pkg/api/v1;visionv1";

service SpatialIntelligenceService {
  rpc StreamTelemetry(stream ClientPacket) returns (stream SpatialFeedback);
}

message ClientPacket {
  string session_id = 1;
  int64 timestamp_ms = 2;

  oneof payload {
    FrameChunk frame = 3;       // JPEG/WebP comprimido ou H.265 NAL unit
    SensorTelemetry sensors = 4; // IMU, Acelerômetro, Orientação
    UserVoiceIntent intent = 5;  // Áudio da pergunta do usuário ("Onde sentar?")
  }
}
...
```

---

## 📱 4. Camada Cliente e Acessibilidade

O aplicativo Flutter (`clients/mobile`) implementa padrões ergonômicos assistivos estritos:
- **Accessibility Semantics First**:
  - Todos os widgets interativos encapsulados com o componente `Semantics(label: "...", hint: "...")`.
  - Suporte nativo e sincronizado com os leitores de tela Google TalkBack (Android) e Apple VoiceOver (iOS).
- **Audio Spatializer Engine**:
  - Alertas utilizam cálculo posicional binaural (pan estéreo e atenuação por distância) para que o som aparente vir fisicamente da direção do obstáculo.
- **Padrões de Resposta Tátil (Haptic Cues)**:
  - **1 Vibração Longa (500 ms)**: Caminho livre confirmado.
  - **3 Pulsos Curtos (100 ms)**: Obstáculo no nível da cintura.
  - **Vibração Contínua Alta Frequência**: Risco iminente de colisão ou degrau descendente.

---

## 🔒 5. Privacidade e Segurança (Data Minimization)

- **Ephemeral Frame Buffering**: Quadros de vídeo transmitidos à nuvem são processados em memória volátil (RAM) e descartados imediatamente após a extração de tensores pelo YOLO/VLM. Nenhuma imagem de vias públicas ou de pessoas no campo visual do usuário é persistida em disco sem consentimento explícito.
- **On-Device Face Blurring**: O cliente móvel aplica desfoque (*blur*) em rostos de transeuntes antes de despachar o chunk ao cluster de IA, garantindo conformidade com a LGPD e o AI Act da União Europeia.
- **Tokens de Acesso com Escopo de Dispositivo**: Autenticação utilizando mTLS / PASETO entre wearables/smartphones e o Ingress Gateway em Go.

---

## 🚀 6. Guia Rápido de Instalação e Execução

### Pré-requisitos
- Go 1.24+
- Python 3.12+ com UV ou pip
- Flutter SDK 3.x
- Docker Engine 26+

```bash
# 1. Clonar repositório
git clone https://github.com/org/inclusive-vision-system.git
cd inclusive-vision-system

# 2. Compilar protoc stubs
make proto

# 3. Rodar testes monorepo
make test

# 4. Inicializar Infraestrutura e AI Engine via Docker Compose
make docker-up

# 5. Ou rodar localmente os serviços
make run-gateway
make run-ai
```
