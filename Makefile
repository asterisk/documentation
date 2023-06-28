SHELL := /usr/bin/bash
REMOTE ?= local
BUILD_DIR ?= ./temp
PUSH_OPT := $(if $(findstring yes,$(PUSH)),-p,)
include Makefile.inc

ifeq ($(BRANCH),)
all:
	@for branch in $(EVERYTHING) ; do \
		$(MAKE) version BRANCH=$${branch} PUSH=$(PUSH) ;\
	done

clean-all:
	@for branch in $(EVERYTHING) ; do \
		rm -rf $(BUILD_DIR)/build-$${branch} ;\
	done
endif

JOB_DATE ?= $(shell date +%F)
LAST_JOB := $(shell gh --repo asterisk/asterisk run list -w CreateDocs -s success --json databaseId,conclusion,updatedAt --created $(JOB_DATE) --jq '.[0].databaseId')
BRANCH_DIR := $(BUILD_DIR)/build-${BRANCH}

version: download
	@if [ -z "$(BRANCH)" ] ; then \
		echo "You must supply 'BRANCH=<branch>' on the make command line" ;\
		exit 1 ;\
	fi
	@mkdir -p $(BRANCH_DIR)/docs/_Asterisk_REST_Interface
	@rsync -aH $(BRANCH_DIR)/source/*.md $(BRANCH_DIR)/docs/_Asterisk_REST_Interface/
	@cp mkdocs-template.yml $(BRANCH_DIR)/mkdocs.yml
	@echo "# Asterisk $(BRANCH) Documentation" > $(BRANCH_DIR)/docs/index.md
	@if [ "$(BRANCH)" == "$(LATEST)" ] ; then \
		rsync -aH docs/. $(BRANCH_DIR)/docs/ ;\
		utils/fix_build.sh $(BRANCH_DIR)/docs/ utils/build_fixes.yml ;\
		utils/astxml2markdown.py --file=$(BRANCH_DIR)/source/asterisk-docs.xml \
			--xslt=utils/astxml2markdown.xslt \
			--directory=$(BRANCH_DIR)/docs/ --branch=$(BRANCH) --version=GIT ;\
		mike deploy -F $(BRANCH_DIR)/mkdocs.yml -r $(REMOTE) -u $(PUSH_OPT) \
			-t "Asterisk Latest ($(BRANCH))" $(BRANCH) latest ;\
		mike set-default -F $(BRANCH_DIR)/mkdocs.yml -r $(REMOTE) \
			$(PUSH_OPT) $(BRANCH) ;\
	else \
		utils/astxml2markdown.py --file=$(BRANCH_DIR)/source/asterisk-docs.xml \
			--xslt=utils/astxml2markdown.xslt \
			--directory=$(BRANCH_DIR)/docs/ --branch=$(BRANCH) --version=GIT ;\
		mike deploy -F $(BRANCH_DIR)/mkdocs.yml -r $(REMOTE) -u $(PUSH_OPT) \
			-t "Asterisk $(BRANCH)" $(BRANCH) ;\
	fi

download:
	@if [ -z "$(BRANCH)" ] ; then \
		echo "You must supply 'BRANCH=<branch>' on the make command line" ;\
		exit 1 ;\
	fi
	@if [ -z "$(LAST_JOB)" ] ; then \
		echo "No current docs job" ;\
		exit 1 ;\
	fi
	@mkdir -p $(BRANCH_DIR)
	@echo "Retrieving documentation from job $(LAST_JOB) for branch: $(BRANCH)"
	@if [ -d $(BRANCH_DIR)/source ] ; then \
		rm -rf $(BRANCH_DIR)/source.bak 2>/dev/null || : ;\
		mv $(BRANCH_DIR)/source $(BRANCH_DIR)/source.bak ;\
	fi
	@mkdir -p $(BRANCH_DIR)/source
	@gh run download --repo asterisk/asterisk $(LAST_JOB) \
		-n documentation-$(BRANCH) -D $(BRANCH_DIR)/source ||\
		{ [ -d $(BRANCH_DIR)/source.bak ] && {\
			rm -rf $(BRANCH_DIR)/source ;\
			mv $(BRANCH_DIR)/source.bak $(BRANCH_DIR)/source ;\
			exit 1 ;\
		} ; }
	@if [ -d $(BRANCH_DIR)/source.bak ] ; then \
		rm -rf $(BRANCH_DIR)/source.bak ;\
	fi

FORCE:

.PHONY: all clean-all clean version download

clean:
	@if [ -z "$(BRANCH)" ] ; then \
		echo "You must supply 'BRANCH=<branch>' on the make command line" ;\
		exit 1 ;\
	fi
	rm -rf docs-$(BRANCH)
