/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable no-console */
const AWS = require('aws-sdk');

const logger = require('./helpers/logger');
const manifest = require('./config/manifest');

const s3 = new AWS.S3();
const { bucket } = manifest;

exports.handler = async (event, context) => {
  logger.info(
    { event: 'START', triggerEvent: event, context },
    'Lambda execution started'
  );

  const response = {
    statusCode: 200,
    headers: {},
    body: 'Hello World from the GetSignedUrl lambda',
    isBase64Encoded: false,
  };
  return response;
};
