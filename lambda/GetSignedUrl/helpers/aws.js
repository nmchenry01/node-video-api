const getSignedUrl = params => {
  const { s3, key, bucket, logger } = params;

  const s3Params = { Bucket: bucket, Key: key };

  try {
    const url = s3.getSignedUrl('getObject', s3Params);
    return url;
  } catch (error) {
    logger.error(
      { event: 'ERROR', error, key },
      'Error getting object list from S3'
    );
    throw Error(error.message);
  }
};

module.exports = { getSignedUrl };
