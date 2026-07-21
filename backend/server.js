require("dotenv").config();
const app = require("./src/app");
const { testConnection, pool } = require("./src/config/database");
const { userTableQuery } = require("./src/models/userSchema");

const PORT = process.env.PORT || 3000;

const startServer = async () => {
  try {
    await testConnection();
    await pool.execute(userTableQuery);
    console.log("Users table ready");

    app.listen(PORT, "0.0.0.0", () => {
      console.log(`\nServer running on port ${PORT}`);
      console.log(`Local: http://localhost:${PORT}`);
      console.log(`Network: http://192.168.1.8:${PORT}`);
    });
  } catch (err) {
    console.error("Failed to start:", err);
    process.exit(1);
  }
};

startServer();
