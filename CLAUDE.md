# Claude Guide: Inclusive Vision System (IVS)

## 🛠 Useful Commands

### Backend (Go)
- `go build ./...` - Build all services
- `go test ./...` - Run all backend tests

### AI Engine (Python)
- `pip install -r requirements.txt` - Setup environment
- `pytest` - Run inference tests

### Frontend (Angular)
- `npm run build` - Build production artifacts
- `npm run test` - Run unit tests

### Docker
- `docker compose up --build` - Start the full local environment

## 📜 Development Workflow

1.  **A11y First:** Before writing code, describe how the feature will be interacted with via keyboard and screen reader.
2.  **Schema Sync:** If changing the Cognitive API, update `docs/ARCHITECTURE.md` and both Python/Go models.
3.  **Semantic PRs:** Ensure every PR includes an "Accessibility Impact" section in the description.

## 🔗 Internal Links

- [Project Proposal](PROPOSAL.md)
- [Architecture Overview](docs/ARCHITECTURE.md)
- [Agent Instructions](AGENTS.md)
