#!/bin/bash

# Imports/Updates EvE database tables
# The script must be run from the directory containing the sql or sql.bz2 files.

TABLES="
invBlueprintTypes
invCategories
invGroups
invMarketGroups
invMetaGroups
invMetaTypes
invTypeMaterials
invTypes
ramTypeRequirements
"

for T in $TABLES ; do
# Locate the SQL file for the table
	if FILE=`ls *$T*.sql 2>&1` ; then
		echo -n
	else
# If no SQL file is found, is there a compressed SQL file?
		if FILE=`ls *$T*.bz2 2>&1` ; then
			echo Extracting $FILE
			bunzip2 $FILE
			FILE=`ls *$T*.sql 2>&1`
		fi
  fi
	if [ -f $FILE ] ; then
		echo Importing $FILE
		mysql5 -u root --password=password tritanium_apple < $FILE
	else
		echo Could Not Locate File for Table $T
	fi
done
