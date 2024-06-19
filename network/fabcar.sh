function createCar() {
    read -p "Inserisci la targa della macchina da inserire : " targa
    read -p "Inserisci il costruttore della macchina da inserire : " costruttore
    read -p "Inserisci il modello della macchina da inserire : " modello
    read -p "Inserisci il colore della macchina da inserire : " colore
    read -p "Inserisci il proprietario della macchina da inserire : " proprietario
    comando="{\"Args\":[\"CreateCar\", \"${targa}\", \"${costruttore}\", \"${modello}\", \"${colore}\", \"${proprietario}\"]}"
    docker exec cli peer chaincode invoke -n fabcar -C mychannel -o ${ORDERER_HOSTNAME}:${ORDERER_PORT} --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/${ORDERER_HOSTNAME}/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt -c "$comando"
    # rimosso --peerAddresses peer0.org3.example.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt 
}

function queryCar() {
    read -p "Inserisci la targa della macchina da ricercare : " targa
    risposta=$(docker exec cli peer chaincode query -n fabcar -C mychannel -c "{\"Args\":[\"queryCar\",\"${targa}\"]}")
    costruttore=$(echo $risposta | jq '.make' | tr -d '"')
    modello=$(echo $risposta | jq '.model' | tr -d '"')
    colore=$(echo $risposta | jq '.colour' | tr -d '"')
    proprietario=$(echo $risposta | jq '.owner' | tr -d '"')
    echo "${costruttore} ${modello} di ${proprietario} (${colore})"
}

function queryAllCars() {
    risposte=$(docker exec cli peer chaincode query -n fabcar -C mychannel -c "{\"Args\":[\"queryAllCars\"]}")
    numero=$(echo $risposte | jq length)
    for (( i=0; i<$numero ; i++ )); 
    do
        costruttore=$(echo $risposte | jq ".[${i}].Record.make" | tr -d '"')
        modello=$(echo $risposte | jq ".[${i}].Record.model" | tr -d '"')
        colore=$(echo $risposte | jq ".[${i}].Record.colour" | tr -d '"')
        proprietario=$(echo $risposte | jq ".[${i}].Record.owner" | tr -d '"')
        echo "${costruttore} ${modello} di ${proprietario} (${colore})"
    done
}

function changeCarOwner() {
    read -p "Inserisci la targa della macchina di cui cambiare il proprietario : " targa
    read -p "Inserisci il nuovo proprietario della macchina : " proprietario
    comando="{\"Args\":[\"ChangeCarOwner\", \"${targa}\", \"${proprietario}\"]}"
    docker exec cli peer chaincode invoke -n fabcar -C mychannel -o ${ORDERER_HOSTNAME}:${ORDERER_PORT} --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/${ORDERER_HOSTNAME}/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt -c "$comando"
    # rimosso --peerAddresses peer0.org3.example.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
}

MODE=$1

if [ "${MODE}" == "createCar" ]; then
    createCar
elif [ "${MODE}" == "queryCar" ]; then
    queryCar
elif [ "${MODE}" == "queryAllCars" ]; then
    queryAllCars
elif [ "${MODE}" == "changeCarOwner" ]; then
    changeCarOwner
fi
