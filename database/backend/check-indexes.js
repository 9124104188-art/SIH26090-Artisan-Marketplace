require("dotenv").config();

const mongoose = require("mongoose");

const User = require("./src/models/User");
const Artisan = require("./src/models/Artisan");
const Product = require("./src/models/Product");
const Order = require("./src/models/Order");
const Review = require("./src/models/Review");

const checkIndexes = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);

    console.log("\n===== USERS =====");
    console.log(await User.collection.indexes());

    console.log("\n===== ARTISANS =====");
    console.log(await Artisan.collection.indexes());

    console.log("\n===== PRODUCTS =====");
    console.log(await Product.collection.indexes());

    console.log("\n===== ORDERS =====");
    console.log(await Order.collection.indexes());

    console.log("\n===== REVIEWS =====");
    console.log(await Review.collection.indexes());

    console.log("\nIndex verification completed successfully!");
  } catch (error) {
    console.error("Index verification failed:");
    console.error(error.message);
  } finally {
    await mongoose.disconnect();
  }
};

checkIndexes();
