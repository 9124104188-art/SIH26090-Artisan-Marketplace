const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
  {
    artisanId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Artisan",
      required: true
    },

    title: {
      type: String,
      required: true,
      trim: true
    },

    description: {
      type: String,
      required: true,
      trim: true
    },

    category: {
      type: String,
      required: true,
      trim: true
    },

    materials: {
      type: [String],
      default: []
    },

    price: {
      type: Number,
      required: true,
      min: 0
    },

    images: {
      type: [String],
      default: []
    },

    status: {
      type: String,
      enum: ["draft", "published", "archived"],
      default: "draft"
    }
  },
  {
    timestamps: true,
    collection: "products"
  }
);

// Required indexes
productSchema.index({ status: 1, category: 1 });
productSchema.index(
  { title: "text", description: "text" }
);
productSchema.index({ artisanId: 1 });

module.exports = mongoose.model("Product", productSchema);
