const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const Artisan = require("../models/Artisan");
const { JWT_SECRET } = require("../middleware/auth");

const router = express.Router();

// POST /api/auth/register
router.post("/register", async (req, res) => {
  try {
    const { name, email, password, role, craftType, location } = req.body;

    if (!name || !email || !password || !role) {
      return res.status(400).json({ success: false, message: "name, email, password and role are required." });
    }
    if (!["buyer", "artisan"].includes(role)) {
      return res.status(400).json({ success: false, message: "role must be 'buyer' or 'artisan'." });
    }
    if (password.length < 6) {
      return res.status(400).json({ success: false, message: "Password must be at least 6 characters." });
    }

    const existing = await User.findOne({ email: email.toLowerCase().trim() }).collation({ locale: "en", strength: 2 });
    if (existing) {
      return res.status(409).json({ success: false, message: "An account with this email already exists." });
    }

    const passwordHash = await bcrypt.hash(password, 12);
    const user = await User.create({ name: name.trim(), email: email.toLowerCase().trim(), passwordHash, role });

    let artisanId = null;
    if (role === "artisan") {
      if (!craftType || !location) {
        return res.status(400).json({ success: false, message: "craftType and location are required for artisan registration." });
      }
      const artisan = await Artisan.create({ userId: user._id, craftType: craftType.trim(), location: location.trim() });
      artisanId = artisan._id;
    }

    const token = jwt.sign(
      { userId: user._id, role: user.role, name: user.name, artisanId },
      JWT_SECRET,
      { expiresIn: "30d" }
    );

    return res.status(201).json({
      success: true,
      data: {
        token,
        user: { id: user._id, name: user.name, email: user.email, role: user.role, artisanId }
      }
    });
  } catch (err) {
    if (err.code === 11000) {
      return res.status(409).json({ success: false, message: "An account with this email already exists." });
    }
    return res.status(500).json({ success: false, message: err.message });
  }
});

// POST /api/auth/login
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, message: "email and password are required." });
    }

    const user = await User.findOne({ email: email.toLowerCase().trim() }).collation({ locale: "en", strength: 2 });
    if (!user) {
      return res.status(401).json({ success: false, message: "Invalid email or password." });
    }

    const match = await bcrypt.compare(password, user.passwordHash);
    if (!match) {
      return res.status(401).json({ success: false, message: "Invalid email or password." });
    }

    let artisanId = null;
    if (user.role === "artisan") {
      const artisan = await Artisan.findOne({ userId: user._id });
      artisanId = artisan ? artisan._id : null;
    }

    const token = jwt.sign(
      { userId: user._id, role: user.role, name: user.name, artisanId },
      JWT_SECRET,
      { expiresIn: "30d" }
    );

    return res.json({
      success: true,
      data: {
        token,
        user: { id: user._id, name: user.name, email: user.email, role: user.role, artisanId }
      }
    });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;
