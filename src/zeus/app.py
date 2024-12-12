# Third-party
from fastapi import FastAPI

# Internal
from zeus.api.v1.routes import router as v1_router


# The main API entrypoint class.
app = FastAPI()
app.include_router(v1_router)
app.include_router(v1_router, prefix="/v1", tags=["v1"])