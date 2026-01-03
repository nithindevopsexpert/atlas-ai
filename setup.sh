#!/bin/bash

mkdir -p app docker tests .github/workflows

cat << 'EOPY' > app/main.py
from fastapi import FastAPI
from app.api import router
from app.health import health_router

app = FastAPI(title="Atlas AI Inference Service", version="1.0.0")
app.include_router(router)
app.include_router(health_router)
EOPY

cat << 'EOPY' > app/api.py
from fastapi import APIRouter
from app.schemas import PredictionRequest, PredictionResponse
from app.model import predict

router = APIRouter()

@router.post("/predict", response_model=PredictionResponse)
def run_prediction(request: PredictionRequest):
    return {"prediction": predict(request.features)}
EOPY

cat << 'EOPY' > app/model.py
def predict(features):
    return round(sum(features) / max(len(features), 1), 4)
EOPY

cat << 'EOPY' > app/schemas.py
from pydantic import BaseModel
from typing import List

class PredictionRequest(BaseModel):
    features: List[float]

class PredictionResponse(BaseModel):
    prediction: float
EOPY

cat << 'EOPY' > app/health.py
from fastapi import APIRouter

health_router = APIRouter()

@health_router.get("/health")
def health():
    return {"status": "ok"}
EOPY

cat << 'EOPY' > docker/Dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app ./app
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOPY

cat << 'EOPY' > requirements.txt
fastapi
uvicorn
pydantic
EOPY
