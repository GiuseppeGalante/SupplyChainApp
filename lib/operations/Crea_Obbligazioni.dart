

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supply_chain_securitization/component/Address.dart';
import 'package:supply_chain_securitization/component/AppBarApplication.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/Crediti.dart';
import 'package:supply_chain_securitization/entity/Obbligazione.dart';
import 'package:supply_chain_securitization/entity/Transazioni.dart';
import 'package:supply_chain_securitization/pages/HomePage_Cartolarizzatore.dart';

class Crea_Obbligazioni extends StatefulWidget
{
  String address="";
  List<Credito> crediti=[];
  Crea_Obbligazioni({Key? key,required this.crediti,required this.address});
  @override
  State<StatefulWidget> createState() => Crea_Obbligazioni_State(crediti:crediti,address:address);
}
class Crea_Obbligazioni_State extends State<Crea_Obbligazioni> {
  List<Credito> crediti = [];
  String address="";
  Crea_Obbligazioni_State({Key? key, required this.crediti,required this.address});

  List<Credito> crediti_ceduti = [];
  Map<Credito, bool> elenco = {};
  late Future<dynamic> l;
  final formKey = GlobalKey<FormState>();
  Credito dropdownValue=new Credito();
  int n=0;
  String intera="";
  String decimale="";
  int n_transazioni=0;
  List<int> ob_x_transazione=[];
  List<Transazione> transazioni=[];
  String valore="";
  Future<List<Credito>> leggi() async {
    for (int i = 0; i < crediti_ceduti.length; i++) {
      await getCreditoById_No_Format_Number(crediti_ceduti[i].id_credito_ceduto).then((value) {
        crediti_ceduti[i].valore = value.valore;
        crediti_ceduti[i].solvibilita = value.solvibilita;
        crediti_ceduti[i].originator=value.originator;
        crediti_ceduti[i].transazioni=value.transazioni;
      });
    }
    return crediti_ceduti;
  }
  late TextEditingController _numero_obbligazioni;
  @override
  void initState() {
    _numero_obbligazioni=new TextEditingController();
    crediti_ceduti =
        crediti.where((element) => element.stato == "Ceduto").toList();
    l = leggi().then((value) => crediti_ceduti = value);
    if(crediti_ceduti.length>0)
    dropdownValue=crediti_ceduti[0];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: l,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBarApplication(),
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color:  Colori.background,
                    ),
                    child: Padding(
                      padding:EdgeInsets.only(left: 20,top:10,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cartolarizza", style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                          ),),
                          SizedBox(height: 40),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Crediti Cartolarizzabili",style: TextStyle(
                                    color: Colori.verde_scuro,
                                    fontSize: 16
                                ),),
                                DropdownButtonFormField<Credito>(
                                  decoration: InputDecoration(
                                    border:OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colori.verde_scuro)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colori.verde_scuro,width: 2)
                                    ),
                                    prefixIcon: Icon(Icons.description_outlined,color: Colori.grigio,),
                                  ),
                                  value: dropdownValue,
                                  items: crediti
                                      .map<DropdownMenuItem<Credito>>((Credito value) {
                                    return DropdownMenuItem<Credito>(
                                      value: value,
                                      child: Text(value.id,style: TextStyle(
                                        fontSize: 14
                                      ),),
                                    );
                                  }).toList(),
                                  onChanged: (Credito? newValue) async {
                                    print(newValue?.id_credito_emesso);
                                    n=0;
                                    transazioni=[];
                                    ob_x_transazione=[];
                                    n_transazioni=0;
                                    int a=0;
                                    Transazione t1=new Transazione();
                                    n_transazioni=newValue!.transazioni.length;
                                    print("N transazioni:"+n_transazioni.toString());
                                    int pr=0;
                                    for(int j=0;j<n_transazioni;j++)
                                    {
                                      await getTransazioneById(newValue.transazioni[j]).then((value) => t1=value);
                                      transazioni.add(t1);
                                      if(t1.tipo_prezzo=="double")
                                        {
                                          int punto=t1.prezzo.indexOf(".");
                                          int lunghezza=t1.prezzo.substring(punto+1).length;
                                          if(lunghezza==2)
                                            pr=int.parse(t1.prezzo.substring(0, t1.prezzo.length - 3));
                                          if(lunghezza==1)
                                            pr = int.parse(t1.prezzo.substring(0, t1.prezzo.length - 2));

                                        } else
                                          pr=int.parse(t1.prezzo.substring(0, t1.prezzo.length));
                                      a=massimoDivisore(pr);
                                      print("a:"+a.toString());
                                      ob_x_transazione.add(a);
                                      n=n+a;

                                    }
                                    setState(() {
                                      dropdownValue = newValue!;
                                      _numero_obbligazioni.text=n.toString();

                                    });
                                  },),
                                SizedBox(height: 10),
                                Text("Numero di obbligazioni",style: TextStyle(
                                    color: Colori.verde_scuro,
                                    fontSize: 16
                                ),),
                                SizedBox(height: 10),
                                TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colori.verde_scuro),
                                  cursorColor: Colori.verde_scuro,
                                  controller: _numero_obbligazioni,
                                  decoration: InputDecoration(
                                    border:OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colori.verde_scuro)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colori.verde_scuro,width: 2)
                                    ),
                                    prefixIcon: Icon(Icons.numbers_outlined,color: Colori.grigio,),
                                  ),
                                ),

                                SizedBox(height: 40),
                                Center(
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colori.verde_scuro),
                                          padding: MaterialStateProperty.all(EdgeInsets.only(left:100,right: 100,top: 25,bottom: 25))
                                      ),
                                      onPressed: ()async {
                                        if(formKey.currentState!.validate()){
                                            int create=0;
                                            int totali=n;
                                            print(dropdownValue.tipo_valore);
                                          if(dropdownValue.tipo_valore=="int") {

                                              Obbligazione o=new Obbligazione();
                                              o.possessore=address;
                                              o.credito=dropdownValue.id;
                                                for(int j=0;j<n_transazioni;j++)
                                                {

                                                    for(int i=0;i<ob_x_transazione[j];i++)
                                                    {
                                                      valore=((int.parse(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length))/ob_x_transazione[j]).toString());
                                                      await Crea_Obbligazione(Address.spv, transazioni[j].id_transazione_emessa, dropdownValue.id_credito_emesso, valore);
                                                      //print("${i + 1}:Emesso con valore ${valore}\n");
                                                      create++;

                                                    }

                                                }

                                              if(create==totali)

                                              Crea_Credito_Cartolarizzato(dropdownValue.originator,dropdownValue.transazioni,dropdownValue.solvibilita,
                                                  dropdownValue.valore,dropdownValue.stato,dropdownValue.tipo_valore,dropdownValue.proprietario,dropdownValue.id);

                                              showDialog(
                                                  barrierDismissible: false,
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
                                                                  child:  Text("Obbligazioni Create",style: TextStyle(
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
                                                                            MaterialPageRoute(builder: (context) => HomePage_Cartolarizzatore(connesso: 1, address: address)),
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






                                          }else {
                                            Obbligazione o=new Obbligazione();
                                            o.possessore=address;
                                            o.credito=dropdownValue.id;

                                            for(int j=0;j<n_transazioni;j++)
                                              {
                                                for(int i=0;i<ob_x_transazione[j];i++)
                                                  {
                                                    if(i==0)
                                                      {
                                                        print("New Transaction");
                                                        if(transazioni[j].tipo_prezzo=="int")
                                                           decimale=".00";
                                                        else
                                                          {
                                                            int punto=transazioni[j].prezzo.indexOf(".");
                                                            int lunghezza=transazioni[j].prezzo.substring(punto+1).length;
                                                            if(lunghezza==1)
                                                              decimale=transazioni[j].prezzo.substring(transazioni[j].prezzo.length-2);
                                                            else
                                                              decimale=transazioni[j].prezzo.substring(transazioni[j].prezzo.length-2);
                                                          }

                                                        //print(transazioni[j].prezzo);

                                                        if(transazioni[j].tipo_prezzo=="int")
                                                          valore=((int.parse(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length))/ob_x_transazione[j]).toString());
                                                        if(transazioni[j].tipo_prezzo=="double")
                                                          {
                                                            int punto=transazioni[j].prezzo.indexOf(".");
                                                            int lunghezza=transazioni[j].prezzo.substring(punto+1).length;
                                                            if(lunghezza==1) {
                                                              valore=((int.parse(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length - 2))/ob_x_transazione[j])+num.parse(decimale)).toString();
                                                            }

                                                            else
                                                              valore=((int.parse(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length - 3))/ob_x_transazione[j])+(int.parse(decimale))).toString();

                                                          }

                                                        await Crea_Obbligazione(Address.spv, transazioni[j].id_transazione_emessa, dropdownValue.id_credito_emesso, valore);


                                                        //print("${i + 1}:Emesso con valore ${valore} e di ${transazioni[j].acquirente}\n");
                                                      }else {
                                                      if(transazioni[j].tipo_prezzo=="int")
                                                        valore=((int.parse(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length))/ob_x_transazione[j]).toString());
                                                      else
                                                        {
                                                          int punto=transazioni[j].prezzo.indexOf(".");
                                                          int lunghezza=transazioni[j].prezzo.substring(punto+1).length;
                                                          if(lunghezza==1) {
                                                            valore=((int.parse(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length - 2))/ob_x_transazione[j])).toString();
                                                          }

                                                          else
                                                            valore=((int.parse(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length - 3))/ob_x_transazione[j])).toString();

                                                          //valore = ((int.parse(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length - 3)) / ob_x_transazione[j])).toString();
                                                         //print(transazioni[j].prezzo.substring(0, transazioni[j].prezzo.length - 3));
                                                        }
                                                      await Crea_Obbligazione(Address.spv, transazioni[j].id_transazione_emessa, dropdownValue.id_credito_emesso, valore);

                                                         //print("${i + 1}:Emesso con valore ${valore} e di ${transazioni[j].acquirente}\n");
                                                    }

                                                    create++;




                                                  }
                                              }
                                            if(create==totali)
                                              Crea_Credito_Cartolarizzato(dropdownValue.originator,dropdownValue.transazioni,dropdownValue.solvibilita,
                                                  dropdownValue.valore,dropdownValue.stato,dropdownValue.tipo_valore,dropdownValue.proprietario,dropdownValue.id);

                                              showDialog(
                                                  barrierDismissible: false,
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
                                                                  child:  Text("Obbligazioni Create",style: TextStyle(
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
                                                                            MaterialPageRoute(builder: (context) => HomePage_Cartolarizzatore(connesso: 1, address: address)),
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
                                            }
                                        }
                                      },
                                      child: Text("Emetti",style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black
                                      ),)),
                                )


                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
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
          );;
        }
    );
  }
}