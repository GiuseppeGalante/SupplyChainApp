


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/Transazioni.dart';

class View_Transazione extends StatefulWidget
{
  late String id;
  View_Transazione({Key? key,required this.id});
  @override
  State<StatefulWidget> createState() => View_Transazione_State(id:id);
}

class View_Transazione_State extends State<View_Transazione>
{
  late String id;
  late Future<Transazione> tr;
  Transazione t=new Transazione();
  View_Transazione_State({Key? key,required this.id});
  @override
  void initState() {
    tr=getTransazioneById(id).then((value) => t=value);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tr,
        builder: (context,snapshot)
        {
          if(snapshot.hasData)
          {
            return Scaffold(
              appBar: AppBar(
                title:Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Dettaglio",style: TextStyle(
                            fontSize:22,
                            fontWeight: FontWeight.bold
                        ),),
                ),


                actions: [
                  Container(

                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:  Image.network("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                      )
                  ),
                ],
              ),
              body: Container(
                  decoration: BoxDecoration(
                      color: Colori.background
                  ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding:EdgeInsets.only(top:40),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.fingerprint,size: 30,color: Colori.grigio,),
                        title: Text("Transazione",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                        subtitle: Text(t.id_transazione_emessa,style: TextStyle(
                          fontSize: 15,
                        ),),
                      ),
                      ListTile(
                        leading: Icon(Icons.storefront_outlined,size: 30,color: Colori.grigio,),
                        title: Text("Venditore",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),),
                        subtitle: Text(t.venditore,style: TextStyle(
                          fontSize: 15,
                        ),),
                      ),
                      ListTile(
                        leading: Icon(Icons.shopping_bag_outlined,size: 30,color: Colori.grigio,),
                        title:Text("Acquirente",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                        subtitle: Text(t.acquirente,style: TextStyle(
                          fontSize: 15,)),
                      ),
                      ListTile(
                        leading: Icon(Icons.payments_outlined,size: 30,color: Colori.grigio,),
                        title:Text("Prezzo",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),),
                        subtitle: Text(t.prezzo,style: TextStyle(
                          fontSize: 15
                        ),) ,
                      ),
                      ListTile(
                        leading: Icon(Icons.verified_outlined,size: 30,color: Colori.grigio,),
                        title:Text("Solvibilità",style:TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                        subtitle: Text(t.solvibilita,style: TextStyle(
                          fontSize: 15
                        ),) ,
                      ),
                      ListTile(
                        leading: Icon(Icons.info_outline,size: 30,color: Colori.grigio,),
                        title:Text("Stato",style:TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                        subtitle: Text(t.stato,style: TextStyle(
                          fontSize: 15
                        ),) ,
                      )
                    ],
                  )
                ),
              ),
            );
          }else if (snapshot.hasError) {
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