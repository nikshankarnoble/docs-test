# Built-in
import logging

# Third-party
from fastapi import APIRouter, HTTPException


log = logging.getLogger("uvicorn")


# The main API entrypoint class.
router = APIRouter()


@router.get("/hello")
def hello() -> dict[str, str]:
    """
    Returns the full prompt configuration data as JSON.

    Returns:
        JSON object containing the full prompt configuration data.

    Raises:
        HTTPException: If there is an error retrieving the data.
    """
    return {"message": "Hello World"}
