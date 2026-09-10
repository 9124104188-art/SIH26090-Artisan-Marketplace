require("dotenv").config();

const connectDB = require("./src/config/db");
const User = require("./src/models/User");
const Product = require("./src/models/Product");
const Review = require("./src/models/Review");

const testReview = async () => {
  await connectDB();

  const buyer = await User.findOne({
    email: "testbuyer@example.com"
  });

  const product = await Product.findOne({
    title: "Traditional Handmade Pottery"
  });

  if (!buyer || !product) {
    console.log("Test buyer or product not found.");
    process.exit(1);
  }

  const review = await Review.create({
    productId: product._id,
    buyerId: buyer._id,
    rating: 5,
    comment: "Excellent handmade product!"
  });

  console.log("Review created successfully!");
  console.log(review);

  process.exit(0);
};

testReview();
