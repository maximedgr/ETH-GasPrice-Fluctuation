#!/bin/bash
curl "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=JCSHH896K1VMHXII4BITGYEDWUJ7W64AMZ" > api_data.txt
echo "Bot is running..."
echo $(cat api_data.txt | grep -oP '(?<="SafeGasPrice":").*?(?=")')

# create database OS_Project;
# use OS_Project;
# create table GasPrice(USD_price VARCHAR(30) NOT NULL, date VARCHAR(30) NOT NULL, PRIMARY KEY (date));

sudo mysql
USE OS_Project;
INSERT INTO GasPrice(USD_price,date) VALUES("17","24/11/2022:01");
EOF


sudo mysql test.db <<EOF
create table GasPrice(USD_price VARCHAR(30) NOT NULL, date VARCHAR(30) NOT NULL, PRIMARY KEY (date));
INSERT INTO GasPrice(USD_price,date) VALUES("17","24/11/2022:01");
select * from GasPrice;
EOF