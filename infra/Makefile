# Variables
STACK ?= app
ENV ?= dev
TERRAFORM_IMAGE = hashicorp/terraform:1.11
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
WORKDIR := $(ROOT_DIR)/stacks/$(STACK)

ENV_VARS = -e STACK="$(STACK)" -e ENV="$(ENV)" \
	-e TF_VAR_dockerhub_username="$${TF_VAR_dockerhub_username:-}" \
	-e TF_VAR_dockerhub_token="$${TF_VAR_dockerhub_token:-}" \
	-e TF_VAR_github_token="$${TF_VAR_github_token:-}" \
	-e TF_VAR_aws_access_key_id="$${AWS_ACCESS_KEY_ID:-}" \
	-e TF_VAR_aws_secret_access_key="$${AWS_SECRET_ACCESS_KEY:-}" \
	-e TF_VAR_aws_region="$${AWS_DEFAULT_REGION:-}" \
	-e AWS_ACCESS_KEY_ID="$${AWS_ACCESS_KEY_ID:-}" \
	-e AWS_SECRET_ACCESS_KEY="$${AWS_SECRET_ACCESS_KEY:-}"

define RUN_TERRAFORM
docker run -i --rm \
    --volume "$(WORKDIR):/app" \
    $(ENV_VARS) \
    $(TERRAFORM_IMAGE) -chdir="/app" $(1) -var-file="vars/$(ENV).tfvars"
endef

# Check required files
check:
	@file "$(WORKDIR)/"
	@file "$(WORKDIR)/vars/$(ENV).tfvars"

# Terraform actions
plan: check
	@echo "[$(WORKDIR)] ENV: $(ENV), STACK: $(STACK)"
	$(call RUN_TERRAFORM,init)
	$(call RUN_TERRAFORM,plan)

apply: check
	@echo "[$(WORKDIR)] ENV: $(ENV), STACK: $(STACK)"
	$(call RUN_TERRAFORM,init)
	$(call RUN_TERRAFORM,apply -auto-approve)

import: check
	@echo "[$(WORKDIR)] ENV: $(ENV), STACK: $(STACK)"
	$(call RUN_TERRAFORM,init)
	$(call RUN_TERRAFORM,import $(IMPORT_ARG))

destroy: check
	@echo "[$(WORKDIR)] ENV: $(ENV), STACK: $(STACK)"
	$(call RUN_TERRAFORM,init)
	$(call RUN_TERRAFORM,destroy -auto-approve)

shell:
	docker run --rm -ti \
	  --volume "$(shell pwd):/app" \
	  $(ENV_VARS) \
	  --entrypoint /bin/sh \
	  $(TERRAFORM_IMAGE)

help:
	@echo "Usage: make [STACK=app] [ENV=dev] {plan|apply|import|destroy|shell}"
	@echo "For import, use: make import IMPORT_ARG='resource id'"

.PHONY: help plan apply import destroy shell check
