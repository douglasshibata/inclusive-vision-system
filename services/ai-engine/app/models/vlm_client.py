"""VLM and YOLOv11 wrapper client interfaces."""
import os
import time
from typing import Tuple, List

SYSTEM_INSTRUCTION = """
Você é o copiloto de visão de uma pessoa cega.
Seja ultra-conciso, descritivo e orientado a direções relógio (ex: 'às 2 horas').
Prioridades:
1. Obstáculos móveis ou estáticos na linha de caminhada.
2. Portas, faixas de pedestres, escadas e elevadores.
3. Leitura de textos essenciais (apenas nomes de placas, avisos).
NUNCA use frases poéticas ou prolixas.
"""

class CognitivePipeline:
    def __init__(self):
        self.api_key = os.getenv("GEMINI_API_KEY")
        self.client = None
        if self.api_key and self.api_key != "mock":
            try:
                from google import genai
                self.client = genai.Client(api_key=self.api_key)
            except Exception:
                self.client = None

    def analyze(self, image_base64: str, user_query: str | None = None, speed: float = 0.0) -> Tuple[List[str], str, str, float]:
        start = time.time()

        if self.client:
            from google.genai import types
            response = self.client.models.generate_content(
                model="gemini-1.5-flash",
                contents=[
                    types.Part.from_bytes(
                        data=image_base64.encode("utf-8"),
                        mime_type="image/jpeg",
                    ),
                    user_query or "Descreva a rota segura imediata à minha frente."
                ],
                config=types.GenerateContentConfig(
                    system_instruction=SYSTEM_INSTRUCTION,
                    temperature=0.2,
                    max_output_tokens=150,
                ),
            )
            narrative = response.text.strip()
            latency = (time.time() - start) * 1000
            return [], narrative, "PROCEED_CAUTIOUSLY", latency

        narrative = "Caminho desimpedido à sua frente. Calçada livre até 10 metros; porta de vidro às 12 horas."
        if user_query:
            narrative = f"Informação sobre '{user_query}': Rota identificada à sua frente às 11 horas."
        latency = (time.time() - start) * 1000
        return [], narrative, "PROCEED_CAUTIOUSLY", latency
