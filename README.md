# SupplyChainApp

Lo scopo di quest'applicativo è quello di implementare la tecnica finanziaria della cartolarizzazione del credito all'interno di una generica supply chain usando la blockchain. Per fare ciò sono stati sviluppati tre smart contract ed un applicazione in Flutter. Le tecnologie utilizzate sono Hyperledger Besu, Hyperledger Firefly, Flutter.

### Hyperledger Besu
È possibile utilizzare Besu per sviluppare applicazioni aziendali che richiedono un'elaborazione delle transazioni sicura e ad alte prestazioni in una rete privata.

### Hyperledger Firefly
Hyperledger FireFly è un Supernode open source, uno stack completo per le aziende per creare e ridimensionare applicazioni Web3 sicure.

### Flutter
Flutter è un framework per lo sviluppo cross-platform di app per dispositivi mobili. Con Flutter, è quindi possibile, a partire da un unico codice sorgente, effettuare il deploy dell’applicazione su diverse piattaforme.

----------------------------------------------------------------------------------------------------------------------------
## Hyperledger Firefly
Installa Hyperledger Firefly seguendo la seguente [guida]("https://hyperledger.github.io/firefly/gettingstarted/firefly_cli.html").
### Creazione dello stack tramite Hyperledger Firefly
```sh
    ff init [Nome_Stack] 4 -b ethereum -c evmconnect -n besu
```
Il comando precedente crerà uno stack di nome **Nome_Stack** con **4** nodi, userà il connettore **evmconnect** ed ogni nodo è di tipo **Besu** (Hyperledger Besu).  
### Avvio dello stack tramite Hyperledger Firefly
```sh
    ff start [Nome_Stack]
```
----------------------------------------------------------------------------------------------------------------------------
## Compilazione degli smart contract
Installare il compilatore Solidity [**solc**](https://docs.soliditylang.org/en/latest/installing-solidity.html).
Dalla cartella [**contracts**](https://github.com/GiuseppeGalante/SupplyChainApp/tree/main/contracts) estrarre gli smart contracts e compilarli tramite **solc**.
```sh
solc --combined-json abi,bin --evm-version paris CreaObbligazioni.sol > Obbligazioni.json
```
```sh
solc --combined-json abi,bin --evm-version paris Crediti.sol > Crediti.json
```
- Installare la libreria [**@openzeppelin**](https://docs.openzeppelin.com/contracts/5.x/)
- In _node_modules_ cercare la cartella @openzeppelin e copiarla nella directory principale
- eseguire il comando seguente
```sh
solc --combined-json abi,bin --evm-version paris Crea_Obbligazioni.sol [Path Directory]/@openzeppelin/contracts/token/ERC721/ERC721.sol > crea_obbligazioni.json
```
------------------------------------------------------------------------------
## Deploy degli smart contract
```sh
ff deploy ethereum blockchain Obbligazioni.json -v
```
```sh
ff deploy ethereum blockchain Crediti.json -v
```
Per l'ultimo smart contract seguire le guide ai seguenti [link1](https://github.com/nguyer/firefly-nft-workshop-2023-03-023?tab=readme-ov-file#deploy-your-smart-contract) fino a "Create a Token Pool" e [link2](https://hyperledger.github.io/firefly/tutorials/custom_contracts/ethereum.html#create-an-http-api-for-the-contract) solo "Create an HTTP API for the contract".

---------------------------------------------------------------------
## App
- Creare il progetto Flutter 
```sh
flutter create [Nome_Progetto]
```
- Creare un nuovo progetto su Firebase e seguire la [guida](https://firebase.google.com/docs/flutter/setup?hl=it&platform=ios).
- Copiare il contenuto della cartella [lib](https://github.com/GiuseppeGalante/SupplyChainApp/tree/main/lib) nella cartella **lib** del progetto appena creato.



 

