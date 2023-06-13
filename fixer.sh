#!/bin/bash

# issues
# 'docs/Home/Configuration/Interfaces/Distributed-Device-State/Distributed-Device-State-with-XMPP-PubSub.md'
# 'docs/Home/Fundamentals/Asterisk-Configuration/Asterisk-Configuration-Files/Adding-to-an-existing-section.md'

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
	mkdir -p docs-api/Historical-Pages/
	rm -rf ${mvdirs//docs\//docs-api\/}
	mv $mvdirs docs-api/Historical-Pages/
fi

dirs=$(find docs -type d)
for d in $dirs ; do
	[ ! -f "${d}.md" ] && continue
	mv "${d}.md" "${d}/index.md"
	sed -i -r -e "1,/---/s/^title:.*/title: Overview/g" "${d}/index.md"
done

mds=$(find docs -name index.md -type f)
for f in $mds ; do
	lines=$(sed -r -e "1,/---/d" -e "/^$/d" $f | wc -l)
	[ $lines -eq 0 ] && { echo "Deleted empty $f" ; rm $f ; }
done

curl --output docs/favicon.ico https://www.asterisk.org/favicon.ico
cp docs/favicon.ico overrides/.icons/
