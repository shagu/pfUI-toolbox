#!/bin/bash

locales="enUS koKR frFR deDE zhCN zhTW esES esMX ruRU"

for loc in $locales; do
  for file in out/tmp/*${loc}.lua; do
    echo >> out/locales_${loc}.lua
    cat $file >> out/locales_${loc}.lua
  done
done
