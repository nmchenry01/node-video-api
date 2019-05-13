/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable no-console */
const AWS = require('aws-sdk');
const _ = require('lodash');

const logger = require('./helpers/logger');
const manifest = require('./config/manifest');

const s3 = new AWS.S3();
const { bucket } = manifest;

exports.handler = async (event, context) => {
  logger.info(
    { event: 'START', triggerEvent: event, context },
    'Lambda execution started'
  );

  const key = _.get(event, 'pathParameters.key');

  if (!key) {
    const response = {
      statusCode: 400,
      headers: {},
      body: 'The key query parameter is required',
      isBase64Encoded: false,
    };
    return response;
  }

  const response = {
    statusCode: 200,
    headers: {},
    body: 'Hello World from the GetSignedUrl lambda',
    isBase64Encoded: false,
  };
  return response;
};
