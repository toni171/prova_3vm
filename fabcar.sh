function createCar() {
    read -p "Inserisci la targa della macchina da inserire : " targa
    read -p "Inserisci il costruttore della macchina da inserire : " costruttore
    read -p "Inserisci il modello della macchina da inserire : " modello
    read -p "Inserisci il colore della macchina da inserire : " colore
    read -p "Inserisci il proprietario della macchina da inserire : " proprietario
    comando="{\"Args\":[\"CreateCar\", \"${targa}\", \"${costruttore}\", \"${modello}\", \"${colore}\", \"${proprietario}\"]}"
    docker exec cli peer chaincode invoke -n fabcar -C mychannel -o ${ORDERER_HOSTNAME}:${ORDERER_PORT} --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/${ORDERER_HOSTNAME}/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org2.example.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org3.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt -c "$comando"
}

function queryCar() {
    read -p "Inserisci la targa della macchina da ricercare : " targa
    docker exec cli peer chaincode query -n fabcar -C mychannel -c "{\"Args\":[\"queryCar\",\"${targa}\"]}"
}

function queryAllCars() {
    docker exec cli peer chaincode query -n fabcar -C mychannel -c "{\"Args\":[\"queryAllCars\"]}"
}

function changeCarOwner() {
    read -p "Inserisci la targa della macchina di cui cambiare il proprietario : " targa
    read -p "Inserisci il nuovo proprietario della macchina : " proprietario
    comando="{\"Args\":[\"ChangeCarOwner\", \"${targa}\", \"${proprietario}\"]}"
    docker exec cli peer chaincode invoke -n fabcar -C mychannel -o ${ORDERER_HOSTNAME}:${ORDERER_PORT} --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/${ORDERER_HOSTNAME}/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses peer0.org3.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt -c "$comando"
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
