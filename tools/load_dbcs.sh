#!/bin/bash

# Available game locales
LOCALES="enUS koKR frFR deDE zhCN zhTW esES esMX ruRU"

# PATH_MPQ contains folders for each language (eg. enUS, deDE, ..).
# Each language folder contains the corresponding dbc.MPQ and patch-*.MPQ.
PATH_MPQ="$HOME/games/files/wow/1.12.1/patches"
PATH_OUTPUT="DBC"

# Required DBCs are:
# pfUI:
#   ChrClasses.dbc
#   ItemSubClass.dbc
#   ItemClass.dbc
#   Spell.dbc
#
# pfQuest:
#   AreaTable.dbc
#   WorldMapArea.dbc
#
LIST_DBC=" \
  DBFilesClient\ChrClasses.dbc \
  DBFilesClient\ItemSubClass.dbc \
  DBFilesClient\ItemClass.dbc \
  DBFilesClient\Spell.dbc \
  DBFilesClient\AreaTable.dbc \
  DBFilesClient\WorldMapArea.dbc \
"

rm -rf $PATH_OUTPUT && mkdir $PATH_OUTPUT

for loc in $LOCALES; do
  if [ -d ${PATH_MPQ}/${loc} ]; then

    echo ":: Building $loc"
    rm -rf $loc && mkdir $loc

    for dbc in $LIST_DBC; do
      echo "   - $dbc"

      MPQExtractor \
        -p ${PATH_MPQ}/${loc}/patch.MPQ ${PATH_MPQ}/${loc}/patch-1.MPQ ${PATH_MPQ}/${loc}/patch-2.MPQ ${PATH_MPQ}/${loc}/patch-3.MPQ \
        -e "$dbc" \
        -o $loc \
        "${PATH_MPQ}/${loc}/dbc.MPQ"
    done

    echo ":: Moving results to $PATH_OUTPUT"
    for file in $loc/*; do
      mv $file $PATH_OUTPUT/$(basename $file .dbc)_$loc.dbc
    done

    rmdir $loc
  else
    echo ":: Skipping $loc"
  fi
  echo
done
