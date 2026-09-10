require("dotenv").config();

const connectDB = require("./src/config/db");
const User = require("./src/models/User");
const Product = require("./src/models/Product");
const Order = require("./src/models/Order");

const testOrder = async () => {
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

  const order = await Order.create({
    buyerId: buyer._id,

    items: [
      {
        productId: product._id,
        artisanId: product.artisanId,
        quantity: 2,

        // Snapshot of the price when the order was placed
        priceAtOrder: product.price
      }
    ],

    status: "confirmed",

    totalAmount: product.price * 2
  });

  console.log("Order created successfully!");
  console.log(order);

  process.exit(0);
};

testOrder();
