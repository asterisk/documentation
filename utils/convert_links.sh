#!/bin/bash
PROGNAME=$(realpath $0)
PROGDIR=$(dirname $PROGNAME)

# Confluence's storage is flat.  Every page is referenced
# from the top with an absolute '/' prefix.  
# This doesn't work well here so for every internal link,
# we have to search for the target page and update the
# link to include the target's full path relative to the
# document root.

files=$(grep -rl "](/" docs/*)
prefix="/"
IFS=$' \n'
for f in $files ; do
	sed -n -r -e "s@.*\]\(${prefix}([^)]+)\).*@\1@gip" $f | while read URL ; do
		if [ -z "${URL%%#*}" ] ; then
			newurl=$($PROGDIR/slugify.py "${URL}")
		else
			newurl=$($PROGDIR/slugify.py "${URL%%#*}")
		fi
		[[ "$newurl" =~ Asterisk-[0-9][0-9] ]] && continue

		if [ "$URL" == "Home" ] ; then
			newpage="/"
		else
			newpage=$(cd site ; find -iname "${newurl}" | tr -d '\n')
			newpage=${newpage/.\//}
			if [ -z "$newpage" ] ; then
				newpage=$(cd site ; find -iname "${newurl}.html" | tr -d '\n')
				newpage=${newpage/.\//}
			fi
		fi
		if [ -n "$newpage" ] ; then
			fixed=$(sed -n -r -e "s@${prefix}${URL//+/\\+}@/${newpage}@gip" $f)
			if [ -z "$fixed" ] ; then
				echo -e "$f Unable to fix: ${prefix}${URL} -> ${newurl}"
			else
				sed -i -r -e "s@${prefix}${URL//+/\\+}@/${newpage}@gi" $f
			fi
		else
			if [[ ! "${newurl}" =~ .*REST.* ]] ; then
				echo "$f: Page not found: ${prefix}${URL} -> ${newurl}"
			fi
		fi
	done
done
