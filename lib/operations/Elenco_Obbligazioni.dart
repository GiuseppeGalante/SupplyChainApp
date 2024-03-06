


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supply_chain_securitization/component/AppBarApplication.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/entity/Obbligazione.dart';

class Elenco_Obbligazioni extends StatefulWidget
{
  String address="";

  Elenco_Obbligazioni({Key? key,required this.address});
  @override
  State<StatefulWidget> createState() => Elenco_Obbligazioni_State(address: address);

}
class Elenco_Obbligazioni_State extends State<Elenco_Obbligazioni>
{
     late Future<List<String>> ob;
     List<String> obbligazioni=[];
     String address="";
     Elenco_Obbligazioni_State({Key? key,required this.address});

  void initState() {
    ob=getObbligazioni(address).then((value) => obbligazioni=value);
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBarApplication(),
      body: Padding(
        padding: EdgeInsets.only(top:15),
        child: FutureBuilder(
            future: ob,
            builder: (context,snapshot)
            {
              if(snapshot.hasData)
              {
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemCount: obbligazioni.length,
                    itemBuilder: (BuildContext ctx, index)
                    {
                      return GestureDetector(
                        onTap: (){
                          print(obbligazioni[index].split(",")[0].toString());
                        },
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage("assets/images/nft.webp"),
                              height: 50,),
                            SizedBox(height: 5,),
                            Column(
                              children: [
                                Text("#"+index.toString(),style: TextStyle(
                                    fontSize: 20
                                ),),
                                ((){
                                  return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:[
                                        Text("Valore:",style:TextStyle(
                                            fontSize: 15
                                        )),
                                        Text(" "+obbligazioni[index].split(",")[3].toString(),style:TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ))
                                      ]
                                  );

                                }()),
                                /*Text("Valore"+obbligazioni[index].split(",")[0],style: TextStyle(
                                 fontSize: 20
                             ),)*/
                              ],
                            ),


                          ],
                        ),
                      );




                      /*Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image:DecorationImage(
                              image: NetworkImage("https://cdn.pixabay.com/photo/2021/11/26/10/45/nft-6825614_1280.png")
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(obbligazioni[index]),
                      );*/
                    }
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
                          Padding(padding: EdgeInsets.only(left: 50, right: 50),
                              child: Center(
                                  child: CircularProgressIndicator(color: Colori.verde_scuro))),
                          SizedBox(height: 20,),
                          Text("Carico le obbligazioni")


                        ],

                      ),
                    ),
                  ),
                ),
              );



            }
        ),
      ),
    );

  }
}