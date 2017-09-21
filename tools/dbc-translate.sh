#!/bin/bash

function SearchTranslation () {
  id=$(grep "\"$spell\"" Spell_enUS.dbc.csv | cut -d , -f 1 | head -n 1)

  echo "============================================="
  echo -e " $1 ($id)"
  echo "============================================="

  for locale in enUS deDE frFR koKR ruRU zhCN; do
    case "$locale" in
      "enUS")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 2)"
      ;;
      "deDE")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 5)"
      ;;
      "frFR")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 4)"
      ;;
      "koKR")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 3)"
      ;;
      "ruRU")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 2)"
      ;;
      "zhCN")
        echo -e "$locale:\t$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 6)"
      ;;
    esac
  done
}

if [ "$1" = "-r" ]; then
  while true; do
    echo -n "Search: "
    read spell
    echo
    SearchTranslation "$spell"
    echo
    echo
  done
else
  spell=$1
  SearchTranslation "$spell"
fi
