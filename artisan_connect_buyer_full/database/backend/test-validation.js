require("dotenv").config();

const mongoose = require("mongoose");

const User = require("./src/models/User");
const Product = require("./src/models/Product");
const Order = require("./src/models/Order");
const Review = require("./src/models/Review");

const testValidation = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);

    console.log("\n===== VALIDATION TESTS =====");

    // 1. Invalid user role
    try {
      await User.create({
        name: "Invalid Role Test",
        email: "invalid-role-test@example.com",
        passwordHash: "test",
        role: "invalid"
      });

      console.log("❌ ERROR: Invalid user role was accepted.");
    } catch (error) {
      console.log("✅ Invalid user role rejected.");
    }

    // 2. Invalid product status
    try {
      await Product.create({
        artisanId: new mongoose.Types.ObjectId(),
        title: "Invalid Status Test",
        description: "Test",
        category: "Test",
        price: 100,
        status: "invalid"
      });

      console.log("❌ ERROR: Invalid product status was accepted.");
    } catch (error) {
      console.log("✅ Invalid product status rejected.");
    }

    // 3. Invalid review rating
    try {
      await Review.create({
        productId: new mongoose.Types.ObjectId(),
        buyerId: new mongoose.Types.ObjectId(),
        rating: 6,
        comment: "Invalid rating test"
      });

      console.log("❌ ERROR: Invalid rating was accepted.");
    } catch (error) {
      console.log("✅ Invalid rating rejected.");
    }

    // 4. Invalid order quantity
    try {
      await Order.create({
        buyerId: new mongoose.Types.ObjectId(),
        items: [
          {
            productId: new mongoose.Types.ObjectId(),
            artisanId: new mongoose.Types.ObjectId(),
            quantity: 0,
            priceAtOrder: 100
          }
        ],
        totalAmount: 100
      });

      console.log("❌ ERROR: Invalid quantity was accepted.");
    } catch (error) {
      console.log("✅ Invalid quantity rejected.");
    }

    // 5. Order with no items
    try {
      await Order.create({
        buyerId: new mongoose.Types.ObjectId(),
        items: [],
        totalAmount: 0
      });

      console.log("❌ ERROR: Empty order was accepted.");
    } catch (error) {
      console.log("✅ Empty order rejected.");
    }

    // 6. Negative product price
    try {
      await Product.create({
        artisanId: new mongoose.Types.ObjectId(),
        title: "Negative Price Test",
        description: "Test",
        category: "Test",
        price: -100
      });

      console.log("❌ ERROR: Negative price was accepted.");
    } catch (error) {
      console.log("✅ Negative price rejected.");
    }

    console.log("\nValidation testing completed.");
  } catch (error) {
    console.error("Validation test failed:");
    console.error(error.message);
  } finally {
    await mongoose.disconnect();
  }
};

testValidation();
