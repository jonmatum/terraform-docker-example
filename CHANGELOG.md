# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2](https://github.com/jonmatum/terraform-docker-example/compare/v1.0.1...v1.0.2) (2026-02-13)


### Bug Fixes

* **ci:** bypass expired GPG key check for Docker provider ([df1a165](https://github.com/jonmatum/terraform-docker-example/commit/df1a16525f0f85a5e20d8b2cc034136f171a38b4))

## [1.0.1](https://github.com/jonmatum/terraform-docker-example/compare/v1.0.0...v1.0.1) (2026-02-13)


### Bug Fixes

* add required_version to all Terraform configs and improve lint target ([eb95f91](https://github.com/jonmatum/terraform-docker-example/commit/eb95f915a6037e670d9e3387b2f28892ab58dfaa))
* correct module paths and AWS provider config ([b488005](https://github.com/jonmatum/terraform-docker-example/commit/b488005550d3d1cd04a4dd73ba2aa8299515e626))
* make example validation non-fatal in CI ([8424a57](https://github.com/jonmatum/terraform-docker-example/commit/8424a57c7b3ecbb5bdec8b3df7cfb5df6c822428))
* simplify CI workflow to only validate terraform ([e441224](https://github.com/jonmatum/terraform-docker-example/commit/e4412244de5bb1dee0ad63d2d49d9d812926065b))
* update release-please workflow to use correct action ([246dfeb](https://github.com/jonmatum/terraform-docker-example/commit/246dfeb651d18c3ed61cd933c83b77836ada6083))
* use correct AWS provider arguments in ECS example ([d2a8afa](https://github.com/jonmatum/terraform-docker-example/commit/d2a8afae23e739b780c848da23ee7bb3bd092eb0))
* use GITHUB_WORKSPACE to navigate back to root in CI ([419a24e](https://github.com/jonmatum/terraform-docker-example/commit/419a24efce91f1a2d4eb1f9cf68bd1021ff0fbdb))
* use subshells in CI workflow to preserve working directory ([88fc165](https://github.com/jonmatum/terraform-docker-example/commit/88fc1653f2e2439f134ccfbe51274cc8a701b2c2))
* validate modules before examples in CI ([75d9613](https://github.com/jonmatum/terraform-docker-example/commit/75d9613e262cafb59f36487d6c8a76b887f82228))

## 1.0.0 (2026-02-13)


### Features

* add terraform docker modules with comprehensive examples ([9ef7f15](https://github.com/jonmatum/terraform-docker-example/commit/9ef7f156749e12f1143d2f811163356f85532192))

## [Unreleased]

### Added
- Initial release with Docker container and ECS Fargate modules
- Four comprehensive examples (basic Docker, FastAPI+React, Docker Compose, ECS LocalStack)
- Pre-commit hooks for validation and formatting
- Automated documentation generation
- Makefile for common tasks
- CI/CD pipeline with GitHub Actions
