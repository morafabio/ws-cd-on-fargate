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
docker run -i --rm --volume "$(WORKDIR):/app" $(ENV_VARS) $(TERRAFORM_IMAGE) -chdir="/app" $(1)
endef

check:
	@echo "[$(WORKDIR)] ENV: $(ENV), STACK: $(STACK)"
	@file "$(WORKDIR)/"
	@file "$(WORKDIR)/vars/$(ENV).tfvars"

tf-init: check
	$(call RUN_TERRAFORM,init)

plan: tf-init
	$(call RUN_TERRAFORM,plan -var-file="vars/$(ENV).tfvars")

apply: tf-init
	$(call RUN_TERRAFORM,apply -auto-approve -var-file="vars/$(ENV).tfvars")

import: tf-init
	$(call RUN_TERRAFORM,import $(IMPORT_ARG))

state-pull: tf-init
	$(call RUN_TERRAFORM,state pull > $(STACK).tfstate)

graph: tf-init
	mkdir -p graphs/
	$(call RUN_TERRAFORM,graph -type=plan> graphs/$(STACK).dot)

graph-png: graph state-pull
	docker run --rm -i -u $(id -u):$(id -g) --volume "$(shell pwd):/app" --entrypoint "/bin/ash" cycloid/inframap -c "cat /app/graphs/$(STACK).dot | dot -Tpng > /app/graphs/$(STACK).png"
	docker run --rm -i -u $(id -u):$(id -g) --volume "$(shell pwd):/app" --entrypoint "/bin/ash" cycloid/inframap -c "mkdir -p /app/graphs/; ./inframap generate /app/$(STACK).tfstate | dot -Tpng > /app/graphs/$(STACK)-inframap.png"

destroy: tf-init
	$(call RUN_TERRAFORM,destroy -auto-approve -var-file="vars/$(ENV).tfvars")

show: tf-init
	$(call RUN_TERRAFORM,show)

format: tf-init
	$(call RUN_TERRAFORM,fmt -recursive)

shell:
	docker run --rm -ti --volume "$(shell pwd):/app" $(ENV_VARS) --entrypoint /bin/sh $(TERRAFORM_IMAGE)

help:
	@echo "Usage: make [STACK=app] [ENV=dev] [IMPORT_ARG='resource id'] {help|check|tf-init|plan|apply|import|state-pull|graph|graph-png|destroy|show|format|shell}"
	@echo "check: Display working directory and verify required files exist."
	@echo "tf-init: Execute terraform initialization in the specified stack directory."
	@echo "plan: Run 'terraform plan' with the corresponding vars file."
	@echo "apply: Run 'terraform apply' with auto-approval and specified vars."
	@echo "import: Import a resource; pass the resource ID using IMPORT_ARG."
	@echo "state-pull: Retrieve current state and save as $(STACK).tfstate."
	@echo "graph: Generate a DOT-format graph of the terraform plan in the graphs/ folder."
	@echo "graph-png: Create PNG images from the plan graph and state; utilizes Inframap."
	@echo "destroy: Run 'terraform destroy' with auto-approval and specified vars."
	@echo "show: Display the current terraform state."
	@echo "format: Recursively format terraform configuration files."
	@echo "shell: Open an interactive shell in the terraform docker container."

.PHONY: check tf-init plan apply import state-pull graph graph-png destroy show format shell help
