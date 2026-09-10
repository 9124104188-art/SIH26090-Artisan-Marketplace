const mongoose = require("mongoose");

const artisanSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    craftType: {
      type: String,
      required: true,
      trim: true
    },

    location: {
      type: String,
      required: true,
      trim: true
    }
  },
  {
    timestamps: true,
    collection: "artisans"
  }
);

// Unique index on userId
artisanSchema.index(
  { userId: 1 },
  {
    unique: true
  }
);

// Indexes required by the specification
artisanSchema.index({ craftType: 1 });
artisanSchema.index({ location: 1 });

module.exports = mongoose.model("Artisan", artisanSchema);
