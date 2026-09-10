const express = require("express");
const Order = require("../models/Order");
const Product = require("../models/Product");
const Artisan = require("../models/Artisan");
const { authenticate, requireRole } = require("../middleware/auth");

const router = express.Router();

// GET /api/orders — buyer sees own orders, artisan sees orders containing their items
router.get("/", authenticate, async (req, res) => {
  try {
    let filter = {};
    if (req.user.role === "buyer") {
      filter.buyerId = req.user.userId;
    } else if (req.user.role === "artisan") {
      const artisan = await Artisan.findOne({ userId: req.user.userId });
      if (artisan) filter["items.artisanId"] = artisan._id;
    }

    const orders = await Order.find(filter)
      .populate("buyerId", "name email")
      .populate("items.productId", "title images")
      .sort({ createdAt: -1 })
      .limit(50);

    return res.json({ success: true, data: orders });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

// POST /api/orders — buyer only
router.post("/", authenticate, requireRole("buyer"), async (req, res) => {
  try {
    const { items } = req.body;
    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ success: false, message: "items array is required." });
    }

    // Validate each item and compute total
    let totalAmount = 0;
    const resolvedItems = [];

    for (const item of items) {
      if (!item.productId || !item.quantity || item.quantity < 1) {
        return res.status(400).json({ success: false, message: "Each item needs productId and quantity >= 1." });
      }
      const product = await Product.findById(item.productId);
      if (!product) {
        return res.status(404).json({ success: false, message: `Product ${item.productId} not found.` });
      }

      const priceAtOrder = item.priceAtOrder || product.price;
      totalAmount += priceAtOrder * item.quantity;

      resolvedItems.push({
        productId: product._id,
        artisanId: product.artisanId,
        quantity: item.quantity,
        priceAtOrder
      });
    }

    const order = await Order.create({
      buyerId: req.user.userId,
      items: resolvedItems,
      totalAmount,
      status: "pending"
    });

    return res.status(201).json({ success: true, data: order });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;
