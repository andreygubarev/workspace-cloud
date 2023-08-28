### Make ######################################################################
MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Brief overview of available targets and their descriptions
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

### Python ####################################################################
PYTHON_VENV ?= $(MAKEFILE_DIR)/.venv

### Ansible ###################################################################
ANSIBLE_LINT := ansible-lint
ANSIBLE_GALAXY := ansible-galaxy

.PHONY: format
format: install ## Automatically format the source code
	@$(ANSIBLE_LINT) -v

.PHONY: clean
clean: ## Remove temporary files
	rm -rf $(PYTHON_VENV) .cache *.tar.gz
