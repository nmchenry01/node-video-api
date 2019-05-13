const manifest = {
  logLevel: {
    [process.env.NODE_ENV]: 'INFO',
    development: 'TRACE',
    qa: 'DEBUG',
    production: 'INFO',
  }[process.env.NODE_ENV],
  bucket: process.env.bucket,
};

module.exports = manifest;
