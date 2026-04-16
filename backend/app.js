require("dotenv").config();

const requiredEnvVars = ["DB_NAME", "DB_USER", "DB_PASS", "JWT_SECRET"];
const missingEnvVars = requiredEnvVars.filter((name) => !process.env[name]);

if (missingEnvVars.length > 0) {
  throw new Error(
    `Variables .env manquantes: ${missingEnvVars.join(", ")}. Veuillez compléter le fichier backend/.env.`
  );
}

const express = require("express");
const cors = require("cors");
const http = require("http");

// Import de la base de données
const sequelize = require("./config/db");

// Import des routes
const authRoutes = require("./routes/authRoutes");
const adminRoutes = require("./routes/adminRoutes");
const invitationRoutes = require("./routes/invitationRoutes");

const productRoutes = require("./routes/productRoutes");
const orderRoutes = require("./routes/orderRoutes");
const deliveryRoutes = require("./routes/deliveryRoutes");
const userRoutes = require("./routes/userRoutes");

console.log("DB USER:", process.env.DB_USER);
const PORT = process.env.PORT || 5310;
require("./models"); // Import des modèles et relations

const { User, Product } = require("./models");
const bcrypt = require("bcryptjs");
const { createDbBackup } = require("./utils/dbBackup");
const { realtimeEmitter } = require("./utils/realtime");

const createApp = () => {
  const appInstance = express();

  appInstance.use(cors());
  appInstance.use(express.json());

  appInstance.use("/auth", authRoutes);
  appInstance.use("/users", userRoutes);
  appInstance.use("/products", productRoutes);
  appInstance.use("/orders", orderRoutes);
  appInstance.use("/deliveries", deliveryRoutes);
  appInstance.use("/admin", adminRoutes);
  appInstance.use("/invitations", invitationRoutes);

  appInstance.get("/", (req, res) => {
    res.send("API Delivery Platform is running 🚀");
  });

  appInstance.get("/events", (req, res) => {
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");

    res.write(`data: ${JSON.stringify({ eventType: "connected" })}\n\n`);

    const onEvent = (event) => {
      res.write(`data: ${JSON.stringify(event)}\n\n`);
    };

    realtimeEmitter.on("event", onEvent);

    req.on("close", () => {
      realtimeEmitter.off("event", onEvent);
    });
  });

  return appInstance;
};

const setupWebSocketRealtime = (server) => {
  let WebSocketServer;
  try {
    WebSocketServer = require("ws").WebSocketServer;
  } catch (err) {
    console.warn("WebSocket non disponible (package ws manquant)");
    return;
  }

  const wss = new WebSocketServer({ server, path: "/ws" });

  const handler = (event) => {
    const data = JSON.stringify(event);
    for (const client of wss.clients) {
      if (client.readyState === 1) {
        client.send(data);
      }
    }
  };

  realtimeEmitter.on("event", handler);
  server.on("close", () => {
    realtimeEmitter.off("event", handler);
  });
};

// fonction pour initialiser la DB avec des données de test
const syncAndSeed = async () => {
  const resetDb = process.env.RESET_DB === "true";
  const isProd = process.env.NODE_ENV === "production";
  const dbAlterEnabled = process.env.DB_ALTER
    ? process.env.DB_ALTER === "true"
    : !isProd;

  await sequelize.sync({ force: resetDb, alter: !resetDb && dbAlterEnabled });

  const password = await bcrypt.hash("Password123!", 10);

  let admin = await User.findOne({ where: { email: "admin@platform.com" } });
  let seller1 = await User.findOne({ where: { email: "seller1@platform.com" } });
  let seller2 = await User.findOne({ where: { email: "seller2@platform.com" } });
  let deliveryUser = await User.findOne({ where: { email: "driver1@platform.com" } });
  let client = await User.findOne({ where: { email: "client1@platform.com" } });

  if (!admin) {
    admin = await User.create({ name: "Admin", email: "admin@platform.com", password, role: "admin" });
  }
  if (!seller1) {
    seller1 = await User.create({ name: "Vendeur 1", email: "seller1@platform.com", password, role: "vendeur" });
  }
  if (!seller2) {
    seller2 = await User.create({ name: "Vendeur 2", email: "seller2@platform.com", password, role: "vendeur" });
  }
  if (!deliveryUser) {
    deliveryUser = await User.create({ name: "Livreur 1", email: "driver1@platform.com", password, role: "livreur" });
  }
  if (!client) {
    client = await User.create({ name: "Client 1", email: "client1@platform.com", password, role: "client" });
  }

  const productCount = await Product.count();
  if (productCount === 0) {
    await Promise.all([
      Product.create({ name: "T-shirt bleu", price: 19.9, stock: 50, category: "Mode", vendorId: seller1.id }),
      Product.create({ name: "Casquette", price: 12.5, stock: 25, category: "Accessoires", vendorId: seller1.id }),
      Product.create({ name: "Sac à dos", price: 39.9, stock: 15, category: "Bagagerie", vendorId: seller2.id }),
      Product.create({ name: "Lunettes de soleil", price: 29.9, stock: 20, category: "Mode", vendorId: seller2.id }),
    ]);
  }
};

const waitForDatabase = async (maxRetries = 30, delayMs = 1000) => {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      await sequelize.authenticate();
      console.log("✓ Database connection successful");
      return;
    } catch (err) {
      if (attempt === maxRetries) {
        throw new Error(`Failed to connect to database after ${maxRetries} attempts: ${err.message}`);
      }
      console.log(`[${attempt}/${maxRetries}] Database not ready yet, retrying in ${delayMs}ms...`);
      await new Promise(resolve => setTimeout(resolve, delayMs));
    }
  }
};

const startServer = async () => {
  try {
    // Attendre que la base de données soit prête
    await waitForDatabase();
    
    if (process.env.AUTO_DB_BACKUP !== "false") {
      try {
        const backup = await createDbBackup();
        console.log(`Backup DB cree: ${backup.outputPath}`);
      } catch (backupError) {
        console.warn(`Backup ignore (non bloquant): ${backupError.message}`);
      }
    }

    await syncAndSeed();
    console.log("Database synced (without destructive reset)");

    const appInstance = createApp();
    const server = http.createServer(appInstance);
    setupWebSocketRealtime(server);

    server.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });

    return { app: appInstance, server };
  } catch (err) {
    console.error("Database connection error:", err);
    throw err;
  }
};

if (require.main === module) {
  startServer();
}

module.exports = {
  app: createApp(),
  createApp,
  syncAndSeed,
  startServer,
};