#!/bin/env lua
-- http://lua-users.org/wiki/SortedIteration
function __genOrderedIndex( t )
  local orderedIndex = {}
  for key in pairs(t) do
    table.insert( orderedIndex, key )
  end
  table.sort( orderedIndex )
  return orderedIndex
end

function orderedNext(t, state)
  local key = nil
  if state == nil then
    t.__orderedIndex = __genOrderedIndex( t )
    key = t.__orderedIndex[1]
  else
    for i = 1,#t.__orderedIndex do
      if t.__orderedIndex[i] == state then
        key = t.__orderedIndex[i+1]
      end
    end
  end

  if key then
    return key, t[key]
  end

  t.__orderedIndex = nil
  return
end

function opairs(t)
    return orderedNext, t, nil
end

luasql = require("luasql.mysql").mysql()
mysql = luasql:connect("cmangos-vanilla","mangos","mangos","127.0.0.1")

local sellvalue = {}
local vanilla = {}
local sql = [[ SELECT * FROM `cmangos-vanilla`.item_template ]]
local query = mysql:execute(sql)
while query:fetch(sellvalue, "a") do
  local entry = tonumber(sellvalue.entry)
  local SellPrice = tonumber(sellvalue.SellPrice)
  local BuyPrice = tonumber(sellvalue.BuyPrice)

  if SellPrice ~= 0 or BuyPrice ~= 0 then
    vanilla[entry] = SellPrice..","..BuyPrice
  end
end

local sellvalue = {}
local tbc = {}
local sql = [[ SELECT * FROM `cmangos-tbc`.item_template ]]
local query = mysql:execute(sql)
while query:fetch(sellvalue, "a") do
  local entry = tonumber(sellvalue.entry)
  local SellPrice = tonumber(sellvalue.SellPrice)
  local BuyPrice = tonumber(sellvalue.BuyPrice)

  if SellPrice ~= 0 or BuyPrice ~= 0 then
    tbc[entry] = SellPrice..","..BuyPrice
  end
end

local diff = {}
for entry, data in pairs(tbc) do
  if not vanilla[entry] or data ~= vanilla[entry] then
    diff[entry] = data
  end
end

local file = io.open("out/sellvalue.lua", "w")
file:write("pfSellData = {")
local count = 0
for entry, data in opairs(vanilla) do
  if count == 0 then
    file:write("\n  ["..entry.."]=\""..data.."\",")
  else
    file:write(" ["..entry.."]=\""..data.."\",")
  end
  count = count + 1
  if count > 5 then count = 0 end
end
file:close()

local file = io.open("out/sellvalue-tbc.lua", "w")
file:write("pfSellData_tbc = {")
local count = 0
for entry, data in opairs(diff) do
  if count == 0 then
    file:write("\n  ["..entry.."]=\""..data.."\",")
  else
    file:write(" ["..entry.."]=\""..data.."\",")
  end
  count = count + 1
  if count > 5 then count = 0 end
end
file:close()
