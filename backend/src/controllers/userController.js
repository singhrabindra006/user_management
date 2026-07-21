const userService = require("../services/userService");
const { success, error } = require("../utils/response");

// Register new user
const register = async (req, res) => {
  try {
    const { name } = req.body;

    if (!name || name.trim() === "") {
      return error(res, "Name is required", 400);
    }

    const user = await userService.registerUser(
      req.user.uid,
      req.user.email,
      name,
    );

    return success(res, "User registered", user, 201);
  } catch (err) {
    return error(res, err.message, 400);
  }
};

// Get user profile
const getProfile = async (req, res) => {
  try {
    const user = await userService.getUserProfile(req.user.uid);

    return success(res, "Profile fetched", user);
  } catch (err) {
    return error(res, err.message, 404);
  }
};

// Complete user profile
const completeProfile = async (req, res) => {
  try {
    if (req.file) {
      console.log("File Details:", {
        fieldname: req.file.fieldname,
        originalname: req.file.originalname,
        mimetype: req.file.mimetype,
        size: req.file.size,
      });
    }

    const { name } = req.body;
    const imageBuffer = req.file?.buffer;
    const mimeType = req.file?.mimetype;

    if (!name || name.trim() === "") {
      return error(res, "Name is required", 400);
    }

    if (!imageBuffer) {
      return error(res, "Profile image is required", 400);
    }

    const user = await userService.completeProfile(
      req.user.uid,
      name,
      imageBuffer,
      mimeType,
    );

    return success(res, "Profile completed", user);
  } catch (err) {
    return error(res, err.message, 400);
  }
};

// Update user profile
const updateProfile = async (req, res) => {
  try {
    console.log("[userController] UPDATE PROFILE");
    const { name } = req.body;
    const imageBuffer = req.file?.buffer || null;
    const mimeType = req.file?.mimetype || null;

    console.log("Name:", name);
    console.log("Has Image:", !!imageBuffer);

    const user = await userService.updateUserProfile(req.user.uid, {
      name,
      imageBuffer,
      mimeType,
    });
    return success(res, "Profile updated", user);
  } catch (err) {
    return error(res, err.message, 400);
  }
};

// Delete user profile
const deleteProfile = async (req, res) => {
  try {
    await userService.deleteUser(req.user.uid);
    return success(res, "User deleted");
  } catch (err) {
    return error(res, err.message, 400);
  }
};

module.exports = {
  register,
  getProfile,
  completeProfile,
  updateProfile,
  deleteProfile,
};
