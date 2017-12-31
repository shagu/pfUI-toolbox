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

  file="out/locales_${loc}.lua"

  # main-header
  echo "pfUI_locale[\"${loc}\"] = {}" > $file

  if [ -f "DBC/ChrClasses_${loc}.dbc.csv" ]; then
    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"class\"] = {" >> $file

    classes="WARLOCK WARRIOR HUNTER MAGE PRIEST DRUID PALADIN SHAMAN ROGUE"
    for class in $classes; do
      trans=$(grep $class DBC/ChrClasses_${loc}.dbc.csv | cut -d , -f $(expr $index + 6))
      echo "  [${trans}] = \"$class\"," >> $file
    done

    echo "}" >> $file
  fi


  if [ -f "DBC/ItemSubClass_${loc}.dbc.csv" ] && [ -f "DBC/ItemClass_${loc}.dbc.csv" ]; then
    quiver=$(grep "^11,2," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    soulbag=$(grep "^1,1," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    bag=$(grep "^1,0," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"bagtypes\"] = {" >> $file
    echo "  [$quiver] = \"QUIVER\"," >> $file
    echo "  [$soulbag] = \"SOULBAG\"," >> $file
    echo "  [$bag] = \"DEFAULT\"," >> $file
    echo "}" >> $file

    wand=$(grep "^2,19," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    thrown=$(grep "^2,16," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    gun=$(grep "^2,3," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    crossbow=$(grep "^2,18," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    #bullet=$(grep "^6,3," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    #arrow=$(grep "^6,2," DBC/ItemSubClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 11))
    projectile=$(grep "^6,6,0," DBC/ItemClass_${loc}.dbc.csv | cut -d , -f $(expr $index + 4))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"itemtypes\"] = {" >> $file
    echo "  [\"INVTYPE_WAND\"] = $wand," >> $file
    echo "  [\"INVTYPE_THROWN\"] = $thrown," >> $file
    echo "  [\"INVTYPE_GUN\"] = $gun," >> $file
    echo "  [\"INVTYPE_CROSSBOW\"] = $crossbow," >> $file
    echo "  [\"INVTYPE_PROJECTILE\"] = $projectile," >> $file
#    echo "  [\"INVTYPE_GUNPROJECTILE\"] = $bullet," >> $file
#    echo "  [\"INVTYPE_BOWPROJECTILE\"] = $arrow," >> $file
    echo "}" >> $file
  fi

  if [ -f "DBC/Spell_${loc}.dbc.csv" ]; then
    wing_clip=$(grep "^2974," DBC/Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))
    arcane_shot=$(grep "^3044," DBC/Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"hunterpaging\"] = {" >> $file
    echo "  [\"MELEE\"] = $wing_clip," >> $file
    echo "  [\"RANGED\"] = $arcane_shot," >> $file
    echo "}" >> $file


    aimed_shot=$(grep "^19434," DBC/Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))
    multi_shot=$(grep "^20735," DBC/Spell_${loc}.dbc.csv | cut -d , -f $(expr $index + 121))

    echo >> $file
    echo "pfUI_locale[\"${loc}\"][\"customcast\"] = {" >> $file
    echo "  [\"AIMEDSHOT\"] = $aimed_shot," >> $file
    echo "  [\"MULTISHOT\"] = $multi_shot," >> $file
    echo "}" >> $file
  fi

  index=$(expr $index + 1)
done
