const bunyan = require('bunyan');
const manifest = require('../config/manifest');

const logger = bunyan.createLogger({
  name: 'GetS3Contents Lambda',
  level: manifest.logLevel,
});

module.exports = logger;
