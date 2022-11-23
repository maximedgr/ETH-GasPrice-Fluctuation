# Ethereum - Gas Price Alert & Analysis 
Application alerting a user via Telegram message and web visualization of abnormal variations in the ETH GasPrice datas.

# Etherscan API :
[Gas Price API](https://api.etherscan.io/api?module=gastracker&action=gasoracle)

create database OS_Project;
use OS_Project;
create table GasPrice(USD_price VARCHAR(30) NOT NULL, date VARCHAR(30) NOT NULL, PRIMARY KEY (date));