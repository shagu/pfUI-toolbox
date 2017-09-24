#!/usr/bin/php
<?php

ini_set('memory_limit', '-1');

$count = 0;
$mysql = new mysqli("127.0.0.1", "mangos", "mangos", "mangos");
if($mysql->connect_errno != 0){	echo "cant connect to database"; }
$mysql->set_charset("utf8");

$lname = null;
$count = 1;
$zcount = array();

$qSpells = '
SELECT
aowow_spell.spellID, aowow_spell.effect1id, base, spellname_loc0, iconname, rank_loc0,
Spell_frFR.spellName AS frFR, Spell_deDE.spellName AS deDE, Spell_zhCN.spellName AS zhCN, Spell_esES.spellName AS esES, Spell_ruRU.spellName AS ruRU, Spell_koKR.spellName AS koKR

FROM `aowow_spell`

LEFT JOIN aowow_spellcasttimes ON aowow_spell.spellcasttimesID = aowow_spellcasttimes.id
LEFT JOIN aowow_spellicons ON aowow_spell.spellicon = aowow_spellicons.id
LEFT JOIN Spell_frFR ON aowow_spell.spellID = Spell_frFR.spellID
LEFT JOIN Spell_deDE ON aowow_spell.spellID = Spell_deDE.spellID
LEFT JOIN Spell_zhCN ON aowow_spell.spellID = Spell_zhCN.spellID
LEFT JOIN Spell_ruRU ON aowow_spell.spellID = Spell_ruRU.spellID
LEFT JOIN Spell_koKR ON aowow_spell.spellID = Spell_koKR.spellID
LEFT JOIN Spell_esES ON aowow_spell.spellID = Spell_esES.spellID

WHERE aowow_spellcasttimes.base > 0

/* 24 create, 36 learn, 53 enchant */
AND aowow_spell.effect1id != "24"
AND aowow_spell.effect1id != "36"
AND aowow_spell.effect1id != "53"

/* dummy */
AND aowow_spell.spellname_loc0 != "Attack"
AND aowow_spell.spellname_loc0 != "Attacking"
AND aowow_spell.spellname_loc0 NOT LIKE \'%TEST%\'
AND aowow_spell.spellname_loc0 NOT LIKE \'%OLD%\'

ORDER BY spellname_loc0, rank_loc0 DESC
';

$file_enUS = "out/tmp/spells_enUS.lua";
$file_frFR = "out/tmp/spells_frFR.lua";
$file_deDE = "out/tmp/spells_deDE.lua";
$file_zhCN = "out/tmp/spells_zhCN.lua";
$file_ruRU = "out/tmp/spells_ruRU.lua";
$file_koKR = "out/tmp/spells_koKR.lua";
$file_esES = "out/tmp/spells_esES.lua";

file_put_contents($file_enUS, "pfUI_locale[\"enUS\"][\"spells\"] = {\n");
file_put_contents($file_frFR, "pfUI_locale[\"frFR\"][\"spells\"] = {\n");
file_put_contents($file_deDE, "pfUI_locale[\"deDE\"][\"spells\"] = {\n");
file_put_contents($file_zhCN, "pfUI_locale[\"zhCN\"][\"spells\"] = {\n");
file_put_contents($file_ruRU, "pfUI_locale[\"ruRU\"][\"spells\"] = {\n");
file_put_contents($file_koKR, "pfUI_locale[\"koKR\"][\"spells\"] = {\n");
file_put_contents($file_esES, "pfUI_locale[\"esES\"][\"spells\"] = {\n");

$old_name_loc0 = "";

$spell_query = $mysql->query($qSpells);
while($spell_fetch = $spell_query->fetch_array(MYSQLI_ASSOC)){
  $id         = $spell_fetch["spellID"];
  $cast       = $spell_fetch["base"];
  $name_loc0  = $spell_fetch["spellname_loc0"];
  $name_frFR  = $spell_fetch["frFR"];
  $name_deDE  = $spell_fetch["deDE"];
  $name_zhCN  = $spell_fetch["zhCN"];
  $name_ruRU  = $spell_fetch["ruRU"];
  $name_koKR  = $spell_fetch["koKR"];
  $name_esES  = $spell_fetch["esES"];
  $icon       = $spell_fetch["iconname"];

  $icon       = str_replace("\r", "", $icon);

  $name_loc0       = str_replace("'", "\'", $name_loc0);
  $name_frFR       = str_replace("'", "\'", $name_frFR);
  $name_deDE       = str_replace("'", "\'", $name_deDE);
  $name_zhCN       = str_replace("'", "\'", $name_zhCN);
  $name_ruRU       = str_replace("'", "\'", $name_ruRU);
  $name_koKR       = str_replace("'", "\'", $name_koKR);
  $name_esES       = str_replace("'", "\'", $name_esES);

  if ($name_loc0 != $old_name_loc0) {
   file_put_contents($file_enUS, "  ['$name_loc0'] = {t=$cast, icon=\"$icon\" },\n", FILE_APPEND);
   file_put_contents($file_frFR, "  ['$name_frFR'] = {t=$cast, icon=\"$icon\" },\n", FILE_APPEND);
   file_put_contents($file_deDE, "  ['$name_deDE'] = {t=$cast, icon=\"$icon\" },\n", FILE_APPEND);
   file_put_contents($file_zhCN, "  ['$name_zhCN'] = {t=$cast, icon=\"$icon\" },\n", FILE_APPEND);
   file_put_contents($file_ruRU, "  ['$name_ruRU'] = {t=$cast, icon=\"$icon\" },\n", FILE_APPEND);
   file_put_contents($file_koKR, "  ['$name_koKR'] = {t=$cast, icon=\"$icon\" },\n", FILE_APPEND);
   file_put_contents($file_esES, "  ['$name_esES'] = {t=$cast, icon=\"$icon\" },\n", FILE_APPEND);
   $old_name_loc0 = $name_loc0;
  }
}

file_put_contents($file_enUS, "}\n", FILE_APPEND);
file_put_contents($file_frFR, "}\n", FILE_APPEND);
file_put_contents($file_deDE, "}\n", FILE_APPEND);
file_put_contents($file_zhCN, "}\n", FILE_APPEND);
file_put_contents($file_ruRU, "}\n", FILE_APPEND);
file_put_contents($file_koKR, "}\n", FILE_APPEND);
file_put_contents($file_esES, "}\n", FILE_APPEND);

?>
