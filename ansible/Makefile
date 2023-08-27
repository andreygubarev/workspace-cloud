### Make ######################################################################
MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Brief overview of available targets and their descriptions
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

### Python ####################################################################
PYTHON_VENV ?= $(MAKEFILE_DIR)/.venv
PYTHON_BIN := $(PYTHON_VENV)/bin/python3
PYTHON_PIP := $(PYTHON_BIN) -m pip

$(PYTHON_VENV):
	$(shell brew --prefix python@3.10)/bin/python3.10 -m venv $(PYTHON_VENV)
	$(PYTHON_PIP) install 'setuptools>=45.0.0' wheel
	$(PYTHON_PIP) install -r requirements.txt

### Ansible ###################################################################
ANSIBLE_LINT := ansible-lint
ANSIBLE_GALAXY := ansible-galaxy

.PHONY: install
install: $(PYTHON_VENV) ## Build Python package
	$(ANSIBLE_GALAXY) install -r requirements.yml

.PHONY: format
format: build ## Automatically format the source code
	@$(ANSIBLE_LINT) -v

.PHONY: clean
clean: ## Remove temporary files
	rm -rf $(PYTHON_VENV) *.tar.gz
