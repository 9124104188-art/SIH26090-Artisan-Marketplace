require("dotenv").config();

const connectDB = require("./src/config/db");
const User = require("./src/models/User");

const testUser = async () => {
  await connectDB();

  const user = await User.create({
    name: "Test Buyer",
    email: "testbuyer@example.com",
    passwordHash: "test-password-hash",
    role: "buyer"
  });

  console.log("User created successfully!");
  console.log(user);

  process.exit(0);
};

testUser();
