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

case $1 in
	"install" )
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

	if [ -f /usr/bin/curl ];
	then
		curl --silent -L $tarball > $tmpfile
	else
		wget -q $tarball -O $tmpfile
	fi
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
			mv ./squallstar-bancha-*/* $installdir/* -f
		else
			mv ./squallstar-bancha-* $installdir -f
		fi

	fi
	rm $tmpfile
	rm ./squallstar-bancha-* -rf
	echo " done!"


	echo "-- Install procedure finished!"
	echo "-- Enjoy your new CMS!"

	#Install end
	;;

	"update" )

	if [ -d core ];
	then
		echo "-- Update procedure started..."

		echo -n "-- Downloading the latest version from GitHub... "

		if [ -f /usr/bin/curl ];
        	then
        		curl --silent -L $tarball > $tmpfile
        	else
        	        wget -q $tarball -O $tmpfile
	        fi

        	echo "done!"

		echo -n "-- Extracting data... "
		tar -xf $tmpfile
		echo "done!"

		if [ -d core ];
		then
			oldcore="._old.core"

			if [ -d $oldcore ];
			then
				rm $oldcore -rf
			fi

			mv core $oldcore
			echo "-- Core folder moved to $oldcore"
		fi
		echo -n "-- Replacing core folder... "
		mv ./squallstar-bancha-*/core ./core -f
		echo "done!"

		if [ -d themes ];
		then
			themesdir="themes/"
			oldtheme="._old.admin"

			if [ -d $themes$oldtheme ];
			then
				rm $themes$oldtheme -rf
			fi

			echo "-- Admin theme moved to themes/$oldtheme"
			mv themes/admin $themes$oldtheme
		else
			mkdir themes
		fi

		echo -n "-- Replacing admin theme... "
                mv ./squallstar-bancha-*/themes/admin ./themes/admin
                echo "done!"

		echo "-- Update finished!"

		rm $tmpfile -rf
		rm ./squallstar-bancha-* -rf

	else
		echo "-- Bancha has not been found in the current directory."
		echo "   Please use this script on the root of your Bancha installation"
		echo "   (where the core directory is located)"
	fi

	#Update end
	;;


	"upgrade" )

		echo "   Did you mean \"bancha update\" ?"
                echo
                exit 1
	;;


	"cache" )

	case $2 in
		"clear" )
		echo -n "-- Clearing cache..."

		rm ./application/cache/_bancha/*.tmp
		rm ./application/cache/_pages/*
		rm ./application/cache/_db/* -rf

		echo "done!"
		;;
	esac

	;;

	* )
	#Default
	echo "You did not select an operation. Available options:"
	echo "- install  (e.g. bancha install)"
	echo "- update   (e.g. bancha update)"
	echo "- cache    (e.g. bancha cache clear)"

esac
echo