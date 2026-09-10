require("dotenv").config();

const connectDB = require("./src/config/db");
const Artisan = require("./src/models/Artisan");
const Product = require("./src/models/Product");

const testProduct = async () => {
  await connectDB();

  const artisan = await Artisan.findOne({
    craftType: "Handmade Pottery"
  });

  if (!artisan) {
    console.log("Test artisan not found.");
    process.exit(1);
  }

  const product = await Product.create({
    artisanId: artisan._id,
    title: "Traditional Handmade Pottery",
    description: "A handcrafted pottery item made by a rural artisan.",
    category: "Pottery",
    materials: ["Clay"],
    price: 500,
    images: [],
    status: "published"
  });

  console.log("Product created successfully!");
  console.log(product);

  process.exit(0);
};

testProduct();
