#!/bin/bash
curl "https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=JCSHH896K1VMHXII4BITGYEDWUJ7W64AMZ" > api_data.txt
echo "Bot is running..."
echo "SafeGasPrice :" $(cat api_data.txt | grep -oP '(?<="SafeGasPrice":").*?(?=")')
echo "LastBlock :" $(cat api_data.txt | grep -oP '(?<="LastBlock":").*?(?=")')
echo "Date : " $(date '+%Y-%m-%d %H:%M:%S')

./insert.sh
