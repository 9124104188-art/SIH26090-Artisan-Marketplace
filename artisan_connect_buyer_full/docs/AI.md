# SIH26090 – AI Architecture & Integration Specification

## 1. Executive Summary

This document specifies the technical architecture, data contracts, and integration protocols for the **AI/ML Module** of **Artisan Connect** (SIH26090).

The AI microservice is built using **Python + FastAPI**, optimized for low resource usage, free-tier execution, and zero mandatory cloud API costs. It serves as the intelligent backend engine for both the **Node.js Gateway Backend** and the **Flutter Mobile Application**.

---

## 2. System Architecture & Flow

```text
               +-----------------------+
               |  Flutter Mobile App   |
               +-----------+-----------+
                           |
                           v
               +-----------------------+
               |  Node.js API Gateway  |
               +-----------+-----------+
                           |
                           v
               +-----------------------+
               |   FastAPI AI Service  |
               |     (Port 8000)       |
               +-----------+-----------+
                           |
     +---------------------+---------------------+
     |                     |                     |
     v                     v                     v
+---------+         +--------------+      +--------------+
| Vision  |         |  Voice NLP   |      | Smart Price  |
| Engine  |         | Transcriber  |      | Calculator   |
+---------+         +--------------+      +--------------+
```

---

## 3. Shared Data Contract

All AI services output data conforming strictly to the shared product data contract:

| Field Name | Type | Description |
| :--- | :--- | :--- |
| `title` | `String` | Polished product title |
| `description` | `String` | Storytelling product description |
| `category` | `String` | Standard craft category (`Pottery`, `Handloom`, `Woodcraft`, `Basketry`, `Jewellery`, `Painting`, `Other`) |
| `craftType` | `String` | Specific craft technique (e.g. `Traditional Pottery`, `Handloom Weaving`) |
| `materials` | `Array<String>` | List of raw materials used (e.g. `["Natural Clay"]`) |
| `images` / `imageUrl` | `String` | Enhanced image path or URL |
| `suggestedPrice` | `Integer` | Fair market price estimate in INR |
| `minimumPrice` | `Integer` | Price floor covering direct costs + buffer |
| `maximumPrice` | `Integer` | Upper ceiling for premium market listing |
| `tags` | `Array<String>` | Indexing and search tags |

---

## 4. Endpoint Specifications

### Gateway Base URL
`http://localhost:8000`

### Endpoints

| Endpoint | Method | Input | Output | Description |
| :--- | :--- | :--- | :--- | :--- |
| `/health` | `GET` | None | `HealthData` | Service liveness check |
| `/ai/image/process` | `POST` | `multipart/form-data` (`file`, `removeBg`) | `ImageProcessResponseData` | Resizes, enhances contrast/sharpness, and cleans backdrop |
| `/ai/voice/transcribe` | `POST` | `multipart/form-data` (`file`) | `VoiceTranscribeResponseData` | Speech-to-Text transcription |
| `/ai/catalog/generate` | `POST` | `application/json` (`text`, `category`, `artisanInfo`) | `CatalogGenerateData` | Autogenerates title, description, materials, and tags |
| `/ai/product/classify` | `POST` | `application/json` (`text`) | `ClassifyData` | Craft classification + confidence score |
| `/ai/product/tags` | `POST` | `application/json` (`text`, `category`) | `TagsData` | Extracts craft tags and material attributes |
| `/ai/pricing/predict` | `POST` | `application/json` (`materialCost`, `labourHours`, etc.) | `PricingData` | Transparent formula pricing calculation |

---

## 5. Standard JSON Envelope

### Success Response Format (HTTP 200)
```json
{
  "success": true,
  "data": { ... }
}
```

### Error Response Format (HTTP 400 / 404 / 500)
```json
{
  "success": false,
  "message": "Detailed error explanation"
}
```

---

## 6. Integration Checklist for Developers

### Node.js Backend Developer:
1. Proxy requests from Node.js routes (e.g., `POST /api/v1/ai/catalog`) to FastAPI (`http://localhost:8000/ai/catalog/generate`).
2. Pass the standard data envelope directly back to the Flutter app.
3. Ensure file uploads (`multipart/form-data`) pass the binary stream directly to `/ai/image/process` and `/ai/voice/transcribe`.

### Flutter Mobile Developer:
1. Direct audio recordings from artisan voice input to `/ai/voice/transcribe`.
2. Connect photo uploads in the Add Product Flow wizard to `/ai/image/process`.
3. Use `/ai/catalog/generate` for one-click auto-fill of product title, description, category, craft type, materials, and tags.
4. Auto-populate price inputs using `/ai/pricing/predict`.
