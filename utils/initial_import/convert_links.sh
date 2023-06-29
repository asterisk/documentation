#!/bin/bash
PROGNAME=$(realpath $0)
PROGDIR=$(dirname $PROGNAME)

# Confluence's storage is flat.  Every page is referenced
# from the top with an absolute '/' prefix.  
# This doesn't work well here so for every internal link,
# we have to search for the target page and update the
# link to include the target's full path relative to the
# document root.

dir=${1:-docs/}

files=$(grep -rlE "\]\(/[^/()]+\)" $dir | grep -E ".md$")
#files=$(grep -rl "](/" docs/*)
prefix="/"
IFS=$' \n'
declare -ix fixed_count=0

fixfile() {
	f="$1"
	declare -i fixed_count=0
	while read URL ; do
		if [ -z "$URL" ] ; then
			echo "   no issues"
			break;			
		fi
		search="temp/build-20/site/$URL"
#		echo "Search: '$search'"
		if [ -f "$search" ] || [ -d "$search" ] ; then
#			echo "   found: $URL"
			continue
		fi

		if [ -z "${URL%%#*}" ] ; then
			newurl=$($PROGDIR/../slugify.py "${URL}")
		else
			newurl=$($PROGDIR/../slugify.py "${URL%%#*}")
		fi
		[[ "$newurl" =~ Asterisk-[0-9][0-9] ]] && continue

		echo "   not found: $URL"
		if [ "$URL" == "Home" ] ; then
			newpage="/"
		else
			newpage=$(cd temp/build-20/site ; find -iname "${newurl}" | tr -d '\n')
			newpage="${newpage/.\//}"
			if [ -z "$newpage" ] ; then
				newpage=$(cd temp/build-20/site ; find -iname "${newurl}.html" | tr -d '\n')
				newpage="${newpage/.\//}"
			fi
		fi
		if [ -n "$newpage" ] ; then
#			echo $newpage
			newsearch=${URL//+/\\+}
			newsearch=${newsearch//\?/\\?}

			fixed=$(sed -n -r -e "s@\]\(/${newsearch}\)@](/${newpage})@gip" $f)
			if [ -z "$fixed" ] ; then
				echo -e "      Unable to fix: ${newsearch} -> ${newpage}"
			else
				fixed_count=$(( fixed_count + 1 ))
				echo "      fixed: /${newpage}"
				sed -i -r -e "s@\]\(/${newsearch}\)@](/${newpage})@gi" $f
			fi
		else
			if [[ ! "${newurl}" =~ .*REST.* ]] ; then
				echo "      Page not found: ${newurl}"
			fi
		fi
	done < <(sed -n -r -e "s/.*\]\(\/([^/)]+)\).*/\1/gp" $f )
	return $fixed_count
}

for f in $files ; do
	echo $f
	while true ; do
		fixfile $f && break;
	done
done
