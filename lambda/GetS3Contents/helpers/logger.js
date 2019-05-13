const bunyan = require('bunyan');
const manifest = require('../config/manifest');

const { logLevel } = manifest;

const logger = bunyan.createLogger({
  name: 'GetS3Contents Lambda',
  level: logLevel,
});

module.exports = logger;
