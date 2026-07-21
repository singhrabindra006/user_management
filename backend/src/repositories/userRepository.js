const { pool } = require("../config/database");

//  Find user by UID
const findByUid = async (uid) => {
  try {
    const [rows] = await pool.execute(
      "SELECT * FROM users WHERE firebase_uid = ?",
      [uid],
    );
    return rows[0] || null;
  } catch (err) {
    throw err;
  }
};

// Create new user
const create = async (uid, email, name) => {
  try {
    await pool.execute(
      "INSERT INTO users (firebase_uid, email, name) VALUES (?, ?, ?)",
      [uid, email, name],
    );
    return await findByUid(uid);
  } catch (err) {
    throw err;
  }
};
// update the profile image
const updateProfile = async (uid, name, imageBuffer, mimeType) => {
  try {
    const [result] = await pool.execute(
      "UPDATE users SET name = ?, profile_image = ?, image_mime_type = ?, profile_completed = TRUE WHERE firebase_uid = ?",
      [name, imageBuffer, mimeType, uid],
    );
    if (result.affectedRows === 0) {
      throw new Error("User not found or update failed");
    }
    return await findByUid(uid);
  } catch (err) {
    throw err;
  }
};

// Update name only
const updateName = async (uid, name) => {
  try {
    const [result] = await pool.execute(
      "UPDATE users SET name = ? WHERE firebase_uid = ?",
      [name, uid],
    );
    return await findByUid(uid);
  } catch (err) {
    throw err;
  }
};

// Update image only
const updateImage = async (uid, imageBuffer, mimeType) => {
  try {
    const [result] = await pool.execute(
      "UPDATE users SET profile_image = ?, image_mime_type = ? WHERE firebase_uid = ?",
      [imageBuffer, mimeType, uid],
    );
    return await findByUid(uid);
  } catch (err) {
    throw err;
  }
};

// Delete user
const deleteUser = async (uid) => {
  try {
    const [result] = await pool.execute(
      "DELETE FROM users WHERE firebase_uid = ?",
      [uid],
    );
    return result.affectedRows > 0;
  } catch (err) {
    throw err;
  }
};

// Check if user exists
const exists = async (uid) => {
  try {
    const [rows] = await pool.execute(
      "SELECT 1 FROM users WHERE firebase_uid = ? LIMIT 1",
      [uid],
    );
    const userExists = rows.length > 0;
    return userExists;
  } catch (err) {
    throw err;
  }
};

module.exports = {
  findByUid,
  create,
  updateProfile,
  updateName,
  updateImage,
  delete: deleteUser,
  exists,
};
