# Inclusive Vision System (IVS)

A comprehensive, AI-powered inclusive system designed to empower blind and low-vision users through advanced assistive technologies.

## 🛠 Technical Stack & Versions

| Layer | Technology | Version |
|-------|------------|---------|
| Frontend (Mobile) | Flutter / Dart | 3.29.0 / 3.7.0 |
| Frontend (Web) | Angular | 19.1.0 |
| AI Engine | Python / PyTorch | 3.12 / 2.6.0 |
| Backend | Go | 1.24.3 |
| Accessibility APIs | VoiceOver, TalkBack, NVDA | Latest |

## 🚀 Local Setup

1.  **Clone the monorepo:**
    ```bash
    git clone <repository-url>
    cd inclusive-vision-system
    ```

2.  **Environment Configuration:**
    Copy `.env.example` to `.env` and configure your API keys for AI services (Gemini, Claude, or OpenAI).
    ```bash
    cp .env.example .env
    ```

3.  **Documentation:**
    Read the full [Project Proposal](PROPOSAL.md) for a detailed breakdown of the system's vision and architecture.

## 📖 How to Use

*   **As a Developer:** Explore the `api/` directory for integration guidelines.
*   **As a Designer:** Review `docs/DESIGN.md` for accessibility-first UI patterns and WCAG compliance checklists.
*   **As a User:** Access the [User Guide](docs/USER_GUIDE.md) (provided in accessible formats).

## 🚢 How to Deploy

The IVS is containerized using multi-stage Docker builds.
```bash
docker compose up --build
```

## ⚙️ Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `AI_PROVIDER` | AI service to use (openai, gemini, claude) | `gemini` |
| `API_KEY` | Secret key for the chosen AI provider | `None` |
| `OFFLINE_MODE` | Enable/disable offline cognitive processing | `true` |

## 🛠 Development Guidelines

1.  **Accessibility First:** Every component must have proper ARIA labels and keyboard support.
2.  **Test with Assistive Tech:** All UI changes must be verified using at least one screen reader (VoiceOver, TalkBack, or NVDA).
3.  **Performance:** Keep latency for TTS and Braille output under 100ms.
