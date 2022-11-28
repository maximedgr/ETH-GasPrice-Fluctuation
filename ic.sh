#!/bin/bash
#intervalle de confiance à 95%
mean=$(sqlite3 gas_tab.db "SELECT avg(USD_price) from GasPrice;")
taille=$(sqlite3 gas_tab.db "SELECT COUNT(*) from GasPrice;")
sqrttaille=$(sqlite3 gas_tab.db "SELECT sqrt($taille);")
coeff=1.96
variance=$(sqlite3 gas_tab.db "SELECT SUM((GasPrice.USD_price-(SELECT AVG(GasPrice.USD_price) FROM GasPrice))*(GasPrice.USD_price-(SELECT AVG(GasPrice.USD_price) FROM GasPrice)) ) / (COUNT(GasPrice.USD_price)-1) AS Variance FROM GasPrice;")
std=$(sqlite3 gas_tab.db "SELECT sqrt($variance);")
icu=$(sqlite3 gas_tab.db "SELECT $mean+$coeff*($std/$sqrttaille);")
icd=$(sqlite3 gas_tab.db "SELECT $mean-$coeff*($std/$sqrttaille);")
echo "Moyenne : "$mean
echo "Taille échantillon : "$taille
echo "LN coeff: "$coeff
echo "Variance : "$variance
echo "Std : "$std
echo "IC : "
echo "["$icd" ; "$icu"]"


outsidevalue=$(sqlite3 gas_tab.db "SELECT GasPrice.USD_price FROM GasPrice WHERE GasPrice.blocktime=( SELECT MAX(GasPrice.blocktime) FROM GasPrice WHERE GasPrice.USD_price NOT BETWEEN $icd AND $icu) ;")
outsidevalueTime=$(sqlite3 gas_tab.db "SELECT GasPrice.blocktime FROM GasPrice WHERE GasPrice.blocktime=( SELECT MAX(GasPrice.blocktime) FROM GasPrice WHERE GasPrice.USD_price NOT BETWEEN $icd AND $icu) ;")
outsidevalueDate=$(sqlite3 gas_tab.db "SELECT GasPrice.date FROM GasPrice WHERE GasPrice.blocktime=( SELECT MAX(GasPrice.blocktime) FROM GasPrice WHERE GasPrice.USD_price NOT BETWEEN $icd AND $icu) ;")

last_ano=$(cat last_anomalie.txt)

if [[ $last_ano == "" ]];
then
echo "c'est vide"
else
echo "c'est pas vide"
fi

if [[ $outsidevalue != "" ]];
then
echo "Anomalie detected : "$outsidevalue" | Blocktime : "$outsidevalueTime " | Date : "$outsidevalueDate
sqlite3 gas_tab.db  "INSERT INTO Anomalie(USD_price,date,blocktime) VALUES($outsidevalue,'$outsidevalueDate',$outsidevalueTime);"
echo "Done -> INSERT INTO Anomalie(USD_price,date,blocktime) VALUES($outsidevalue,$outsidevalueDate,$outsidevalueTime);"
else 
echo "No Anomalie detected."
fi

# if [[ $outsidevalue >=~ $pat1 ]];
# then
# sqlite3 gas_tab.db  "INSERT INTO Anomalie(USD_price,date,blocktime) VALUES($outsidevalue,$outsidevalueDate,$outsidevalueTime);"
# echo "Done -> INSERT INTO Anomalie(USD_price,date,blocktime) VALUES($outsidevalue,$outsidevalueDate,$outsidevalueTime);"
# fi 


# Variance : 
# SELECT SUM((GasPrice.USD_price-(SELECT AVG(GasPrice.USD_price) FROM GasPrice))*(GasPrice.USD_price-(SELECT AVG(GasPrice.USD_price) FROM GasPrice)) ) / (COUNT(GasPrice.USD_price)-1) AS Variance FROM GasPrice;

# Toute les heures on va réduire la taille de l'échantillon pour avoir seulement ceux de la dernière heure et ainsi opérer dessus