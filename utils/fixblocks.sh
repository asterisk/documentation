#!/bin/bash
f=$1

[ -f $1 ] && {
	./reprocess.py --quiet --single-page $1 --md-fixes ./md_fixes.yml
	sed -i -r -e '/!!!/,/\[\/\/\]/s/(^[^![])/    \1/g' $1
} || [ -d $1 ] && {
	dirs=$(find $1 -type d )
	for d in $dirs ; do
		echo $d
		./reprocess.py --docs $d --no-recurse --md-fixes ./md_fixes.yml
		files=$(find $d -maxdepth 1 -name '*.md')
		sed -i -r -e '/!!!/,/\[\/\/\]/s/(^[^![])/    \1/g' $files
	done
}

