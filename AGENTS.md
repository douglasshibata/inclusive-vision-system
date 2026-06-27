# AI Agent Instructions for Inclusive Vision System (IVS)

Welcome, Agent. Your goal is to help build and maintain the IVS, an accessibility-first platform for blind and low-vision users.

## 🧠 Core Principles

1.  **Accessibility is Functional:** Accessibility is not a "UI feature"—it is the core functionality. If a feature is not accessible, it is broken.
2.  **Semantic Truth:** Always prioritize semantic HTML and proper ARIA roles. Never use `div` or `span` for interactive elements when a `button` or `a` is appropriate.
3.  **Low Latency:** Every millisecond counts for users relying on audio feedback. Optimize algorithms and network calls for speed.
4.  **Privacy First:** Users trust this system with their location and voice. Ensure all data handling follows strict privacy protocols.

## 🛠 Project Structure

- `backend/`: Go-based API and microservices.
- `ai-engine/`: Python-based cognitive and vision models.
- `frontend-web/`: Angular application for management and high-precision reading.
- `mobile/`: Flutter application for navigation and sensing.
- `docs/`: Technical documentation and design specifications.

## 📝 Coding Standards

### Frontend (Angular/Flutter)
- Every image **MUST** have an `alt` tag or a `Semantics` label.
- Focus management must be explicit. After a modal opens or a screen changes, focus must be programmatically moved to the most logical starting point.
- Ensure 4.5:1 minimum contrast ratio for all text elements.

### Backend (Go/Python)
- All cognitive outputs must include a `confidence_score`.
- Large payloads (images/PDFs) must be handled via streams to minimize memory pressure.
- Implement robust health checks for AI model availability.

## 🧪 Testing Requirements

- **Unit Tests:** Mandatory for all logic.
- **Accessibility Audit:** Use automated tools (Axe, Lighthouse) in every build.
- **Screen Reader Verification:** When updating the UI, provide a transcript of how a screen reader (VoiceOver/TalkBack) would read the changed section.

## 🚩 Escalation

If you encounter a design pattern that seems inaccessible (e.g., relying purely on color or complex mouse gestures), flag it immediately for human review.
