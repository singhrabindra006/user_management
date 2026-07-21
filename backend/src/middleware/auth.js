const { getAuth } = require("../config/firebase");

const authenticateToken = async (req, res, next) => {
  try {
    const header = req.headers.authorization;
    if (!header || !header.startsWith("Bearer ")) {
      return res
        .status(401)
        .json({ success: false, message: "Token required" });
    }
    const token = header.split("Bearer ")[1];
    const decoded = await getAuth().verifyIdToken(token);
    req.user = { uid: decoded.uid, email: decoded.email };
    next();
  } catch (err) {
    return res.status(401).json({ success: false, message: "Invalid token" });
  }
};

module.exports = { authenticateToken };
