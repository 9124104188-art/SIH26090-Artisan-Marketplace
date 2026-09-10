import os
import shutil
import tempfile
import logging
from pathlib import Path
from fastapi import FastAPI, File, UploadFile, HTTPException, Form, Request
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

from app.config import UPLOADS_DIR, PORT, HOST
from app.schemas import (
    ApiResponse,
    HealthData,
    ImageProcessResponseData,
    VoiceTranscribeResponseData,
    CatalogGenerateRequest,
    CatalogGenerateData,
    ClassifyRequest,
    ClassifyData,
    TagsRequest,
    TagsData,
    PricingRequest,
    PricingData,
    RecommendationsRequest,
    RecommendationsData,
    RecommendationItem,
)
from app.image.enhancer import process_and_enhance_image
from app.voice.speech_to_text import transcribe_audio_file
from app.catalog.generator import (
    CatalogProviderError,
    generate_catalog_fields,
    classify_text,
    generate_tags
)
from app.pricing.pricing_engine import calculate_smart_price

def _rank_recommendations(payload: RecommendationsRequest) -> list[RecommendationItem]:
    preferred_categories = {value.strip().lower() for value in payload.preferredCategories}
    preferred_tags = {value.strip().lower() for value in payload.preferredTags}
    ranked = []

    for product in payload.products:
        category_match = product.category.strip().lower() in preferred_categories
        tag_matches = preferred_tags.intersection(
            {tag.strip().lower() for tag in [*product.tags, *product.materials]}
        )
        quality_score = min(3.0, max(0.0, product.rating / 5) * 2 + min(product.reviews, 100) / 100)
        score = (4.0 if category_match else 0.0) + min(3.0, len(tag_matches)) + quality_score
        if category_match:
            reason = f"Matches your interest in {product.category}."
        elif tag_matches:
            reason = f"Matches your interest in {sorted(tag_matches)[0]}."
        else:
            reason = "Highly rated by marketplace shoppers."
        ranked.append((score, product.productId, reason))

    ranked.sort(key=lambda item: (-item[0], item[1]))
    return [
        RecommendationItem(productId=product_id, score=round(score, 3), reason=reason)
        for score, product_id, reason in ranked[:payload.limit]
    ]

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("artisan-ai")

app = FastAPI(
    title="Artisan Connect AI Microservice",
    description="AI/ML backend for SIH26090 - Voice, Computer Vision, Smart Cataloging & Pricing Engine",
    version="1.0.0"
)

# Enable CORS for Flutter web and mobile clients.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Serve uploaded & processed images
app.mount("/uploads", StaticFiles(directory=str(UPLOADS_DIR)), name="uploads")

# Custom exception handler to maintain consistent JSON response envelope
@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"success": False, "message": exc.detail}
    )

from fastapi.exceptions import RequestValidationError

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors = exc.errors()
    msg = errors[0].get("msg", "Invalid request parameters") if errors else "Validation error"
    return JSONResponse(
        status_code=400,
        content={"success": False, "message": f"Validation error: {msg}"}
    )

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Global unhandled error: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"success": False, "message": "Internal AI service error. Please try again."}
    )

# ---------------------------------------------------------
# ENDPOINTS
# ---------------------------------------------------------

@app.get("/health", response_model=ApiResponse[HealthData])
async def health_check():
    """Health check endpoint for service monitoring."""
    return ApiResponse(
        success=True,
        data=HealthData()
    )

@app.post("/ai/image/process", response_model=ApiResponse[ImageProcessResponseData])
async def process_image(
    file: UploadFile = File(...),
    removeBg: bool = Form(True)
):
    """
    Image Processing Pipeline:
    Raw Image -> Resize -> Quality Enhancement -> Background Removal -> Processed Image
    """
    if not file or not file.filename:
        raise HTTPException(status_code=400, detail="Missing image file in request")

    temp_dir = tempfile.mkdtemp()
    temp_filepath = os.path.join(temp_dir, Path(file.filename).name)

    try:
        with open(temp_filepath, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        if os.path.getsize(temp_filepath) == 0:
            raise HTTPException(status_code=400, detail="Uploaded image file is empty")

        result = process_and_enhance_image(
            input_path=temp_filepath,
            remove_background=removeBg
        )

        return ApiResponse(
            success=True,
            data=ImageProcessResponseData(**result)
        )
    except ValueError as ve:
        raise HTTPException(status_code=400, detail=str(ve))
    except RuntimeError as error:
        raise HTTPException(status_code=503, detail=str(error))
    except Exception as e:
        logger.error(f"Error in /ai/image/process: {e}")
        raise HTTPException(status_code=500, detail=f"Unable to process image: {str(e)}")
    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)

