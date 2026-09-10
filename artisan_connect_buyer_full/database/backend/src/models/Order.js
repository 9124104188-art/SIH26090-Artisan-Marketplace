const mongoose = require("mongoose");

const orderItemSchema = new mongoose.Schema(
  {
    productId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Product",
      required: true
    },

    artisanId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Artisan",
      required: true
    },

    quantity: {
      type: Number,
      required: true,
      min: 1
    },

    priceAtOrder: {
      type: Number,
      required: true,
      min: 0
    }
  },
  {
    _id: false
  }
);

const orderSchema = new mongoose.Schema(
  {
    buyerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    items: {
      type: [orderItemSchema],
      required: true,
      validate: {
        validator: function (items) {
          return items.length > 0;
        },
        message: "An order must contain at least one item."
      }
    },

    status: {
      type: String,
      enum: [
        "pending",
        "confirmed",
        "processing",
        "shipped",
        "delivered",
        "cancelled"
      ],
      default: "pending"
    },

    totalAmount: {
      type: Number,
      required: true,
      min: 0
    }
  },
  {
    timestamps: true,
    collection: "orders"
  }
);

// Required indexes
orderSchema.index({ buyerId: 1 });
orderSchema.index({ "items.artisanId": 1 });
orderSchema.index({ status: 1 });

module.exports = mongoose.model("Order", orderSchema);
