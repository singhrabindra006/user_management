const userRepository = require("../repositories/userRepository");
const admin = require("../config/firebase");

const formatUser = (user) => {
  if (!user) return null;

  let profileImageBase64 = null;
  if (user.profile_image && user.image_mime_type) {
    profileImageBase64 = user.profile_image.toString("base64");
  }

  return {
    firebase_uid: user.firebase_uid,
    email: user.email,
    name: user.name,
    profile_image_base64: profileImageBase64,
    profile_completed: !!user.profile_completed,
    created_at: user.created_at,
    updated_at: user.updated_at,
  };
};

// Register new user
const registerUser = async (uid, email, name) => {
  const existing = await userRepository.findByUid(uid);

  if (existing) {
    throw new Error("User already exists");
  }

  const newUser = await userRepository.create(uid, email, name);

  return formatUser(newUser);
};

//Get user profile
const getUserProfile = async (uid) => {
  const user = await userRepository.findByUid(uid);

  if (!user) {
    throw new Error("User not found");
  }

  return formatUser(user);
};

// Complete user profile
const completeProfile = async (uid, name, imageBuffer, mimeType) => {
  const exists = await userRepository.exists(uid);
  if (!exists) {
    throw new Error("User not found");
  }

  const updatedUser = await userRepository.updateProfile(
    uid,
    name,
    imageBuffer,
    mimeType,
  );

  if (!updatedUser) {
    throw new Error("Failed to update profile");
  }
  return formatUser(updatedUser);
};

// Update user profile
const updateUserProfile = async (uid, { name, imageBuffer, mimeType }) => {
  const exists = await userRepository.exists(uid);
  if (!exists) {
    throw new Error("User not found");
  }

  let user;

  if (name && imageBuffer) {
    user = await userRepository.updateProfile(uid, name, imageBuffer, mimeType);
  } else if (name) {
    user = await userRepository.updateName(uid, name);
  } else if (imageBuffer) {
    user = await userRepository.updateImage(uid, imageBuffer, mimeType);
  } else {
    throw new Error("Nothing to update");
  }

  return formatUser(user);
};

// Delete user
const deleteUser = async (uid) => {
  const exists = await userRepository.exists(uid);
  if (!exists) {
    throw new Error("User not found");
  }

  try {
    await userRepository.delete(uid);
    await admin.auth().deleteUser(uid);
    return true;
  } catch (err) {
    throw new Error("Failed to delete user");
  }
};

module.exports = {
  registerUser,
  getUserProfile,
  completeProfile,
  updateUserProfile,
  deleteUser,
};
