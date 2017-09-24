#!/bin/bash

# 0	enUS 	English
# 1	koKR	Korean
# 2	frFR	French
# 3	deDE	German
# 4	zhCN	Chinese
# 5	zhTW	Taiwan
# 6	esES	Spanish (Spain)
# 7	esMX	Spanish (Mexican)
# 8	ruRU	Russian (not existing, fallback index: 0)

locales="enUS koKR frFR deDE zhCN zhTW esES esMX ruRU"

index=0
for loc in $locales; do

  # fix for custom ruRU clients
  if [ "$loc" = "ruRU" ]; then index=0; fi

  file="../out/locales_${loc}.lua"
  echo "building ${file}..."

  # main-header
  echo "pfUI_locale[\"${loc}\"] = {}" > $file
  
  # classes
  if [ -f "ChrClasses_${loc}.dbc.csv" ]; then
    classes="WARLOCK WARRIOR HUNTER MAGE PRIEST DRUID PALADIN SHAMAN ROGUE"

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"class\"] = {" >> $file

    for class in $classes; do
      trans=$(grep $class ChrClasses_${loc}.dbc.csv | cut -d , -f $(expr $index + 6))
      echo "  [${trans}] = \"$class\"," >> $file
    done

    echo "}" >> $file
  fi

  # bagtypes
  if [ -f "ItemSubClass_${loc}.dbc.csv" ]; then
    quiver=$(grep "^11,2," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    soulbag=$(grep "^1,1," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    bag=$(grep "^1,0," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"bagtypes\"] = {" >> $file
    echo "  [$quiver] = \"QUIVER\"," >> $file
    echo "  [$soulbag] = \"SOULBAG\"," >> $file
    echo "  [$bag] = \"DEFAULT\"," >> $file
    echo "}" >> $file   
  fi

  # itemsubclass
  if [ -f "ItemSubClass_${loc}.dbc.csv" ]; then
    wand=$(grep "^2,19," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    thrown=$(grep "^2,16," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    gun=$(grep "^2,3," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    crossbow=$(grep "^2,18," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    bullet=$(grep "^6,3," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    arrow=$(grep "^6,2," ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"itemtypes\"] = {" >> $file
    echo "  [\"INVTYPE_WAND\"] = $wand," >> $file
    echo "  [\"INVTYPE_THROWN\"] = $thrown," >> $file
    echo "  [\"INVTYPE_GUN\"] = $gun," >> $file
    echo "  [\"INVTYPE_CROSSBOW\"] = $crossbow," >> $file
    echo "  [\"INVTYPE_GUNPROJECTILE\"] = $bullet," >> $file
    echo "  [\"INVTYPE_BOWPROJECTILE\"] = $arrow," >> $file
    echo "}" >> $file
  fi

  if [ -f "Spell_${loc}.dbc.csv" ]; then
    holy_light=$(grep "^3472," Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))
    flash_heal=$(grep "^2061," Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))
    healing_touch=$(grep "^3735," Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))
    healing_wave=$(grep "^331," Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"rangecheck\"] = {" >> $file
    echo "  [\"PALADIN\"] = $holy_light," >> $file
    echo "  [\"PRIEST\"] = $flash_heal," >> $file
    echo "  [\"DRUID\"] = $healing_touch," >> $file
    echo "  [\"SHAMAN\"] = $healing_wave," >> $file
    echo "}" >> $file


    wing_clip=$(grep "^2974," Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))
    arcane_shot=$(grep "^3044," Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"hunterpaging\"] = {" >> $file
    echo "  [\"MELEE\"] = $wing_clip," >> $file
    echo "  [\"RANGED\"] = $arcane_shot," >> $file
    echo "}" >> $file


    aimed_shot=$(grep "^19434," Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))
    multi_shot=$(grep "^20735," Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"customcast\"] = {" >> $file
    echo "  [\"AIMEDSHOT\"] = $aimed_shot," >> $file
    echo "  [\"MULTISHOT\"] = $multi_shot," >> $file
    echo "}" >> $file
  fi

  index=$(expr $index + 1)
done
