#!/usr/bin/bash

infile=${1:?"Usage: $(basename $0) <input_file> [<input_file> ... ]"}

left=$(mktemp /tmp/left-XXXXX)
right=$(mktemp /tmp/right-XXXXX)

grep --no-filename -E "^/wiki" "$@" | sort --key=1,1 > ${left}
sort --key=1,1 -u ${left} > ${right}
diff -uprN ${left} ${right} || { echo "Duplicate entries found!" 1>&2 ; exit 1 ; }
grep -vE '(/wiki[^ ]+)\s+(/.+)/;$' ${right} && { echo "Bad entries found!" 1>&2 ; exit 1 ; }
rm -rf ${left} ${right}
exit 0
