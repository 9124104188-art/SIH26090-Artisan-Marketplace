const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },

    email: {
      type: String,
      required: true,
      trim: true,
      lowercase: true
    },

    passwordHash: {
      type: String,
      required: true
    },

    role: {
      type: String,
      enum: ["buyer", "artisan", "admin"],
      required: true
    }
  },
  {
    timestamps: true,
    collection: "users"
  }
);

// Unique case-insensitive email index
userSchema.index(
  { email: 1 },
  {
    unique: true,
    collation: {
      locale: "en",
      strength: 2
    }
  }
);

// Role index
userSchema.index({ role: 1 });

module.exports = mongoose.model("User", userSchema);