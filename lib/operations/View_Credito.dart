


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/Crediti.dart';

class View_Credito extends StatefulWidget
{
  late String id;
  View_Credito({Key? key,required this.id});
  @override
  State<StatefulWidget> createState() => View_Credito_State(id:id);
}

class View_Credito_State extends State<View_Credito>
{
  late String id;
  late Future<Credito> tr;
  Credito c=new Credito();
  View_Credito_State({Key? key,required this.id});
  @override
  void initState() {
    tr=getCreditoById(id).then((value) => c=value);
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
                          title: Text("Credito",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          subtitle: Text(c.id_credito_emesso,style: TextStyle(
                            fontSize: 15,
                          ),),
                        ),
                        ListTile(
                          leading: Icon(Icons.storefront_outlined,size: 30,color: Colori.grigio,),
                          title: Text("Transazioni",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          subtitle: ((){
                            String transazioni="";
                             for(int i=0;i<c.transazioni.length;i++)
                               {
                                 transazioni=transazioni+c.transazioni[i]+"\n";
                               }
                             return Text(transazioni,style: TextStyle(
                               fontSize: 12,
                             ),);

                          }())
                        ),
                        ListTile(
                          leading: Icon(Icons.shopping_bag_outlined,size: 30,color: Colori.grigio,),
                          title:Text("Proprietario",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          subtitle: Text(c.originator,style: TextStyle(
                            fontSize: 15,)),
                        ),
                        ListTile(
                          leading: Icon(Icons.payments_outlined,size: 30,color: Colori.grigio,),
                          title:Text("Valore",style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          subtitle: Text(c.valore,style: TextStyle(
                              fontSize: 15
                          ),),
                        ),
                        ListTile(
                          leading: Icon(Icons.verified_outlined,size: 30,color: Colori.grigio,),
                          title:Text("Solvibilità",style:TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          subtitle: Text(c.solvibilita,style: TextStyle(
                              fontSize: 15
                          ),),
                        ),
                        ListTile(
                          leading: Icon(Icons.info_outline,size: 30,color: Colori.grigio,),
                          title:Text("Stato",style:TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                          subtitle: Text(c.stato,style: TextStyle(
                              fontSize: 15
                          ),) ,
                        )
                      ],
                    )
                ),
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