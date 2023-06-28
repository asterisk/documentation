SHELL := /usr/bin/bash
REMOTE=local
include Makefile.inc

all:
	@for b in $(EVERYTHING) ; do \
		$(MAKE) $${b} ;\
	done

clean-all:
	@for b in $(EVERYTHING) ; do \
		rm -rf $${b} ;\
	done

TODAY := $(shell date +%F)
LAST_JOB := $(shell gh --repo asterisk/asterisk run list -w CreateDocs -s success --json databaseId,conclusion,updatedAt --created $(TODAY) --jq '.[0].databaseId')

docs-%-source: BRANCH = $(subst docs-,,$(subst -source,,$@))
docs-%-source:
	@if [ "$(LAST_JOB)" == "" ] ; then \
		echo "No current docs job" ;\
		exit 1 ;\
	fi
	@echo "Retrieving documentation from job $(LAST_JOB) for branch: $(BRANCH)"
	@if [ -d docs-$(BRANCH)/source ] ; then \
		rm -rf docs-$(BRANCH)/source.bak 2>/dev/null || : ;\
		mv docs-$(BRANCH)/source docs-$(BRANCH)/source.bak ;\
	fi
	@mkdir -p docs-$(BRANCH)/source
	@gh run download --repo asterisk/asterisk $(LAST_JOB) -n documentation-$(BRANCH) -D docs-$(BRANCH)/source ||\
		{ [ -d docs-$(BRANCH)/source.bak ] && {\
			rm -rf docs-$(BRANCH)/source ;\
			mv docs-$(BRANCH)/source.bak docs-$(BRANCH)/source ;\
			exit 1 ;\
		} ; }
	@[ -d docs-$(BRANCH)/source.bak ] && rm -rf docs-$(BRANCH)/source.bak

#docs-general: FORCE
#	@echo "Copying general docs"
#	@mkdir -p $@/docs
#	@cp mkdocs-template.yml $@/mkdocs.yml
#	@rsync -vaH docs/. ./$@/docs/
#	mike deploy -F $@/mkdocs.yml -r $(REMOTE) -u -p -t "Asterisk General" general
#	mike set-default -F $@/mkdocs.yml -r $(REMOTE) -p general
	
docs-%: private BRANCH = $(subst docs-,,$@)
docs-%: docs-%-source FORCE
	@mkdir -p $@/docs/_Asterisk_REST_Interface
	@rsync -vaH $@/source/*.md $@/docs/_Asterisk_REST_Interface/
	@cp mkdocs-template.yml $@/mkdocs.yml
	@echo "# Asterisk $(BRANCH) Documentation" > $@/docs/index.md
	./astxml2markdown.py --file=$@/source/asterisk-docs.xml --directory=$@/docs/ --branch=$(BRANCH) --version=GIT
	@if [ "$(BRANCH)" == "$(LATEST)" ] ; then \
		rsync -vaH docs/. ./$@/docs/ ;\
		mike deploy -F $@/mkdocs.yml -r $(REMOTE) -u -p \
			-t "Asterisk Latest ($(BRANCH))" $(BRANCH) latest ;\
		mike set-default -F $@/mkdocs.yml -r $(REMOTE) -p $(BRANCH) ;\
	else \
		mike deploy -F $@/mkdocs.yml -r $(REMOTE) -u -p \
			-t "Asterisk $(BRANCH)" $(BRANCH) ;\
	fi

FORCE:

#.PHONY: $(EVERYTHING) $(append /source/asterisk-docs.xml,$(EVERYTHING))

clean:
	rm -rf docs-$(BRANCH)

 