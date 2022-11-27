#!/bin/bash
gasPrice=$(cat api_data.txt | grep -oP '(?<="SafeGasPrice":").*?(?=")')
lastBlock=$(cat api_data.txt | grep -oP '(?<="LastBlock":").*?(?=")')
date_=$(date +"%D %T")

sqlite3 gas_tab.db  "INSERT INTO GasPrice(USD_price,date,blocktime) VALUES($GasPrice,$Date_,$LastBlock);"

echo "Done -> INSERT INTO GasPrice(USD_price,date,blocktime) VALUES($gasPrice,$date_,$lastBlock);"

