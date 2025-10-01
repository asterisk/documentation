#!/usr/bin/bash
PROGDIR=$(dirname $(realpath $0))

infile=${1:?"Usage: $(basename $0) <input_file> <path_to_generated_website> <map_output_file>"}
site=${2:?"Usage: $(basename $0) <input_file> <path_to_generated_website> <map_output_file>"}
outfile=${3:?"Usage: $(basename $0) <input_file> <path_to_generated_website> <map_output_file>"}

urls=$(mktemp /tmp/urls-XXXXX)
titles=$(mktemp /tmp/titles-XXXXX)
fixed=$(mktemp /tmp/fixed-XXXXX)

sed -r -e 's/([^|]+)\|(.*)/\1/g' ${infile} > ${urls}
sed -r -e 's/([^|]+)\|(.*)/\2/g' ${infile} > ${titles}
sed -i -r -e 's/[^A-Za-z0-9. _-]//g' ${titles}
sed -i -r -e 's/\s+/-/g'  ${titles}

urlcount=$(cat ${urls} | wc -l)
uniqueurls=$(cat ${urls} | sort -u | wc -l)

if [ $urlcount -ne ${uniqueurls} ] ; then
	echo "There were duplicate URLs in ${infile}" 1>&2
	exit 1
fi

titlecount=$(cat ${titles} | wc -l)

if [ $urlcount -ne $titlecount ] ; then
	echo "${urls} and ${titles} have different counts ($urlcount and $titlecount)" 1>&2
	exit 1
fi

exec 5<${urls}
exec 6<${titles}
mapfile -t -u 5 URLS
mapfile -t -u 6 TITLES
rm ${urls} ${titles}

for (( ix=0 ; urlcount - ix ; ix+=1 )) ; do
	echo "${URLS[$ix]}|${TITLES[$ix]}" >> ${fixed}
done

if [ ${outfile} == "-" ] ; then
	outfile=/dev/stdout
else
	rm -rf ${outfile}
fi

