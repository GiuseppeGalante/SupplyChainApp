// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.10;

contract Manage_Crediti
{
    struct Credito
    {
        address originator;
        string[] elenco_transazioni;
        string solvibilita;
        uint valore;
        string stato;
        string tipo_valore;
        address proprietario;
    }

    function salva_credito(address originator,string[] memory elenco_transazioni,string memory solvibilita,uint valore,string memory stato,string memory tipo_valore,address proprietario) public pure
    {
       Credito(originator,elenco_transazioni,solvibilita,valore,stato,tipo_valore,proprietario);
    }             
}
