const router = require("express").Router();
const controller = require("../controllers/orderController");
const { authenticate } = require("../middleware/authMiddleware");

router.post("/", authenticate, controller.createOrder);
router.get("/", authenticate, controller.getOrders);
router.put("/:id/status", authenticate, controller.updateStatus);

module.exports = router;