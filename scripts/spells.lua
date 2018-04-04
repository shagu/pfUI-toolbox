#!/usr/bin/lua
-- depends on luasql

do -- database connection
  luasql = require("luasql.mysql").mysql()
  mysql = luasql:connect("mangos","mangos","mangos","127.0.0.1")
end

do -- nice progress display
  progress = {}
  progress.cache = {}
  progress.lastmsg = ""

  function progress:InitTable(sqltable)
    local ret = {}
    local query = mysql:execute('SELECT COUNT(*) FROM ' .. sqltable)
    while query:fetch(ret, "a") do
      self.cache[sqltable] = { 1, ret['COUNT(*)'] }
      return true
    end
  end

  function progress:Print(sqltable, msg)
    if not self.cache[sqltable] or msg ~= self.lastmsg then
      self:InitTable(sqltable)
      self.lastmsg = msg
    end

    local cur, max = unpack(self.cache[sqltable])
    local perc = cur / max * 100

    io.write("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b")
    io.write(string.format("%.1f%%\t",perc, cur, max) .. msg .. "\t[" .. cur .. "/" .. max .. "]")
    io.flush()

    self.cache[sqltable][1] = self.cache[sqltable][1] + 1
  end
end

local locales = { "enUS", "frFR", "koKR", "deDE", "ruRU", "esES", "zhCN" }

local results = {
  learnable = {},
  spell = {},
  debuff = {},
}

local playerspells = {}
local spells = {}
local debuffs = {}

for _, loc in pairs(locales) do
  spells[loc] = {}
  debuffs[loc] = {}
end

local function querySpell(id)
  return [[
  SELECT
    aowow_spell.spellID as id,
    aowow_spellduration.durationBase as duration,
    aowow_spellcasttimes.base as casttime,
    aowow_spellicons.iconname as icon,
    rank_loc0 as rank,
    spellname_loc0 as name_enUS,
    Spell_frFR.spellname as name_frFR,
    Spell_koKR.spellname as name_koKR,
    Spell_deDE.spellname as name_deDE,
    Spell_ruRU.spellname as name_ruRU,
    Spell_esES.spellname as name_esES,
    Spell_zhCN.spellname as name_zhCN,
    effect1targetA as dtype1, -- 6 or 22 if debuff
    effect2targetA as dtype2, -- 6 or 22 if debuff
    effect3targetA as dtype3, -- 6 or 22 if debuff
    effect1id as spelltype -- 24 create, 36 learn, 53 enchant

    FROM `aowow_spell`

    INNER JOIN mangos.Spell_frFR ON ( mangos.Spell_frFR.spellID = aowow_spell.spellID )
    INNER JOIN mangos.Spell_koKR ON ( mangos.Spell_koKR.spellID = aowow_spell.spellID )
    INNER JOIN mangos.Spell_deDE ON ( mangos.Spell_deDE.spellID = aowow_spell.spellID )
    INNER JOIN mangos.Spell_ruRU ON ( mangos.Spell_ruRU.spellID = aowow_spell.spellID )
    INNER JOIN mangos.Spell_zhCN ON ( mangos.Spell_zhCN.spellID = aowow_spell.spellID )
    INNER JOIN mangos.Spell_esES ON ( mangos.Spell_esES.spellID = aowow_spell.spellID )

    INNER JOIN mangos.aowow_spellicons 		ON ( aowow_spell.spellicon 				= mangos.aowow_spellicons.id )
    LEFT JOIN mangos.aowow_spellduration 	ON ( aowow_spell.durationID 			= mangos.aowow_spellduration.durationID )
    LEFT JOIN mangos.aowow_spellcasttimes ON ( aowow_spell.spellcasttimesID = mangos.aowow_spellcasttimes.id )

    WHERE
    	aowow_spell.spellID = ]] .. id
end

