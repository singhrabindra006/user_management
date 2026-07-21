const express = require("express");
const router = express.Router();
const { authenticateToken } = require("../middleware/auth");
const { upload, handleUploadError } = require("../middleware/upload");
const ctrl = require("../controllers/userController");

//All routes
router.post("/register", authenticateToken, ctrl.register);
router.get("/me", authenticateToken, ctrl.getProfile);
router.post(
  "/complete",
  authenticateToken,
  upload.single("image"),
  handleUploadError,
  ctrl.completeProfile,
);
router.put(
  "/me",
  authenticateToken,
  upload.single("image"),
  handleUploadError,
  ctrl.updateProfile,
);
router.delete("/me", authenticateToken, ctrl.deleteProfile);

module.exports = router;
