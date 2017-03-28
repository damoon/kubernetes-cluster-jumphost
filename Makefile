#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

export DOMAIN_NAME = 172.28.128.4.xip.io
SERVICE_FILES = $(shell find services/ -mindepth 1 -maxdepth 1 -type f -print0 -name '*.yml' | xargs -0 -I {} echo -n "-f {} ")

export UID = $(shell id -u)
export GID = $(shell id -g $(UID))

SERVICES ?=

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }

help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
.PHONY: help

ansible: ##@setup install ansible
	./etc/install-ansible.sh
.PHONY: ansible

jumphost: ##@setup build the jumphost
	ansible-playbook -i inventory jumphost.yml
	groups | grep docker >/dev/null || ( sudo usermod -aG docker `whoami` && newgrp docker )
.PHONY: jumphost

start: ##@services start services (defined via SERVICES)
	docker-compose -p jumphost $(SERVICE_FILES) up -d $(SERVICES)
.PHONY: services

stop: ##@services stop services (defined via SERVICES)
	docker-compose -p jumphost $(SERVICE_FILES) stop $(SERVICES)
.PHONY: services

clean: ##@services remove services (defined via SERVICES)
	docker-compose -p jumphost $(SERVICE_FILES) rm -f $(SERVICES)
.PHONY: services

logs: ##@services follow logs of services (defined via SERVICES)
	docker-compose -p jumphost $(SERVICE_FILES) logs -f $(SERVICES)
.PHONY: services
