#!/bin/bash

function csv2sql () {
  # arg1 = DBC, eg. "Spell"
  # arg2 = Locale, eg. "frFR"
  # arg3 = Offset, eg. 123

  FILE=$1_$2
  COLUMN=$(echo $1 | tr '[:upper:]' '[:lower:]')

  echo $FILE

  cat $FILE.dbc.csv | cut -d , -f 1,$3 > $FILE.csv
  echo "DROP TABLE IF EXISTS $FILE;" > $FILE.sql
  echo "CREATE TABLE $FILE ( ${COLUMN}ID int, ${COLUMN}Name varchar(255));" >> $FILE.sql
  cat $FILE.csv | tail -n +2 | awk -F',' '{ printf "INSERT INTO '$FILE' VALUES (%s,%s);",$1,$2;print ""}' >> $FILE.sql
  rm $FILE.csv
  sed -i s/\'/"\\\'"/g $FILE.sql
  sed -i '3,$ { /\");/! s/);/");/g }' $FILE.sql
  sed -i '/",");/d' $FILE.sql

  mysql -h 127.0.0.1 -u mangos --password="mangos" mangos < $FILE.sql
}

csv2sql Spell koKR 122
csv2sql Spell frFR 123
csv2sql Spell deDE 124
csv2sql Spell zhCN 125
csv2sql Spell esES 127
csv2sql Spell ruRU 121
