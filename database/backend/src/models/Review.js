const mongoose = require("mongoose");

const reviewSchema = new mongoose.Schema(
  {
    productId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Product",
      required: true
    },

    buyerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    rating: {
      type: Number,
      required: true,
      min: 1,
      max: 5
    },

    comment: {
      type: String,
      trim: true,
      default: ""
    }
  },
  {
    timestamps: true,
    collection: "reviews"
  }
);

// A buyer can review a product only once
reviewSchema.index(
  { productId: 1, buyerId: 1 },
  {
    unique: true
  }
);

module.exports = mongoose.model("Review", reviewSchema);
