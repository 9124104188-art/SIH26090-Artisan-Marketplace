import uuid
import logging
import shutil
from pathlib import Path
from typing import Dict, Any
from app.config import UPLOADS_DIR

logger = logging.getLogger(__name__)

def process_and_enhance_image(
    input_path: str,
    max_size: int = 1024,
    remove_background: bool = True
) -> Dict[str, Any]:
    """Store the uploaded image unchanged and return its public URL."""
    try:
        UPLOADS_DIR.mkdir(parents=True, exist_ok=True)
        suffix = Path(input_path).suffix or ".bin"
        filename = f"original_{uuid.uuid4().hex[:12]}{suffix}"
        output_filepath = UPLOADS_DIR / filename
        shutil.copyfile(input_path, output_filepath)
        return {
            "imageUrl": f"/uploads/{filename}",
            "originalName": Path(input_path).name,
            "enhanced": False,
            "bgRemoved": False
        }

    except RuntimeError:
        raise
    except Exception as e:
        logger.error(f"Image enhancement error: {e}")
        raise ValueError(f"Unable to process image: {str(e)}")
