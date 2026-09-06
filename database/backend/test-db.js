require("dotenv").config();

const connectDB = require("./src/config/db");

const testDatabase = async () => {
  await connectDB();
  console.log("Database test completed successfully!");
  process.exit(0);
};

testDatabase();
