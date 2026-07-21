const multer = require("multer");

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024,
  },
  fileFilter: (req, file, cb) => {
    // accept common image formats
    const allowedMimeTypes = [
      "image/jpeg",
      "image/jpg",
      "image/png",
      "image/gif",
      "image/webp",
      "image/heic",
      "image/heif",
    ];

    if (allowedMimeTypes.includes(file.mimetype)) {
      cb(null, true);
      return;
    }
    if (file.mimetype.startsWith("image/")) {
      cb(null, true);
      return;
    }

    const ext = file.originalname.toLowerCase().split(".").pop();
    const allowedExtensions = [
      "jpg",
      "jpeg",
      "png",
      "gif",
      "webp",
      "heic",
      "heif",
    ];

    if (allowedExtensions.includes(ext)) {
      cb(null, true);
      return;
    }
    cb(new Error("Only images are allowed"), false);
  },
});

const handleUploadError = (err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    if (err.code === "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        success: false,
        message: "File too large (max 10MB)",
      });
    }
    if (err.code === "LIMIT_UNEXPECTED_FILE") {
      return res.status(400).json({
        success: false,
        message: `Unexpected field: ${err.field}. Expected field name: 'image'`,
      });
    }
    return res.status(400).json({
      success: false,
      message: `Upload error: ${err.message}`,
    });
  }

  if (err.message === "Only images are allowed") {
    return res.status(400).json({
      success: false,
      message: "Only image files (JPG, PNG, GIF, WEBP) are allowed",
    });
  }

  next(err);
};

module.exports = { upload, handleUploadError };
