import re
import json
import logging
from pathlib import Path
from typing import Dict, Any, List, Tuple
from urllib.parse import urlparse
import httpx
from google import genai
from google.genai import errors as genai_errors
from google.genai import types

from app.config import (
    ALLOWED_CATEGORIES,
    DEFAULT_CATEGORY,
    GEMINI_MODEL,
    LLM_API_KEY,
    LLM_PROVIDER,
)
from app.schemas import CatalogGenerateData
from app.config import UPLOADS_DIR

logger = logging.getLogger(__name__)


class CatalogProviderError(Exception):
    """A user-facing failure from the configured catalog provider."""

    def __init__(self, message: str, status_code: int = 502):
        super().__init__(message)
        self.message = message
        self.status_code = status_code

# Craft Knowledge Base for Rule-Based Classifier & Extraction Engine
CRAFT_MAP = {
    "Pottery": {
        "keywords": ["pot", "clay", "terracotta", "pitcher", "ceramic", "vase", "earthen", "matka", "diya", "planter", "mud"],
        "materials": ["Natural Clay", "Terracotta", "Ceramic Glaze"],
        "craft_types": ["Traditional Pottery", "Terracotta Craft", "Glazed Ceramics"],
        "default_tags": ["pottery", "handmade", "terracotta", "clay", "eco-friendly", "home-decor"]
    },
    "Handloom": {
        "keywords": ["saree", "silk", "cotton", "weave", "handloom", "khadi", "dupatta", "fabric", "shawl", "scarf", "stole", "thread", "textile", "kanchipuram", "banarasi"],
        "materials": ["Pure Silk", "Organic Cotton", "Khadi Thread", "Jute Silk"],
        "craft_types": ["Handloom Weaving", "Block Printing", "Embroidery", "Zari Craft"],
        "default_tags": ["handloom", "saree", "ethnic-wear", "handwoven", "traditional", "silk"]
    },
    "Woodcraft": {
        "keywords": ["wood", "carved", "wooden", "timber", "furniture", "box", "toy", "sculpture", "statue", "rosewood", "teak", "sandalwood"],
        "materials": ["Rosewood", "Teak Wood", "Sandalwood", "Sheesham Wood"],
        "craft_types": ["Wood Carving", "Lacquerware", "Inlay Work", "Wooden Handicraft"],
        "default_tags": ["woodcraft", "carved", "wooden", "artisan-made", "rustic", "home-decor"]
    },
    "Basketry": {
        "keywords": ["basket", "bamboo", "cane", "straw", "wicker", "woven", "grass", "jute", "mat", "tray", "reed"],
        "materials": ["Natural Bamboo", "Cane Reed", "Golden Jute", "Kuna Grass"],
        "craft_types": ["Bamboo Basketry", "Cane Weaving", "Jute Craft"],
        "default_tags": ["basketry", "bamboo", "sustainable", "handwoven", "eco-friendly", "storage"]
    },
    "Jewellery": {
        "keywords": ["jewel", "necklace", "bangle", "earring", "silver", "bead", "brass", "pendant", "bracelet", "ring", "ornament", "kundan", "meenakari"],
        "materials": ["Sterling Silver", "Brass", "Glass Beads", "Terracotta Beads", "Copper"],
        "craft_types": ["Filigree", "Beadwork", "Tribal Jewellery", "Meenakari Work"],
        "default_tags": ["jewellery", "handmade", "ethnic-jewellery", "beadwork", "artisanal", "accessories"]
    },
    "Painting": {
        "keywords": ["painting", "canvas", "madhubani", "warli", "pattachitra", "tanjore", "art", "portrait", "mural", "color", "ink", "brush", "frame"],
        "materials": ["Natural Pigments", "Handmade Paper", "Canvas", "Organic Dyes"],
        "craft_types": ["Madhubani Painting", "Warli Art", "Pattachitra", "Tanjore Painting"],
        "default_tags": ["painting", "wall-art", "traditional-art", "handpainted", "madhubani", "culture"]
    }
}

def classify_text(text: str) -> Tuple[str, float]:
    """
    Classifies input text into one of the 7 allowed product categories:
    Pottery, Handloom, Woodcraft, Basketry, Jewellery, Painting, Other.
    Returns (category_name, confidence_score).
    """
    if not text or not text.strip():
        return (DEFAULT_CATEGORY, 0.5)

    text_lower = text.lower()
    scores: Dict[str, float] = {cat: 0.0 for cat in ALLOWED_CATEGORIES}

    for cat, info in CRAFT_MAP.items():
        for kw in info["keywords"]:
            if kw in text_lower:
                # Direct match score boost
                scores[cat] += 2.0 if re.search(rf"\b{kw}\b", text_lower) else 1.0

    best_cat = max(scores, key=scores.get)
    max_score = scores[best_cat]

    if max_score == 0:
        return (DEFAULT_CATEGORY, 0.60)

    # Normalize confidence score between 0.70 and 0.98
    confidence = min(0.70 + (max_score * 0.08), 0.98)
    return (best_cat, round(confidence, 2))

