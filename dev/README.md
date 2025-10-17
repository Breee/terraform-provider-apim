# Local Development Environment

Quick setup for developing the Gravitee APIM Terraform Provider.

## Quick Start

```bash
# 1. Start services
make dev-up

# 2. Build provider
make dev-build

# 3. Configure Terraform to use your local build
make dev-setup-terraform

# 4. Test it
cd dev/examples/simple-api
terraform plan
terraform apply
```

## Development Cycle

After making code changes:

```bash
make dev-build          # Rebuild
cd dev/examples/simple-api
terraform plan          # Test (no need to re-init!)
```

## Services

Once running (`make dev-up`):

- **Console UI**: http://localhost:8084 (admin/admin)
- **Gateway**: http://localhost:8082
- **Automation API**: http://localhost:8083/automation

## Common Commands

```bash
make dev-up             # Start APIM
make dev-down           # Stop APIM
make dev-build          # Build provider
make dev-logs           # View logs
make dev-example-tests  # Run tests
```

## Examples

Located in `dev/examples/`:
- `simple-api/` - Basic API
- `application/` - Application resource
- `shared-policy-group/` - Policy group

All examples serve as both documentation and regression tests.

## Testing

```bash
# Run example regression tests
make dev-example-tests

# Run single test
make dev-example-test-single TEST=TestExampleSimpleAPI

# Run all tests
make all-tests
```

## Troubleshooting

**Provider not found?**
```bash
make dev-build && make dev-setup-terraform
```

**Changes not working?**
```bash
make dev-build  # Must rebuild after code changes
```

**Need to reset?**
```bash
cd dev && docker compose down -v
make dev-up
```

## How It Works

1. `make dev-setup-terraform` creates `~/.terraformrc` with dev overrides
2. Terraform uses YOUR binary instead of downloading from registry
3. After `make dev-build`, Terraform automatically picks up changes
4. No need to `terraform init` again after rebuilding

That's it! 🚀
