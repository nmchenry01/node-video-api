/* eslint-disable no-console */
exports.handler = async (event, context) => {
  console.info('Received event:', JSON.stringify(event, null, 2));
  console.info(context);

  const response = {
    statusCode: 200,
    headers: {},
    body: 'Hello World from the GetSignedUrl lambda',
    isBase64Encoded: false,
  };
  return response;
};
