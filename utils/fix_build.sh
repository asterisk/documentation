#!/bin/bash
PROGPATH=$(realpath $0)
PROGDIR=$(dirname $PROGPATH)
USAGE="Usage: ${0} <directory> <regex yml>"
: ${1:?${USAGE}}
[ ! -d "$1" ] && { echo "'$1' doesn't exist or is not a directory" ; exit 1 ; }
: ${2:?${USAGE}}
[ ! -f "$2" ] && { echo "'$2' doesn't exist or is not a file" ; exit 1 ; }

dirs=$(find $1 -type d )
for d in $dirs ; do
	${PROGDIR}/reprocess.py --quiet --docs $d --no-recurse --md-fixes $2
done
