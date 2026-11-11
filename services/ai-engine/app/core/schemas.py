"""Core schemas and config for IVS Cognitive Engine."""
from pydantic import BaseModel, Field
from typing import List, Optional

class SceneAnalysisRequest(BaseModel):
    image_base64: str = Field(..., description="Base64 encoded JPEG or WebP frame")
    user_query: Optional[str] = Field(None, description="User question or navigational inquiry")
    walking_speed_kmh: float = Field(0.0, description="Estimated current user speed in km/h")

class SceneAnalysisResponse(BaseModel):
    immediate_alerts: List[str] = Field(default_factory=list, description="Immediate safety alerts")
    scene_narrative: str = Field(..., description="Concise, clock-position based scene summary")
    target_action: str = Field(..., description="Action recommendation (e.g. PROCEED_CAUTIOUSLY, STOP)")
    processing_time_ms: float = Field(..., description="Total inference latency in ms")
