from fastapi import FastAPI, Request
from transformers import pipeline
import time
import socket

start_time = time.time()
hostname = socket.gethostname()

app = FastAPI()
classifier = pipeline("sentiment-analysis")

@app.get("/")
def root():
    uptime = round(time.time() - start_time, 2)  # Δt = t_current - t₀
    return {
        "status": "ok",
        "uptime_seconds": uptime,
        "hostname": hostname
    }

@app.post("/predict")
async def predict(req: Request):
    data = await req.json()
    text = data.get("text", "")
    try:
        result = classifier(text)[0]
        return {
            "label": result["label"],
            "score": float(result["score"])
        }
    except Exception as e:
        return {
            "label": "error",
            "score": 0.0,
            "error": str(e)
        }
