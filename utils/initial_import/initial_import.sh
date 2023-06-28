#!/bin/bash
PROGNAME=$(realpath $0)
PROGDIR=$(dirname $PROGNAME)

initial_configure() {

	[ -f docs/Images.md ] && rm docs/Images.md
	[ -f docs/Home.md ] && mv docs/Home.md docs/index.md
	[ -d docs/Home ] && {
		mv docs/Home/* docs/
		rmdir docs/Home
	}
	[ -f docs/How-to-articles.md ] && rm docs/How-to-articles.md
	[ -f docs/Meeting-notes.md ] && rm docs/Meeting-notes.md

	mvdirs=$(find docs/ -maxdepth 1 -name "Asterisk-[0-9][0-9]-Documentation*")
	if [ -n "$mvdirs" ] ; then
		mkdir -p docs-api/
		rm -rf ${mvdirs//docs\//docs-api\/}
		mv $mvdirs docs-api/
	fi

	mvdirs=$(find docs/Historical-Pages -maxdepth 1 -name "Asterisk-*-Documentation*")
	if [ -n "$mvdirs" ] ; then
		rm -rf ${mvdirs}
	fi
	[ -f docs/Historical-Pages.md ] && rm docs/Historical-Pages.md

#	dirs=$(find docs -type d)
#	for d in $dirs ; do
#		[ ! -f "${d}.md" ] && continue
#		mv "${d}.md" "${d}/index.md"
#		sed -i -r -e "1,/---/s/^title:.*/title: Overview/g" "${d}/index.md"
#	done
	
	if [ -d docs/Historical-Pages ] ; then
		[ -d Historical-Pages ] && rm -rf Historical-Pages
		mv docs/Historical-Pages ./
	fi

	[ -d docs/Asterisk-Test-Suite-Documentation ] && \
		mv docs/Asterisk-Test-Suite-Documentation docs/Test-Suite-Documentation 

	[ -f docs/Sangoma-and-Digium-Join-Together-FAQ.md ] && \
		mv docs/Sangoma-and-Digium-Join-Together-FAQ.md \
			docs/About-the-Project/

	[ -f docs/Asterisk-Security-Vulnerabilities.md ] && \
		mv docs/Asterisk-Security-Vulnerabilities.md \
			docs/About-the-Project/

	[ -f docs/Asterisk-Project-Infrastructure-Migration.md ] && \
		mv docs/Asterisk-Project-Infrastructure-Migration.md \
			docs/Development/
		
#	mds=$(find docs -name index.md -type f)
#	for f in $mds ; do
#		lines=$(sed -r -e "1,/---/d" -e "/^$/d" $f | wc -l)
#		[ $lines -eq 0 ] && { echo "Deleted empty $f" ; rm $f ; }
#	done

	[ ! -f docs/favicon.ico ] && cp overrides/.icons/favicon.ico ./docs/
	cp overrides/index.md ./docs/

	echo "docs.asterisk.org" > docs/CNAME
}


#rm -rf docs
#rsync -vaH ../internal/confluence2markdown/output/markdown/. ./docs/
#initial_configure
#mkdocs build
${PROGDIR}/convert_links.sh

