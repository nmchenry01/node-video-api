/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable no-console */
const AWS = require('aws-sdk');
const _ = require('lodash');

const logger = require('./helpers/logger');
const { getSignedUrl } = require('./helpers/aws');
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

  const params = { s3, key, bucket, logger };
  const signedUrl = getSignedUrl(params);
  logger.debug({ event: 'RECV', signedUrl });

  const response = {
    statusCode: 200,
    headers: {},
    body: JSON.stringify({ signedUrl }),
    isBase64Encoded: false,
  };

  logger.info(
    { event: 'END', response },
    'Lambda returning response to client'
  );

  return response;
};
