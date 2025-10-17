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

resource "apim_apiv4" "quick-start-api" {
  # should match the resource name
  hrid            = "quick-start-api"
  name            = "[Terraform] Quick Start PROXY API"
  description     = "A simple API that routes traffic to gravitee echo API"
  version         = "1.0"
  type            = "PROXY"
  state           = "STARTED"         # API will be deployed
  lifecycle_state = "PUBLISHED"       # Will be published in Portal
  visibility      = "PUBLIC"          # Will be public in the Portal
  listeners = [
    {
      http = {
        type = "HTTP"
        entrypoints = [
          {
            type = "http-proxy"
          }
        ]
        paths = [
          {
            path = "/quick-start-api/"
          }
        ]
      }
    }
  ]
  endpoint_groups = [
    {
      name = "Default HTTP proxy group"
      type = "http-proxy"
      load_balancer = {
        type = "ROUND_ROBIN"
      }
      endpoints = [
        {
          name   = "Default HTTP proxy"
          type   = "http-proxy"
          weight = 1
          inherit_configuration = false
          # Configuration is JSON as endpoint can be custom plugins
          configuration = jsonencode({
            target = "https://api.gravitee.io/echo"
          })
        }
      ]
    }
  ]
  plans = [
    {
      hrid = "keyless"
      name        = "KeyLess"
      type        = "API"
      mode        = "STANDARD"
      validation  = "AUTO"
      status      = "PUBLISHED"
      description = "This plan does not require any authentication"
      security = {
        type = "KEY_LESS"
      }
    }
  ]
}


