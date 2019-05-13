// TODO: Add level based off of NODE_ENV property (injected via Terraform)
// TODO: Inject bucket in from terraform, using lambda env variable

const manifest = {
  logLevel: 'INFO',
  bucket: 'node-video-api-content',
};

module.exports = manifest;
