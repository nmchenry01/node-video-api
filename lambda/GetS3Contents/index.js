/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable no-console */
const AWS = require('aws-sdk');

const logger = require('./helpers/logger');
const { listS3Objects } = require('./helpers/aws');
const { formatBody } = require('./helpers/format');
const manifest = require('./config/manifest');

const s3 = new AWS.S3();
const { bucket } = manifest;

// TODO: Need to implement pagination for use with UI

exports.handler = async (event, context) => {
  logger.info(
    { event: 'START', triggerEvent: event, context },
    'Lambda execution started'
  );

  const s3Objects = await listS3Objects(s3, bucket, logger);
  logger.info({ event: 'REC', s3Objects });

  const formattedBody = formatBody(s3Objects);
  logger.info({ event: 'REC', formattedBody });

  const response = {
    statusCode: 200,
    headers: {},
    body: JSON.stringify(formattedBody),
    isBase64Encoded: false,
  };
  return response;
};
