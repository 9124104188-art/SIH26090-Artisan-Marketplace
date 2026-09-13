import uuid
import logging
import shutil
from io import BytesIO
from pathlib import Path
from typing import Dict, Any

from app import config
from app.config import UPLOADS_DIR

logger = logging.getLogger(__name__)

def process_and_enhance_image(
    input_path: str,
    max_size: int = 1024,
    remove_background: bool = True
) -> Dict[str, Any]:
    """Process the uploaded image and return its public URL."""
    # Lazy imports: rembg (ONNX) and Cloudinary SDK are heavy and only needed
    # when an image is actually processed, not during FastAPI startup.
    try:
        from rembg import remove as remove_background_image
    except ImportError:
        remove_background_image = None
    import cloudinary
    from cloudinary import uploader

    try:
        UPLOADS_DIR.mkdir(parents=True, exist_ok=True)
        suffix = Path(input_path).suffix or ".bin"
        filename = f"original_{uuid.uuid4().hex[:12]}{suffix}"
        output_filepath = UPLOADS_DIR / filename
        background_removed = False
        if remove_background and remove_background_image is not None:
            try:
                with open(input_path, "rb") as source:
                    processed = remove_background_image(source.read())
                with open(output_filepath, "wb") as output:
                    output.write(processed)
                background_removed = True
            except Exception as error:
                logger.warning("Background removal unavailable: %s", error)

        if not background_removed:
            shutil.copyfile(input_path, output_filepath)

        cloudinary_values = (
            config.CLOUDINARY_CLOUD_NAME,
            config.CLOUDINARY_API_KEY,
            config.CLOUDINARY_API_SECRET,
        )
        if not all(cloudinary_values):
            raise RuntimeError("Cloudinary image storage is not configured.")

        cloudinary.config(
            cloud_name=config.CLOUDINARY_CLOUD_NAME,
            api_key=config.CLOUDINARY_API_KEY,
            api_secret=config.CLOUDINARY_API_SECRET,
            secure=True,
        )
        with open(output_filepath, "rb") as processed_file:
            upload_result = uploader.upload(
                BytesIO(processed_file.read()),
                public_id=f"artisan-connect/{Path(filename).stem}",
                resource_type="image",
            )
        secure_url = upload_result.get("secure_url")
        if not isinstance(secure_url, str) or not secure_url.startswith("https://"):
            raise RuntimeError("Cloudinary did not return a secure image URL.")

        return {
            "imageUrl": secure_url,
            "originalName": Path(input_path).name,
            "enhanced": background_removed,
            "bgRemoved": background_removed
        }

    except RuntimeError:
        raise
    except Exception as e:
        logger.error(f"Image enhancement error: {e}")
        raise ValueError(f"Unable to process image: {str(e)}")
