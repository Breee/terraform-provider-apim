terraform {
  required_providers {
    apim = {
      source = "gravitee-io/apim"
    }
  }
}

provider "apim" {
  server_url = "http://localhost:8083/automation"
  username   = "admin"
  password   = "admin"
}

# Create an application
resource "apim_application" "test_app" {
  name        = "Test Application"
  description = "Application for local development testing"

  settings = {
    app = {
      type = "WEB"
    }
  }
}

output "application_id" {
  value       = apim_application.test_app.id
  description = "The ID of the created application"
}

output "application_name" {
  value       = apim_application.test_app.name
  description = "The name of the created application"
}
