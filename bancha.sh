#!/bin/bash
# --------------------------------------------------
# Bancha Shell Utilities
# A simple bash script that performs many operations
#
# @author     Nicholas Valbusa - info@squallstar.it
# @copyright  Squallstar Studio 2011-2012(C)
#
# Usage:
# bancha install      # Bancha fresh install
# bancha update       # Core update
# bancha cache clear  # Clears the website cache
#
# --------------------------------------------------

echo

#Download url
tarball="https://github.com/squallstar/bancha/tarball/master"

#Tmp file
tmpfile=bnc_tmp-installer.zip

#Log file
logfile="./bancha-bash.log"

#Downloads the latest version from GitHub
get_tarball() {
	if [ -f /usr/bin/curl ];
	then
		curl --silent -L $tarball > $tmpfile
	else
		wget -q $tarball -O $tmpfile
	fi
}

#Cache app paths
get_apppaths() {

	if [ -f index.php ];
	then
		conf=".bnc_conf.php"

		cp index.php $conf
		sed -i 's/require/#require_once/g' $conf

		echo >> $conf

		#1. Core path
		echo "echo APPPATH;" >> $conf
		corepath=$(/usr/bin/php $conf)
		sed -i '$d' $conf

		#2. Themes path
		echo "echo THEMESPATH;" >> $conf
		themespath=$(/usr/bin/php $conf)
		sed -i '$d' $conf

		#3. App path
		echo "echo USERPATH;" >> $conf
		userpath=$(/usr/bin/php $conf)

		rm $conf
	else
		echo "-- Bancha has not been found in the current directory."
		echo "   Please use this script on the public root of your Bancha installation"
		echo "   (where the index.php file is located)"
		exit 1;
	fi
}

case $1 in
	"install" )
	touch $logfile

	#Install procedure

	if [ -f index.php ];
        then
                echo "-- WARNING!!! Bancha is already installed in this location."
		echo "   Did you mean \"bancha update\" ?"
		echo
		exit 1
	fi

	echo "-- Please choose the path where you want to install Bancha."
	echo "   Leave blank to install in current directory."
	echo -n "   > Install dir: "
	read installdir

	echo -n "-- Downloading the latest version from GitHub... "
	get_tarball
	echo "done!"

	echo -n "-- Extracting "

	LEN=$(echo ${#installdir})
	if [ $LEN -lt 1 ];
	then
		echo -n "here..."
		tar -xf $tmpfile
		mv ./squallstar-bancha-*/* ./ -f
	else
		echo -n "to $installdir..."
		tar -xf $tmpfile
		if [ -d $installdir ];
		then
			mv -f ./squallstar-bancha-*/* $installdir/*
		else
			mv -f ./squallstar-bancha-* $installdir
		fi

	fi
	rm $tmpfile
	rm -rf ./squallstar-bancha-*
	echo " done!"


	echo "-- Install procedure finished!"
	echo "-- Enjoy your new CMS!"

	#Install end
	;;

	"update" )
	touch $logfile

	get_apppaths

	echo "-- Update procedure started..."

	echo -n "-- Downloading the latest version from GitHub... "
	get_tarball
	echo "done!"

	echo -n "-- Extracting data... "
	tar -xf $tmpfile
	echo "done!"

	if [ -d $corepath ];
	then
		oldcore="._old.core"

		if [ -d $oldcore ];
		then
			rm "$oldcore" -rf
		fi

		mv "$corepath" "$oldcore"
		echo "-- Core folder moved to $oldcore"
	fi
	echo -n "-- Replacing core folder... "
	mv ./squallstar-bancha-*/core "$corepath" -f
	echo "done!"

	if [ -d $themespath ];
	then
		oldtheme="._old.theme-admin"

		if [ -d "$themespath$oldtheme" ];
		then
			rm "$themespath$oldtheme" -rf
		fi

		echo "-- Admin theme moved to $themespath$oldtheme"
		mv "$themespath/admin" "$themespath$oldtheme"
	else
		mkdir $themespath
	fi

	echo -n "-- Replacing admin theme... "
			admintheme="admin"
            mv ./squallstar-bancha-*/themes/admin "$themespath$admintheme"
            echo "done!"

	echo "-- Update finished!"
	echo "[" `date` "] Update finished." >> $logfile

	rm "$tmpfile" -rf
	rm ./squallstar-bancha-* -rf

	#Update end
	;;


	"upgrade" )

		echo "   Did you mean \"bancha update\" ?"
                echo
                exit 1
	;;


	"clear" )

	case $2 in
		"cache" )
		touch $logfile
		echo -n "-- Clearing cache..."

		get_apppaths

		cachetmp_files="cache/_bancha/"
		cachetmp_pages="cache/_pages/"
		cachetmp_db="cache/_db/"

		#1. Files
		rm "$userpath$cachetmp_files" -rf
		mkdir "$userpath$cachetmp_files"

		#2. Pages
		rm "$userpath$cachetmp_pages" -rf
		mkdir "$userpath$cachetmp_pages"

		#3. DB queries
		rm "$userpath$cachetmp_db" -rf
		mkdir "$userpath$cachetmp_db"

		echo "done!"

		echo "[" `date` "] Cache cleared." >> $logfile

		;;


		"presets" )

		touch $logfile
        echo -n "-- Clearing cached presets..."

		cached_presets="./attach/cache"
		rm "$cached_presets" -rf
		mkdir "$cached_presets"
		touch "$cached_presets/index.html"

		echo "done!"

		echo "[" `date` "] Presets cache cleared." >> $logfile

		;;

		* )
		#Cache default
		echo "You need to select a clear operation."
		echo
		echo "- Clear admin/website cache:      'bancha clear cache'"
		echo "- Clear image/presets cache:      'bancha clear presets'"
		;;

	esac

	;;

	* )
	#Default
	echo "Usage: bancha [OPERATION]"
	echo
	echo "You did not select an operation. Available options:"
	echo "- install  (e.g. bancha install)"
	echo "- update   (e.g. bancha update)"
	echo "- cache    (e.g. bancha clear cache|presets)"

esac
echo
