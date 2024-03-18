// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

contract Genera_Transazioni
{
    struct Transazioni
    {
        address venditore;
        address acquirente;
        uint256 prezzo;
        string solvibilita;
        string stato;
        string tipo_prezzo;
    }
    
    function setTransazione(address venditore, address acquirente, uint256 prezzo, string memory solvibilita, string memory stato, string memory tipo_prezzo) public pure{
         
		 require(venditore != acquirente);
		 
		 Transazioni(venditore,acquirente,prezzo,solvibilita,stato,tipo_prezzo);

    }
}
