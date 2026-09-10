require("dotenv").config();

const connectDB = require("./src/config/db");
const User = require("./src/models/User");
const Artisan = require("./src/models/Artisan");

const testArtisan = async () => {
  await connectDB();

  const user = await User.findOne({
    email: "testbuyer@example.com"
  });

  if (!user) {
    console.log("Test user not found.");
    process.exit(1);
  }

  const artisan = await Artisan.create({
    userId: user._id,
    craftType: "Handmade Pottery",
    location: "Tamil Nadu"
  });

  console.log("Artisan created successfully!");
  console.log(artisan);

  process.exit(0);
};

testArtisan();
