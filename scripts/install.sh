#!/bin/bash

THEMEDIRECTORY=$(cd `dirname $0` && cd .. && pwd)
THUNDERFOLDER=~/.thunderbird
PROFILENAME=""


# Get options.
while getopts 'f:p:g:t:h' flag; do
	case "${flag}" in
	f) THUNDERFOLDER="${OPTARG}" ;;
	p) PROFILENAME="${OPTARG}" ;;
	h)
		echo "Thunderbird Papirus Icon Theme Install Script:"
		echo "  -f <thunderbird_folder_path>. Set custom Thunderbird folder path."
		echo "  -p <profile_name>. Set custom profile name."
		echo "  -h to show this message."
		exit 0
		;;
	esac
done

function saveProfile(){
	local PROFILE_PATH="$1"

	cd "$THUNDERFOLDER/$PROFILE_PATH"
	echo "Installing theme in $PWD"
	# Create a chrome directory if it doesn't exist.
	mkdir -p chrome
	cd chrome

	# Copy theme repo inside
	echo "Copying repo in $PWD"
	cp -fR "$THEMEDIRECTORY" "$PWD"

	# Create single-line user CSS files if non-existent or empty.
	if [ -s userChrome.css ]; then
		# Remove older theme imports
		sed 's/@import "thunderbird-theme-papirus.*.//g' userChrome.css | sed '/^\s*$/d' > userChrome.css
		echo >> userChrome.css
	else
		echo >> userChrome.css
	fi

	# Import this theme at the beginning of the CSS files.
	sed -i '1s/^/@import "thunderbird-theme-papirus\/userChrome.css";\n/' userChrome.css

	cd ..

	# Symlink user.js to thunderbird-theme-papirus one.
	echo "Set configuration user.js file"
	ln -fs chrome/thunderbird-theme-papirus/configuration/user.js user.js

	echo "Done."
	cd ..
}

PROFILES_FILE="${THUNDERFOLDER}/profiles.ini"
if [ ! -f "${PROFILES_FILE}" ]; then
	>&2 echo "failed, please check Thunderbird installation, unable to find profile.ini at ${THUNDERFOLDER}"
	exit 1
fi
echo "Profiles file found"

PROFILES_PATHS=($(grep -E "^Path=" "${PROFILES_FILE}" | tr -d '\n' | sed -e 's/\s\+/SPACECHARACTER/g' | sed 's/Path=/::/g' )) 
PROFILES_PATHS+=::

PROFILES_ARRAY=()
if [ "${PROFILENAME}" != "" ];
	then
		echo "Using ${PROFILENAME} theme"
		PROFILES_ARRAY+=${PROFILENAME}
else
	echo "Finding all avaliable themes";
	while [[ $PROFILES_PATHS ]]; do
		PROFILES_ARRAY+=( "${PROFILES_PATHS%%::*}" )
		PROFILES_PATHS=${PROFILES_PATHS#*::}
	done
fi



if [ ${#PROFILES_ARRAY[@]} -eq 0 ]; then
	echo No Profiles found on $PROFILES_FILE;

else
	for i in "${PROFILES_ARRAY[@]}"
	do
		if [[ ! -z "$i" ]];
		then
			echo Installing Theme on $(sed 's/SPACECHARACTER/ /g' <<< $i) ;
			saveProfile "$(sed 's/SPACECHARACTER/ /g' <<< $i)"
		fi;
	
	done
fi
