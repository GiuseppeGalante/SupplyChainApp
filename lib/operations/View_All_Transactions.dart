

import 'package:flutter/material.dart';
import 'package:supply_chain_securitization/component/AppBarApplication.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/Transazioni.dart';
import 'package:supply_chain_securitization/operations/View_Transazione.dart';

class View_All_Transactions extends StatefulWidget
{
  List<Transazione> transazioni=[];
  View_All_Transactions({Key? key,required this.transazioni});
  @override
  State<StatefulWidget> createState() => View_All_Transactions_State(transazioni:transazioni);

}
class View_All_Transactions_State extends State<View_All_Transactions>
{
  List<Transazione> transazioni=[];
  View_All_Transactions_State({Key? key, required this.transazioni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarApplication(),
      body: ListView.builder(
          itemCount: transazioni.length,
          itemBuilder: (context,index)
          {
            return GestureDetector(
              onTap: ()
              {
                if(transazioni[index].id_transazione_raggruppata=="" && transazioni[index].id_transazione_pagata=="")
                {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => View_Transazione(id: transazioni[index].id_transazione_emessa)));
                }else if(transazioni[index].id_transazione_pagata=="")
                {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => View_Transazione(id: transazioni[index].id_transazione_raggruppata)));
                }else
                {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => View_Transazione(id: transazioni[index].id_transazione_raggruppata)));
                }

              },
              child: ListTile(
                leading: Icon(Icons.paid_outlined,color: Colori.verde_scuro,),
                trailing: Text(transazioni[index].id_transazione_emessa, style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold
                ),),



              ),
            );
          }
      )
    );
  }

}