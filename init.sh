#!/bin/bash
# sqlite3 must be installed
sqlite3 gas_tab.db  "create table GasPrice(USD_price VARCHAR(50) NOT NULL, date DATETIME NOT NULL, blocktime VARCHAR(50) NOT NULL, PRIMARY KEY (blocktime));"