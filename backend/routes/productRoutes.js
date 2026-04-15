const router = require("express").Router();
const controller = require("../controllers/productController");

router.post("/", controller.createProduct);
router.get("/", controller.getProducts);

module.exports = router;