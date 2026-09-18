import uuid
import logging
from io import BytesIO
from pathlib import Path
from typing import Dict, Any

from PIL import Image, ImageEnhance, ImageOps

from app import config
from app.config import UPLOADS_DIR

logger = logging.getLogger(__name__)

def process_and_enhance_image(
    input_path: str,
    max_size: int = 1024,
    remove_background: bool = True
) -> Dict[str, Any]:
    """
    Process the uploaded image and return its public URL.
    Pipeline:
    1. Resize image to enforce max dimension (default 1024px) using Pillow.
    2. Enhance contrast and sharpness for marketplace catalog quality.
    3. Conditionally run background removal only if enabled by configuration.
    4. Fall back gracefully to the Pillow-enhanced image if background removal fails or is unavailable.
    5. Upload to Cloudinary for permanent storage.
    """
    import cloudinary
    from cloudinary import uploader

    try:
        UPLOADS_DIR.mkdir(parents=True, exist_ok=True)
        suffix = Path(input_path).suffix.lower()
        if suffix not in (".jpg", ".jpeg", ".png", ".webp"):
            suffix = ".jpg"

        filename = f"processed_{uuid.uuid4().hex[:12]}{suffix}"
        output_filepath = UPLOADS_DIR / filename

        # 1 & 2: Pillow resize and enhancement
        with Image.open(input_path) as img:
            img = ImageOps.exif_transpose(img)
            orig_w, orig_h = img.size

            if orig_w > max_size or orig_h > max_size:
                img.thumbnail((max_size, max_size), Image.Resampling.LANCZOS)

            if img.mode not in ("RGB", "RGBA"):
                img = img.convert("RGB")

            enhancer_contrast = ImageEnhance.Contrast(img)
            img = enhancer_contrast.enhance(1.05)
            enhancer_sharpness = ImageEnhance.Sharpness(img)
            img = enhancer_sharpness.enhance(1.1)

            if suffix in (".jpg", ".jpeg") and img.mode != "RGB":
                img = img.convert("RGB")

            save_kwargs = {"quality": 90, "optimize": True} if suffix in (".jpg", ".jpeg") else {}
            img.save(output_filepath, **save_kwargs)
            final_width, final_height = img.size

        # 3 & 4: Safe background removal (disabled by default on Render / low-memory tiers)
        background_removed = False
        enable_bg_removal = getattr(config, "ENABLE_BG_REMOVAL", False)

        if remove_background and enable_bg_removal:
            try:
                from rembg import remove as remove_background_image
                with open(output_filepath, "rb") as source:
                    processed = remove_background_image(source.read())

                bg_filename = f"processed_{uuid.uuid4().hex[:12]}.png"
                bg_filepath = UPLOADS_DIR / bg_filename
                with open(bg_filepath, "wb") as output:
                    output.write(processed)

                output_filepath = bg_filepath
                filename = bg_filename
                background_removed = True

                with Image.open(output_filepath) as bg_img:
                    final_width, final_height = bg_img.size
            except Exception as error:
                logger.warning(
                    "Background removal unavailable or failed, falling back to enhanced image: %s",
                    error,
                )
                background_removed = False

        # 5: Cloudinary upload
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
            "width": final_width,
            "height": final_height,
            "enhanced": True,
            "bgRemoved": background_removed,
        }

    except RuntimeError:
        raise
    except Exception as e:
        logger.error(f"Image enhancement error: {e}")
        raise ValueError(f"Unable to process image: {str(e)}")
