

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supply_chain_securitization/component/AppBarApplication.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/Crediti.dart';
import 'package:supply_chain_securitization/entity/Transazioni.dart';
import 'package:supply_chain_securitization/pages/HomePage.dart';

class Raggruppa_Transazioni extends StatefulWidget
{
  List<Transazione> transazioni=[];
  String address;
  Raggruppa_Transazioni({Key? key,required this.transazioni,required this.address});
  @override
  State<StatefulWidget> createState() => Raggruppa_Transazioni_State(transazioni:transazioni,address:address);
}
class Raggruppa_Transazioni_State extends State<Raggruppa_Transazioni>
{
  List<Transazione> transazioni=[];
  List<Transazione> transazioni_attive=[];
  String address;
  Map<Transazione,bool> elenco={};
  late Future<dynamic> l;
  Raggruppa_Transazioni_State({Key? key,required this.transazioni,required this.address});

  Future<List<Transazione>> leggi()
  async{
    for(int i=0;i<transazioni_attive.length;i++) {

      await getTransazioneById(transazioni_attive[i].id_transazione_emessa).then((value) {
        transazioni_attive[i].prezzo = value.prezzo;
        transazioni_attive[i].solvibilita = value.solvibilita;
      });
    }
    return transazioni_attive;
  }

  @override
  void initState() {

    transazioni_attive=transazioni.where((element) => element.stato=="Emessa").toList();
    l=leggi().then((value) => transazioni_attive=value);
    for(int i=0;i<transazioni_attive.length;i++) {
      elenco[transazioni_attive[i]] = false;
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
                                title: Text(key.id_transazione_emessa,style: TextStyle(
                                    fontSize: 15
                                ),),
                                children: [
                                  Text("Acquirente",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Text(key.acquirente,style: TextStyle(
                                    fontSize: 15,
                                  ),),
                                  Text("Venditore",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Text(key.venditore),
                                  Text("Prezzo",style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Text(key.prezzo),
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
                          int count=elenco.values.fold(0, (prev, currentValue){
                            if(currentValue==true)
                              {
                                return prev+1;
                              }else
                                {
                                  return prev;
                                }
                          });
                          if(count>=2) {

                            List<String> transa = [];
                            List<Transazione> transazioni_scelte = [];
                            num valore = 0;
                            double valore_media = 0;
                            elenco.forEach((key, value) {
                              if (value) {
                                transa.add(key.id_transazione_emessa);
                                transazioni_scelte.add(key);
                                valore = valore + num.parse(key.prezzo);
                                valore_media = valore_media +
                                    double.parse(key.solvibilita) *
                                        double.parse(key.prezzo);
                              }
                            }
                            );

                            String solvibilita_credito = double.parse(
                                (valore_media / valore).toStringAsFixed(2))
                                .toString();
                            String valore_s = valore.toString();
                            String tipo = "";
                            if (int.tryParse(valore_s) != null) {
                              tipo = "int";
                              valore_s = "${valore_s}000000000000000000";
                            }
                            else if (double.tryParse(valore_s) != null) {
                              tipo = "double";
                              num prezzo_d=(num.parse(valore_s));
                              valore_s=(prezzo_d*100).toInt().toString();
                              valore_s = "${valore_s}000000000000000000";
                            }
                            print(tipo);

                            int code = await Crea_Credito(
                                address, transa, solvibilita_credito, valore_s,
                                "Cedibile", tipo,address);

                            if (code == 202) {
                              String prezzo_transazione = "";
                              for (int i = 0; i < transa.length; i++) {
                                if (int.tryParse(
                                    transazioni_scelte[i].prezzo) != null) {
                                  tipo = "int";
                                  prezzo_transazione = "${transazioni_scelte[i].prezzo}000000000000000000";
                                }
                                else if (double.tryParse(transazioni_scelte[i].prezzo) != null) {
                                  tipo = "double";
                                  num prezzo_d = (num.parse(
                                      transazioni_scelte[i].prezzo));
                                  prezzo_transazione = (prezzo_d * 100).toInt().toString();
                                  prezzo_transazione =
                                  "${prezzo_transazione}000000000000000000";
                                }

                                Crea_Transazione_Ragguppata(
                                    transazioni_scelte[i].venditore,
                                    transazioni_scelte[i].acquirente,
                                    prezzo_transazione,
                                    transazioni_scelte[i].solvibilita,
                                    "Cedibile",
                                    transazioni_scelte[i].id,
                                    tipo);
                              }


                              setState(() {

                              });

                              showDialog(
                                  context: context,
                                  builder: (BuildContext builder){
                                    return AlertDialog(
                                      content: Container(
                                        height: 260,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Icon(Icons.sentiment_satisfied_alt_outlined,
                                                color: Colori.verde_scuro,
                                                size: 100,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    top:40
                                                  ),
                                                child:  Text("Transazioni Raggruppate",style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                                ),),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top:40
                                                ),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).pushAndRemoveUntil(
                                                      MaterialPageRoute(builder: (context) => HomePage(connesso: 1, address: address)),
                                                        ModalRoute.withName('/')
                                                    );
                                                  },
                                                  child: Text("Torna alla Home"),
                                                )
                                              )

                                            ],
                                          )



                                        ),
                                      ),
                                    );

                                  }
                              );


                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colori.verde_scuro,
                                  content: const Text('Credito Ragguppato'),
                                ),
                              );
                            } else {
                              //Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: const Text(
                                      'Errore nella transazione'),
                                ),
                              );
                            }
                          }else
                            {
                              showDialog(
                                  context: context,
                                  builder: (context)
                                  {
                                    return AlertDialog(
                                      content: Text("Devi selezionare almeno due transazioni"),
                                    );
                                  }
                              );
                            }
                        },
                        child: Text("Raggruppa",style: TextStyle(
                            fontSize: 20,
                            color: Colors.black
                        ),)
                    )


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