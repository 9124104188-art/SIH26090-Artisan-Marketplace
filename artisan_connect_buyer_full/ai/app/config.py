import os
from pathlib import Path
from dotenv import load_dotenv

# Load .env if present
env_file = Path(__file__).resolve().parent.parent / ".env"
if env_file.exists():
    load_dotenv(env_file)

PORT = int(os.getenv("PORT", "8000"))
HOST = os.getenv("HOST", "0.0.0.0")
ENV = os.getenv("ENV", "development")

LLM_PROVIDER = os.getenv("LLM_PROVIDER", "mock").lower()
LLM_API_KEY = os.getenv("LLM_API_KEY", "")
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")

# Directory paths
BASE_DIR = Path(__file__).resolve().parent.parent
UPLOADS_DIR = BASE_DIR / "uploads"
UPLOADS_DIR.mkdir(parents=True, exist_ok=True)

# Shared Data Contract Categories
ALLOWED_CATEGORIES = [
    "Pottery",
    "Handloom",
    "Woodcraft",
    "Basketry",
    "Jewellery",
    "Painting",
    "Other"
]

DEFAULT_CATEGORY = "Other"