def generate_tags(text: str, category: str = None, materials: List[str] = None) -> Dict[str, Any]:
    """
    Generates category, craftType, materials list, and tags list based on text & category.
    """
    if not category or category not in ALLOWED_CATEGORIES:
        category, _ = classify_text(text or "")

    craft_info = CRAFT_MAP.get(category, {
        "materials": ["Handcrafted Natural Material"],
        "craft_types": ["Traditional Handicraft"],
        "default_tags": ["handicraft", "handmade", "artisan", "traditional"]
    })

    # Extract materials present in text
    found_materials = []
    text_lower = (text or "").lower()
    for mat in craft_info["materials"]:
        if any(w in text_lower for w in mat.lower().split()):
            found_materials.append(mat)
    if not found_materials:
        found_materials = [craft_info["materials"][0]]

    if materials:
        for m in materials:
            if m not in found_materials:
                found_materials.append(m)

    # Select craft type
    craft_type = craft_info["craft_types"][0]
    for ct in craft_info["craft_types"]:
        if any(w in text_lower for w in ct.lower().split()):
            craft_type = ct
            break

    # Build tags set
    tags_set = set(craft_info["default_tags"])
    tags_set.add("artisan-connect")
    tags_set.add("handmade")

    # Add word-based tags from text
    words = re.findall(r'\b[a-zA-Z]{4,}\b', text_lower)
    stop_words = {"this", "made", "with", "from", "using", "that", "which", "artisan", "product"}
    for w in words:
        if w not in stop_words and len(tags_set) < 12:
            tags_set.add(w)

    return {
        "category": category,
        "craftType": craft_type,
        "materials": found_materials,
        "tags": sorted(list(tags_set))
    }

def generate_catalog_fields(
    text: str,
    voice_text: str = None,
    category_hint: str = None,
    artisan_info: str = None,
    image_url: str = None,
) -> Dict[str, Any]:
    """
    Generates structured product catalog fields:
    title, description, category, craftType, materials, tags.
    """
    raw_input = (text or voice_text or "").strip()
    if not raw_input:
        raw_input = "Handmade artisan product"

    if LLM_PROVIDER == "gemini":
        return _call_llm_catalog_generator(raw_input, category_hint, artisan_info, image_url)

    # Rule-Based NLP catalog generator (100% offline & free-tier reliable)
    return _rule_based_catalog_generator(raw_input, category_hint, artisan_info)

def _rule_based_catalog_generator(
    raw_input: str,
    category_hint: str = None,
    artisan_info: str = None
) -> Dict[str, Any]:
    """
    Generates polished title and storytelling description without external API calls.
    """
    category, confidence = classify_text(raw_input)
    if category_hint and category_hint in ALLOWED_CATEGORIES:
        category = category_hint

    tag_data = generate_tags(raw_input, category=category)

    # Generate polished Title
    clean_input = re.sub(r'^(this is a|here is a|handmade|crafted)\s+', '', raw_input, flags=re.IGNORECASE)
    clean_input = clean_input.strip().capitalize()

    mat_name = tag_data["materials"][0] if tag_data["materials"] else ""
    craft_type = tag_data["craftType"]

    if len(clean_input) > 5 and len(clean_input) < 50 and not clean_input.endswith("."):
        title = f"Handcrafted {clean_input}"
    else:
        title = f"Traditional {mat_name} {category}".strip()
        title = re.sub(r'\s+', ' ', title)

    # Clean description build
    desc_intro = f"A traditional {tag_data['craftType'].lower()} handcrafted using premium {mat_name.lower()}."
    if artisan_info:
        desc_story = f" Crafted by skilled artisans in {artisan_info}."
    else:
        desc_story = " Meticulously crafted by rural master artisans carrying forward generations of cultural heritage."

    if len(raw_input) > 20:
        desc_user = f" Product Note: {raw_input}"
    else:
        desc_user = ""

    description = f"{desc_intro}{desc_story}{desc_user}".strip()
    price = _extract_price(raw_input)
    quantity = _extract_quantity(raw_input)

    return {
        "title": title,
        "description": description,
        "category": category,
        "craftType": tag_data["craftType"],
        "materials": tag_data["materials"],
        "tags": tag_data["tags"],
        "price": price,
        "quantity": quantity,
        "confidence": confidence
    }

