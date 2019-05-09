# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

[0.0.3] 2019-05-09

### Added

- Add API Gateway and attach to lambda functions
- Update lambda IAM permissions to be invoked by API Gateway

### Changed

- Update Terraform directory and move all files under a code directory

### Fixed

- Update makefile to zip lambda functions and deploy without directory structure
- Refactor

[0.0.2] 2019-05-08

### Added

- S3 bucket with encryption enabled
- Auto-approval for makefile deploy/destroy commands

### Fixed

- Permissions for lambdas to log to Cloudwatch

[0.0.1] 2019-05-07

### Added

- Basic skeleton for lambda functions
- Initial Terraform setup
- Linting configuration
- Project skeleton

### Documented

- Initial README and CHANGELOG
