/* eslint-disable no-console */
exports.handler = async (event, context) => {
  console.info('Received event:', JSON.stringify(event, null, 2));
  console.info(context);
};
