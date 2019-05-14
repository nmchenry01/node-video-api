const AWS = require('aws-sdk');
const sinon = require('sinon');

const { getSignedUrl } = require('../helpers/aws');
const logger = require('../helpers/logger');

const s3 = new AWS.S3();

describe('aws.js', () => {
  describe('getSignedUrl', () => {
    let sandbox;
    beforeEach(() => {
      sandbox = sinon.createSandbox();
    });

    afterEach(() => {
      sandbox.restore();
    });

    it('should throw error if operation fails', () => {
      expect.assertions(1);
      sandbox.stub(s3, 'getSignedUrl').throws('Error', ['Error building URL']);

      const bucket = 'test bucket';
      const key = 'key';

      const params = { s3, key, bucket, logger };
      try {
        getSignedUrl(params);
      } catch (error) {
        expect(error.message).toBe('Error building URL');
      }
    });

    // Not really useful, just wanted to test out the sinon sandbox functionality
    it('should return a signed url', async () => {
      expect.assertions(1);
      sandbox.stub(s3, 'getSignedUrl').returns('url.com');

      const bucket = 'test bucket';
      const key = 'key';

      const params = { s3, key, bucket, logger };

      const response = getSignedUrl(params);

      expect(response).toBe('url.com');
    });
  });
});
