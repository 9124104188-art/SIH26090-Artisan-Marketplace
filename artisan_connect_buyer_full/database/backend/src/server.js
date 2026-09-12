require("dotenv").config();
const express = require("express");
const cors = require("cors");
const path = require("path");
const connectDB = require("./config/db");

// Routes
const authRoutes = require("./routes/auth");
const productRoutes = require("./routes/products");
const artisanRoutes = require("./routes/artisans");
const orderRoutes = require("./routes/orders");
const reviewRoutes = require("./routes/reviews");
const aiRoutes = require("./routes/ai");

const app = express();
const PORT = process.env.PORT || 3000;

const configuredOrigins = (process.env.FRONTEND_URLS || process.env.FRONTEND_URL || "")
  .split(",").map((origin) => origin.trim()).filter(Boolean);
app.use(cors({
  origin: (origin, callback) => {
    if (
      !origin ||
      configuredOrigins.includes(origin) ||
      /^http:\/\/localhost:\d+$/.test(origin) ||
      /^http:\/\/127\.0\.0\.1:\d+$/.test(origin)
    ) {
      return callback(null, true);
    }
    return callback(null, false);
  },
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));

app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true }));
app.use("/uploads", express.static(path.join(__dirname, "../uploads")));

// Health check
app.get("/api/health", (req, res) => {
  res.json({ success: true, data: { status: "healthy", service: "artisan-connect-api", timestamp: new Date().toISOString() } });
});

// Mount routes
app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/artisans", artisanRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/reviews", reviewRoutes);
app.use("/api/ai", aiRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: `Route ${req.method} ${req.path} not found.` });
});

// Global error handler
app.use((err, req, res, _next) => {
  console.error("[Error]", err.message);
  res.status(500).json({ success: false, message: err.message || "Internal server error." });
});

// Start listening immediately, then connect to MongoDB
const server = app.listen(PORT, () => {
  console.log(`\n✅ Artisan Connect API running on http://localhost:${PORT}`);
  console.log(`   Health: http://localhost:${PORT}/api/health`);
});
server.timeout = 180000;
server.headersTimeout = 185000;
server.keepAliveTimeout = 180000;

// Connect to MongoDB asynchronously (DB routes will fail gracefully if not connected)
connectDB();

module.exports = app;
