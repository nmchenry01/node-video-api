const bunyan = require('bunyan');
const manifest = require('../config/manifest');

const { logLevel } = manifest;

const logger = bunyan.createLogger({
  name: 'GetSignedUrl Lambda',
  level: logLevel,
});

module.exports = logger;
