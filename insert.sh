#!/bin/bash
gasPrice= echo $(cat api_data.txt | grep -oP '(?<="SafeGasPrice":").*?(?=")')
lastBlock= echo $(cat api_data.txt | grep -oP '(?<="LastBlock":").*?(?=")')
date_= echo $(date +"%D %T")

#sqlite3 gas_tab.db  "INSERT INTO GasPrice(USD_price,date) VALUES($GasPrice,$Date_,$LastBlock);"

echo $gasPrice


