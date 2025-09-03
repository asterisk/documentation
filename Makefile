#
# NOTE: For readability, two space characters are used to
# indent the contents of make ifeq/ifneq statements.
# Don't confuse these with tabs used to indent rule
# recipies.
#

SHELL := /usr/bin/bash
DEPLOY_BRANCH ?= gh-pages
BUILD_DIR ?= ./temp
GH=gh
JOB_DATE ?= $(shell date +%F)
SERVE_OPTS ?= -a [::]:8000
BRANCHES ?=
BRANCH ?=

-include Makefile.inc

ifneq ($(BRANCHES),)
  COMMA := ,
  BB := $(subst $(COMMA), ,$(BRANCHES))
  includes := $(foreach b,$(BB),Makefile.$(b).inc)
  -include $(includes)
endif

# 'make' has a realpath function but it only works on
# existing files and directories.
SITE_DIR ?= $(shell realpath $(BUILD_DIR)/site)

ifeq ($(NO_MINIFY),)
MINIFY_REGEX := /\#\s+-\s+minify:/,/^$$/ s/^\# / /g
else
MINIFY_REGEX := /\s+-\s+minify:/,/^$$/ s/^ /\# /g
endif

all:: build

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
  BRANCH_DIR := $(BUILD_DIR)/build-$(subst /,-,$(BRANCH))
  $(BRANCH_DIR): $(BUILD_DIR)
	@echo "Creating $(BRANCH_DIR)"
	@mkdir -p $(BRANCH_DIR)
  ifeq ($(findstring certified,$(BRANCH)),certified)
    BRANCH_DOC_DIR := Certified-Asterisk_$(subst certified/,,$(BRANCH))_Documentation
  else
    BRANCH_DOC_DIR := Asterisk_$(BRANCH)_Documentation
  endif
endif

$(BUILD_DIR)/mkdocs.yml: mkdocs.yml
	@cp mkdocs.yml $(BUILD_DIR)/mkdocs.yml

static-setup:: $(BUILD_DIR) $(BUILD_DIR)/mkdocs.yml
	@echo "Setting Up Static Documentation"
ifeq ($(NO_STATIC),)
	@echo "  Copying docs/ to temp build"
	@rsync -vaH --delete-after docs/. $(BUILD_DIR)/docs/
else
	@echo "  Copying only docs/index.md and favicon.ico to temp build"
	@mkdir -p $(BUILD_DIR)/docs
	@cp docs/index.md docs/favicon.ico $(BUILD_DIR)/docs/
endif	
	@[ -L $(BUILD_DIR)/mkdocs.yml ] && rm $(BUILD_DIR)/mkdocs.yml || :
	@cp mkdocs.yml $(BUILD_DIR)/mkdocs.yml
	@[ -L $(BUILD_DIR)/overrides ] && rm $(BUILD_DIR)/overrides || :
	@ln -sfr overrides $(BUILD_DIR)/overrides
	@touch $(BUILD_DIR)/.site_built

$(BUILD_DIR)/.site_built:
	@$(MAKE) --no-print-directory $(if $(NO_STATIC),NO_STATIC=yes,) static-setup

$(BUILD_DIR)/docs: $(BUILD_DIR)/.site_built

dynamic-setup:
	@branches=$(BRANCHES) ;\
	IFS=',' ;\
	for branch in $${branches} ; do \
		echo "Building branch $${branch}" ;\
		$(MAKE) --no-print-directory BRANCH=$${branch} $(if $(NO_STATIC),NO_STATIC=yes,) dynamic-branch-setup ;\
	done

dynamic-branch-setup: branch-check dynamic-core-setup $(if $(SKIP_ARI),,dynamic-ari-setup)

NEEDS_DOWNLOAD := no

ifneq ($(BRANCH),)
  ifeq ($(findstring $(MAKECMDGOALS),clean static-setup serve deploy),)
    ifeq ($(ASTERISK_XML_FILE),)
      NEEDS_DOWNLOAD := yes
    endif

    ifeq ($(SKIP_ARI),)
      ifeq ($(ASTERISK_ARI_DIR),)
        NEEDS_DOWNLOAD := yes
      endif
    endif
  endif
endif

ifeq ($(NEEDS_DOWNLOAD),yes)
  $(info Finding last CreateDocs job)
  LAST_JOB := $(shell $(GH) --repo asterisk/asterisk run list -w CreateDocs -s success --json databaseId,conclusion,updatedAt --created $(JOB_DATE) --jq '.[0].databaseId')
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
	@mkdir -p $(BUILD_DIR)/docs/$(BRANCH_DOC_DIR)
	@utils/astxml2markdown.py --file=$(ASTERISK_XML_FILE) \
		--xslt=utils/astxml2markdown.xslt \
		--directory=$(BRANCH_DIR)/docs/ --branch=$(BRANCH) --version=GIT
	@[ -L $(BUILD_DIR)/docs/$(BRANCH_DOC_DIR)/API_Documentation ] && \
		rm $(BUILD_DIR)/docs/$(BRANCH_DOC_DIR)/API_Documentation || :
	@ln -sfr $(BRANCH_DIR)/docs $(BUILD_DIR)/docs/$(BRANCH_DOC_DIR)/API_Documentation 