@app.post("/ai/voice/transcribe", response_model=ApiResponse[VoiceTranscribeResponseData])
async def transcribe_voice(
    file: UploadFile = File(...)
):
    """
    Voice -> Text Transcription:
    Transcribes audio recorded by artisans into text.
    """
    if not file or not file.filename:
        raise HTTPException(status_code=400, detail="Missing audio file in request")

    temp_dir = tempfile.mkdtemp()
    temp_filepath = os.path.join(temp_dir, file.filename)

    try:
        with open(temp_filepath, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        if os.path.getsize(temp_filepath) == 0:
            raise HTTPException(status_code=400, detail="Uploaded audio file is empty")

        text = transcribe_audio_file(temp_filepath)

        return ApiResponse(
            success=True,
            data=VoiceTranscribeResponseData(text=text)
        )
    except FileNotFoundError as fnf:
        raise HTTPException(status_code=404, detail=str(fnf))
    except ValueError as ve:
        raise HTTPException(status_code=400, detail=str(ve))
    except RuntimeError as error:
        raise HTTPException(status_code=503, detail=str(error))
    except Exception as e:
        logger.error(f"Error in /ai/voice/transcribe: {e}")
        raise HTTPException(status_code=500, detail=f"Unable to transcribe audio: {str(e)}")
    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)

@app.post("/ai/catalog/generate", response_model=ApiResponse[CatalogGenerateData])
async def generate_catalog(payload: CatalogGenerateRequest):
    """
    Generates structured product catalog (title, description, category, craftType, materials, tags)
    from voice transcription or raw description text.
    """
    raw_text = payload.text or payload.voiceText
    if not raw_text or not raw_text.strip():
        raise HTTPException(status_code=400, detail="Description or voice transcription text is required")

    try:
        result = generate_catalog_fields(
            text=raw_text,
            category_hint=payload.category,
            artisan_info=payload.artisanInfo,
            image_url=payload.imageUrl,
        )
        return ApiResponse(
            success=True,
            data=CatalogGenerateData(**result)
        )
    except CatalogProviderError as error:
        logger.warning("Catalog provider error: %s", error.message)
        raise HTTPException(status_code=error.status_code, detail=error.message) from error
    except Exception as e:
        logger.error(f"Error in /ai/catalog/generate: {e}")
        raise HTTPException(status_code=500, detail=f"Unable to generate catalog: {str(e)}")

@app.post("/ai/product/classify", response_model=ApiResponse[ClassifyData])
async def classify_product(payload: ClassifyRequest):
    """
    Classifies product description into standard craft categories:
    Pottery, Handloom, Woodcraft, Basketry, Jewellery, Painting, Other.
    """
    raw_text = payload.text or payload.description
    if not raw_text or not raw_text.strip():
        raise HTTPException(status_code=400, detail="Text or description is required for classification")

    try:
        category, confidence = classify_text(raw_text)
        return ApiResponse(
            success=True,
            data=ClassifyData(category=category, confidence=confidence)
        )
    except Exception as e:
        logger.error(f"Error in /ai/product/classify: {e}")
        raise HTTPException(status_code=500, detail=f"Unable to classify product: {str(e)}")

@app.post("/ai/product/tags", response_model=ApiResponse[TagsData])
async def extract_product_tags(payload: TagsRequest):
    """
    Generates category, craftType, materials, and tags for product indexing.
    """
    if not payload.text and not payload.category:
        raise HTTPException(status_code=400, detail="Text or category is required to extract tags")

    try:
        result = generate_tags(
            text=payload.text or "",
            category=payload.category,
            materials=payload.materials
        )
        return ApiResponse(
            success=True,
            data=TagsData(**result)
        )
    except Exception as e:
        logger.error(f"Error in /ai/product/tags: {e}")
        raise HTTPException(status_code=500, detail=f"Unable to generate tags: {str(e)}")

@app.post("/ai/pricing/predict", response_model=ApiResponse[PricingData])
async def predict_pricing(payload: PricingRequest):
    """
    Transparent Smart Pricing Engine:
    Calculates suggestedPrice, minimumPrice, maximumPrice based on material cost, labor, overhead, and margin.
    """
    try:
        result = calculate_smart_price(
            material_cost=payload.materialCost,
            labour_hours=payload.labourHours,
            hourly_rate=payload.hourlyRate,
            labour_cost_override=payload.labourCost,
            overhead=payload.overhead,
            margin_percent=payload.marginPercent,
            craft_complexity=payload.craftComplexity
        )
        return ApiResponse(
            success=True,
            data=PricingData(**result)
        )
    except ValueError as ve:
        raise HTTPException(status_code=400, detail=str(ve))
    except Exception as e:
        logger.error(f"Error in /ai/pricing/predict: {e}")
        raise HTTPException(status_code=500, detail=f"Unable to calculate pricing: {str(e)}")

@app.post("/ai/recommendations", response_model=ApiResponse[RecommendationsData])
async def recommendations(payload: RecommendationsRequest):
    """Ranks available products using the buyer's current preference signals."""
    return ApiResponse(
        success=True,
        data=RecommendationsData(recommendations=_rank_recommendations(payload)),
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host=HOST, port=PORT, reload=True)
