const { Message } = require('../models/index');
const { io } = require('../server');

const createMessage = async (req, res) => {
  try {
    const newMessage = new Message(req.body);
    await newMessage.save();
    res.status(201).json(newMessage);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

const getMessages = async (req, res) => {
  try {
    const messages = await Message.find().sort({ createdAt: -1 });
    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const acceptMessage = async (req, res) => {
  try {
    const message = await Message.findByIdAndUpdate(req.params.id, { accepted: true }, { new: true });
    res.json(message);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

exports.sendEmergencyAlert = (req, res) => {
  const { message } = req.body;
  
  if (!message) {
    return res.status(400).json({ error: 'Message is required' });
  }

  io.emit('emergency-alert', {
    message,
    timestamp: new Date().toISOString()
  });

  res.status(200).json({ success: true });
};


app.post('/send-message', (req, res) => {
  const { message } = req.body;
  
  if (!message) {
    return res.status(400).json({ error: 'Message is required' });
  }

  io.emit('emergency-alert', {
    message,
    timestamp: new Date().toISOString()
  });

  res.status(200).json({ success: true });
});