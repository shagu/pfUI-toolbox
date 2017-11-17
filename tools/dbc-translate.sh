#!/bin/bash

function SearchTranslation () {
  id=$(grep "\"$spell\"" Spell_enUS.dbc.csv | cut -d , -f 1 | head -n 1)

  echo "============================================="
  echo -e " $1 ($id)"
  echo "============================================="

  for locale in enUS koKR frFR deDE zhCN esES ruRU; do
    case "$locale" in
      "enUS")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 2)"
      ;;
      "koKR")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 3)"
      ;;
      "frFR")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 4)"
      ;;
      "deDE")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 5)"
      ;;
      "zhCN")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 6)"
      ;;
      "esES")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 8)"
      ;;
      "ruRU")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 2)"
      ;;
    esac
  done
}

function BrowseTranslation () {
  grep "$spell" Spell_enUS.dbc.csv | cut -d , -f 1 | while read id; do
    echo "============================================="
    echo -e " $(cut -d , -f 1,121-130 Spell_enUS.dbc.csv | grep "^$id," | cut -d , -f 2) ($id)"
    echo "============================================="

    for locale in enUS koKR frFR deDE zhCN esES ruRU; do
      case "$locale" in
        "enUS")
          echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 2)"
        ;;
        "koKR")
          echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 3)"
        ;;
        "frFR")
          echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 4)"
        ;;
        "deDE")
          echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 5)"
        ;;
        "zhCN")
          echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 6)"
        ;;
        "esES")
          echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 8)"
        ;;
        "ruRU")
          echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 2)"
        ;;
      esac
    done
  done
}




if [ "$1" = "-r" ]; then
  while true; do
    echo -n "Search: "
    read spell
    echo
    BrowseTranslation "$spell"
    echo
    echo
  done
else
  spell=$1
  SearchTranslation "$spell"
fi
