# Inclusive Vision System (IVS)

IVS is an AI-powered inclusive system designed to empower blind and low-vision users through advanced assistive technologies.

## 📋 Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Security](#security)

## Overview
A comprehensive ecosystem providing real-time navigation, object recognition, and cognitive assistance via wearable and mobile interfaces.

## Architecture
- **Navigation Service (Go)**: Low-latency spatial mapping.
- **Cognitive Engine (Python)**: High-level scene description using multimodal LLMs.
- **Client Layers**: Flutter (Mobile) and Angular (Web Dashboard).

## Tech Stack
- **Languages**: Go 1.24.3, Python 3.12, Dart/Flutter, TypeScript/Angular.
- **AI Models**: YOLOv11, CLIP, Gemini 1.5 Flash.
- **Backend**: Microservices with gRPC and WebSockets.

## Installation
Refer to individual service directories:
- `backend/`: Go implementation.
- `ai-engine/`: Python FastAPI.
- `frontend-web/`: Angular dashboard.

## Security
- **Privacy First**: Localized processing for voice and location data where possible.
- **Authentication**: Centralized OAuth2/OIDC via the Go Gateway.
- **Compliance**: Adherence to WCAG 2.2 AAA standards.

## License
Open Source / Accessibility First
