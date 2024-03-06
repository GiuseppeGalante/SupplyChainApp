

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supply_chain_securitization/component/AppBarApplication.dart';
import 'package:supply_chain_securitization/component/BottomBarApplication.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/API.dart';
import 'package:supply_chain_securitization/entity/Crediti.dart';
import 'package:supply_chain_securitization/entity/Transazioni.dart';
import 'package:supply_chain_securitization/operations/Cedi_Credito.dart';
import 'package:supply_chain_securitization/operations/Raggruppa_Transazioni.dart';
import 'package:supply_chain_securitization/operations/View_All_Transactions.dart';
import 'package:supply_chain_securitization/operations/View_Transazione.dart';


class HomePage extends StatefulWidget
{
  int connesso=-1;
  String address="";
  HomePage({Key? key,required this.connesso,required this.address});
  @override
  State<StatefulWidget> createState() => HomePageState(connesso:connesso,address: address);
}

class HomePageState extends State<HomePage>
{
  late Future<double> bal;
  late Future<List<Transazione>> tr;
  late Future value;
  List<Transazione> transazioni=[];
  int connesso=-1;
  String address="";
  String a="";
  String p="";
  double balance=0;

  final formKey = GlobalKey<FormState>();
  late TextEditingController _venditore;
  late TextEditingController _acquirente;
  late TextEditingController _prezzo;
  List<Credito> cr=[];
  HomePageState({Key? key,required this.connesso,required this.address});
  @override
  void initState() {
    _venditore = new TextEditingController();
    _acquirente = new TextEditingController();
    _prezzo = new TextEditingController();
    bal=getBalance(address).then((value) => balance=(double.parse(value))/1000000000000000000);
    tr=getTransazioni(address).then((value) => transazioni=value);
    value=Future.wait([tr,bal]);
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
                                    onTap: ()=> _aggiungi_transazione(context),
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
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:6),
                                      child: Container(
                                           child: Text("Aggiungi Transazione",
                                             textAlign: TextAlign.center,),
                                          ),
                                      ),



                                    ],
                                  )
                        ),

                                ),
                                SizedBox(width: 20,),
                                Container(
                                    width: 80,
                                    height: 100,
                                    child: GestureDetector(
                                      onTap: ()
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => Raggruppa_Transazioni(transazioni: transazioni,address:address)))
                                              .then((value) => {setState((){tr=getTransazioni(address).then((value) => transazioni=value); })});
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
                                              child: Icon(Icons.receipt_long_outlined),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top:6),
                                            child: Container(
                                                child: Text("Raggruppa Transazioni")),
                                          ),



                                        ],
                                      ),
                                    )
                                    

                                ),
                                SizedBox(width: 20,),
                                Container(
                                    width: 80,
                                    height: 100,
                                    child: GestureDetector(
                                      onTap: ()
                                      {
                                        getCrediti("Cedibile").then((value) => cr=value).whenComplete(() =>Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => Cedi_Credito(crediti:cr,address:address)))
                                            .then((value) => {setState((){tr=getTransazioni(address).then((value) => transazioni=value); })}));
                                        /*Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => Cedi_Credito(address:address)))
                                            .then((value) => {setState((){tr=getTransazioni(address).then((value) => transazioni=value); })});*/
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
                                              child: Icon(Icons.send_outlined),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top:6),
                                            child: Container(
                                                child: Text("Cedi Credito",textAlign: TextAlign.center,)),
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
                                Text("Transazioni",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                )),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => View_All_Transactions(transazioni:transazioni)));
                                  },
                                  child: Text("View All"),
                                )

                              ],
                            ),
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: ((){
                                  if(transazioni.length<=4)
                                    return transazioni.length;
                                  else
                                    return 4;
                                }()),
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



                            })
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
                      Icon(Icons.wallet_outlined,color: Colori.verde_scuro,size: 100,),
                      SizedBox(height: 20,),
                      Padding(padding: EdgeInsets.only(left: 50,
                          right: 50),
                          child: Center(
                              child: CircularProgressIndicator(color: Colori.verde_scuro))),

                    ],

                  ),
                ),
              ),
            ),
          );



        }
    );
  }

  Future<void> _aggiungi_transazione(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ScaffoldMessenger(
          child: Builder(builder:(context){
            return Scaffold(
              backgroundColor: Colors.transparent,
              body:AlertDialog(
                  content: Container(
                      height: 450,
                      child: Form(
                        key:formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Expanded(
                                child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Text("Venditore",style: TextStyle(
                                          color: Colori.verde_scuro,
                                          fontSize: 16
                                      ),),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        validator: (value){
                                          if(value!.isEmpty || !RegExp(r'^0x').hasMatch(value)){
                                            setState(() {
                                              _venditore.text="";
                                            });
                                            return "Enter Correct Address";
                                          }else{
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: Colori.verde_scuro),
                                        cursorColor: Colori.verde_scuro,
                                        controller: _venditore,
                                        decoration: InputDecoration(
                                          border:OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colori.verde_scuro)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colori.verde_scuro,width: 2)
                                          ),
                                          prefixIcon: Icon(Icons.storefront,color: Colori.grigio,),
                                          suffixIcon: GestureDetector(
                                              onTap: () async {
                                                var barcodeScanRes="";
                                                try {
                                                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                      '#ff6666', 'Cancel', true, ScanMode.QR);
                                                } on PlatformException {
                                                  barcodeScanRes = 'Failed to get platform version.';
                                                }
                                                setState(() {
                                                  _venditore.text=barcodeScanRes;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(left: BorderSide(width: 1))
                                                ),
                                                child: Icon(Icons.qr_code,color: Colors.black,),
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text("Acquirente",style: TextStyle(
                                          color: Colori.verde_scuro,
                                          fontSize: 16
                                      ),),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        validator: (value){
                                          if(value!.isEmpty || !RegExp(r'^0x').hasMatch(value)){
                                            setState(() {
                                              _acquirente.text="";
                                            });
                                            return "Enter Correct Address";
                                          }else{
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: Colori.verde_scuro),
                                        cursorColor: Colori.verde_scuro,
                                        controller: _acquirente,
                                        decoration: InputDecoration(
                                          border:OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colori.verde_scuro)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colori.verde_scuro,width: 2)
                                          ),
                                          prefixIcon: Icon(Icons.shopping_bag_outlined,color: Colori.grigio,),
                                          suffixIcon: GestureDetector(
                                              onTap: () async {
                                                var barcodeScanRes="";
                                                try {
                                                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                      '#ff6666', 'Cancel', true, ScanMode.QR);
                                                } on PlatformException {
                                                  barcodeScanRes = 'Failed to get platform version.';
                                                }
                                                setState(() {
                                                  _acquirente.text=barcodeScanRes;
                                                });
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(left: BorderSide(width: 1))
                                                  ),
                                                  child: Icon(Icons.qr_code,color: Colors.black,)
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text("Prezzo",style: TextStyle(
                                          color: Colori.verde_scuro,
                                          fontSize: 16
                                      ),),
                                      SizedBox(height: 10,),
                                      TextFormField(
                                        validator: (value){
                                          if(value!.isEmpty){
//allow upper and lower case alphabets and space
                                            return "Enter Price";
                                          }else if(!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(value))
                                           {
                                             setState(() {
                                               _prezzo.text="";
                                             });
                                             return "Insert a valid number";
                                           }
                                          else{
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(color: Colori.verde_scuro),
                                        cursorColor: Colori.verde_scuro,
                                        controller: _prezzo,
                                        decoration: InputDecoration(
                                          border:OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colori.verde_scuro)
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colori.verde_scuro,width: 2)
                                          ),
                                          prefixIcon: Icon(Icons.payments_outlined,color: Colori.grigio,),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              SizedBox(height: 40),
                              Center(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colori.verde_scuro),
                                        padding: MaterialStateProperty.all(EdgeInsets.only(left:50,right: 50,top: 25,bottom: 25))
                                    ),
                                    onPressed: ()async {
                                      if(formKey.currentState!.validate()){
                                        String prezzo="";
                                        String tipo="";
                                         if(int.tryParse(_prezzo.text)!= null)
                                         {
                                            tipo="int";
                                            prezzo="${_prezzo.text}000000000000000000";
                                         }
                                         else if(double.tryParse(_prezzo.text)!= null)
                                         {
                                             tipo="double";
                                             num prezzo_d= (num.parse(_prezzo.text));
                                             prezzo=(prezzo_d*100).toInt().toString();
                                             prezzo="${prezzo}000000000000000000";
                                         }


                                         int code=await Crea_Transazione(_venditore.text, _acquirente.text, prezzo, "0.82","Emessa",tipo);
                                        if(code==202)
                                        {
                                          setState(() {
                                            _venditore.text="";
                                            _acquirente.text="";
                                            _prezzo.text="";
                                            tr=getTransazioni(address).then((value) => transazioni=value);
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colori.verde_scuro,
                                              content: const Text('Transazione Aggiunta'),
                                            ),
                                          );
                                          Future.delayed(Duration(seconds: 2),() async{
                                            Navigator.of(context).pop();
                                          });
                                        }
                                        else
                                        {
                                          setState(() {
                                            _venditore.text="";
                                            _acquirente.text="";
                                            _prezzo.text="";
                                          });
                                          //Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: const Text('Errore nella transazione'),
                                            ),
                                          );

                                        }
                                      }

                                    },
                                    child: Text("Salva",style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black
                                    ),)),
                              )

                            ]
                        ),
                      )


                  )
              )
            );
          }
          ),

        );

      },
    );
  }



}