const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log("✅ MongoDB connected successfully!");
  } catch (error) {
    console.error("⚠️  MongoDB connection failed:", error.message);
    console.error("    Check: MONGODB_URI is set and this IP is whitelisted on Atlas.");
    // Do not exit — allow health check and non-DB routes to serve
  }
};

module.exports = connectDB;
