// // // 1. First, install required packages:
// // // npm init -y
// // // npm install express mongoose bcryptjs jsonwebtoken cors dotenv

// // // server.js
// const express = require('express');
// const mongoose = require('mongoose');
// const cors = require('cors');
// require('dotenv').config();

// const app = express();

// app.use(cors());
// app.use(express.json());

// // Connect to MongoDB
// mongoose.connect(process.env.MONGODB_URI)
//   .then(() => console.log('Connected to MongoDB'))
//   .catch(err => console.error('Could not connect to MongoDB', err));

// // User Schema
// const userSchema = new mongoose.Schema({
//   fullName: { type: String, required: true },
//   nicNumber: { type: String, required: true, unique: true },
//   address: { type: String, required: true },
//   workPlace: { type: String, required: true },
//   mobileNumber: { type: String, required: true },
//   email: { type: String, required: true, unique: true },
//   password: { type: String, required: true }
// });

// const User = mongoose.model('User', userSchema);

// // Registration endpoint
// app.post('/api/register', async (req, res) => {
//   try {
//     const { fullName, nicNumber, address, workPlace, mobileNumber, email, password } = req.body;
    
//     // Check if user already exists
//     const existingUser = await User.findOne({ email });
//     if (existingUser) {
//       return res.status(400).json({ message: 'User already exists' });
//     }

//     // Hash password
//     const bcrypt = require('bcryptjs');
//     const hashedPassword = await bcrypt.hash(password, 10);

//     // Create new user
//     const user = new User({
//       fullName,
//       nicNumber,
//       address,
//       workPlace,
//       mobileNumber,
//       email,
//       password: hashedPassword
//     });

//     await user.save();
//     res.status(201).json({ message: 'User registered successfully' });
//   } catch (error) {
//     res.status(500).json({ message: 'Error registering user', error: error.message });
//   }
// });

// // Login endpoint
// app.post('/api/login', async (req, res) => {
//   try {
//     const { email, password } = req.body;
    
//     // Find user
//     const user = await User.findOne({ email });
//     if (!user) {
//       return res.status(400).json({ message: 'Invalid email or password' });
//     }

//     // Check password
//     const bcrypt = require('bcryptjs');
//     const validPassword = await bcrypt.compare(password, user.password);
//     if (!validPassword) {
//       return res.status(400).json({ message: 'Invalid email or password' });
//     }

//     // Generate JWT
//     const jwt = require('jsonwebtoken');
//     const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);
    
//     res.json({ token });
//   } catch (error) {
//     res.status(500).json({ message: 'Error logging in', error: error.message });
//   }
// });

// const PORT = process.env.PORT || 5000;
// app.listen(PORT, () => console.log(`Server running on port ${PORT}`));


// //---------------------------------------------------------------------------

//mobile app to web
// const express = require('express');
// const mongoose = require('mongoose');
// const http = require('http');
// const socketIo = require('socket.io');
// const cors = require('cors');
// require('dotenv').config();

// const app = express();
// const server = http.createServer(app);
// const io = socketIo(server);

// app.use(cors());
// app.use(express.json());

// // Connect to MongoDB
// mongoose.connect((process.env.MONGODB_URI));

// // Create Alert Schema
// const alertSchema = new mongoose.Schema({
//   message: String,
//   timestamp: { type: Date, default: Date.now }
// });

// const Alert = mongoose.model('Alert', alertSchema);

// // Socket.io connection
// io.on('connection', (socket) => {
//   console.log('New client connected');
//   socket.on('disconnect', () => {
//     console.log('Client disconnected');
//   });
// });

// // API route to send alert
// app.post('/api/send-alert', async (req, res) => {
//   try {
//     const { message } = req.body;
//     const newAlert = new Alert({ message });
//     await newAlert.save();

//     // Emit the new alert to all connected clients
//     io.emit('new_alert', newAlert);

//     res.status(200).json({ message: 'Alert sent successfully' });
//   } catch (error) {
//     res.status(500).json({ error: 'Failed to send alert' });
//   }
// });

// // API route to get alert history
// app.get('/api/alert-history', async (req, res) => {
//   try {
//     const alerts = await Alert.find().sort({ timestamp: -1 }).limit(50);
//     res.status(200).json(alerts);
//   } catch (error) {
//     res.status(500).json({ error: 'Failed to fetch alert history' });
//   }
// });

// const PORT = process.env.PORT || 5000;
// server.listen(PORT, () => console.log(`Server running on port ${PORT}`));




//------------correct backend code----------------

// const express = require('express');
// const http = require('http');
// const socketIO = require('socket.io');
// const cors = require('cors');
// require('dotenv').config();
// const connectDB = require('./db/connection');
// const routes = require('./routes');

// const app = express();
// const server = http.createServer(app);
// const io = socketIO(server, {
//   cors: {
//     origin: "*",
//     methods: ["GET", "POST"]
//   }
// });

// // Middleware
// app.use(cors());
// app.use(express.json());

// // Routes
// app.use('/api', routes);

// // Socket.IO Connection
// io.on('connection', (socket) => {
//   console.log('Client connected');
  
//   socket.on('disconnect', () => {
//     console.log('Client disconnected');
//   });
// });

// // Database connection
// connectDB();

// // Server Start
// const PORT = process.env.PORT || 5000;
// server.listen(PORT, () => {
//   console.log(`Server running on port ${PORT}`);
// });

// module.exports = { io };

const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const cors = require('cors');
require('dotenv').config();
const connectDB = require('./db/connection');
const routes = require('./routes');
const mongoose = require('mongoose');

const app = express();
const server = http.createServer(app);
const io = socketIO(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors());
app.use(express.json());

// Define Alert Schema
const AlertSchema = new mongoose.Schema({
  message: String,
  timestamp: Date
});

const Alert = mongoose.model('Alert', AlertSchema);

// Routes
app.use('/', routes);

// Emergency Alert Route
app.post('/send-alert', async (req, res) => {
  try {
    const { message, timestamp } = req.body;
    const newAlert = new Alert({ message, timestamp });
    await newAlert.save();

    // Emit the alert to all connected clients
    io.emit('newAlert', { message, timestamp });

    res.status(200).json({ message: 'Alert sent successfully' });
  } catch (error) {
    console.error('Error sending alert:', error);
    res.status(500).json({ error: 'Failed to send alert' });
  }
});

// Get all alerts route
app.get('/alerts', async (req, res) => {
  try {
    const alerts = await Alert.find().sort({ timestamp: -1 });
    res.status(200).json(alerts);
  } catch (error) {
    console.error('Error fetching alerts:', error);
    res.status(500).json({ error: 'Failed to fetch alerts' });
  }
});

// Socket.IO Connection
io.on('connection', (socket) => {
  console.log('Client connected');

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

// Database connection
connectDB();

// Server Start
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = { io };
