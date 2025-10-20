# Gravitee - APIM Terraform Provider

<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".assets/gravitee-logo-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset=".assets/gravitee-logo-light.svg">
  <img alt="Gravitee.io" width="400">
</picture>

<!-- Start Summary [summary] -->
## Summary

Gravitee: Gravitee API Management Terraform Provider (beta)

You can manage with Terraform the following:
* APIs
* Shared Policy Groups
* Applications
* Subscriptions

[Go to our documentation web site for more about configuration, capabilities and examples](https://documentation.gravitee.io/apim/terraform)

Compatible with APIM 4.9 and above

Checkout other sections to configure, authenticate and start working with Gravitee resources
<!-- End Summary [summary] -->

<!-- Start Table of Contents [toc] -->
## Table of Contents
<!-- $toc-max-depth=2 -->
* [Gravitee - APIM Terraform Provider](#gravitee-apim-terraform-provider)
  * [Installation](#installation)
  * [Authentication](#authentication)
  * [Available Resources and Data Sources](#available-resources-and-data-sources)

<!-- End Table of Contents [toc] -->

<!-- Start Installation [installation] -->
## Installation

To install this provider, copy and paste this code into your Terraform configuration. Then, run `terraform init`.

```hcl
terraform {
  required_providers {
    apim = {
      source  = "gravitee-io/apim"
      version = "0.3.0"
    }
  }
}

provider "apim" {
  # Configuration options
}
```
<!-- End Installation [installation] -->

<!-- Start Authentication [security] -->
## Authentication

This provider supports authentication configuration via environment variables and provider configuration.

The configuration precedence is:

- Provider configuration
- Environment variables

Available configuration:

| Provider Attribute | Description |
|---|---|
| `bearer_auth` | Service account authentication. Configurable via environment variable `APIM_SA_TOKEN`. |
| `cloud_auth` | Gravitee Cloud Token authentication. Configurable via environment variable `APIM_CLOUD_TOKEN`. |
| `password` | Basic authentication password. Configurable via environment variable `APIM_PASSWORD`. |
| `username` | Basic authentication username. Configurable via environment variable `APIM_USERNAME`. |
<!-- End Authentication [security] -->

<!-- Start Available Resources and Data Sources [operations] -->
## Available Resources and Data Sources

### Resources

* [apim_apiv4](docs/resources/apiv4.md)
* [apim_application](docs/resources/application.md)
* [apim_shared_policy_group](docs/resources/shared_policy_group.md)
* [apim_subscription](docs/resources/subscription.md)
### Data Sources

* [apim_apiv4](docs/data-sources/apiv4.md)
* [apim_application](docs/data-sources/application.md)
* [apim_shared_policy_group](docs/data-sources/shared_policy_group.md)
* [apim_subscription](docs/data-sources/subscription.md)
<!-- End Available Resources and Data Sources [operations] -->

<!-- No End Testing the provider locally [usage] -->

<!-- Placeholder for Future Speakeasy SDK Sections -->

# Local Development Environment

Quick setup for developing the Gravitee APIM Terraform Provider.

You can use terraform or tofu cli.

## Quick Start

```bash
# 1. One-time setup (starts services, builds provider, configures Terraform)
make dev-setup

# 2. Test it
cd examples/use-cases/application-simple && terraform apply && terraform destroy
```

## Development Cycle

1. Add a new use-case example in `examples/use-cases/` or modify an existing one.
1. After making code changes:
  ```bash
  make dev               # Build + validate + status
  # OR
  make build             # Just build (shorter)

  cd examples/use-cases/application-simple
  terraform plan         # Test (no need to re-init!)
  terraform apply
  ```

## Services

Once running (`make dev-up`):

- **Console UI**: http://localhost:8084 (admin/admin)
- **Gateway**: http://localhost:8082
- **Automation API**: http://localhost:8083/automation

There is a `compose.yml` file defining the services used for local development.

## Common Commands

```bash
make dev-setup          # One-time setup (services + provider + config)
make dev                # Main dev command (build + validate + status)
make build              # Quick build only
make dev-status         # Check environment status
make dev-logs           # View logs
make dev-up             # Start devenv
make dev-down           # Stop devenv
```

## Examples

Located in `examples" directory.
All examples serve as both documentation and regression tests.


### Testing

```sh
make unit-tests              # Unit tests
make all-tests              # All tests
```

