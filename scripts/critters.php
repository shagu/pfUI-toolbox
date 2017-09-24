#!/usr/bin/php
<?php

ini_set('memory_limit', '-1');

$file = "out/tmp/critters_";
$mysql = new mysqli("127.0.0.1", "mangos", "mangos", "mangos");
if($mysql->connect_errno != 0){	echo "cant connect to database"; }
$mysql->set_charset("utf8");

$query = $mysql->query("
  SELECT name AS name_loc0, name_loc1, name_loc2, name_loc3, name_loc4, name_loc5, name_loc6, name_loc7, name_loc8 FROM creature_template

  INNER JOIN locales_creature ON ( locales_creature.entry = creature_template.entry )

  WHERE type = 8 ORDER BY name_loc0"
);

file_put_contents($file . "enGB" . ".lua", "pfUI_locale[\"enGB\"][\"critters\"] = {\n");
file_put_contents($file . "koKR" . ".lua", "pfUI_locale[\"koKR\"][\"critters\"] = {\n");
file_put_contents($file . "frFR" . ".lua", "pfUI_locale[\"frFR\"][\"critters\"] = {\n");
file_put_contents($file . "deDE" . ".lua", "pfUI_locale[\"deDE\"][\"critters\"] = {\n");
file_put_contents($file . "zhCN" . ".lua", "pfUI_locale[\"zhCN\"][\"critters\"] = {\n");
file_put_contents($file . "esES" . ".lua", "pfUI_locale[\"esES\"][\"critters\"] = {\n");
file_put_contents($file . "ruRU" . ".lua", "pfUI_locale[\"ruRU\"][\"critters\"] = {\n");

while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
    // fetch names
    $name_loc0 = $fetch["name_loc0"]; // enGB
    $name_loc1 = $fetch["name_loc1"]; // koKR
    $name_loc2 = $fetch["name_loc2"]; // frFR
    $name_loc3 = $fetch["name_loc3"]; // deDE
    $name_loc4 = $fetch["name_loc4"]; // zhCN
    $name_loc6 = $fetch["name_loc6"]; // esES
    $name_loc8 = $fetch["name_loc8"]; // ruRU

    $name_loc0 = str_replace("'", "\'", $name_loc0);
    $name_loc1 = str_replace("'", "\'", $name_loc1);
    $name_loc2 = str_replace("'", "\'", $name_loc2);
    $name_loc3 = str_replace("'", "\'", $name_loc3);
    $name_loc4 = str_replace("'", "\'", $name_loc4);
    $name_loc6 = str_replace("'", "\'", $name_loc6);
    $name_loc8 = str_replace("'", "\'", $name_loc8);

    file_put_contents($file . "enGB" . ".lua", "  '$name_loc0',\n", FILE_APPEND);
    file_put_contents($file . "koKR" . ".lua", "  '$name_loc1',\n", FILE_APPEND);
    file_put_contents($file . "frFR" . ".lua", "  '$name_loc2',\n", FILE_APPEND);
    file_put_contents($file . "deDE" . ".lua", "  '$name_loc3',\n", FILE_APPEND);
    file_put_contents($file . "zhCN" . ".lua", "  '$name_loc4',\n", FILE_APPEND);
    file_put_contents($file . "esES" . ".lua", "  '$name_loc6',\n", FILE_APPEND);
    file_put_contents($file . "ruRU" . ".lua", "  '$name_loc8',\n", FILE_APPEND);
}

// finalize
file_put_contents($file . "enGB" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "koKR" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "frFR" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "deDE" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "zhCN" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "esES" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "ruRU" . ".lua", "}\n", FILE_APPEND);
?>
