

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:supply_chain_securitization/component/AppBarApplication.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/Crediti.dart';
import 'package:supply_chain_securitization/pages/HomePage.dart';

class Cedi_Credito extends StatefulWidget
{
  String address;
  List<Credito> crediti=[];
  Cedi_Credito({Key? key,required this.crediti,required this.address});
  @override
  State<StatefulWidget> createState() => Cedi_Credito_State(credito_cedibile:crediti,address: address);
}

class Cedi_Credito_State extends State<Cedi_Credito>
{
  List<Credito> credito_cedibile=[];
  String address;
  Map<Credito,bool> elenco={};
  late Future<dynamic> l;
  late Future<List<Credito>> cr;
  late Future value;
  final formKey = GlobalKey<FormState>();
  late TextEditingController _possessore;
  Cedi_Credito_State({Key? key,required this.credito_cedibile,required this.address});

  Future<List<Credito>> leggi()
  async{
    for(int i=0;i<credito_cedibile.length;i++) {
      await getCreditoById_No_Format_Number(credito_cedibile[i].id_credito_emesso).then((value) {
        credito_cedibile[i].valore = value.valore;
        credito_cedibile[i].solvibilita = value.solvibilita;
        credito_cedibile[i].originator=value.originator;
        credito_cedibile[i].transazioni=value.transazioni;
      });
    }
    return credito_cedibile;
  }

