const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  throw new Error("JWT_SECRET is required. Set it in the backend .env file before starting the server.");
}

/**
 * Verify JWT and attach decoded payload as req.user.
 */
const authenticate = (req, res, next) => {
  const authHeader = req.headers.authorization || "";
  if (!authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ success: false, message: "Authentication required." });
  }
  const token = authHeader.slice(7);
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ success: false, message: "Invalid or expired token." });
  }
};

/**
 * Role-based guard — call after authenticate.
 * @param {...string} roles
 */
const requireRole = (...roles) => (req, res, next) => {
  if (!req.user || !roles.includes(req.user.role)) {
    return res.status(403).json({ success: false, message: "Forbidden: insufficient permissions." });
  }
  next();
};

module.exports = { authenticate, requireRole, JWT_SECRET };
