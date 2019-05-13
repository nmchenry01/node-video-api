/* eslint-disable no-console */
const logger = require('./helpers/logger');

exports.handler = async (event, context) => {
  logger.debug(
    { event: 'START', triggerEvent: event, context },
    'Lambda execution started'
  );

  const response = {
    statusCode: 200,
    headers: {},
    body: 'Hello World from the GetS3Contents lambda',
    isBase64Encoded: false,
  };
  return response;
};
