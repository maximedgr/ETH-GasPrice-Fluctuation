#!/bin/bash
sudo mysql test.db <<EOF
select * from GasPrice;
EOF