ifneq ($(ASTERISK_ARI_DIR),)
  ARI_PREREQ := $(ASTERISK_ARI_DIR)/Asterisk_REST_Data_Models.md
else
  ARI_PREREQ := download-from-job
  ASTERISK_ARI_DIR := $(BRANCH_DIR)/source/
endif

dynamic-ari-setup: branch-check $(BUILD_DIR)/docs $(BRANCH_DIR) $(ARI_PREREQ)
	@echo "Setting Up ARI Dynamic Documentation for branch '$(BRANCH)'"
	@echo "  Copying ARI markdown"
	@mkdir -p $(BRANCH_DIR)/docs/Asterisk_REST_Interface
	@rsync -aH $(ASTERISK_ARI_DIR)/*.md $(BRANCH_DIR)/docs/Asterisk_REST_Interface/
	@sed -i "1i ---\nsearch:\n  boost: 0.5\n---\n" $(BRANCH_DIR)/docs/Asterisk_REST_Interface/*REST_API.md
	@cp overrides/.copy-in/ari.pages $(BRANCH_DIR)/docs/Asterisk_REST_Interface/.pages
	@echo "# Asterisk REST Interface" > $(BRANCH_DIR)/docs/Asterisk_REST_Interface/index.md
	
download-from-job: $(BRANCH_DIR) branch-check 
	@if [ -z "$(LAST_JOB)" ] ; then \
		echo "No current docs job" ;\
		exit 1 ;\
	fi
	@echo "Retrieving documentation from job $(LAST_JOB) for branch: $(BRANCH)"
	@[ -d $(BRANCH_DIR)/source ] && rm -rf $(BRANCH_DIR)/source || :
	@mkdir -p $(BRANCH_DIR)/source
	@$(GH) run download --repo asterisk/asterisk $(LAST_JOB) \
		-n documentation-$(subst /,-,$(BRANCH)) -D $(BRANCH_DIR)/source

ifeq ($(BRANCH),)
  build: static-setup dynamic-setup
	@echo Building to $(SITE_DIR)
	@[ ! -f $(BUILD_DIR)/mkdocs.yml ] && \
		{ echo "Can't build. '$(BUILD_DIR)/mkdocs.yml' not found" ; exit 1 ; } || :
	@sed -i -r -e "$(MINIFY_REGEX)" $(BUILD_DIR)/mkdocs.yml
	@mkdocs build -f $(BUILD_DIR)/mkdocs.yml -d $(SITE_DIR)
else
  build: BRANCH = $(BRANCH)
  build: dynamic-branch-setup
	@echo Building to $(SITE_DIR)
	@[ ! -f $(BUILD_DIR)/mkdocs.yml ] && \
		{ echo "Can't build. '$(BUILD_DIR)/mkdocs.yml' not found" ; exit 1 ; } || :
	@sed -i -r -e "$(MINIFY_REGEX)" $(BUILD_DIR)/mkdocs.yml
	@mkdocs build -f $(BUILD_DIR)/mkdocs.yml -d $(SITE_DIR)
endif

deploy: no-branch-check
	@if [ -z "$(DEPLOY_REMOTE)" ] ; then \
		echo "No DEPLOY_REMOTE was defined in Makefile.inc" ;\
		exit 1 ;\
	fi 
	@echo Deploying to remote '$(DEPLOY_REMOTE)'
	@[ ! -f $(BUILD_DIR)/mkdocs.yml ] && \
		{ echo "Can't deploy. '$(BUILD_DIR)/mkdocs.yml' not found" ; exit 1 ; } || :
	@sed -i -r -e "$(MINIFY_REGEX)" $(BUILD_DIR)/mkdocs.yml
	@mkdocs gh-deploy -r $(DEPLOY_REMOTE) -b $(DEPLOY_BRANCH) \
		-d $(SITE_DIR) --no-history -f $(BUILD_DIR)/mkdocs.yml

serve: 
	@mkdocs serve -f $(BUILD_DIR)/mkdocs.yml $(SERVE_OPTS)


clean:
ifneq ($(BRANCH_DIR),)
	@rm -rf $(BRANCH_DIR) || :
else
	@rm -rf $(BUILD_DIR) || :
endif	

siteclean:
	@rm -rf $(SITE_DIR) || :

.PHONY: all clean siteclean branch-check no-branch-check \
	static-setup dynamic-setup dynamic-branch-setup dynamic-core-setup dynamic-ari-setup \
	download-from-job build deploy
