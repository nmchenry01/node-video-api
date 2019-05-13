const formatBytes = (bytes, decimals = 2) => {
  if (!Number.isInteger(bytes)) throw Error('Bytes is not a valid integer');
  if (bytes === 0) return '0 Bytes';

  const k = 1024;
  const dm = decimals < 0 ? 0 : decimals;
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

  const i = Math.floor(Math.log(bytes) / Math.log(k));

  return `${parseFloat((bytes / k ** i).toFixed(dm))} ${sizes[i]}`;
};

const formatBody = (s3Objects, logger) => {
  return s3Objects.Contents.map(object => {
    const { Size, Key } = object;

    try {
      const size = formatBytes(Size);
      return { key: Key, size };
    } catch (error) {
      logger.error({ event: 'ERROR', object, error }, 'Error formatting bytes');
      throw Error(error.message);
    }
  });
};

module.exports = { formatBody, formatBytes };
