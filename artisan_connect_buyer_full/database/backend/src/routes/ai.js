const express = require("express");
const axios = require("axios");
const crypto = require("crypto");
const fs = require("fs");
const path = require("path");
const multer = require("multer");
const FormData = require("form-data");
const { authenticate } = require("../middleware/auth");

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 12 * 1024 * 1024 } });
const uploadsDir = path.join(__dirname, "../../uploads");

const handleUpload = (field) => (req, res, next) => {
  upload.single(field)(req, res, (error) => {
    if (!error) return next();
    if (error instanceof multer.MulterError && error.code === "LIMIT_FILE_SIZE") {
      return res.status(413).json({ success: false, message: "Uploaded file must be 12 MB or smaller." });
    }
    return res.status(400).json({ success: false, message: "Invalid multipart upload." });
  });
};

const AI_BASE = () => (process.env.AI_SERVICE_URL || "http://localhost:8000").replace(/\/$/, "");

/**
 * Generic proxy: forwards request body to the FastAPI AI service,
 * keeps Gemini/LLM credentials safely on the server.
 */
const proxyToAI = async (req, res, aiPath) => {
  try {
    const url = `${AI_BASE()}${aiPath}`;
    const response = await axios.post(url, req.body, {
      headers: { "Content-Type": "application/json" },
      timeout: 30000
    });
    return res.status(response.status).json(response.data);
  } catch (err) {
    if (err.response) {
      return res.status(err.response.status).json(err.response.data);
    }
    return res.status(503).json({ success: false, message: "AI service is unavailable. Please try again later." });
  }
};

// All AI endpoints require authentication
router.use(authenticate);

// POST /api/ai/image/process — authenticated original image upload
router.post("/image/process", handleUpload("file"), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ success: false, message: "Missing image file in request." });
  }
  try {
    fs.mkdirSync(uploadsDir, { recursive: true });
    const extension = path.extname(req.file.originalname).toLowerCase() || ".bin";
    const filename = `original_${crypto.randomBytes(8).toString("hex")}${extension}`;
    fs.writeFileSync(path.join(uploadsDir, filename), req.file.buffer);
    return res.status(200).json({
      success: true,
      data: {
        imageUrl: `/uploads/${filename}`,
        originalName: req.file.originalname,
        enhanced: false,
        bgRemoved: false
      }
    });
  } catch (err) {
    return res.status(500).json({ success: false, message: "Unable to save the uploaded image." });
  }
});

// POST /api/ai/catalog/generate
router.post("/catalog/generate", (req, res) => proxyToAI(req, res, "/ai/catalog/generate"));

// POST /api/ai/voice/transcribe — authenticated multipart proxy
router.post("/voice/transcribe", handleUpload("file"), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ success: false, message: "Missing audio file in request." });
  }
  try {
    const form = new FormData();
    form.append("file", req.file.buffer, {
      filename: req.file.originalname,
      contentType: req.file.mimetype || "audio/wav"
    });
    const response = await axios.post(`${AI_BASE()}/ai/voice/transcribe`, form, {
      headers: form.getHeaders(),
      timeout: 45000,
      maxContentLength: Infinity,
      maxBodyLength: Infinity
    });
    return res.status(response.status).json(response.data);
  } catch (err) {
    if (err.response) return res.status(err.response.status).json(err.response.data);
    return res.status(503).json({ success: false, message: "AI service is unavailable. Please try again later." });
  }
});

// POST /api/ai/product/classify
router.post("/product/classify", (req, res) => proxyToAI(req, res, "/ai/product/classify"));

// POST /api/ai/product/tags
router.post("/product/tags", (req, res) => proxyToAI(req, res, "/ai/product/tags"));

// POST /api/ai/pricing/predict
router.post("/pricing/predict", (req, res) => proxyToAI(req, res, "/ai/pricing/predict"));

// POST /api/ai/recommendations
router.post("/recommendations", (req, res) => proxyToAI(req, res, "/ai/recommendations"));

// GET /api/ai/health — check AI service status
router.get("/health", async (req, res) => {
  try {
    const response = await axios.get(`${AI_BASE()}/health`, { timeout: 5000 });
    return res.json(response.data);
  } catch {
    return res.status(503).json({ success: false, message: "AI service is unavailable." });
  }
});

module.exports = router;