  @override
  void initState() {
    _possessore = new TextEditingController();
    l=leggi().then((value) => credito_cedibile=value);
    for(int i=0;i<credito_cedibile.length;i++) {
      elenco[credito_cedibile[i]] = false;
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBarApplication(),
        body: FutureBuilder(
            future: l,
            builder: (BuildContext context, snapshot) {
              if(snapshot.hasData)
              {
                return Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height/1.4
                      ),
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: elenco.keys.map((key)
                          {
                            return new CheckboxListTile(
                              activeColor: Colori.verde_scuro,
                              hoverColor: Colori.verde_scuro,
                              value: elenco[key],
                              title:ExpansionTile(
                                iconColor: Colori.verde_scuro,
                                collapsedIconColor: Colori.verde_scuro,
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                title: Text(key.id_credito_emesso,style: TextStyle(
                                    fontSize: 15
                                ),),
                                children: [
                                  Text("Acquirente",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Text(key.originator,style: TextStyle(
                                    fontSize: 15,
                                  ),),
                                  Text("Prezzo",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                  ((){
                                    String v="";
                                    if(key.tipo_valore=="int")
                                      v=key.valore.substring(0,key.valore.length-18);
                                    else
                                      v=(double.parse(key.valore.substring(0,key.valore.length-18))/100).toString();
                                    return Text(v);
                                  }()),

                                  Text("Solvibilià",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Text(key.solvibilita)
                                ],
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  elenco[key]=value!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,

                            ); }).toList()
                      ),
                    ),

                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colori.verde_scuro),
                            padding: MaterialStateProperty.all(EdgeInsets.only(left:50,right: 50,top: 25,bottom: 25))
                        ),
                        onPressed: () async {
                          int count = elenco.values.fold(
                              0, (prev, currentValue) {
                            if (currentValue == true) {
                              return prev + 1;
                            } else {
                              return prev;
                            }
                          });
                          if (count == 1) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: AlertDialog(
                                          content: Container(
                                              height: 250,
                                              child: Form(
                                                key: formKey,
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Expanded(
                                                        child: ListView(
                                                            shrinkWrap: true,
                                                            children: [
                                                              Text(
                                                                "Nuovo prossessore:",
                                                                style: TextStyle(
                                                                    color: Colori
                                                                        .verde_scuro,
                                                                    fontSize: 16
                                                                ),),
                                                              SizedBox(
                                                                  height: 10),
                                                              TextFormField(
                                                                validator: (value) {
                                                                  if (value!
                                                                      .isEmpty ||
                                                                      !RegExp(
                                                                          r'^0x').hasMatch(value)) {
                                                                    setState(() {
                                                                      _possessore.text = "";
                                                                    });
                                                                    return "Enter Correct Address";
                                                                  } else {
                                                                    return null;
                                                                  }
                                                                },
                                                                keyboardType: TextInputType
                                                                    .text,
                                                                style: TextStyle(
                                                                    color: Colori
                                                                        .verde_scuro),
                                                                cursorColor: Colori
                                                                    .verde_scuro,
                                                                controller: _possessore,
                                                                decoration: InputDecoration(
                                                                  border: OutlineInputBorder(),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colori.verde_scuro)
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colori.verde_scuro,
                                                                          width: 2)
                                                                  ),
                                                                  prefixIcon: Icon(
                                                                    Icons.person_2_outlined,
                                                                    color: Colori.grigio,),
                                                                  suffixIcon: GestureDetector(
                                                                      onTap: () async {
                                                                        var barcodeScanRes = "";
                                                                        try {
                                                                          barcodeScanRes =
                                                                          await FlutterBarcodeScanner
                                                                              .scanBarcode(
                                                                              '#ff6666',
                                                                              'Cancel',
                                                                              true,
                                                                              ScanMode
                                                                                  .QR);
                                                                        } on PlatformException {
                                                                          barcodeScanRes =
                                                                          'Failed to get platform version.';
                                                                        }
                                                                        setState(() {
                                                                          _possessore
                                                                              .text =
                                                                              barcodeScanRes;
                                                                        });
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            border: Border(
                                                                                left: BorderSide(
                                                                                    width: 1))
                                                                        ),
                                                                        child: Icon(
                                                                          Icons
                                                                              .qr_code,
                                                                          color: Colors
                                                                              .black,),
                                                                      )
                                                                  ),
                                                                ),
                                                              ),

                                                            ]
                                                        ),
                                                      ),
                                                      SizedBox(height: 40),
                                                      Center(
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty
                                                                    .all(Colori
                                                                    .verde_scuro),
                                                                padding: MaterialStateProperty
                                                                    .all(
                                                                    EdgeInsets
                                                                        .only(
                                                                        left: 50,
                                                                        right: 50,
                                                                        top: 25,
                                                                        bottom: 25))
                                                            ),
                                                            onPressed: () async {
                                                              if (formKey.currentState!.validate()) {
                                                                List<Credito> crediti_scelti = [];
                                                                elenco.forEach((key, value) {
                                                                  if (value) {
                                                                    crediti_scelti.add(key);
                                                                  }
                                                                });
                                                                int code = await Crea_Credito_Ceduto(address, crediti_scelti[0].transazioni,
                                                                    crediti_scelti[0].solvibilita, crediti_scelti[0].valore, "Ceduto",
                                                                    crediti_scelti[0].tipo_valore, _possessore.text, crediti_scelti[0].id);
                                                                if (code == 202) {
                                                                  setState(() {
                                                                    _possessore.text = "";
                                                                  });
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar( backgroundColor: Colori.verde_scuro,
                                                                      content: const Text('Credito Ceduto'),
                                                                    ),
                                                                  );
                                                                  Future.delayed(
                                                                      Duration(seconds: 2), () async {
                                                                    Navigator.of(context).pushAndRemoveUntil(
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                HomePage(connesso: 1, address: address)),
                                                                        ModalRoute.withName('/')
                                                                    );
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    _possessore.text = "";
                                                                  });
                                                                  ScaffoldMessenger.of(
                                                                      context).showSnackBar(
                                                                    SnackBar(
                                                                      backgroundColor: Colors.red,
                                                                      content: const Text(
                                                                          'Errore nella transazione'),
                                                                    ),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            child: Text("Invia",
                                                              style: TextStyle(
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
                            );
                          }else
                          {
                            showDialog(
                                context: context,
                                builder: (context)
                                {
                                  return AlertDialog(
                                    content: Text("Devi selezionare un credito"),
                                  );
                                }
                                );
                          }
                          },
                      child: Text("Continua",style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      )),
                            ),
                  ],
                );




              }else if(snapshot.hasError)
              {
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
                                  child: CircularProgressIndicator(color: Colori.verde_scuro))),

                        ],

                      ),
                    ),
                  ),
                ),
              );
            }
        )
    );

  }

}