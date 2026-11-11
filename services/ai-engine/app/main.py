import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
try:
    from app.core.schemas import SceneAnalysisRequest, SceneAnalysisResponse
    from app.models.vlm_client import CognitivePipeline
except ImportError:
    from core.schemas import SceneAnalysisRequest, SceneAnalysisResponse
    from models.vlm_client import CognitivePipeline

app = FastAPI(title="IVS Cognitive Engine", version="2.0.0")

pipeline = CognitivePipeline()

@app.get("/health")
async def health():
    return {
        "status": "online",
        "service": "IVS Cognitive Engine",
        "version": "2.0.0",
        "vlm_ready": pipeline.client is not None,
    }

@app.post("/v1/cognitive/describe", response_model=SceneAnalysisResponse)
async def describe_scene(payload: SceneAnalysisRequest):
    try:
        immediate_alerts, narrative, target_action, latency = pipeline.analyze(
            image_base64=payload.image_base64,
            user_query=payload.user_query,
            speed=payload.walking_speed_kmh,
        )

        return SceneAnalysisResponse(
            immediate_alerts=immediate_alerts,
            scene_narrative=narrative,
            target_action=target_action,
            processing_time_ms=round(latency, 2),
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro de inferência multimodal: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
