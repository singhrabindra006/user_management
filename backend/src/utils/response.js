// Success response helper
const success = (res, message, data = null, statusCode = 200) => {
  const response = {
    success: true,
    message,
  };
  if (data !== null) {
    response.data = data;
  }
  return res.status(statusCode).json(response);
};

// Error response helper
const error = (res, message, statusCode = 500) => {
  return res.status(statusCode).json({
    success: false,
    message,
  });
};

module.exports = { success, error };
