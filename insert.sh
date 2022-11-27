#!/bin/bash
gasPrice=$(cat api_data.txt | grep -oP '(?<="SafeGasPrice":").*?(?=")')
lastBlock=$(cat api_data.txt | grep -oP '(?<="LastBlock":").*?(?=")')
date_=$(date '+%Y-%m-%d %H:%M:%S')

sqlite3 gas_tab.db  "INSERT INTO GasPrice(USD_price,date,blocktime) VALUES($GasPrice,$Date_,$LastBlock);"

echo "Done -> INSERT INTO GasPrice(USD_price,date,blocktime) VALUES($gasPrice,$date_,$lastBlock);"

