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
