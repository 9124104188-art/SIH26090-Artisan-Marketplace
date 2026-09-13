import io
import pytest
from PIL import Image
from fastapi.testclient import TestClient

from app.main import app
from app.image import enhancer

client = TestClient(app)

def _fake_cloudinary_upload(file, **kwargs):
    return {
        "secure_url": "https://res.cloudinary.com/test-cloud/image/upload/test.jpg"
    }

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    json_data = response.json()
    assert json_data["success"] is True
    assert json_data["data"]["status"] == "healthy"
    assert json_data["data"]["service"] == "artisan-ai-service"

def test_catalog_generate_valid():
    payload = {
        "text": "This is a handmade clay pot made using natural clay. It takes two days to make."
    }
    response = client.post("/ai/catalog/generate", json=payload)
    assert response.status_code == 200
    res = response.json()
    assert res["success"] is True
    data = res["data"]
    assert "title" in data
    assert "description" in data
    assert data["category"] == "Pottery"
    assert "Natural Clay" in data["materials"]
    assert isinstance(data["tags"], list)

def test_catalog_generate_empty_text():
    response = client.post("/ai/catalog/generate", json={"text": ""})
    assert response.status_code == 400
    res = response.json()
    assert res["success"] is False
    assert "required" in res["message"].lower() or "missing" in res["message"].lower()

def test_classify_product_pottery():
    payload = {"text": "Handcrafted earthen clay matka pot"}
    response = client.post("/ai/product/classify", json=payload)
    assert response.status_code == 200
    res = response.json()
    assert res["success"] is True
    assert res["data"]["category"] == "Pottery"
    assert res["data"]["confidence"] > 0.5

def test_classify_product_handloom():
    payload = {"text": "Pure silk saree handwoven on traditional loom with zari border"}
    response = client.post("/ai/product/classify", json=payload)
    assert response.status_code == 200
    res = response.json()
    assert res["success"] is True
    assert res["data"]["category"] == "Handloom"

def test_product_tags_endpoint():
    payload = {
        "text": "Rosewood carved elephant statue",
        "category": "Woodcraft"
    }
    response = client.post("/ai/product/tags", json=payload)
    assert response.status_code == 200
    res = response.json()
    assert res["success"] is True
    assert res["data"]["category"] == "Woodcraft"
    assert len(res["data"]["tags"]) > 0

def test_pricing_predict_standard():
    payload = {
        "materialCost": 300,
        "labourHours": 12,
        "hourlyRate": 30,
        "overhead": 50,
        "marginPercent": 20,
        "craftComplexity": "medium"
    }
    response = client.post("/ai/pricing/predict", json=payload)
    assert response.status_code == 200
    res = response.json()
    assert res["success"] is True
    data = res["data"]
    assert data["suggestedPrice"] > 0
    assert data["minimumPrice"] <= data["suggestedPrice"]
    assert data["maximumPrice"] >= data["suggestedPrice"]
    assert data["breakdown"]["materialCost"] == 300
    assert data["breakdown"]["labourCost"] == 360

def test_pricing_model_is_persisted_and_returns_prediction_range():
    from app.pricing.pricing_engine import MODEL_PATH, _load_model

    _load_model.cache_clear()
    response = client.post("/ai/pricing/predict", json={"materialCost": 300})
    assert response.status_code == 200
    data = response.json()["data"]
    assert MODEL_PATH.is_file()
    assert data["minimumPrice"] <= data["suggestedPrice"] <= data["maximumPrice"]

def test_pricing_rejects_invalid_complexity():
    response = client.post(
        "/ai/pricing/predict",
        json={"materialCost": 100, "craftComplexity": "unknown"},
    )
    assert response.status_code == 400
    assert response.json()["success"] is False

def test_pricing_predict_negative_material_cost():
    payload = {"materialCost": -50}
    response = client.post("/ai/pricing/predict", json=payload)
    assert response.status_code in [400, 422]
    res = response.json()
    assert res["success"] is False or "detail" in res

