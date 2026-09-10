const express = require("express");
const Artisan = require("../models/Artisan");
const { authenticate, requireRole } = require("../middleware/auth");

const router = express.Router();

// GET /api/artisans
router.get("/", async (req, res) => {
  try {
    const { craftType, location, limit = 50, skip = 0 } = req.query;
    const filter = {};
    if (craftType) filter.craftType = { $regex: craftType, $options: "i" };
    if (location) filter.location = { $regex: location, $options: "i" };

    const artisans = await Artisan.find(filter)
      .populate("userId", "name email")
      .skip(Number(skip))
      .limit(Number(limit))
      .sort({ createdAt: -1 });

    return res.json({ success: true, data: artisans });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

// GET /api/artisans/:id
router.get("/:id", async (req, res) => {
  try {
    const artisan = await Artisan.findById(req.params.id).populate("userId", "name email");
    if (!artisan) return res.status(404).json({ success: false, message: "Artisan not found." });
    return res.json({ success: true, data: artisan });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

// PUT /api/artisans/:id — artisan (self) or admin only
router.put("/:id", authenticate, requireRole("artisan", "admin"), async (req, res) => {
  try {
    const artisan = await Artisan.findById(req.params.id);
    if (!artisan) return res.status(404).json({ success: false, message: "Artisan not found." });

    // Artisan can only update their own profile
    if (req.user.role === "artisan" && artisan.userId.toString() !== req.user.userId) {
      return res.status(403).json({ success: false, message: "You can only update your own profile." });
    }

    const { craftType, location } = req.body;
    if (craftType) artisan.craftType = craftType.trim();
    if (location) artisan.location = location.trim();

    await artisan.save();
    return res.json({ success: true, data: artisan });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;
