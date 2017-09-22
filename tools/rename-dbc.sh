#!/bin/sh

# Initial folder hirarchy:
# - enUS
#   |- foo.dbc
#   |- bar.dbc
#
# - deDE
#   |- foo.dbc
#   |- bar.dbc
#
# - frFR
#   |- foo.dbc
#   |- bar.dbc
#
# - ...
#
# Converts to files like foo_enUS.dbc, bar_enUS.dbc, foo_deDE.dbc, bar_deDE.dbc, ...

for file in */*; do
  dirname=$(dirname $file)
  filename=$(basename $file .dbc)
  cp -v $file ./${filename}_${dirname}.dbc
done
