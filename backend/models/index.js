const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  message: { type: String, required: true },
  accepted: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now }
});

const userSchema = new mongoose.Schema({
  fullName: { type: String, required: true },
  nicNumber: { type: String, required: true, unique: true },
  address: { type: String, required: true },
  workPlace: { type: String, required: true },
  mobileNumber: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }
});

const Message = mongoose.model('Message', messageSchema);
const User = mongoose.model('User', userSchema);

module.exports = { Message, User };