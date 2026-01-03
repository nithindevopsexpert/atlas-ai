from fastapi import APIRouter
from app.schemas import PredictionRequest, PredictionResponse
from app.model import predict

router = APIRouter()

@router.post("/predict", response_model=PredictionResponse)
def run_prediction(request: PredictionRequest):
    return {"prediction": predict(request.features)}
