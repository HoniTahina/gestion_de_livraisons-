const router = require("express").Router();
const controller = require("../controllers/adminController");
const { authenticate, authorizeRole } = require("../middleware/authMiddleware");

router.get("/stats", authenticate, authorizeRole("admin"), controller.getStats);
router.post("/users", authenticate, authorizeRole("admin"), controller.createUser);

module.exports = router;
