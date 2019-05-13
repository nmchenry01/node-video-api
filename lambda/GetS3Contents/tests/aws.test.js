const AWS = require('aws-sdk');
const sinon = require('sinon');

const { listS3Objects } = require('../helpers/aws');
const logger = require('../helpers/logger');

const s3 = new AWS.S3();

describe('listS3Objects', () => {
  let sandbox;
  beforeEach(() => {
    sandbox = sinon.createSandbox();
  });

  afterEach(() => {
    sandbox.restore();
  });

  it('throw error if operation fails', async () => {
    expect.assertions(1);
    sandbox
      .stub(s3, 'listObjectsV2')
      .returns({ promise: () => Promise.reject(Error('Network Error')) });

    const bucket = 'test bucket';

    try {
      await listS3Objects(s3, bucket, logger);
    } catch (error) {
      expect(error.message).toBe('Network Error');
    }
  });

  // Not really useful, just wanted to test out the sinon sandbox functionality
  it('returns object', async () => {
    expect.assertions(1);
    sandbox.stub(s3, 'listObjectsV2').returns({
      promise: () =>
        Promise.resolve({
          Contents: [{ Key: 'somekey' }, { Key: 'someotherkey' }],
        }),
    });

    const bucket = 'test bucket';

    const response = await listS3Objects(s3, bucket, logger);

    expect(response).toEqual({
      Contents: [{ Key: 'somekey' }, { Key: 'someotherkey' }],
    });
  });
});