def test_recommendations_rank_preferred_products():
    payload = {
        "products": [
            {
                "productId": "pot-1",
                "category": "Pottery",
                "tags": ["handmade"],
                "materials": ["clay"],
                "rating": 4.2,
                "reviews": 20,
            },
            {
                "productId": "loom-1",
                "category": "Handloom",
                "tags": ["silk"],
                "materials": ["cotton"],
                "rating": 4.8,
                "reviews": 100,
            },
        ],
        "preferredCategories": ["Pottery"],
        "preferredTags": ["clay"],
        "limit": 1,
    }
    response = client.post("/ai/recommendations", json=payload)
    assert response.status_code == 200
    data = response.json()["data"]["recommendations"]
    assert len(data) == 1
    assert data[0]["productId"] == "pot-1"
    assert "Pottery" in data[0]["reason"]

def test_recommendations_require_products():
    response = client.post("/ai/recommendations", json={"products": []})
    assert response.status_code == 400
    assert response.json()["success"] is False

def test_image_process_without_background_removal(monkeypatch):
    monkeypatch.setattr(enhancer.config, "CLOUDINARY_CLOUD_NAME", "test-cloud")
    monkeypatch.setattr(enhancer.config, "CLOUDINARY_API_KEY", "test-key")
    monkeypatch.setattr(enhancer.config, "CLOUDINARY_API_SECRET", "test-secret")
    monkeypatch.setattr("cloudinary.uploader.upload", _fake_cloudinary_upload)
    # Create a small in-memory dummy image
    img = Image.new("RGB", (200, 200), color=(255, 100, 100))
    img_bytes = io.BytesIO()
    img.save(img_bytes, format="JPEG")
    img_bytes.seek(0)

    files = {"file": ("test_pot.jpg", img_bytes, "image/jpeg")}
    response = client.post("/ai/image/process", files=files, data={"removeBg": "false"})
    assert response.status_code == 200
    res = response.json()
    assert res["success"] is True
    assert "imageUrl" in res["data"]
    assert res["data"]["enhanced"] is False
    assert res["data"]["bgRemoved"] is False
    assert res["data"]["imageUrl"].startswith("https://res.cloudinary.com/")

def test_image_process_succeeds_without_background_removal_service(monkeypatch):
    monkeypatch.setattr(enhancer.config, "CLOUDINARY_CLOUD_NAME", "test-cloud")
    monkeypatch.setattr(enhancer.config, "CLOUDINARY_API_KEY", "test-key")
    monkeypatch.setattr(enhancer.config, "CLOUDINARY_API_SECRET", "test-secret")
    monkeypatch.setattr("cloudinary.uploader.upload", _fake_cloudinary_upload)
    image = Image.new("RGB", (20, 20), color=(255, 100, 100))
    image_bytes = io.BytesIO()
    image.save(image_bytes, format="JPEG")
    image_bytes.seek(0)
    files = {"file": ("test_pot.jpg", image_bytes, "image/jpeg")}
    response = client.post("/ai/image/process", files=files, data={"removeBg": "true"})
    assert response.status_code == 200
    assert response.json()["data"]["enhanced"] is True
    assert response.json()["data"]["bgRemoved"] is True
    assert response.json()["data"]["imageUrl"].startswith("https://res.cloudinary.com/")

def test_voice_transcribe(monkeypatch):
    monkeypatch.setattr(
        "app.main.transcribe_audio_file",
        lambda _: "This is a handmade clay pot priced at 900 rupees with quantity 4.",
    )
    # Create a dummy audio file buffer
    dummy_wav = b"RIFF44WAVEfmt \x10\x00\x00\x00\x01\x00\x01\x00D\xac\x00\x00\x88X\x01\x00\x02\x00\x10\x00data\x10\x00\x00\x00" + b"\x00" * 32
    files = {"file": ("voice.wav", io.BytesIO(dummy_wav), "audio/wav")}
    response = client.post("/ai/voice/transcribe", files=files)
    assert response.status_code == 200
    res = response.json()
    assert res["success"] is True
    assert isinstance(res["data"]["text"], str)
    assert len(res["data"]["text"]) > 0