conflprefix="/wiki/display/AST/"
conflprefixlen=${#conflprefix}

declare -A typexref=(
	["AGICommand"]="AGI_Commands"
	["ManagerAction"]="AMI_Actions"
	["ManagerEvent"]="AMI_Events"
	["Application"]="Dialplan_Applications"
	["Function"]="Dialplan_Functions"
	["Configuration"]="Module_Configuration"
)

declare -A namexref=(
	["Documentation"]="-"
	["Command+Reference"]="API_Documentation"
	["ARI"]="API_Documentation/Asterisk_REST_Interface"
	["AGI+Commands"]="API_Documentation/AGI_Commands"
	["AMI+Actions"]="API_Documentation/AMI_Actions"
	["AMI+Events"]="API_Documentation/AMI_Events"
	["Dialplan+Applications"]="API_Documentation/Dialplan_Applications"
	["Dialplan+Functions"]="API_Documentation/Dialplan_Functions"
	["Module+Configuration"]="API_Documentation/Module_Configuration"
	["REST+Data+Models"]="API_Documentation/Asterisk_REST_Interface/Asterisk_REST_Data_Models"
	["Applications+REST+API"]="API_Documentation/Asterisk_REST_Interface/Applications_REST_API"
	["Asterisk+REST+API"]="API_Documentation/Asterisk_REST_Interface/Asterisk_REST_API"
	["Asterisk+REST+Data+Models"]="API_Documentation/Asterisk_REST_Interface/Asterisk_REST_Data_Models"
	["Bridges+REST+API"]="API_Documentation/Asterisk_REST_Interface/Bridges_REST_API"
	["Channels+REST+API"]="API_Documentation/Asterisk_REST_Interface/Channels_REST_API"
	["Devicestates+REST+API"]="API_Documentation/Asterisk_REST_Interface/Devicestates_REST_API"
	["Endpoints+REST+API"]="API_Documentation/Asterisk_REST_Interface/Endpoints_REST_API"
	["Events+REST+API"]="API_Documentation/Asterisk_REST_Interface/Events_REST_API"
	["Mailboxes+REST+API"]="API_Documentation/Asterisk_REST_Interface/Mailboxes_REST_API"
	["Playbacks+REST+API"]="API_Documentation/Asterisk_REST_Interface/Playbacks_REST_API"
	["Recordings+REST+API"]="API_Documentation/Asterisk_REST_Interface/Recordings_REST_API"
	["Sounds+REST+API"]="API_Documentation/Asterisk_REST_Interface/Sounds_REST_API"
)

declare -A site_pages
while read f ; do
	bn=${f##*/}
	bn=${bn,,}
	[ -z "$bn" ] && continue
	site_pages[$bn]=$f
done < <(find ${site} -type d -printf "%P\n")

declare -A site_dirs
while read f ; do
	[ -z "$f" ] && continue
	site_dirs[$f]=1
done < <(find ${site} -type d -printf "%P\n")

exec 7<${fixed}

while read -u 7 LINE ; do
	url=${LINE%%|*}
	title=${LINE##*|}
	lctitle=${title,,}
	pagename=${url:${conflprefixlen}}
	path=""

	if [[ $pagename =~ ^New[+]in[+]([0-9]+)$ ]] ; then
		version=${BASH_REMATCH[1]}
		if [[ "$version" =~ (18|20|21|22|23) ]] ; then
			path="Asterisk_${version}_Documentation/WhatsNew"
		else
			path="Latest_API/WhatsNew"
		fi
	fi

	if [ -z "$path" ] && [[ $pagename =~ ^Upgrading[+]to[+]Asterisk[+]([0-9]+)$ ]] ; then
		version=${BASH_REMATCH[1]}
		if [[ "$version" =~ (18|20|21|22|23) ]] ; then
			path="Asterisk_${version}_Documentation/Upgrading"
		else
			path="Latest_API/Upgrading"
		fi
	fi

	if [ -z "$path" ] && [[ $pagename =~ ^(Asterisk[+]([0-9]+)[+])?([^_]+)$ ]] ; then
		version=${BASH_REMATCH[2]}
		ptype=${BASH_REMATCH[3]}
		np=${namexref[$ptype]}
		if [ -n "$np" ] ; then
			if [[ "$version" =~ (18|20|21|22|23) ]] ; then
				pp="Asterisk_${version}_Documentation"
			else
				pp="Latest_API"
			fi
			if [ "$np" == "-" ] ; then
				path="${pp}"
			else
				path="${pp}/$np"
			fi
		fi
	fi

	if [ -z "$path" ] && [[ $pagename =~ ^(Asterisk[+]([0-9]+)[+])?(AGICommand|Application|Function|ManagerAction|ManagerEvent|Configuration)_(.+) ]] ; then
		version=${BASH_REMATCH[2]}
		ptype=${BASH_REMATCH[3]}
		np="${BASH_REMATCH[4]//+/_}"
		if [[ $np =~ ^(.+)_(res|app)_[a-z]+$ ]] ; then
			np=${BASH_REMATCH[1]}
		fi
		if [[ "$version" =~ (18|20|21|22|23) ]] ; then
			pp="Asterisk_${version}_Documentation"
		else
			pp="Latest_API"
		fi
		path="${pp}/API_Documentation/${typexref[$ptype]}/$np"
	fi

	if [ -z "$path" ] ; then
		path=${site_pages[$lctitle]}
	fi

	if [ -z "$path" ] || [ -z "${site_dirs[$path]}" ] ; then
		echo "Not found: ($url) ($lctitle) ($path)" 1>&2
		continue
	fi

	echo "${url} /${path}/;" >> ${outfile}
done

rm ${fixed}
outcount=$(cat ${outfile} | wc -l)
if [ $outcount -ne $urlcount ] ; then
	echo "Warning: output map count ${outcount} != input url count ${urlcount}" 1>&2
fi

# now we have to find them


