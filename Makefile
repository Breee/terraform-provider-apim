APIM_USERNAME ?= admin
APIM_PASSWORD ?= admin
APIM_API1_USERNAME ?= api1
APIM_API1_PASSWORD ?= api1
APIM_SERVER_URL ?= http://localhost:30083/automation

.PHONY: speakeasy
speakeasy: ## Run speakeasy generation with curated examples and docs
	@rm -f terraform-provider-apim
	@mv ~/.terraformrc ~/.terraformrc.keep 2>/dev/null || true
	@terraform fmt -recursive > /dev/null
	@make doc-gen
	speakeasy run --output console --skip-versioning
	@make cloud-init-patch
	@go mod tidy
	@rm -rf examples/data-sources docs/data-sources examples/README.md USAGE.md > /dev/null
	@mv ~/.terraformrc.keep ~/.terraformrc 2>/dev/null || true
	@go build

cloud-init-patch:
	@node cloud-init-patch.js

.PHONY: lint
lint: ## Run speakeasy lint accepting no error or warning
	@speakeasy lint openapi --schema schemas/automation-api-oas.yaml --max-validation-errors 0 --max-validation-warnings 0 --non-interactive
	@grep "// BEGIN GRAVITEE CLOUD INIT" internal/provider/provider.go > /dev/null || (echo "Cloud initializer code snippet appear to be missing" && exit 1)
	@terraform fmt -recursive -check || (echo "Error: Above terraform files are not properly formatted. Please run 'terraform fmt -recursive' to fix formatting issues" && exit 1)

.PHONY: lint-fix
lint-fix: ## Fix issues that can be found
	@terraform fmt -recursive

.PHONY: sync-oas
sync-oas: ## Copy OAS from APIM assuming the project is in ../gravitee-apim-management
	@cp ../gravitee-api-management/gravitee-apim-rest-api/gravitee-apim-rest-api-automation/gravitee-apim-rest-api-automation-rest/src/main/resources/open-api.yaml schemas/automation-api-oas.yaml

PRE_TEST_DIR = "$(shell pwd)/examples/use-cases/application-simple"

.PHONY: pre-test
pre-test:
	@echo "Validating resource creation with user ${APIM_USERNAME}"
	@cd $(PRE_TEST_DIR) && rm -rf terraform.state terraform.state.backup .terraform && \
	terraform apply -auto-approve 2>&1 > /tmp/tf.log || \
	(echo "Can't do terraform apply with ${APIM_USERNAME}" && cat /tmp/tf.log && exit 1)

	@echo "Validating resource destruction with user ${APIM_USERNAME}"
	@cd $(PRE_TEST_DIR) && \
	terraform apply -auto-approve -destroy 2>&1 > /tmp/tf.log || \
	(echo "Can't do terraform destroy with ${APIM_USERNAME}" && cat /tmp/tf.log && exit 1)

.PHONY: acceptance-tests
acceptance-tests: ## Run acceptance tests
	@APIM_USERNAME=${APIM_USERNAME} APIM_PASSWORD="$${APIM_PASSWORD}" APIM_SERVER_URL=${APIM_SERVER_URL} TF_ACC=1 go test -v ./tests/acceptance


.PHONY: examples-tests
examples-tests: ## Run acceptance tests using examples
	@APIM_USERNAME=${APIM_USERNAME} APIM_PASSWORD="$${APIM_PASSWORD}" APIM_SERVER_URL=${APIM_SERVER_URL} TF_ACC=1 go test -v ./tests/examples


.PHONY: all-tests
all-tests: unit-tests acceptance-tests ## Run all tests (unit, examples, and acceptance)
	@echo ""
	@echo "=========================================="
	@echo "✓ All tests passed successfully!"
	@echo "=========================================="

.PHONY: unit-tests
unit-tests: ## Run unit tests
	@go test ./internal/...

.PHONY: doc-gen
doc-gen: ## Generate Terraform examples docs
	@docker run --rm -v ./.docgen/config:/config -v ./:/plugin graviteeio/doc-gen

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

# Local development environment
.PHONY: dev-up
dev-up: ## Start local Gravitee APIM and dependencies
	@echo "Starting Gravitee APIM local development environment..."
	@cd dev && docker compose up -d
	@echo ""
	@echo "Gravitee APIM is starting. It may take a minute for all services to be ready."
	@echo ""
	@echo "Services:"
	@echo "  - Management API: http://localhost:8083"
	@echo "  - Automation API:  http://localhost:30083/automation"
	@echo "  - Gateway:         http://localhost:8082"
	@echo "  - Console UI:      http://localhost:8084"
	@echo "  - Portal UI:       http://localhost:8085"
	@echo ""
	@echo "Default credentials: admin / admin"

.PHONY: dev-down
dev-down: ## Stop and remove local Gravitee APIM and dependencies
	@cd dev && docker compose down

.PHONY: dev-logs
dev-logs: ## Show logs from local Gravitee APIM environment
	@cd dev && docker compose logs -f

.PHONY: dev-build
dev-build: ## Build the provider for local development
	@echo "Building provider..."
	@go build -o terraform-provider-apim
	@echo "✅ Provider built"

.PHONY: dev-setup-terraform
dev-setup-terraform: ## Setup Terraform to use local provider build
	@echo "Setting up Terraform dev overrides..."
	@echo 'provider_installation {' > ~/.terraformrc
	@echo '  dev_overrides {' >> ~/.terraformrc
	@echo '    "gravitee-io/apim" = "'$(shell pwd)'"' >> ~/.terraformrc
	@echo '  }' >> ~/.terraformrc
	@echo '  direct {}' >> ~/.terraformrc
	@echo '}' >> ~/.terraformrc
	@echo "✅ Terraform configured to use local provider from: $(shell pwd)"

.PHONY: dev-setup
dev-setup: ## Complete development environment setup (run this once)
	@echo "Setting up development environment..."
	@make --no-print-directory dev-up
	@make --no-print-directory dev-build
	@make --no-print-directory dev-setup-terraform
	@echo "✅ Development environment ready!"
	@echo ""
	@echo "You can now:"
	@echo "  - Build updates: make dev-build"
	@echo "  - Test: cd examples/use-cases/application-simple && terraform plan"
	@echo "  - View logs: make dev-logs"

.PHONY: dev-reset-terraform
dev-reset-terraform: ## Remove Terraform dev overrides
	@rm -f ~/.terraformrc ~/.terraform.d/terraform.rc
	@echo "✅ Terraform dev overrides removed"