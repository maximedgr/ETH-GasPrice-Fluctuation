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

anomalie_front=0

outsidevalue=$(sqlite3 gas_tab.db "SELECT GasPrice.USD_price FROM GasPrice WHERE GasPrice.blocktime=( SELECT MAX(GasPrice.blocktime) FROM GasPrice WHERE GasPrice.USD_price NOT BETWEEN $icd AND $icu) ;")
outsidevalueTime=$(sqlite3 gas_tab.db "SELECT GasPrice.blocktime FROM GasPrice WHERE GasPrice.blocktime=( SELECT MAX(GasPrice.blocktime) FROM GasPrice WHERE GasPrice.USD_price NOT BETWEEN $icd AND $icu) ;")
outsidevalueDate=$(sqlite3 gas_tab.db "SELECT GasPrice.date FROM GasPrice WHERE GasPrice.blocktime=( SELECT MAX(GasPrice.blocktime) FROM GasPrice WHERE GasPrice.USD_price NOT BETWEEN $icd AND $icu) ;")

#récupère la dernière anomalie
last_ano=$(cat last_anomalie.txt)
last_ano_value=$(sqlite3 gas_tab.db "SELECT Anomalie.USD_price FROM Anomalie WHERE Anomalie.blocktime == $last_ano ;")

#On store juste le blocktime de la dernière anomalie et on compare si c'est la même ou une nouvelle de détectée
if [[ $last_ano == "" ]]; #Si fichier vide
then
echo "No previous anomalie"
echo $outsidevalueTime > last_anomalie.txt
anomalie_front = outsidevalue
else
if [[ $last_ano_value != $outsidevalue &&  $outsidevalue != "" ]];
then
echo "last_ano_value : "$last_ano_value" outsidevalue : "$outsidevalue
echo "last_ano : "$last_ano" outsidevalueTime : "$outsidevalueTime
echo "Anomalie detected : "$outsidevalue" | Blocktime : "$outsidevalueTime " | Date : "$outsidevalueDate
sqlite3 gas_tab.db  "INSERT INTO Anomalie(USD_price,date,blocktime) VALUES($outsidevalue,'$outsidevalueDate',$outsidevalueTime);"
echo "Done -> INSERT INTO Anomalie(USD_price,date,blocktime) VALUES($outsidevalue,$outsidevalueDate,$outsidevalueTime);"
echo $outsidevalueTime > last_anomalie.txt
anomalie_front = outsidevalue
else 
echo "No new Anomalie detected last was : Value :  "$last_ano_value" | From blocktime : "$last_ano
outsidevalue=last_ano_value
fi
fi

# Front update

cat > index.html <<EOF
index ="
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>My Website</title>
    <link rel="stylesheet" href="./style.css">
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
  </head>
  <body>
    <main>
      <h1>ETH Gas Price anomalie</h1>
    </main>
    <h3>Click on the tabs below:</h3>
    <div class="tab">
      <button class="tablinks" onclick="clickHandle(event, 'Anomalie')">Anomalie</button>
    </div>
  
    <div id="Anomalie" class="tabcontent">
      <h3>$anomalie_front</h3>
  </div>
  
  <script>
  function clickHandle(evt, avtName) {
    let i, tabcontent, tablinks;
  
    // This is to clear the previous clicked content.
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
  
    // Set the tab to be "active".
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
  
    // Display the clicked tab and set it to active.
    document.getElementById(avtName).style.display = "block";
    evt.currentTarget.className += " active";
  }
  </script>

   </body>
</html>
"
EOF


# Toute les heures on va réduire la taille de l'échantillon pour avoir seulement ceux de la dernière heure et ainsi opérer dessus