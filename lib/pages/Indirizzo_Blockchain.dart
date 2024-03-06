
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supply_chain_securitization/component/Colori.dart';

class IndirizzoBlockchain extends StatefulWidget {
  String address="";
  IndirizzoBlockchain({Key? key,required this.address});
  @override
  State<StatefulWidget> createState() => IndirizzoBlockchain_Page(address: address);
}
class IndirizzoBlockchain_Page extends State<IndirizzoBlockchain>
{
  final formKey = GlobalKey<FormState>();
  late TextEditingController _indirizzo;
  late TextEditingController _porta;
  late Future<List<String>> future;
  String a="";
  String p="";
  String address="";
  IndirizzoBlockchain_Page({Key? key,required this.address});
  Future<List<String>> link()
  async {
    final prefs = await SharedPreferences.getInstance();
    a=prefs.getString('url')??'0.0.0.0';
    p=prefs.getString('port')??'5000';
    return [a,p];
  }
  @override
  void initState() {
    future=link();
    _indirizzo = new TextEditingController();
    _porta = new TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          backgroundColor: Colori.background,
          title: Text("Indirizzo Blockchain",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),)
      ),
      body: FutureBuilder<List<String>>(
        future: future,
        builder: (BuildContext context,
            AsyncSnapshot<List<String>> snapshot) {
          if(snapshot.hasData)
            {
              _indirizzo.text=snapshot.data!.toList()[0];
              _porta.text=snapshot.data!.toList()[1];
              return SafeArea(
                child:Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xff363062),
                  ),
                  child:Padding(
                      padding:EdgeInsets.only(left: 20,top:10,right: 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text("Indirizzo",style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty || !RegExp(r'^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$').hasMatch(value)){
                                  //allow upper and lower case alphabets and space
                                  return "Enter Correct Address";
                                }else{
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: _indirizzo,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color:Colors.white
                                ),
                                hintText: "0.0.0.0",
                                prefixIcon: Icon(Icons.public_rounded,color: Colors.white,),
                                border: InputBorder.none,
                                fillColor: Color(0xff435585),
                                filled: true,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text("Porta",style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty || !(int.parse(value)>0) || !RegExp(r'^[0-9]{1,}$').hasMatch(value)){
                                  //allow upper and lower case alphabets and space
                                  return "Enter Correct Port Number";
                                }else{
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              controller: _porta,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color:Colors.white
                                ),
                                hintText: "5000",
                                prefixIcon: Icon(Icons.public_rounded,color: Colors.white,),
                                border: InputBorder.none,
                                fillColor: Color(0xff435585),
                                filled: true,
                              ),
                            ),

                            SizedBox(height: 40),
                            Center(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Color(0xff435585)),
                                      padding: MaterialStateProperty.all(EdgeInsets.only(left:100,right: 100,top: 25,bottom: 25))
                                  ),
                                  onPressed: () async {
                                    if(formKey.currentState!.validate()){
                                      final prefs = await SharedPreferences.getInstance();
                                      Socket.connect( _indirizzo.text, int.parse(_porta.text), timeout: Duration(seconds: 2)).then((socket) async {
                                        await prefs.setString("url", _indirizzo.text);
                                        await prefs.setString("port", _porta.text);
                                        /*Navigator.pushReplacement(context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) => HomePage(connesso: 1,address: address,),
                                          ),);*/
                                        // Don't forget to close socket
                                        socket.destroy();
                                      }).catchError((error){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: const Text('Impossibile connettersi'),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  child: Text("Salva",style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                  ),)),
                            )

                          ],
                        ),
                      )



                  ),
                ) ,
              );
            }else
            {
              return Center(child: ListView(
                children: [
                  Image.asset(
                      "assets/images/qr.png", width: 200,
                      height: 88),
                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.only(left: 50,
                      right: 50),
                      child: Center(
                          child: LinearProgressIndicator())),

                ],
              )
              );
            }



        },

      )






    );
  }

}