local function FillTables(results, pspell)
  if results.name_enUS and
    results.name_enUS ~= "Attack" and
    results.name_enUS ~= "Attacking" and
    results.spelltype ~= "24" and -- create
    results.spelltype ~= "36" and -- learn
    results.spelltype ~= "53" and -- enchant
    not string.find(results.name_enUS, "TEST") and
    not string.find(results.name_enUS, "OLD") and
    not string.find(results.name_enUS, "Copy of")
  then
    results.rank = tonumber(string.sub(results.rank,6)) or 0
    results.casttime = tonumber(results.casttime) or 0
    results.duration = tonumber(results.duration) or 0
    results.icon = string.gsub(results.icon,"\r","") -- *sigh*
    results.name_enUS = string.gsub(results.name_enUS, "\'", "\\'")

    -- create castbars
    if results.casttime > 0 then
      if not spells["enUS"][results.name_enUS] or ( spells["enUS"][results.name_enUS].rank < results.rank and pspell ) then
        for _, loc in pairs(locales) do
          local name = results[_G["name_" .. loc]] or results["name_enUS"]
          name = string.gsub(name, "\'", "\\'")

          spells[loc][name] = {
            cast = results.casttime,
            rank = results.rank,
            icon = results.icon,
          }
        end
      end
    end

    if ( results.dtype1 == "6" or results.dtype1 == "22" or
      results.dtype2 == "6" or results.dtype2 == "22" or
      results.dtype3 == "6" or  results.dtype3 == "22") and
      results.duration > 0
    then
      if not pspell and debuffs["enUS"][results.name_enUS] then
        -- won't add further npc ranks
      else
        -- add debuff entry
        for _, loc in pairs(locales) do
          local name = results[_G["name_" .. loc]] or results["name_enUS"]
          name = string.gsub(name, "\'", "\\'")

          debuffs[loc][name] = debuffs[loc][name] or {}
          debuffs[loc][name][results.rank] = debuffs[loc][name][results.rank] or {}
          debuffs[loc][name][results.rank] = {
            duration = results.duration,
            combo = results.name_enUS == "Rupture" and 2 or results.name_enUS == "Kidney Shot" and 1 or nil
          }
        end
      end
    end
  end
end

-- fetch player learnables first (PvE > PvE)
local query = mysql:execute([[SELECT aowow_spell.effect1triggerspell FROM aowow_spell WHERE aowow_spell.effect1id = "36"]])
while query:fetch(results.learnable, "a") do
  playerspells[results.learnable.effect1triggerspell] = true
end

local query = mysql:execute([[ SELECT spellID FROM aowow_spell WHERE effect1id != "24" AND effect1id != "36" AND effect1id != "53"]])
while query:fetch(results.learnable, "a") do
  local playerspells = mysql:execute(querySpell(results.learnable.spellID))
  while playerspells:fetch(results.spell, "a") do
    progress:Print([[aowow_spell WHERE effect1id != "24" AND effect1id != "36" AND effect1id != "53"]], "spells")
    FillTables(results.spell, playerspells[results.learnable.spellID])
  end
end

-- write files
for _, loc in pairs(locales) do
  local file = io.open("out/tmp/spells_" .. loc .. ".lua", "w")

  -- write spells
  file:write("pfUI_locale[\"" .. loc .. "\"][\"spells\"] = {\n")
  for name, data in pairs(spells[loc]) do
    file:write("  ['" .. name .. "']={t=" .. data.cast .. ",icon='" .. tostring(data.icon) .. "'},\n")
  end
  file:write("}\n")

  -- write debuffs
  file:write("\npfUI_locale[\"" .. loc .. "\"][\"debuffs\"] = {\n")
  for name, rtbl in pairs(debuffs[loc]) do
    local combo = nil
    file:write("  ['" .. name .. "']={r={")

    -- merge durations if possible
    local duration
    if rtbl[1] then
      duration = rtbl[1].duration
    end

    for rank, data in pairs(rtbl) do
      if data.duration ~= duration then
        duration = "NOMERGE"
      end
      if data.combo then combo = data.combo end
    end

    if duration == "NOMERGE" then
      for rank, data in pairs(rtbl) do
        file:write("["..rank.."]="..data.duration..",")
      end
    else
      file:write("[0]="..duration..",")
    end

    file:write("}" .. ( combo and (",c=" .. combo) or "") .. ",},\n")
  end
  file:write("}\n")

  file:close()
end
