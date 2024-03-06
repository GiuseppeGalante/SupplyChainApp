

import 'package:flutter/material.dart';
import 'package:supply_chain_securitization/component/AppBarApplication.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/Crediti.dart';
import 'package:supply_chain_securitization/operations/View_Credito.dart';

class View_All_Crediti extends StatefulWidget
{
  List<Credito> crediti=[];
  View_All_Crediti({Key? key,required this.crediti});
  @override
  State<StatefulWidget> createState() => View_All_Crediti_State(crediti:crediti);

}
class View_All_Crediti_State extends State<View_All_Crediti>
{
  List<Credito> crediti=[];
  View_All_Crediti_State({Key? key, required this.crediti});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarApplication(),
        body: ListView.builder(
            itemCount: crediti.length,
            itemBuilder: (context,index)
            {
              return GestureDetector(
                onTap: ()
                {
                  if(crediti[index].id_credito_pagato=="")
                  {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => View_Credito(id: crediti[index].id_credito_emesso)));
                  }else
                  {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => View_Credito(id: crediti[index].id_credito_pagato)));
                  }


                },
                child: ListTile(
                  leading: Icon(Icons.paid_outlined,color: Colori.verde_scuro,),
                  trailing: Text(crediti[index].id_credito_emesso, style: TextStyle(
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