def _extract_price(text: str) -> int | None:
    match = re.search(r"(?:price|cost|priced at|for)\s*(?:is|of|at)?\s*(?:₹|rs\.?|inr)?\s*(\d[\d,]*)", text, re.IGNORECASE)
    return int(match.group(1).replace(",", "")) if match else None

def _extract_quantity(text: str) -> int | None:
    match = re.search(r"(?:quantity|stock|pieces?|units?)\s*(?:is|of|are|:)?\s*(\d+)|(?:(\d+)\s*(?:pieces?|units?))", text, re.IGNORECASE)
    value = next((group for group in match.groups() if group), None) if match else None
    return int(value) if value else None

def _call_llm_catalog_generator(
    raw_input: str,
    category_hint: str = None,
    artisan_info: str = None,
    image_url: str = None,
) -> Dict[str, Any]:
    """Generate and validate catalog data using the server-side Gemini client."""
    if not LLM_API_KEY or LLM_API_KEY == "YOUR_GEMINI_API_KEY":
        raise CatalogProviderError(
            "Gemini is enabled but LLM_API_KEY is missing.",
            status_code=503,
        )

    prompt = f"""Create a product catalog entry for this artisan product.
Return only JSON matching the requested schema.
Product description: {raw_input}
Category hint: {category_hint or 'none'}
"""
    if artisan_info:
        prompt += f"Artisan context: {artisan_info}\n"

    response_schema = {
        "type": "OBJECT",
        "properties": {
            "title": {"type": "STRING"},
            "description": {"type": "STRING"},
            "category": {"type": "STRING"},
            "craftType": {"type": "STRING"},
            "materials": {"type": "ARRAY", "items": {"type": "STRING"}},
            "tags": {"type": "ARRAY", "items": {"type": "STRING"}},
            "price": {"type": "INTEGER"},
            "quantity": {"type": "INTEGER"},
            "confidence": {"type": "NUMBER"},
        },
        "required": [
            "title",
            "description",
            "category",
            "craftType",
            "materials",
            "tags",
            "price",
            "quantity",
            "confidence",
        ],
    }

    contents: Any = prompt
    image_path = _get_processed_image_path(image_url)
    if image_path:
        image_bytes = image_path.read_bytes()
        contents = [
            prompt,
            types.Part.from_bytes(data=image_bytes, mime_type="image/png"),
        ]

    try:
        client = genai.Client(
            api_key=LLM_API_KEY,
            http_options=types.HttpOptions(timeout=20000),
        )
        response = client.models.generate_content(
            model=GEMINI_MODEL,
            contents=contents,
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
                response_schema=response_schema,
                temperature=0.3,
            ),
        )
    except genai_errors.APIError as error:
        if error.code == 429:
            raise CatalogProviderError(
                "Gemini rate limit reached. Please try again shortly.",
                status_code=429,
            ) from error
        if error.code in (408, 504):
            raise CatalogProviderError(
                "Gemini timed out. Please try again.",
                status_code=504,
            ) from error
        if error.code in (401, 403):
            raise CatalogProviderError(
                "Gemini authentication failed. Check the backend LLM_API_KEY.",
                status_code=502,
            ) from error
        logger.exception("Gemini catalog generation failed with status %s", error.code)
        raise CatalogProviderError(
            "Gemini could not generate the catalog right now.",
            status_code=502,
        ) from error
    except (TimeoutError, httpx.TimeoutException, OSError) as error:
        logger.exception("Gemini catalog generation timed out or could not connect")
        raise CatalogProviderError(
            "Gemini is unavailable. Please try again.",
            status_code=504,
        ) from error
    except Exception as error:
        logger.exception("Unexpected Gemini catalog generation failure")
        raise CatalogProviderError(
            "Gemini could not generate the catalog right now.",
            status_code=502,
        ) from error

    try:
        parsed = json.loads(response.text or "")
        catalog = CatalogGenerateData.model_validate(parsed).model_dump()
    except (json.JSONDecodeError, TypeError, ValueError) as error:
        logger.warning("Gemini returned invalid catalog JSON: %s", error)
        raise CatalogProviderError(
            "Gemini returned an invalid catalog response.",
            status_code=502,
        ) from error

    if catalog["category"] not in ALLOWED_CATEGORIES:
        catalog["category"], _ = classify_text(raw_input)
    catalog["confidence"] = max(0.0, min(1.0, float(catalog["confidence"])))
    return catalog


def _get_processed_image_path(image_url: str | None) -> Path | None:
    """Resolve only image paths produced by this service; never fetch arbitrary URLs."""
    if not image_url:
        return None

    image_path_url = urlparse(image_url).path
    if not image_path_url.startswith("/uploads/"):
        return None

    filename = Path(image_path_url.removeprefix("/uploads/")).name
    image_path = UPLOADS_DIR / filename
    return image_path if image_path.is_file() else None
