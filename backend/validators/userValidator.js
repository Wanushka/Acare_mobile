const { body } = require('express-validator');

exports.registerValidator = [
  body('fullName').notEmpty().withMessage('Full name is required'),
  body('nicNumber').notEmpty().withMessage('NIC number is required'),
  body('address').notEmpty().withMessage('Address is required'),
  body('workPlace').notEmpty().withMessage('Work place is required'),
  body('mobileNumber').notEmpty().withMessage('Mobile number is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long')
];

exports.loginValidator = [
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').notEmpty().withMessage('Password is required')
];