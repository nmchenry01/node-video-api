const { formatBody, formatBytes } = require('../helpers/format');

describe('format.js', () => {
  describe('formatBytes', () => {
    it('should return correct 0 bytes response ', () => {
      expect.assertions(1);
      const bytes = 0;

      const formattedBytes = formatBytes(bytes);

      expect(formattedBytes).toBe('0 Bytes');
    });

    it('should return correct KB response ', () => {
      expect.assertions(1);
      const bytes = 1500;

      const formattedBytes = formatBytes(bytes);

      expect(formattedBytes).toBe('1.46 KB');
    });

    it('should return correct MB response ', () => {
      expect.assertions(1);
      const bytes = 1500000;

      const formattedBytes = formatBytes(bytes);

      expect(formattedBytes).toBe('1.43 MB');
    });

    it('should return correct GB response ', () => {
      expect.assertions(1);
      const bytes = 1500000000;

      const formattedBytes = formatBytes(bytes);

      expect(formattedBytes).toBe('1.4 GB');
    });

    it('should return correct TB response ', () => {
      expect.assertions(1);
      const bytes = 1500000000000;

      const formattedBytes = formatBytes(bytes);

      expect(formattedBytes).toBe('1.36 TB');
    });

    it('should throw error if passed something other than a number', () => {
      expect.assertions(1);
      const bytes = '1';
      try {
        formatBytes(bytes);
      } catch (error) {
        expect(error.message).toBe('Bytes is not a valid integer');
      }
    });
  });
  describe('formatBody', () => {
    it('should return formatted object array for 1 or more objects', () => {
      expect.assertions(1);
      const s3Objects = {
        Contents: [
          { Key: 'id1', Size: 1500 },
          { Key: 'id2', Size: 1500 },
          { Key: 'id3', Size: 1500 },
        ],
      };

      const response = formatBody(s3Objects);

      const expectedResponse = [
        { key: 'id1', size: '1.46 KB' },
        { key: 'id2', size: '1.46 KB' },
        { key: 'id3', size: '1.46 KB' },
      ];

      expect(response).toEqual(expectedResponse);
    });

    it('should return an empty array if there are no objects', () => {
      expect.assertions(1);
      const s3Objects = {
        Contents: [],
      };

      const response = formatBody(s3Objects);

      const expectedResponse = [];

      expect(response).toEqual(expectedResponse);
    });
  });
});
