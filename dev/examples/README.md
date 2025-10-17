# Terraform Examples

Examples for testing the Gravitee APIM Terraform provider.

## Usage

```bash
# Pick an example
cd dev/examples/simple-api

# Run it
terraform init
terraform plan
terraform apply

# Clean up
terraform destroy
```

## Available Examples

- **simple-api/** - Basic HTTP Proxy API
- **application/** - Application resource
- **shared-policy-group/** - Reusable policy group

## Testing

These examples are also used as regression tests:

```bash
# Run all example tests
make dev-example-tests

# Run specific test
make dev-example-test-single TEST=TestExampleSimpleAPI
```

## Provider Configuration

All examples use:

```hcl
provider "apim" {
  server_url = "http://localhost:8083/automation"
  username   = "admin"
  password   = "admin"
}
```

Make sure APIM is running: `make dev-up`
