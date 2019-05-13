const listS3Objects = async (s3, bucket, logger) => {
  try {
    const params = { Bucket: bucket };
    const objects = await s3.listObjectsV2(params).promise();
    return objects;
  } catch (error) {
    logger.error(
      { event: 'ERROR', error },
      'Error getting object list from S3'
    );
    throw Error(error.message);
  }
};

module.exports = { listS3Objects };
