#!/bin/bash

file=lists/$1
basename=$(basename $1 .txt)

locales="enUS koKR frFR deDE zhCN zhTW esES esMX ruRU"

before="  ["
after="] = true,"

function SearchTranslation () {
  spell=$1
  id=$(grep ",\"$spell\"," DBC/Spell_enUS.dbc.csv | cut -d , -f 1 | head -n 1)

  index=0
  for loc in $locales; do

    # fix for custom ruRU clients
    if [ "$loc" = "ruRU" ]; then index=0; fi

    if [ -f DBC/Spell_${loc}.dbc.csv ]; then
      echo "  ${before}$(cut -d , -f 1,121-130 DBC/Spell_${loc}.dbc.csv | grep "^$id," | cut -d , -f $(expr $index + 2))${after}" >> out/tmp/${basename}_${loc}.lua
    fi

    index=$(expr $index + 1)
  done
}

for loc in $locales; do
  echo "pfUI_locale[\"$loc\"][\"interrupts\"] = {" > out/tmp/${basename}_${loc}.lua
done

cat $file | while read -r line; do
  SearchTranslation "$line"
done

for loc in $locales; do
  echo "}" >> out/tmp/${basename}_${loc}.lua
done
