#!/bin/bash

function println() {
  echo -e "\033[0;32m$1\033[0m"
}

# Set for organization 1, 2, or 3
set_org_env() {
  local ORG=$1
  
  cd ~/fabric-samples/test-network
  
  export PATH=${PWD}/../bin:$PATH
  export FABRIC_CFG_PATH=${PWD}/../config/
  export CORE_PEER_TLS_ENABLED=true
  
  if [ "$ORG" == "1" ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    println "Environment set for Org1"
  elif [ "$ORG" == "2" ]; then
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    println "Environment set for Org2"
  elif [ "$ORG" == "3" ]; then
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
    println "Environment set for Org3"
  else
    echo "Usage: set_org_env {1|2|3}"
    return 1
  fi
  
  # Verify MSP directory exists
  if [ ! -d "$CORE_PEER_MSPCONFIGPATH" ]; then
    echo "Warning: MSP directory does not exist: $CORE_PEER_MSPCONFIGPATH"
    return 1
  fi
  
  # Verify TLS cert exists
  if [ ! -f "$CORE_PEER_TLS_ROOTCERT_FILE" ]; then
    echo "Warning: TLS certificate does not exist: $CORE_PEER_TLS_ROOTCERT_FILE"
    return 1
  fi
  
  # Test peer availability
  nc -z localhost ${CORE_PEER_ADDRESS##*:} 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Warning: Cannot connect to peer at $CORE_PEER_ADDRESS"
    return 1
  fi
  
  return 0
}

# Example usage:
# set_org_env 1  # Set environment for Org1
# peer channel list
