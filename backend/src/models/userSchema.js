const userAttributes = {
  id: "INT AUTO_INCREMENT PRIMARY KEY",
  firebase_uid: "VARCHAR(128) NOT NULL UNIQUE",
  email: "VARCHAR(255) NOT NULL",
  name: "VARCHAR(255) DEFAULT NULL",
  profile_image: "LONGBLOB DEFAULT NULL",
  image_mime_type: "VARCHAR(50) DEFAULT NULL",
  profile_completed: "BOOLEAN DEFAULT FALSE",
  created_at: "TIMESTAMP DEFAULT CURRENT_TIMESTAMP",
  updated_at: "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP",
};

// query to create the table
const userTableQuery = `CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  firebase_uid VARCHAR(128) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL,
  name VARCHAR(255) DEFAULT NULL,
  profile_image LONGBLOB DEFAULT NULL,
  image_mime_type VARCHAR(50) DEFAULT NULL,
  profile_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_firebase_uid (firebase_uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`;

module.exports = { userAttributes, userTableQuery };
