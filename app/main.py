from fastapi import FastAPI
from app.api import router
from app.health import health_router

app = FastAPI(
    title="Atlas AI Inference Service",
    version="1.0.0"
)

# Core inference API
app.include_router(router)

# Health & readiness probes (reliability layer)
app.include_router(health_router)

