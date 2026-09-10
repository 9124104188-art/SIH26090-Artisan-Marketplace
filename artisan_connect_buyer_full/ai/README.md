# Artisan Connect - AI/ML Microservice

**SIH26090 – AI-Driven Market Linkage & Smart Cataloging Mobile Application for Marginalized Artisans**

This repository contains the standalone, production-ready **Python + FastAPI AI Microservice** designed for free-tier operation, local execution, and low latency.

---

## 🌟 Features Overview

1. **Voice-to-Text Transcription (`/ai/voice/transcribe`)**: Converts artisan spoken descriptions into plain text via local audio parser & `SpeechRecognition`.
2. **Product Classification (`/ai/product/classify`)**: Categorizes artisan crafts into Pottery, Handloom, Woodcraft, Basketry, Jewellery, Painting, or Other.
3. **Smart Catalog Generation (`/ai/catalog/generate`)**: Autogenerates structured `title`, `description`, `category`, `craftType`, `materials`, and `tags`.
4. **Category & Craft Tags Extraction (`/ai/product/tags`)**: Extracts relevant craft metadata and indexing tags.
5. **Image Processing & Enhancement (`/ai/image/process`)**: Pipeline: `Raw Image -> Resize -> Quality Enhancement -> Background Removal -> Processed Output`.
6. **Transparent Smart Pricing Engine (`/ai/pricing/predict`)**: Transparent formula incorporating material cost, labor hours/rate, craft complexity, overhead, and margin.

---

## 🛠️ Setup & Installation

### Prerequisites
- Python `3.10+` (Tested on Python `3.14`)
- `pip` package manager

### Installation Steps

1. **Navigate to the AI directory**:
   ```bash
   cd ai
   ```

2. **Create a virtual environment (optional but recommended)**:
   ```bash
   python -m venv venv
   # On Windows:
   venv\Scripts\activate
   # On Linux/macOS:
   source venv/bin/activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up Environment Variables**:
   Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

---

## 🚀 Running the FastAPI Service

Start the server using `uvicorn`:

```bash
uvicorn app.main:app --reload --port 8000
```

The service will run locally at:
- **API Base URL**: `http://localhost:8000`
- **Interactive Swagger Docs**: `http://localhost:8000/docs`
- **ReDoc UI**: `http://localhost:8000/redoc`

---

## 📡 API Endpoints & Request Examples

### 1. Health Check
`GET /health`

**Response**:
```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "service": "artisan-ai-service",
    "version": "1.0.0"
  }
}
```

---

### 2. Image Processing & Enhancement
`POST /ai/image/process`  
*Content-Type: multipart/form-data*

**Form Data**:
- `file`: (Image binary - JPG, PNG, WEBP)
- `removeBg`: `true`

**Response**:
```json
{
  "success": true,
  "data": {
    "imageUrl": "/uploads/processed_a1b2c3d4.png",
    "originalName": "pottery_raw.jpg",
    "width": 1024,
    "height": 1024,
    "enhanced": true,
    "bgRemoved": true
  }
}
```

---

### 3. Voice Transcription
`POST /ai/voice/transcribe`  
*Content-Type: multipart/form-data*

**Form Data**:
- `file`: (Audio binary - WAV, MP3, M4A, OGG)

**Response**:
```json
{
  "success": true,
  "data": {
    "text": "This is a handmade clay pot made using natural clay."
  }
}
```

---

### 4. Catalog Generation
`POST /ai/catalog/generate`  
*Content-Type: application/json*

**Request Body**:
```json
{
  "text": "This is a handmade clay pot made using natural clay. It takes two days to make."
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "title": "Handcrafted Natural Clay Pot",
    "description": "A traditional terracotta craft handcrafted using premium natural clay. Meticulously crafted by rural master artisans carrying forward generations of cultural heritage.",
    "category": "Pottery",
    "craftType": "Traditional Pottery",
    "materials": ["Natural Clay"],
    "tags": ["artisan-connect", "clay", "eco-friendly", "handmade", "home-decor", "pottery", "terracotta"]
  }
}
```

---

### 5. Product Classification
`POST /ai/product/classify`  
*Content-Type: application/json*

**Request Body**:
```json
{
  "text": "Handwoven Kanchipuram pure silk saree with zari border"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "category": "Handloom",
    "confidence": 0.94
  }
}
```

---

### 6. Category & Tags
`POST /ai/product/tags`  
*Content-Type: application/json*

**Request Body**:
```json
{
  "text": "Carved rosewood elephant statue",
  "category": "Woodcraft"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "category": "Woodcraft",
    "craftType": "Wood Carving",
    "materials": ["Rosewood"],
    "tags": ["artisan-made", "carved", "home-decor", "rosewood", "rustic", "woodcraft", "wooden"]
  }
}
```

---

### 7. Smart Pricing Prediction
`POST /ai/pricing/predict`  
*Content-Type: application/json*

**Request Body**:
```json
{
  "materialCost": 300,
  "labourHours": 12,
  "hourlyRate": 30,
  "overhead": 50,
  "marginPercent": 20,
  "craftComplexity": "medium"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "suggestedPrice": 850,
    "minimumPrice": 746,
    "maximumPrice": 1062,
    "breakdown": {
      "materialCost": 300.0,
      "labourCost": 360.0,
      "overhead": 50.0,
      "margin": 140.3,
      "complexityMultiplier": 1.15
    }
  }
}
```

---

## 🧪 Testing

Run pytest from the `ai/` directory:

```bash
python -m pytest tests
```

---

## ⚡ Free-Tier & Offline Design

- **Zero Cloud Costs**: Uses local deterministic NLP & computer vision algorithms.
- **Graceful Fallbacks**: If external audio/LLM libraries are unavailable, local rule engines step in seamlessly without failing.
- **Unified Contract**: All endpoints strictly use field names (`title`, `description`, `category`, `craftType`, `materials`, `tags`, `suggestedPrice`, `minimumPrice`, `maximumPrice`).
