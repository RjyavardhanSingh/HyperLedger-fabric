#!/bin/bash
# filepath: /home/hyperledger/fabric-samples/fix-peer-commands.sh

function println() {
  echo -e "\033[0;32m$1\033[0m"
}

function errorln() {
  echo -e "\033[0;31m$1\033[0m"
}

function header() {
  echo -e "\033[0;34m========== $1 ==========\033[0m"
}

cd ~/fabric-samples/test-network

header "CHECKING NETWORK STATUS"
# Check if all containers are running
println "Docker container status:"
CONTAINERS=$(docker ps --format "{{.Names}}")
if [[ ! $CONTAINERS == *"peer0.org1.example.com"* ]]; then
  errorln "peer0.org1.example.com container is not running"
fi
if [[ ! $CONTAINERS == *"peer0.org2.example.com"* ]]; then
  errorln "peer0.org2.example.com container is not running"
fi
if [[ ! $CONTAINERS == *"peer0.org3.example.com"* ]]; then
  errorln "peer0.org3.example.com container is not running"
fi
if [[ ! $CONTAINERS == *"orderer.example.com"* ]]; then
  errorln "orderer.example.com container is not running"
fi

header "CHECKING MSP DIRECTORIES"
# Check if MSP directories exist and are accessible
for org in org1 org2 org3; do
  MSP_PATH="${PWD}/organizations/peerOrganizations/${org}.example.com/users/Admin@${org}.example.com/msp"
  if [ ! -d "$MSP_PATH" ]; then
    errorln "MSP directory for ${org} does not exist: $MSP_PATH"
  else
    if [ ! -r "$MSP_PATH/signcerts/cert.pem" ] && [ ! -r "$MSP_PATH/signcerts/Admin@${org}.example.com-cert.pem" ]; then
      errorln "Cannot read ${org} certificate in signcerts directory"
    fi
  fi
  
  TLS_PATH="${PWD}/organizations/peerOrganizations/${org}.example.com/peers/peer0.${org}.example.com/tls/ca.crt"
  if [ ! -f "$TLS_PATH" ]; then
    errorln "TLS CA certificate for ${org} does not exist: $TLS_PATH"
  else
    if [ ! -r "$TLS_PATH" ]; then
      errorln "Cannot read TLS CA certificate for ${org}"
    fi
  fi
done

header "SETTING UP ENVIRONMENT AND TESTING PEER CONNECTIONS"

# Export the PATH to include the binaries
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/

# Test connection to peers
for org in 1 2 3; do
  header "Testing Org$org Peer Connection"
  
  if [ "$org" == "1" ]; then
    PEER_PORT=7051
  elif [ "$org" == "2" ]; then
    PEER_PORT=9051
  else
    PEER_PORT=11051
  fi
  
  # Set up the environment variables
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_LOCALMSPID="Org${org}MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org${org}.example.com/peers/peer0.org${org}.example.com/tls/ca.crt
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org${org}.example.com/users/Admin@org${org}.example.com/msp
  export CORE_PEER_ADDRESS=localhost:${PEER_PORT}
  
  println "Testing connection to peer0.org${org} (localhost:${PEER_PORT})"
  nc -zv localhost ${PEER_PORT} 2>/dev/null
  if [ $? -eq 0 ]; then
    println "Successfully connected to peer0.org${org}"
  else
    errorln "Failed to connect to peer0.org${org} on port ${PEER_PORT}"
  fi
  
  println "Checking peer channel list command with debug logging"
  FABRIC_LOGGING_SPEC=debug peer channel list 2>&1 | tee /tmp/peer-debug-org${org}.log
  
  # Check for specific errors in the debug log
  if grep -q "Failed to get endorser client" /tmp/peer-debug-org${org}.log; then
    errorln "Endorser client connection issue detected for Org${org}"
  fi
  
  if grep -q "Failed obtaining authentication token" /tmp/peer-debug-org${org}.log; then
    errorln "Authentication token issue detected for Org${org}"
  fi
  
  if grep -q "TLS handshake failed" /tmp/peer-debug-org${org}.log; then
    errorln "TLS handshake failed for Org${org} - certificate issues"
  fi
done

