SHELL := /usr/bin/bash
DEPLOY_BRANCH ?= gh-pages
BUILD_DIR ?= ./temp

include Makefile.inc
ifneq ($(BRANCH),)
-include Makefile.$(BRANCH).inc
endif

JOB_DATE ?= $(shell date +%F)

#ifeq ($(BRANCH),)
#all: static-setup dynamic-setup build
#else
#all: dynamic-branch-setup
#endif
all: build

branch-check:
	@if [ -z "$(BRANCH)" ] ; then \
		echo "You must supply 'BRANCH=<branch>' on the make command line" ;\
		exit 1 ;\
	fi

no-branch-check:
	@if [ -n "$(BRANCH)" ] ; then \
		echo "You can't specify a branch with the build or deploy targets" ;\
		exit 1 ;\
	fi

$(BUILD_DIR):
	@echo "Creating $(BUILD_DIR)"
	@mkdir -p $(BUILD_DIR)

ifneq ($(BRANCH),)
BRANCH_DIR := $(BUILD_DIR)/build-${BRANCH}
$(BRANCH_DIR): $(BUILD_DIR) 
	@echo "Creating $(BRANCH_DIR)"
	@mkdir -p $(BRANCH_DIR)
endif

static-setup: $(BUILD_DIR)
	@echo "Setting Up Static Documentation"
	@echo "  Copying to temp build"
	@ rm -rf $(BUILD_DIR)/docs/
	@rsync -aH docs/. $(BUILD_DIR)/docs/
	@echo "  Applying link transformations"
	@utils/fix_build.sh $(BUILD_DIR)/docs utils/build_fixes.yml
	@[ -L $(BUILD_DIR)/mkdocs.yml ] && rm $(BUILD_DIR)/mkdocs.yml || :
	@ln -sfr mkdocs.yml $(BUILD_DIR)/mkdocs.yml
	@[ -L $(BUILD_DIR)/overrides ] && rm $(BUILD_DIR)/overrides || :
	@ln -sfr overrides $(BUILD_DIR)/overrides
	@touch $(BUILD_DIR)/.site_built

$(BUILD_DIR)/.site_built:
	@$(MAKE) --no-print-directory static-setup

$(BUILD_DIR)/docs: $(BUILD_DIR)/.site_built

dynamic-setup:
	@branches=$(BRANCHES) ;\
	IFS=',' ;\
	for branch in $${branches} ; do \
		echo "Building branch $${branch}" ;\
		$(MAKE) --no-print-directory BRANCH=$${branch} dynamic-branch-setup ;\
	done

dynamic-branch-setup: branch-check dynamic-core-setup dynamic-ari-setup

NEEDS_DOWNLOAD := no

ifeq ($(findstring $(MAKECMDGOALS),clean static-setup serve deploy),)
ifeq ($(ASTERISK_XML_FILE),)
NEEDS_DOWNLOAD := yes
endif

ifeq ($(ASTERISK_ARI_DIR),)
NEEDS_DOWNLOAD := yes
endif
endif

ifeq ($(NEEDS_DOWNLOAD),yes)
$(info Finding last CreateDocs job)
LAST_JOB := $(shell gh --repo asterisk/asterisk run list -w CreateDocs -s success --json databaseId,conclusion,updatedAt --created $(JOB_DATE) --jq '.[0].databaseId')
endif

ifneq ($(ASTERISK_XML_FILE),)
XML_PREREQ := $(ASTERISK_XML_FILE)
else
XML_PREREQ := download-from-job
ASTERISK_XML_FILE := $(BRANCH_DIR)/source/asterisk-docs.xml
endif

