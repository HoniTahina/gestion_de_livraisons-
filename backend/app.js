require("dotenv").config();

const express = require("express");
const cors = require("cors");

// Import de la base de données
const sequelize = require("./config/db");

// Import des routes
const authRoutes = require("./routes/authRoutes");

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Routes
app.use("/auth", authRoutes);

// Test route
app.get("/", (req, res) => {
  res.send("API Delivery Platform is running 🚀");
});

// Connexion DB + démarrage serveur
const PORT = process.env.PORT || 5000;

sequelize
  .sync()
  .then(() => {
    console.log("Database synced");
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Database connection error:", err);
  });