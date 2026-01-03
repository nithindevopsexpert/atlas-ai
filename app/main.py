from fastapi import FastAPI
from app.api import router
from app.health import health_router

app = FastAPI(title="Atlas AI Inference Service", version="1.0.0")
app.include_router(router)
app.include_router(health_router)
