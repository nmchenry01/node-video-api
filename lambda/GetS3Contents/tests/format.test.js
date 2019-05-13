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
    it('should ', () => {
      expect.assertions(0);
    });
  });
});
