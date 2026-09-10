const express = require("express");
const Review = require("../models/Review");
const { authenticate, requireRole } = require("../middleware/auth");

const router = express.Router();

// GET /api/reviews?productId=<id>
router.get("/", async (req, res) => {
  try {
    const { productId } = req.query;
    const filter = {};
    if (productId) filter.productId = productId;

    const reviews = await Review.find(filter)
      .populate("buyerId", "name")
      .sort({ createdAt: -1 })
      .limit(100);

    return res.json({ success: true, data: reviews });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

// POST /api/reviews — buyer only
router.post("/", authenticate, requireRole("buyer"), async (req, res) => {
  try {
    const { productId, rating, comment } = req.body;

    if (!productId || rating == null) {
      return res.status(400).json({ success: false, message: "productId and rating are required." });
    }
    if (rating < 1 || rating > 5) {
      return res.status(400).json({ success: false, message: "rating must be between 1 and 5." });
    }

    const review = await Review.create({
      productId,
      buyerId: req.user.userId,
      rating: Number(rating),
      comment: comment || ""
    });

    const populated = await review.populate("buyerId", "name");
    return res.status(201).json({ success: true, data: populated });
  } catch (err) {
    if (err.code === 11000) {
      return res.status(409).json({ success: false, message: "You have already reviewed this product." });
    }
    return res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;
