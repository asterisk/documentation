
BRANCH := general
REMOTE=local

all: docs-$(BRANCH)

TODAY := $(shell date +%F)
LAST_JOB := $(shell gh --repo asterisk/asterisk run list -w CreateDocs -s success --json databaseId,conclusion,updatedAt --created $(TODAY) --jq '.[0].databaseId')

docs-$(BRANCH)/source/asterisk-docs.xml:
	@if [ "$(LAST_JOB)" == "" ] ; then \
		echo "No current docs job" ;\
		exit 1 ;\
	fi
	@echo "Retrieving documentation from job $(LAST_JOB) for branch: $(BRANCH)"
	@mkdir -p $$(dirname $@)
	@gh run download --repo asterisk/asterisk $(LAST_JOB) -n documentation-$(BRANCH) -D $$(dirname $@)

docs-general:
	@echo "Copying general docs"
	@mkdir -p $@/docs
	@cp mkdocs-template.yml $@/mkdocs.yml
#	@sed -i -r -e "s@<<DOCS_DIR>>@$@/docs@g" $@/mkdocs.yml
	@rsync -vaH docs/. ./$@/docs/
	mike deploy -F $@/mkdocs.yml -r $(REMOTE) -u -p -t "Asterisk General"  
	mike set-default -F $@/mkdocs.yml -r $(REMOTE) -p general  
	

docs-%: docs-%/source/asterisk-docs.xml FORCE  
	@echo "BRANCH: $(BRANCH)"
	@mkdir -p $@/docs
	@cp mkdocs-template.yml $@/mkdocs.yml
	@sed -i -r -e "s@<<DOCS_DIR>>@$@/docs@g" $@/mkdocs.yml
	@rsync -vaH $@/source/*.md $@/docs/


FORCE:

clean:
	rm -rf docs-$(BRANCH)

 