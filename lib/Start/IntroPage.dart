
import 'package:flutter/material.dart';
import 'package:supply_chain_securitization/Start/StartPage.dart';
import 'package:supply_chain_securitization/component/Colori.dart';


class IntroPage extends StatefulWidget
{
  _IntroPage createState()=>_IntroPage();
}



class _IntroPage extends State<IntroPage>
{
  int visualizzato=-1;

  late String url;
  late String porta;
  late String address;
  int connesso=-1;

  Color background=Colori.background;

  Future<void> _SaveSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      visualizzato = (prefs.getInt('visualizzato') ?? 0);
      if(visualizzato==0)
        visualizzato=1;
      prefs.setInt('visualizzato', visualizzato);
    });
  }
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }
  int pagina=0;
  PageController controller =new PageController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration:BoxDecoration(
            color: background
        ),
        child:Stack(
          children: [
            PageView(
              onPageChanged: (value)
              {
                setState(() {
                  pagina = value;
                });
              },
              controller: controller,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/images/prima_pagina.png',
                        height: 250,
                      ),
                    ),
                    SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child:Text(
                          'Benvenuto',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16.0),
                      child: Text(
                        "Quest'app ha lo scopo di risolvere la mancanza di liquidità nella supply chain.",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/images/seconda_pagina.png',
                        width: 350,
                      ),
                    ),
                    SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child:Text(
                          'Collegati alla Blockchain...',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16.0),
                      child: Text(
                        'Noi usiamo Hyperledger Firefly',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/images/terza_pagina.png',
                        height: 200,
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'E scopri le funzioni disponibili ',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16.0),
                      child: Text(
                        "Tutte offerte tramite Smart Contract e API ufficiale",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
                bottom: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget> [

                  Padding(
                  padding: EdgeInsets.only(left: 20),
                  child:
                  ElevatedButton(
                        onPressed: (){
                          _SaveSetting();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => StartPage()));
                        }, child: Text("Skip",style: TextStyle(fontSize:24, fontWeight: FontWeight.bold,color: Colors.white),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colori.grigio),
                        ),
                      ),
                  ),



                      pagina !=2 ?
                      Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: ElevatedButton(
                        onPressed: (){
                          print(controller.page);
                          if (!(controller.page == 4.0))
                            controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.linear);
                        }, child: Text("Next",style: TextStyle(fontSize:24, fontWeight: FontWeight.bold,color: Colors.white),),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colori.verde_scuro),
                        ),
                      )
                      )

                          :

                      Padding(
                        padding: EdgeInsets.only(right: 20),
                          child: ElevatedButton(
                        onPressed: (){
                          _SaveSetting();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => StartPage()));
                        }, child: Text("Finish",style: TextStyle(fontSize:24, fontWeight: FontWeight.bold,color: Colors.white),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colori.verde_scuro),
                        ),
                      )
                      ),


                    ],
                  ) ,
                )


            )

          ],
        ),
      ),
    );
  }

}