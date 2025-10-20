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
ll examples serve as both documentation and regression tests.

