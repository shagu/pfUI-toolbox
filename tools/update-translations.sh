#!/bin/bash
for locale in "deDE" "enUS" "frFR" "koKR" "ruRU" "zhCN" "zhTW" "esES"; do
  file=env/translations_$locale.lua
  file_new=env/translations_$locale.lua_new

  echo "pfUI_translation[\"$locale\"] = {" | tee $file_new

  cat modules/*.lua | sed 's/T\[/\nT\[/g' | grep "T\[" | sed 's/.*T\["\(.*\)"\].*/\1/' | while read -r entry; do
    old=$(grep -F "\"$entry\"" $file 2> /dev/null)
    if [ -z "$old" ] ; then
      old="  [\"$entry\"] = nil,"
    fi
    echo "$old"
  done | sort | uniq | tee -a $file_new
  echo "}" | tee -a $file_new

  mv $file_new $file
done
