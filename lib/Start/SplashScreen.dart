



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supply_chain_securitization/Start/IntroPage.dart';
import 'package:supply_chain_securitization/Start/StartPage.dart';
import 'package:supply_chain_securitization/component/Address.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/pages/HomePage.dart';
import 'package:supply_chain_securitization/pages/HomePage_Cartolarizzatore.dart';

class SplashScreen extends StatefulWidget
{
  _SplashScreen createState()=>_SplashScreen();
}



class _SplashScreen extends State<SplashScreen>
{
  int visualizzato=-1;
  late Future<void> ready;
  late String url;
  late String porta;
  late String address;
  int connesso=-1;

  Future<void> _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {

      url = (prefs.getString('url')??'0');
      porta = (prefs.getString('port')??'0');
      address=prefs.getString('address')??'0';

      visualizzato = (prefs.getInt('visualizzato') ?? 0);
    });
  }

  Future<void> Connect() async{
    await _loadSetting().then((value) =>
        Socket.connect(
            url, int.parse(porta), timeout: Duration(seconds: 2))
            .then((socket) {
          // do what need to be done
          connesso = 1;
          // Don't forget to close socket
          socket.destroy();
        }).catchError((error) {
          connesso = 0;
        })
    );
  }

  void Naviga()
  {
    if(visualizzato==1 && connesso<1)
    {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => StartPage()));
    }
    if(connesso==1 && visualizzato==1)
    {
      if(address==Address.creditore) {
        Navigator.pushReplacement(context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                HomePage(connesso: 1,
                  address: address),
          ),);
      }
      if(address==Address.spv)
      {
        Navigator.pushReplacement(context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                HomePage_Cartolarizzatore(connesso: 1,
                  address: address,),
          ),);
      }
    }
    if(visualizzato<1 && connesso<1)
    {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => IntroPage()));
    }
  }
  @override
  void initState() {
    super.initState();
    /*_loadSetting().whenComplete(() =>
        Connect().whenComplete(() => Naviga()));*/

    ready=_loadSetting().then((value) => Connect().then((value) => Naviga()));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colori.background,
          ),
          child: FutureBuilder(
              future: ready,
              builder: (context,snapshot)
              {
                if(snapshot.hasData)
                {
                  return Text("");
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
                return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Image.asset("assets/images/logo.png",width: 200, height: 88,),
                    Icon(Icons.wallet_outlined,color: Colors.white,size: 100,),
                    SizedBox(height: 20,),
                    Padding(padding: EdgeInsets.only(left: 50,
                        right: 50),
                        child: Center(
                            child: CircularProgressIndicator(color: Colors.white,))),

                  ],
                )
                );

              }
          ),
        ),
      ),
    );











  }

}