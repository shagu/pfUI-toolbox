#!/bin/bash

file=$1

before="  ["
after="] = true,"
locales="enUS deDE frFR koKR ruRU zhCN esES"

function SearchTranslation () {
  spell=$1
  id=$(grep ",\"$spell\"," Spell_enUS.dbc.csv | cut -d , -f 1 | head -n 1)

  for locale in $locales; do
    case "$locale" in
      "enUS")
        echo "  ${before}$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 2)${after}" >> interrupts_${locale}.lua
      ;;
      "koKR")
        echo "  ${before}$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 3)${after}" >> interrupts_${locale}.lua
      ;;
      "frFR")
        echo "  ${before}$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 4)${after}" >> interrupts_${locale}.lua
      ;;
      "deDE")
        echo "  ${before}$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 5)${after}" >> interrupts_${locale}.lua
      ;;
      "zhCN")
        echo "  ${before}$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 6)${after}" >> interrupts_${locale}.lua
      ;;
      "esES")
        echo "  ${before}$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 8)${after}" >> interrupts_${locale}.lua
      ;;
      "ruRU")
        echo "  ${before}$(cut -d , -f 1,121-130 Spell_${locale}.dbc.csv | grep "^$id," | cut -d , -f 2)${after}" >> interrupts_${locale}.lua
      ;;
    esac
  done
}

for locale in $locales; do
  echo "pfUI_locale[\"$locale\"][\"interrupts\"] = {" > interrupts_${locale}.lua
done

cat $file | while read -r line; do
  SearchTranslation "$line"
done

for locale in $locales; do
  echo "}" >> interrupts_${locale}.lua
done
