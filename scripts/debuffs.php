#!/usr/bin/php
<?php
ini_set('memory_limit', '-1');

$mysql = new mysqli("127.0.0.1", "mangos", "mangos", "mangos");
$mysql->set_charset("utf8");

$command = '
SELECT
aowow_spell.spellID as id,
aowow_spellduration.durationBase as duration,
aowow_spellicons.iconname as icon,
spellname_loc0 as name_enUS,
Spell_frFR.spellname as name_frFR,
Spell_koKR.spellname as name_koKR,
Spell_deDE.spellname as name_deDE,
Spell_ruRU.spellname as name_ruRU,
Spell_esES.spellname as name_esES,
Spell_zhCN.spellname as name_zhCN

FROM `aowow_spell`

INNER JOIN mangos.Spell_frFR ON ( mangos.Spell_frFR.spellID = aowow_spell.spellID )
INNER JOIN mangos.Spell_koKR ON ( mangos.Spell_koKR.spellID = aowow_spell.spellID )
INNER JOIN mangos.Spell_deDE ON ( mangos.Spell_deDE.spellID = aowow_spell.spellID )
INNER JOIN mangos.Spell_ruRU ON ( mangos.Spell_ruRU.spellID = aowow_spell.spellID )
INNER JOIN mangos.Spell_zhCN ON ( mangos.Spell_zhCN.spellID = aowow_spell.spellID )
INNER JOIN mangos.Spell_esES ON ( mangos.Spell_esES.spellID = aowow_spell.spellID )

INNER JOIN mangos.aowow_spellicons ON ( mangos.aowow_spellicons.id = aowow_spell.spellicon )
INNER JOIN mangos.aowow_spellduration ON ( mangos.aowow_spellduration.durationID = aowow_spell.durationID )


WHERE
	buff_loc0 != "" AND
    aowow_spell.durationID != 0 AND
    (
    effect1targetA =  6 or effect2targetA = 6 or  effect3targetA = 6 OR
    effect1targetA =  22 or effect2targetA = 22 or  effect3targetA = 22
    )

ORDER BY `rank_loc0` DESC
';

$query = $mysql->query($command);

$file = "out/tmp/debuffs_";

file_put_contents($file . "enUS" . ".lua", "pfUI_locale[\"enUS\"][\"debuffs\"] = {\n");
file_put_contents($file . "koKR" . ".lua", "pfUI_locale[\"koKR\"][\"debuffs\"] = {\n");
file_put_contents($file . "frFR" . ".lua", "pfUI_locale[\"frFR\"][\"debuffs\"] = {\n");
file_put_contents($file . "deDE" . ".lua", "pfUI_locale[\"deDE\"][\"debuffs\"] = {\n");
file_put_contents($file . "zhCN" . ".lua", "pfUI_locale[\"zhCN\"][\"debuffs\"] = {\n");
file_put_contents($file . "ruRU" . ".lua", "pfUI_locale[\"ruRU\"][\"debuffs\"] = {\n");
file_put_contents($file . "esES" . ".lua", "pfUI_locale[\"esES\"][\"debuffs\"] = {\n");


if(!empty($query)) {
  while($fetch = $query->fetch_array(MYSQLI_ASSOC)){
    $name0 = $fetch["name_enUS"];
    $name1 = $fetch["name_koKR"];
    $name2 = $fetch["name_frFR"];
    $name3 = $fetch["name_deDE"];
    $name4 = $fetch["name_zhCN"];
    $name6 = $fetch["name_esES"];
    $name8 = $fetch["name_ruRU"];
    $icon  = $fetch["icon"];
    $duration = $fetch["duration"] / 1000;

    if ( (!isset($saved[$name0])) &&
       ($name0 != "") &&
       (strpos($name0, 'OLD') === false) &&
       (strpos($name0, 'Test ') === false) &&
       (strpos($name0, 'Copy of') === false) ) {

      file_put_contents($file . "enUS" . ".lua", "  [\"" . $name0 . "\"] = $duration,\n", FILE_APPEND);
      file_put_contents($file . "koKR" . ".lua", "  [\"" . $name1 . "\"] = $duration,\n", FILE_APPEND);
      file_put_contents($file . "frFR" . ".lua", "  [\"" . $name2 . "\"] = $duration,\n", FILE_APPEND);
      file_put_contents($file . "deDE" . ".lua", "  [\"" . $name3 . "\"] = $duration,\n", FILE_APPEND);
      file_put_contents($file . "zhCN" . ".lua", "  [\"" . $name4 . "\"] = $duration,\n", FILE_APPEND);
      file_put_contents($file . "esES" . ".lua", "  [\"" . $name6 . "\"] = $duration,\n", FILE_APPEND);
      file_put_contents($file . "ruRU" . ".lua", "  [\"" . $name8 . "\"] = $duration,\n", FILE_APPEND);
    }
    $saved[$name0] = true;
  }
}

file_put_contents($file . "enUS" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "koKR" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "frFR" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "deDE" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "zhCN" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "esES" . ".lua", "}\n", FILE_APPEND);
file_put_contents($file . "ruRU" . ".lua", "}\n", FILE_APPEND);

?>
