import uuid
import logging
import shutil
from pathlib import Path
from typing import Dict, Any
from app.config import UPLOADS_DIR

try:
    from rembg import remove as remove_background
except ImportError:
    remove_background = None

logger = logging.getLogger(__name__)

def process_and_enhance_image(
    input_path: str,
    max_size: int = 1024,
    remove_background: bool = True
) -> Dict[str, Any]:
    """Process the uploaded image and return its public URL."""
    try:
        UPLOADS_DIR.mkdir(parents=True, exist_ok=True)
        suffix = Path(input_path).suffix or ".bin"
        filename = f"original_{uuid.uuid4().hex[:12]}{suffix}"
        output_filepath = UPLOADS_DIR / filename
        background_removed = False
        if remove_background and remove_background is not None:
            try:
                with open(input_path, "rb") as source:
                    processed = remove_background(source.read())
                with open(output_filepath, "wb") as output:
                    output.write(processed)
                background_removed = True
            except Exception as error:
                logger.warning("Background removal unavailable: %s", error)

        if not background_removed:
            shutil.copyfile(input_path, output_filepath)

        return {
            "imageUrl": f"/uploads/{filename}",
            "originalName": Path(input_path).name,
            "enhanced": background_removed,
            "bgRemoved": background_removed
        }

    except RuntimeError:
        raise
    except Exception as e:
        logger.error(f"Image enhancement error: {e}")
        raise ValueError(f"Unable to process image: {str(e)}")
