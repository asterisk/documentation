
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

docs-%/source/asterisk-docs.xml: BRANCH = $(subst docs-,,$(subst /source/asterisk-docs.xml,,$@))
docs-%/source/asterisk-docs.xml:
	@if [ "$(LAST_JOB)" == "" ] ; then \
		echo "No current docs job" ;\
		exit 1 ;\
	fi
	@echo "Retrieving documentation from job $(LAST_JOB) for branch: $%"
	@mkdir -p docs-$(BRANCH)/source
	@gh run download --repo asterisk/asterisk $(LAST_JOB) -n documentation-$(BRANCH) -D docs-$(BRANCH)/source

docs-general: FORCE
	@echo "Copying general docs"
	@mkdir -p $@/docs
	@cp mkdocs-template.yml $@/mkdocs.yml
	@rsync -vaH docs/. ./$@/docs/
	mike deploy -F $@/mkdocs.yml -r $(REMOTE) -u -p -t "Asterisk General" general
	mike set-default -F $@/mkdocs.yml -r $(REMOTE) -p general  
	
docs-%: private BRANCH = $(subst docs-,,$@)
docs-%: docs-%/source/asterisk-docs.xml FORCE  
	@mkdir -p $@/docs/Asterisk_REST_Interface
	@cp mkdocs-template.yml $@/mkdocs.yml
	@rsync -vaH $@/source/*.md $@/docs/Asterisk_REST_Interface/
	@echo "# Asterisk $(BRANCH) Documentation" > $@/docs/index.md
	./astxml2markdown.py --file=$@/source/asterisk-docs.xml --directory=$@/docs/ --branch=$(BRANCH) --version=GIT
	mike deploy -F $@/mkdocs.yml -r $(REMOTE) -u -p -t "Asterisk $(BRANCH)" $(BRANCH)
	mike set-default -F $@/mkdocs.yml -r $(REMOTE) -p general  

FORCE:

clean:
	rm -rf docs-$(BRANCH)

 