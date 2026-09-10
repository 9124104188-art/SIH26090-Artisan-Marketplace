const express = require("express");
const fs = require("fs");
const path = require("path");
const Product = require("../models/Product");
const Artisan = require("../models/Artisan");
const { authenticate, requireRole } = require("../middleware/auth");

const router = express.Router();
const uploadsDir = path.resolve(__dirname, "../../uploads");

const removeUploadedImages = (images = []) => {
  for (const image of images) {
    if (typeof image !== "string") continue;
    let pathname;
    try {
      pathname = new URL(image, "http://localhost").pathname;
    } catch {
      continue;
    }
    if (!pathname.startsWith("/uploads/")) continue;
    const filePath = path.resolve(uploadsDir, path.basename(pathname));
    if (!filePath.startsWith(`${uploadsDir}${path.sep}`)) continue;
    try {
      fs.unlinkSync(filePath);
    } catch (error) {
      if (error.code !== "ENOENT") console.warn("Unable to remove product image:", error.message);
    }
  }
};

// GET /api/products
router.get("/", async (req, res) => {
  try {
    const { category, status = "published", search, artisanId, limit = 50, skip = 0 } = req.query;
    const filter = {};

    if (status) filter.status = status;
    if (category) filter.category = category;
    if (artisanId) filter.artisanId = artisanId;

    let query;
    if (search && search.trim()) {
      query = Product.find({ ...filter, $text: { $search: search.trim() } }, { score: { $meta: "textScore" } })
        .sort({ score: { $meta: "textScore" } });
    } else {
      query = Product.find(filter).sort({ createdAt: -1 });
    }

    const products = await query
      .populate("artisanId", "craftType location userId")
      .skip(Number(skip))
      .limit(Number(limit));

    return res.json({ success: true, data: products });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

// GET /api/products/:id
router.get("/:id", async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).populate("artisanId", "craftType location userId");
    if (!product) return res.status(404).json({ success: false, message: "Product not found." });
    return res.json({ success: true, data: product });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

// POST /api/products — artisan only
router.post("/", authenticate, requireRole("artisan"), async (req, res) => {
  try {
    const artisan = await Artisan.findOne({ userId: req.user.userId });
    if (!artisan) return res.status(403).json({ success: false, message: "No artisan profile found." });

    const { title, description, category, materials, tags, price, stock, images, status } = req.body;
    if (!title || !description || !category || price == null) {
      return res.status(400).json({ success: false, message: "title, description, category and price are required." });
    }

    const product = await Product.create({
      artisanId: artisan._id,
      title,
      description,
      category,
      materials: materials || [],
      tags: tags || [],
      price: Number(price),
      stock: stock == null ? 12 : Number(stock),
      images: images || [],
      status: status || "draft"
    });

    return res.status(201).json({ success: true, data: product });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

// PUT /api/products/:id — artisan owner only
router.put("/:id", authenticate, requireRole("artisan"), async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ success: false, message: "Product not found." });

    const artisan = await Artisan.findOne({ userId: req.user.userId });
    if (!artisan || product.artisanId.toString() !== artisan._id.toString()) {
      return res.status(403).json({ success: false, message: "You can only update your own products." });
    }

    const allowed = ["title", "description", "category", "materials", "tags", "price", "stock", "images", "status"];
    allowed.forEach((field) => { if (req.body[field] !== undefined) product[field] = req.body[field]; });

    await product.save();
    return res.json({ success: true, data: product });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

// DELETE /api/products/:id — artisan owner only
router.delete("/:id", authenticate, requireRole("artisan"), async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ success: false, message: "Product not found." });

    const artisan = await Artisan.findOne({ userId: req.user.userId });
    if (!artisan || product.artisanId.toString() !== artisan._id.toString()) {
      return res.status(403).json({ success: false, message: "You can only delete your own products." });
    }

    removeUploadedImages(product.images);
    await product.deleteOne();
    return res.json({ success: true, data: null });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;
