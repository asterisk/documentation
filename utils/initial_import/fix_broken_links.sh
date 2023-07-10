#!/bin/bash

PROGPATH=$(realpath $0)
PROGDIR=$(dirname $PROGPATH)
USAGE="Usage: ${0} <directory>"
: ${1:?${USAGE}}
[ ! -d "$1" ] && { echo "'$1' doesn't exist or is not a directory" ; exit 1 ; }
: ${2:?${USAGE}}
[ ! -d "$2" ] && { echo "'$2' doesn't exist or is not a directory" ; exit 1 ; }

declare -A dynamap=(
[Configuration]=_Module_Configuration
[ManagerAction]=_AMI_Actions
[ManagerEvent]=_AMI_Events
[Function]=_Dialplan_Functions
[Application]=_Dialplan_Applications
)

#_AGI_Commands
#_Asterisk_REST_Interface

IFS=$'\n '
dirs=$(find $1 -type d )
for d in $dirs ; do
	for f in $(find $d -type f -name *.md) ; do
		links=$(sed -n -r -e "s@.*\]\((/[^)]+)\).*@\1@gp" $f | sort -u)
		for l in $links ; do
			[[ "$l" =~ ^/latest ]] && continue
			if [ ! -d $2$l ]  ; then
				echo "not found: $l"
				[[ "$l" =~ /Asterisk-[0-9][0-9]-(Configuration|ManagerAction|ManagerEvent|Function|Application)_(.*) ]] || { echo "   not fixable" ; continue ; }
				newdir=${dynamap[${BASH_REMATCH[1]}]}
				page=${BASH_REMATCH[2]}
				[ -z "$newdir" ] && { echo "   No newdir" ; continue ; }
				newlink="$newdir/$page"
				echo "   newlink: ${newlink}"
				if [ ! -d $2/$newlink ] ; then
					echo "   not found"
				else
					echo "   FOUND!"
					sed -i -r -e "s@\($l\)@(/$newlink)@g" $f
				fi
			fi
			
		done
	done
done