header "CHECKING FOR PERMISSION ISSUES"
# Check permission issues on key directories
for dir in organizations config; do
  if [ ! -r "${PWD}/${dir}" ]; then
    errorln "Directory ${PWD}/${dir} is not readable"
    sudo chmod -R a+r ${PWD}/${dir}
    println "Fixed permissions on ${PWD}/${dir}"
  fi
done

header "FIXING ENVIRONMENT SETUP SCRIPT"
# Create a fixed environment setup script
cat > ~/fabric-samples/set-peer-env.sh << 'EOF'
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
EOF

chmod +x ~/fabric-samples/set-peer-env.sh

header "CREATING PEER CHANNEL COMMANDS WRAPPER"
# Create a wrapper for peer channel commands
cat > ~/fabric-samples/peer-channel-cmd.sh << 'EOF'
#!/bin/bash

source ~/fabric-samples/set-peer-env.sh

function println() {
  echo -e "\033[0;32m$1\033[0m"
}

function errorln() {
  echo -e "\033[0;31m$1\033[0m"
}

if [ "$1" == "" ] || [ "$2" == "" ]; then
  echo "Usage: $0 {1|2|3} COMMAND [ARGS...]"
  echo "Example: $0 1 list"
  echo "Example: $0 2 getinfo -c mychannel"
  exit 1
fi

ORG=$1
shift
CMD=$1
shift

if ! set_org_env $ORG; then
  errorln "Failed to set environment for Org$ORG"
  exit 1
fi

println "Executing: peer channel $CMD $@"
FABRIC_LOGGING_SPEC=INFO peer channel $CMD $@

if [ $? -ne 0 ]; then
  errorln "Command failed. Trying with additional debugging..."
  FABRIC_LOGGING_SPEC=DEBUG peer channel $CMD $@ 2>&1 | tee /tmp/peer-debug-org${ORG}.log
  
  # Check for common errors
  if grep -q "Failed to get endorser client" /tmp/peer-debug-org${ORG}.log; then
    errorln "Endorser client connection issue. Check if peer is running and accessible."
  fi
  
  if grep -q "Failed obtaining authentication token" /tmp/peer-debug-org${ORG}.log; then
    errorln "Authentication token issue. Check MSP configuration."
  fi
  
  if grep -q "TLS handshake failed" /tmp/peer-debug-org${ORG}.log; then
    errorln "TLS handshake failed. Check TLS certificate configuration."
  fi
fi
EOF

chmod +x ~/fabric-samples/peer-channel-cmd.sh

header "RESTORING NETWORK IF NEEDED"
# Check if network is down, restart if needed
if [[ ! $CONTAINERS == *"peer0.org1.example.com"* ]]; then
  println "Network appears to be down. Attempting to restart..."
  ./network.sh down
  sleep 2
  ./network.sh up createChannel -c mychannel
  sleep 2
  
  # Create additional channels
  ./network.sh createChannel -c bluechannel
  sleep 2
  
  # Add Org3
  cd addOrg3
  ./addOrg3.sh up -c mychannel
  cd ..
  sleep 2
  
  # Create redchannel
  ./network.sh createChannel -c redchannel
  sleep 2
  
  # Join Org3 to redchannel
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_LOCALMSPID="Org3MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
  export CORE_PEER_ADDRESS=localhost:11051
  
  export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
  peer channel fetch 0 ./channel-artifacts/redchannel.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c redchannel --tls --cafile "$ORDERER_CA"
  peer channel join -b ./channel-artifacts/redchannel.block
  
  println "Network restarted and channels recreated"
fi

header "TESTING FIXED PEER COMMANDS"
# Test peer channel list with the new script
println "Testing peer channel list for Org1"
~/fabric-samples/peer-channel-cmd.sh 1 list

println "Testing peer channel list for Org2"
~/fabric-samples/peer-channel-cmd.sh 2 list

println "Testing peer channel list for Org3"
~/fabric-samples/peer-channel-cmd.sh 3 list

println "DIAGNOSIS AND FIX COMPLETE"
println "Use the ~/fabric-samples/set-peer-env.sh script to set up the environment for each organization"
println "Example: source ~/fabric-samples/set-peer-env.sh; set_org_env 1; peer channel list"
println "Or use the wrapper script: ~/fabric-samples/peer-channel-cmd.sh 1 list"