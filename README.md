[//]: # (SPDX-License-Identifier: CC-BY-4.0)

# Hyperledger Fabric Samples

You can use Fabric samples to get started working with Hyperledger Fabric, explore important Fabric features, and learn how to build applications that can interact with blockchain networks using the Fabric SDKs. To learn more about Hyperledger Fabric, visit the [Fabric documentation](https://hyperledger-fabric.readthedocs.io/en/latest).

Note that this branch contains samples for the latest Fabric release. For older Fabric versions, refer to the corresponding branches:

- [release-2.2](https://github.com/hyperledger/fabric-samples/tree/release-2.2)
- [release-1.4](https://github.com/hyperledger/fabric-samples/tree/release-1.4)

## Getting started with the Fabric samples

To use the Fabric samples, you need to download the Fabric Docker images and the Fabric CLI tools. First, make sure that you have installed all of the [Fabric prerequisites](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html). You can then follow the instructions to [Install the Fabric Samples, Binaries, and Docker Images](https://hyperledger-fabric.readthedocs.io/en/latest/install.html) in the Fabric documentation. In addition to downloading the Fabric images and tool binaries, the Fabric samples will also be cloned to your local machine.

## Test network

The [Fabric test network](test-network) in the samples repository provides a Docker Compose based test network with two
Organization peers and an ordering service node. You can use it on your local machine to run the samples listed below.
You can also use it to deploy and test your own Fabric chaincodes and applications. To get started, see
the [test network tutorial](https://hyperledger-fabric.readthedocs.io/en/latest/test_network.html).

The [Kubernetes Test Network](test-network-k8s) sample builds upon the Compose network, constructing a Fabric
network with peer, orderer, and CA infrastructure nodes running on Kubernetes.  In addition to providing a sample
Kubernetes guide, the Kube test network can be used as a platform to author and debug _cloud ready_ Fabric Client
applications on a development or CI workstation.


## Asset transfer samples and tutorials

The asset transfer series provides a series of sample smart contracts and applications to demonstrate how to store and transfer assets using Hyperledger Fabric.
Each sample and associated tutorial in the series demonstrates a different core capability in Hyperledger Fabric. The **Basic** sample provides an introduction on how
to write smart contracts and how to interact with a Fabric network using the Fabric SDKs. The **Ledger queries**, **Private data**, and **State-based endorsement**
samples demonstrate these additional capabilities. Finally, the **Secured agreement** sample demonstrates how to bring all the capabilities together to securely
transfer an asset in a more realistic transfer scenario.

|  **Smart Contract** | **Description** | **Tutorial** | **Smart contract languages** | **Application languages** |
| -----------|------------------------------|----------|---------|---------|
| [Basic](asset-transfer-basic) | The Basic sample smart contract that allows you to create and transfer an asset by putting data on the ledger and retrieving it. This sample is recommended for new Fabric users. | [Writing your first application](https://hyperledger-fabric.readthedocs.io/en/latest/write_first_app.html) | Go, JavaScript, TypeScript, Java | Go, TypeScript, Java |
| [Ledger queries](asset-transfer-ledger-queries) | The ledger queries sample demonstrates range queries and transaction updates using range queries (applicable for both LevelDB and CouchDB state databases), and how to deploy an index with your chaincode to support JSON queries (applicable for CouchDB state database only). | [Using CouchDB](https://hyperledger-fabric.readthedocs.io/en/latest/couchdb_tutorial.html) | Go, JavaScript | Java, JavaScript |
| [Private data](asset-transfer-private-data) | This sample demonstrates the use of private data collections, how to manage private data collections with the chaincode lifecycle, and how the private data hash can be used to verify private data on the ledger. It also demonstrates how to control asset updates and transfers using client-based ownership and access control. | [Using Private Data](https://hyperledger-fabric.readthedocs.io/en/latest/private_data_tutorial.html) | Go, TypeScript, Java | TypeScript |
| [State-Based Endorsement](asset-transfer-sbe) | This sample demonstrates how to override the chaincode-level endorsement policy to set endorsement policies at the key-level (data/asset level). | [Using State-based endorsement](https://github.com/hyperledger/fabric-samples/tree/main/asset-transfer-sbe) | Java, TypeScript | JavaScript |
| [Secured agreement](asset-transfer-secured-agreement) | Smart contract that uses implicit private data collections, state-based endorsement, and organization-based ownership and access control to keep data private and securely transfer an asset with the consent of both the current owner and buyer. | [Secured asset transfer](https://hyperledger-fabric.readthedocs.io/en/latest/secured_asset_transfer/secured_private_asset_transfer_tutorial.html)  | Go | TypeScript |
| [Events](asset-transfer-events) | The events sample demonstrates how smart contracts can emit events that are read by the applications interacting with the network. | [README](asset-transfer-events/README.md)  | Go, JavaScript, Java | Go, TypeScript, Java |
| [Attribute-based access control](asset-transfer-abac) | Demonstrates the use of attribute and identity based access control using a simple asset transfer scenario | [README](asset-transfer-abac/README.md)  | Go | _None_ |

## Full stack asset transfer guide

The [full stack asset transfer guide](full-stack-asset-transfer-guide#readme) workshop demonstrates how a generic asset transfer solution for Hyperledger Fabric can be developed and deployed. This covers chaincode development, client application development, and deployment to a production-like environment.

## Additional samples

Additional samples demonstrate various Fabric use cases and application patterns.

|  **Sample** | **Description** | **Documentation** |
| -------------|------------------------------|------------------|
| [Off chain data](off_chain_data) | Learn how to use block events to build an off-chain database for reporting and analytics. | [Peer channel-based event services](https://hyperledger-fabric.readthedocs.io/en/latest/peer_event_services.html) |
| [Token SDK](token-sdk) | Sample REST API around the Hyperledger Labs [Token SDK](https://github.com/hyperledger-labs/fabric-token-sdk) for privacy friendly (zero knowledge proof) UTXO transactions. | [README](token-sdk/README.md) |
| [Token ERC-20](token-erc-20) | Smart contract demonstrating how to create and transfer fungible tokens using an account-based model. | [README](token-erc-20/README.md) |
| [Token UTXO](token-utxo) | Smart contract demonstrating how to create and transfer fungible tokens using a UTXO (unspent transaction output) model. | [README](token-utxo/README.md) |
| [Token ERC-1155](token-erc-1155) | Smart contract demonstrating how to create and transfer multiple tokens (both fungible and non-fungible) using an account based model. | [README](token-erc-1155/README.md) |
| [Token ERC-721](token-erc-721) | Smart contract demonstrating how to create and transfer non-fungible tokens using an account-based model. | [README](token-erc-721/README.md) |
| [High throughput](high-throughput) | Learn how you can design your smart contract to avoid transaction collisions in high volume environments. | [README](high-throughput/README.md) |
| [Simple Auction](auction-simple) | Run an auction where bids are kept private until the auction is closed, after which users can reveal their bid. | [README](auction-simple/README.md) |
| [Dutch Auction](auction-dutch) | Run an auction in which multiple items of the same type can be sold to more than one buyer. This example also includes the ability to add an auditor organization. | [README](auction-dutch/README.md) |


# 🧱 Hyperledger Fabric Multi-Channel Network

[![Hyperledger Fabric](https://img.shields.io/badge/Hyperledger%20Fabric-2.5.0-blue)](https://hyperledger-fabric.readthedocs.io/)
[![License](https://img.shields.io/badge/license-Apache%202.0-green)](./LICENSE)

This project sets up a **multi-channel Hyperledger Fabric v2.5.0 network** with **three organizations** and **three channels**, demonstrating **data isolation**, **selective membership**, and **privacy-preserving chaincode deployments**.

---

## 📐 Network Topology

### Organizations
- **Org1**
- **Org2**
- **Org3**

### Channels
- `mychannel` → Org1 + Org2  
- `bluechannel` → Org1 + Org2  
- `redchannel` → Org2 + Org3  

### Chaincode Deployments
- `basic` → `mychannel`
- `basic-blue` → `bluechannel`
- `basic-red` → `redchannel`

### Architecture Diagram
┌─────────────────────────────────────────────────────────────────────┐ │ Hyperledger Fabric Network │ ├────────────┬────────────────────────────┬───────────────────────────┤ │ │ │ │ │ ▼ ▼ ▼ │ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ │ │ Org1 │ │ Org2 │ │ Org3 │ │ └─────┬───────────┘ └────────┬────────┘ └────────┬────────┘ │ │ │ │ │ ▼ ▼ ▼ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │ │ peer0.org1 │ │ peer0.org2 │ │ peer0.org3 │ │ └─────────────┘ └─────────────┘ └─────────────┘ │ │ │ │ │ ├──────────────────┐ │ │ │ │ mychannel │◄──────────┘ │ │ └──────────────────┘ │ │ ├──────────────────┐ │ │ │ bluechannel │◄──────────┐ │ │ └──────────────────┘ │ │ │ ┌───────────┴──────────┐ │ │ │ redchannel │◄──────────────┘ │ └──────────────────────┘ └─────────────────────────────────────────────────────────────────────┘

---

## 🧰 Prerequisites

- [Docker](https://www.docker.com/) and Docker Compose
- [Go](https://go.dev/dl/) (v1.17 or higher)
- [Node.js](https://nodejs.org/en/) (v14 or higher)
- Hyperledger Fabric binaries and samples (v2.5.0)

---

## ⚙️ Setup Scripts (Run in Order)

```bash
# 1. Setup Base Network and Channels
./minimal-multi-channel.sh

# 2. Deploy Chaincodes to All Channels
./deploy-all-channel-chaincodes.sh

# 3. Initialize Ledgers with Sample Data
./initialize-all-ledgers.sh

# 4. Query and Inspect Channel Data
./query-all-channels.sh

# 5. Verify Channel Membership and Chaincodes
./verify-full-network.sh

# 6. Test Asset Isolation Across Channels
./test-transactions.sh

# 7. Demo the Full Network Stack
./demo-network.sh

```bash