import pytest
from fastapi.testclient import TestClient
import sys
from pathlib import Path

app_dir = Path(__file__).resolve().parent.parent / "app"
sys.path.insert(0, str(app_dir))

from main import app

client = TestClient(app)

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "online"
    assert data["version"] == "2.0.0"

def test_describe_scene_default():
    payload = {
        "image_base64": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==",
        "user_query": None,
        "walking_speed_kmh": 3.5,
    }
    response = client.post("/v1/cognitive/describe", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "scene_narrative" in data
    assert data["target_action"] == "PROCEED_CAUTIOUSLY"
    assert data["processing_time_ms"] >= 0

def test_describe_scene_with_query():
    payload = {
        "image_base64": "dummy-base64-content",
        "user_query": "Onde está a fila?",
        "walking_speed_kmh": 1.2,
    }
    response = client.post("/v1/cognitive/describe", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "Onde está a fila?" in data["scene_narrative"]
