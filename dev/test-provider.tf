terraform {
  required_providers {
    apim = {
      source = "gravitee-io/apim"
    }
  }
}

provider "apim" {
  server_url = "http://localhost:30083/automation"
  username   = "admin"
  password   = "admin"
}

# Simple test output to verify provider is working
output "provider_test" {
  value = "Provider is configured successfully!"
}
