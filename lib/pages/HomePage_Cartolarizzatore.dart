

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supply_chain_securitization/component/AppBarApplication.dart';
import 'package:supply_chain_securitization/component/BottomBarApplication.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/API.dart';
import 'package:supply_chain_securitization/entity/Crediti.dart';
import 'package:supply_chain_securitization/operations/Crea_Obbligazioni.dart';
import 'package:supply_chain_securitization/operations/Elenco_Obbligazioni.dart';
import 'package:supply_chain_securitization/operations/View_All_Crediti.dart';
import 'package:supply_chain_securitization/operations/View_Credito.dart';

class HomePage_Cartolarizzatore extends StatefulWidget
{
  int connesso=-1;
  String address="";
  HomePage_Cartolarizzatore({Key? key,required this.connesso,required this.address});
  @override
  State<StatefulWidget> createState() => HomePage_Cartolarizzatore_State(connesso:connesso,address: address);
}

class HomePage_Cartolarizzatore_State extends State<HomePage_Cartolarizzatore>
{
  int connesso=-1;
  String address="";
  double balance=0;
  late Future<List<Credito>> cr;
  late Future<double> bal;
  late Future value;
  List<Credito> crediti=[];
  HomePage_Cartolarizzatore_State({Key? key,required this.connesso,required this.address});

  void initState() {
    bal=getBalance(address).then((value) => balance=(double.parse(value))/1000000000000000000);
    cr=getCrediti("Ceduto").then((value) => crediti=value);
    value=Future.wait([cr,bal]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
          future: value,
          builder: (context,snapshot)
          {
            if(snapshot.hasData)
              {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  bottomNavigationBar: BottomBarApplication(),
                  appBar: AppBarApplication(),
                  body: Container(
                      decoration: BoxDecoration(
                          color: Colori.background
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top:20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colori.verde_scuro,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colori.verde_scuro.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width-20,
                              height: 120,
                              child: Padding(
                                padding: EdgeInsets.only(top:20,left:20,right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          Text("Balance",style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          ),),
                                          Text(balance.toString(),style: TextStyle(
                                              fontSize: 20
                                          ),)
                                        ]
                                    ),
                                    QrImageView(
                                      data: address,
                                      version: QrVersions.auto,
                                      size: 80.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top:40),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Container(
                                      width: 80,
                                      height: 100,
                                      child: GestureDetector(
                                        onTap: ()
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => Crea_Obbligazioni(crediti: crediti,address:address)));

                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colori.grigio.withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Icon(Icons.note_add_outlined),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top:6),
                                              child: Container(
                                                  child: Text("Cartolarizza")),
                                            ),



                                          ],
                                        ),
                                      )


                                  ),
                                  SizedBox(width: 20,),
                                  Container(
                                      width: 85,
                                      height: 100,
                                      child: GestureDetector(
                                        onTap: (){
                                          print(address);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => Elenco_Obbligazioni(address:address)));

                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colori.grigio.withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Icon(Icons.monetization_on_outlined),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top:6),
                                              child: Container(
                                                  child: Text("Obbligazioni")),
                                            ),
                                          ],
                                        ),
                                      )

                                  ),

                                ]

                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top:20,left: 10,right: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Crediti",style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      )),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => View_All_Crediti(crediti:crediti)));
                                        },
                                        child: Text("View All"),
                                      )
                                    ],
                                  ),
                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: ((){
                                        print("Crediti: "+crediti.length.toString());
                                        if(crediti.length<=4)
                                          return crediti.length;
                                        else
                                          return 4;
                                      }()),
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



                                      })
                                  /*ListView.builder(
                                        itemCount: transazioni.length,
                                        itemBuilder: (context, index)
                                        {
                                          ListTile(title:Text(index.toString()));
                                          //ListTile(title: Text(transazioni.length.toString()));

                                        }
                                    );*/

                                ],
                              )
                          )




                        ],
                      )
                  ),
                );
              }else if (snapshot.hasError) {
              print(snapshot.error);
              return AlertDialog(
                title: const Text('Errore'),
                content: const Text(
                    "Impossibile connettersi ad Internet.\nChiudere l'app e riprovare"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                    {
                      SystemNavigator.pop()
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            }
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colori.background,
                    ),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wallet_outlined,color: Colors.white,size: 100,),
                        SizedBox(height: 20,),
                        Padding(padding: EdgeInsets.only(left: 50,
                            right: 50),
                            child: Center(
                                child: CircularProgressIndicator(color: Colors.white))),

                      ],

                    ),
                  ),
                ),
              ),
            );

          }
      );
  }

}