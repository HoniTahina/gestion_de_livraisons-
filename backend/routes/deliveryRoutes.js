const router = require("express").Router();
const controller = require("../controllers/deliveryController");

router.post("/assign", controller.assignDelivery);
router.put("/:id/status", controller.updateStatus);
router.get("/", controller.getDeliveries);

module.exports = router;