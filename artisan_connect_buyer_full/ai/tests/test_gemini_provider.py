import json

import pytest
from fastapi.testclient import TestClient

from app import config
from app.catalog import generator
from app.main import app


client = TestClient(app)


def test_gemini_missing_key_returns_service_error(monkeypatch):
    monkeypatch.setattr(config, "LLM_PROVIDER", "gemini")
    monkeypatch.setattr(config, "LLM_API_KEY", "")
    monkeypatch.setattr(generator, "LLM_PROVIDER", "gemini")
    monkeypatch.setattr(generator, "LLM_API_KEY", "")

    response = client.post("/ai/catalog/generate", json={"text": "A handmade clay pot"})

    assert response.status_code == 503
    assert response.json() == {
        "success": False,
        "message": "Gemini is enabled but LLM_API_KEY is missing.",
    }


def test_gemini_response_is_normalized(monkeypatch):
    class FakeModels:
        def generate_content(self, **kwargs):
            return type(
                "Response",
                (),
                {
                    "text": json.dumps(
                        {
                            "title": "Gemini Clay Pot",
                            "description": "A hand-shaped clay pot.",
                            "category": "Unknown",
                            "craftType": "Traditional Pottery",
                            "materials": ["Natural Clay"],
                            "tags": ["handmade", "pottery"],
                            "confidence": 1.4,
                        }
                    )
                },
            )()

    class FakeClient:
        models = FakeModels()

    monkeypatch.setattr(generator, "LLM_PROVIDER", "gemini")
    monkeypatch.setattr(generator, "LLM_API_KEY", "test-key")
    monkeypatch.setattr(generator.genai, "Client", lambda **kwargs: FakeClient())

    result = generator.generate_catalog_fields("A handmade clay pot")

    assert result["category"] == "Pottery"
    assert result["confidence"] == 1.0
    assert result["materials"] == ["Natural Clay"]


def test_gemini_invalid_json_returns_provider_error(monkeypatch):
    class FakeModels:
        def generate_content(self, **kwargs):
            return type("Response", (), {"text": "not-json"})()

    class FakeClient:
        models = FakeModels()

    monkeypatch.setattr(generator, "LLM_PROVIDER", "gemini")
    monkeypatch.setattr(generator, "LLM_API_KEY", "test-key")
    monkeypatch.setattr(generator.genai, "Client", lambda **kwargs: FakeClient())

    with pytest.raises(generator.CatalogProviderError) as error:
        generator.generate_catalog_fields("A handmade clay pot")

    assert error.value.status_code == 502
    assert str(error.value) == "Gemini returned an invalid catalog response."


def test_gemini_rate_limit_returns_retryable_error(monkeypatch):
    class FakeModels:
        def generate_content(self, **kwargs):
            from google.genai import errors as genai_errors

            raise genai_errors.APIError(429, {"error": {"message": "rate limited"}})

    class FakeClient:
        models = FakeModels()

    monkeypatch.setattr(generator, "LLM_PROVIDER", "gemini")
    monkeypatch.setattr(generator, "LLM_API_KEY", "test-key")
    monkeypatch.setattr(generator.genai, "Client", lambda **kwargs: FakeClient())

    with pytest.raises(generator.CatalogProviderError) as error:
        generator.generate_catalog_fields("A handmade clay pot")

    assert error.value.status_code == 429
    assert str(error.value) == "Gemini rate limit reached. Please try again shortly."