dynamic-core-setup: branch-check $(BUILD_DIR)/docs $(BRANCH_DIR) $(XML_PREREQ)
	@echo "Setting Up Core Dynamic Documentation for branch '$(BRANCH)'"
	@echo "  Generating markdown from Asterisk XML"
	@utils/astxml2markdown.py --file=$(ASTERISK_XML_FILE) \
		--xslt=utils/astxml2markdown.xslt \
		--directory=$(BRANCH_DIR)/docs/ --branch=$(BRANCH) --version=GIT
	@[ -L $(BUILD_DIR)/docs/Asterisk_$(BRANCH)_Documentation/API_Documentation ] && \
		rm $(BUILD_DIR)/docs/Asterisk_$(BRANCH)_Documentation/API_Documentation || :
	@ln -sfr $(BRANCH_DIR)/docs $(BUILD_DIR)/docs/Asterisk_$(BRANCH)_Documentation/API_Documentation 

ifneq ($(ASTERISK_ARI_DIR),)
ARI_PREREQ := $(ASTERISK_ARI_DIR)/_Asterisk_REST_Data_Models.md
else
ARI_PREREQ := download-from-job
ASTERISK_ARI_DIR := $(BRANCH_DIR)/source/
endif

dynamic-ari-setup: branch-check $(BUILD_DIR)/docs $(BRANCH_DIR) $(ARI_PREREQ)
	@echo "Setting Up ARI Dynamic Documentation for branch '$(BRANCH)'"
	@echo "  Copying ARI markdown"
	@mkdir -p $(BRANCH_DIR)/docs/Asterisk_REST_Interface
	@rsync -aH $(ASTERISK_ARI_DIR)/*.md $(BRANCH_DIR)/docs/Asterisk_REST_Interface/

download-from-job: $(BRANCH_DIR) branch-check 
	@if [ -z "$(LAST_JOB)" ] ; then \
		echo "No current docs job" ;\
		exit 1 ;\
	fi
	@echo "Retrieving documentation from job $(LAST_JOB) for branch: $(BRANCH)"
	@[ -d $(BRANCH_DIR)/source ] && rm -rf $(BRANCH_DIR)/source || :
	@mkdir -p $(BRANCH_DIR)/source
	@gh run download --repo asterisk/asterisk $(LAST_JOB) \
		-n documentation-$(BRANCH) -D $(BRANCH_DIR)/source

ifeq ($(BRANCH),)
build: static-setup dynamic-setup
	@echo Building to $(BUILD_DIR)/site
	@[ ! -f $(BUILD_DIR)/mkdocs.yml ] && \
		{ echo "Can't build. '$(BUILD_DIR)/mkdocs.yml' not found" ; exit 1 ; } || :
	@mkdocs build -f $(BUILD_DIR)/mkdocs.yml
else
build: BRANCH = $(BRANCH)
build: dynamic-branch-setup
	@echo Building to $(BUILD_DIR)/site
	@[ ! -f $(BUILD_DIR)/mkdocs.yml ] && \
		{ echo "Can't build. '$(BUILD_DIR)/mkdocs.yml' not found" ; exit 1 ; } || :
	@mkdocs build -f $(BUILD_DIR)/mkdocs.yml
endif

deploy: no-branch-check
	@if [ -z "$(DEPLOY_REMOTE)" ] ; then \
		echo "No DEPLOY_REMOTE was defined in Makefile.inc" ;\
		exit 1 ;\
	fi 
	@echo Deploying to remote '$(DEPLOY_REMOTE)'
	@[ ! -f $(BUILD_DIR)/mkdocs.yml ] && \
		{ echo "Can't deploy. '$(BUILD_DIR)/mkdocs.yml' not found" ; exit 1 ; } || :
	@mkdocs gh-deploy -r $(DEPLOY_REMOTE) -b $(DEPLOY_BRANCH) --no-history -f $(BUILD_DIR)/mkdocs.yml

serve: 
	@mkdocs serve -f $(BUILD_DIR)/mkdocs.yml $(SERVE_OPTS)


clean:
ifneq ($(BRANCH_DIR),)
	@rm -rf $(BRANCH_DIR) || :
else
	@rm -rf $(BUILD_DIR) || :
endif	

.PHONY: all clean-all clean branch-check no-branch-check \
	static-setup dynamic-setup dynamic-branch-setup dynamic-core-setup dynamic-ari-setup \
	download-from-job build deploy

