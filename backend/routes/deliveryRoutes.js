const router = require("express").Router();
const controller = require("../controllers/deliveryController");
const { authenticate, authorizeRole } = require("../middleware/authMiddleware");

router.post("/assign", authenticate, authorizeRole(["admin"]), controller.assignDelivery);
router.put("/:id/status", authenticate, authorizeRole(["admin", "livreur"]), controller.updateStatus);
router.get("/", authenticate, controller.getDeliveries);

module.exports = router;