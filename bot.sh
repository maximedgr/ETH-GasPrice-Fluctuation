#!/bin/bash
curl "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=JCSHH896K1VMHXII4BITGYEDWUJ7W64AMZ" > api_data.txt
echo "Bot is running..."
echo $(cat api_data.txt | grep -oP '(?<="SafeGasPrice":").*?(?=")')


sqlite3 test.db  "create table GasPrice(USD_price VARCHAR(30) NOT NULL, date VARCHAR(30) NOT NULL, PRIMARY KEY (date));"
