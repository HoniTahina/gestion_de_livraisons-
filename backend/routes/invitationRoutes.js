const router = require("express").Router();
const controller = require("../controllers/invitationController");
const { authenticate, authorizeRole } = require("../middleware/authMiddleware");

router.post("/generate", authenticate, authorizeRole("admin"), controller.generateCode);
router.get("/", authenticate, authorizeRole("admin"), controller.getCodes);

module.exports = router;