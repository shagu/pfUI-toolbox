#!/usr/bin/php
<?php

ini_set('memory_limit', '-1');

$file = "out/selldata.lua";
$mysql = new mysqli("127.0.0.1", "mangos", "mangos", "mangos");
if($mysql->connect_errno != 0){	echo "cant connect to database"; }
$mysql->set_charset("utf8");

$query = $mysql->query("SELECT * FROM item_template");

file_put_contents($file, "pfSellData = {");
$count = 5;
$num = 0;

while($fetch = $query->fetch_array(MYSQLI_ASSOC)){

if ($id > $num ) { 
  $num = $id; 
}

    $id = $fetch["entry"];
    $sell = $fetch["SellPrice"];
    $buy = $fetch["BuyPrice"];
    $bc = $fetch["BuyCount"];
    $level = $fetch["ItemLevel"];
    $type = $fetch["InventoryType"];

    if ( $type == 4 || $type == 19 || $type == 0 ) {
      $level = 0;
    }

    $buy = $buy / $bc;
    if ($sell == 0 && $buy == 0 && $level == 0) {
        echo "no entry for id $id";
    }else{
        if($count == 5) {
            file_put_contents($file, "\n  [$id]=\"$sell,$buy,$level\",", FILE_APPEND);
            $count = 0;
        }else{
            file_put_contents($file, " [$id]=\"$sell,$buy,$level\",", FILE_APPEND);
            $count = $count + 1;
        }
    }
}
file_put_contents($file, "}\n", FILE_APPEND);
echo "\n\n$num\n\n";
?>
