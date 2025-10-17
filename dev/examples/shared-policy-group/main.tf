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

# Create a shared policy group for rate limiting
resource "apim_shared_policy_group" "rate_limit" {
  name        = "Standard Rate Limit"
  description = "Reusable rate limiting policy for APIs"

  phase = "REQUEST"

  policy_plugins = [
    {
      policy = "rate-limit"
      configuration = jsonencode({
        rate = {
          limit         = 100
          periodTime    = 60
          periodTimeUnit = "SECONDS"
        }
      })
    }
  ]
}

output "policy_group_id" {
  value       = apim_shared_policy_group.rate_limit.id
  description = "The ID of the shared policy group"
}
