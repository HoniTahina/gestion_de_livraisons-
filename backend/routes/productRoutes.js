const router = require("express").Router();
const controller = require("../controllers/productController");
const { authenticate, authorizeRole } = require("../middleware/authMiddleware");

router.post("/", authenticate, authorizeRole(["vendeur", "admin"]), controller.createProduct);
router.get("/", controller.getProducts);
router.put("/:id", authenticate, authorizeRole(["vendeur", "admin"]), controller.updateProduct);

module.exports = router;