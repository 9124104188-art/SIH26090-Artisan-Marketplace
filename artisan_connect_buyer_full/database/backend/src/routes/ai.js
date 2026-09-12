const express = require("express");
const axios = require("axios");
const multer = require("multer");
const FormData = require("form-data");
const { authenticate } = require("../middleware/auth");

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 12 * 1024 * 1024 } });
const handleUpload = (field) => (req, res, next) => {
  upload.single(field)(req, res, (error) => {
    if (!error) return next();
    if (error instanceof multer.MulterError && error.code === "LIMIT_FILE_SIZE") {
      return res.status(413).json({ success: false, message: "Uploaded file must be 12 MB or smaller." });
    }
    return res.status(400).json({ success: false, message: "Invalid multipart upload." });
  });
};

const AI_BASE = () => {
  const configuredUrl = process.env.AI_SERVICE_URL;
  if (configuredUrl) return configuredUrl.replace(/\/$/, "");
  if (process.env.NODE_ENV === "development") return "http://localhost:8000";
  throw new Error("AI_SERVICE_URL is required outside development.");
};

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

// POST /api/ai/image/process — authenticated image-processing proxy
router.post("/image/process", handleUpload("file"), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ success: false, message: "Missing image file in request." });
  }
  try {
    const form = new FormData();
    form.append("file", req.file.buffer, {
      filename: req.file.originalname,
      contentType: req.file.mimetype || "application/octet-stream"
    });
    form.append("removeBg", req.body.removeBg === "false" ? "false" : "true");
    const response = await axios.post(`${AI_BASE()}/ai/image/process`, form, {
      headers: form.getHeaders(),
      timeout: 180000,
      maxContentLength: Infinity,
      maxBodyLength: Infinity
    });
    const data = response.data && response.data.data;
    if (data && typeof data.imageUrl === "string" && data.imageUrl.startsWith("/")) {
      data.imageUrl = `${AI_BASE()}${data.imageUrl}`;
    }
    return res.status(response.status).json(response.data);
  } catch (err) {
    if (err.response) return res.status(err.response.status).json(err.response.data);
    if (err.message === "AI_SERVICE_URL is required outside development.") {
      return res.status(503).json({ success: false, message: "AI service is not configured." });
    }
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
