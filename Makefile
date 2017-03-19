#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

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

traefik: ##@services Install traefik.
	docker-compose -p traefik -f services/traefik.yml up -d
.PHONY: traefik

setup: ##@setup run all setup tasks
	$(MAKE) ansible
	$(MAKE) jumphost
.PHONY: setup

ansible: ##@setup install ansible
	add-apt-repository ppa:ansible/ansible
	apt-get update
	apt-get install -y ansible
.PHONY: ansible

jumphost: ##@setup build the jumphost
	ansible-playbook -i inventory jumphost.yml
.PHONY: jumphost

fix-locals: ##@other fix locals if missing for perl
	export LANGUAGE=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	locale-gen en_US.UTF-8
	dpkg-reconfigure locales
.PHONY: fix-locals

noop: ##@other add nake autocompletion with: complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make
	echo :D
.PHONY: noop
