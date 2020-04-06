SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help
help: ## Help
	@echo 'Commands:'
	@grep -E '^[a-zA-Z_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Clean local cached terreform elements
	rm -rf ./.terraform

.PHONY: init
init: ## Initialize terraform
	terraform init

.PHONY: plan
plan: ## Plan deployment
	terraform plan

.PHONY: apply
apply: ## Apply deployment
	terraform apply

.PHONY: destroy
destroy: ## Plan deployment
	terraform destroy