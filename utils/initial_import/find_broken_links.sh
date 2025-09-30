#!/bin/bash

: ${1:?Need at least 1 directory to process}
VERBOSE=false

for directory in $@ ; do
	[ ! -d $directory ] && { echo "$directory isn't a directory.  Skipping" ; continue ; }
	docroot=""
	testdir=$directory
	while true ; do
		[ -f ${testdir}/sitemap.xml ] && { docroot=$testdir ; break ; }
		testdir=$(dirname $testdir ) || { echo "Bad testdir: '$testdir'" ; break ; }
		[[ $testdir =~ ^(/|[.][.])$ ]] && { echo "docroot not detected for directory $directory" ; break ; } 
	done
	[ -z "$docroot" ] && continue
	echo "Processing $directory with docroot $docroot"
	htmlfiles=$(find $directory -name '*.html' -exec grep -l "<a " '{}' ';')
	for h in $htmlfiles ; do
		hdir=$(dirname $h)

		links=$(sed -n -r -e "s/</\n</gp" $h | sed -n -r -e 's/<a.+href="([^"]+)".*/\1/gp')
		printheader=true
		${VERBOSE} && { echo "  Processing $h" ; printheader=false ; }
		for l in $links ; do
			msg="OK"
			[[ $l =~ (wiki|issues|gerrit)[.]asterisk[.]org ]] && {
				${printheader} && { echo "  Processing $h" ; printheader=false ; }
				echo "    Obsolete link '$l' found"
				continue
			}

			[[ $l =~ ^(javascript|http|mailto) ]] && {
				${VERBOSE} && echo "    Skipping $l"
				continue
			}
			[[ $l =~ ^#(.+) ]] && {
				ll=${BASH_REMATCH[1]}
				grep -q "id=\"${ll}\"" $h || { ${printheader} && { echo "  Processing $h" ; printheader=false ; } ; echo "    anchor '$l' not found" ; continue ; }
				${VERBOSE} && echo "    anchor '$l' OK"
				continue
			}
			[[ $l =~ ^(/[^#]+)#?(.+)? ]] && {
				ll=${BASH_REMATCH[1]}
				anchor=${BASH_REMATCH[2]}
#				[[ $ll =~ [.](pdf|png) ]]
				f=${docroot}${ll}
				[ -d $f ] && f=${docroot}${ll}/index.html
				[ ! -f $f ] && { ${printheader} && { echo "  Processing $h" ; printheader=false ; } ; echo "    link '$f' not found" ; continue ; }
				[ -n "$anchor" ] && {
					grep -q "id=\"${anchor}\"" $f || { ${printheader} && { echo "  Processing $h" ; printheader=false ; } ; echo "    anchor '$anchor' not found in page '$f'" ; continue ; }
				}
				${VERBOSE} && echo "    link $l OK"
				continue
			}
			[[ $l =~ ^([^/][^#]+)#?(.+)? ]] && {
				ll=${BASH_REMATCH[1]}
				anchor=${BASH_REMATCH[2]}
				f=${hdir}/${ll}
				[ -d $f ] && f=${hdir}/${ll}/index.html
				[ ! -f $f ] && { ${printheader} && { echo "  Processing $h" ; printheader=false ; } ; echo "    link '$f' not found" ; continue ; }
				[ -n "$anchor" ] && {
					grep -q "id=\"${anchor}\"" $f || { ${printheader} && { echo "  Processing $h" ; printheader=false ; } ; echo "    anchor '$anchor' not found in page '$f'" ; continue ; }
				}
				${VERBOSE} && echo "    link $l OK"
				continue
			}
			${printheader} && { echo "  Processing $h" ; printheader=false ; }
			echo "    $l NON_MATCHING LINK"
		done
	done
done

