const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const messageController = require('../controllers/messageController');

// Auth routes
router.post('/register', authController.register);
router.post('/login', authController.login);

// Message routes
router.post('/messages', messageController.createMessage);
router.get('/messages', messageController.getMessages);
router.put('/messages/:id/accept', messageController.acceptMessage);
router.post('/send-message', messageController.sendEmergencyAlert);

module.exports = router;