const router = require("express").Router();
const controller = require("../controllers/userController");
const { authenticate, authorizeRole } = require("../middleware/authMiddleware");

router.get("/", authenticate, authorizeRole("admin"), controller.getUsers);
router.get("/me", authenticate, controller.getProfile);
router.put("/me", authenticate, controller.updateProfile);

module.exports = router;