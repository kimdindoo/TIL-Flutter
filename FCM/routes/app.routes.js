const pushNotificationController = require('../controllers/push-notifications.controller');
const express = require('express');
const router = express.Router();

router.post('/send-notification-singleToken', pushNotificationController.sendToSingleToken);
router.post('/send-notification-multipleToken', pushNotificationController.sendToMultipleTokens);


module.exports = router;