/* eslint-disable no-console */
exports.handler = async (event, context) => {
  console.log(event);
  console.log(context);
  // TODO implement
  const response = {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda!')
  };
  return response;
};
