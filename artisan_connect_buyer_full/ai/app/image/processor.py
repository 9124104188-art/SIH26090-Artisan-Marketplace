import logging
from typing import Dict, Any, Tuple
from PIL import Image
import numpy as np

logger = logging.getLogger(__name__)

def analyze_image_features(image_path: str) -> Dict[str, Any]:
    """
    Analyzes basic image attributes (dimensions, brightness, dominant colors)
    without needing heavy deep learning weights.
    """
    try:
        with Image.open(image_path) as img:
            img_rgb = img.convert("RGB")
            width, height = img_rgb.size

            # Resize thumbnail for fast histogram and color analysis
            thumb = img_rgb.copy()
            thumb.thumbnail((100, 100))
            np_img = np.array(thumb)

            # Average brightness calculation
            brightness = float(np.mean(np_img))

            # Basic dominant color bucket (e.g., terracotta/brown vs textile/colorful)
            avg_r = float(np.mean(np_img[:, :, 0]))
            avg_g = float(np.mean(np_img[:, :, 1]))
            avg_b = float(np.mean(np_img[:, :, 2]))

            is_warm_earthy = (avg_r > avg_b) and (avg_r > avg_g) and (avg_g > avg_b * 0.8)

            return {
                "width": width,
                "height": height,
                "aspect_ratio": round(width / max(height, 1), 2),
                "brightness": round(brightness, 2),
                "is_warm_earthy": is_warm_earthy,
                "avg_color": [round(avg_r, 1), round(avg_g, 1), round(avg_b, 1)]
            }
    except Exception as e:
        logger.error(f"Image analysis error: {e}")
        return {
            "width": 0,
            "height": 0,
            "aspect_ratio": 1.0,
            "brightness": 128.0,
            "is_warm_earthy": False,
            "avg_color": [128.0, 128.0, 128.0]
        }
