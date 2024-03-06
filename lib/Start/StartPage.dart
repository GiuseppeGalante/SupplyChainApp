

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supply_chain_securitization/component/Address.dart';
import 'package:supply_chain_securitization/component/Colori.dart';
import 'package:supply_chain_securitization/pages/HomePage.dart';
import 'package:supply_chain_securitization/pages/HomePage_Cartolarizzatore.dart';

class StartPage extends StatefulWidget
{
  State<StatefulWidget> createState() => StartPage_State();
}

class StartPage_State extends State<StartPage>
{
  late String url;
  late String porta;
  late String address;
  late TextEditingController _url;
  late TextEditingController _port;
  late TextEditingController _address;
  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _url = new TextEditingController();
    _port = new TextEditingController();
    _address = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colori.background,
      ),
      body:SafeArea(
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
                  Text("Login", style:TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),),
                  SizedBox(height: 40),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, //Center Column contents horizontally,
                      children: [
                        Text("Url",style: TextStyle(
                            color: Colori.verde_scuro,
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
                          style: TextStyle(color: Colori.verde_scuro),
                          cursorColor: Colori.verde_scuro,
                          controller: _url,
                          decoration: InputDecoration(
                            border:OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colori.verde_scuro)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colori.verde_scuro,width: 2)
                            ),
                            prefixIcon: Icon(Icons.link,color: Colori.grigio,),
                            suffixIcon: GestureDetector(
                                onTap: () async {
                                  var barcodeScanRes="";
                                  try {
                                    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
                                  } on PlatformException {
                                    barcodeScanRes = 'Failed to get platform version.';
                                  }
                                  setState(() {
                                    _url.text=barcodeScanRes;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(left: BorderSide(width: 1))
                                  ),
                                  child: Image.asset("assets/images/barcode.png"),
                                )
                            ),

                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Port",style: TextStyle(
                            color: Colori.verde_scuro,
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
                          style: TextStyle(color: Colori.verde_scuro),
                          cursorColor: Colori.verde_scuro,
                          controller: _port,
                          decoration: InputDecoration(
                            border:OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colori.verde_scuro)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colori.verde_scuro,width: 2)
                            ),
                            prefixIcon: Icon(Icons.public_rounded,color: Colori.grigio,),
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
                                    _port.text=barcodeScanRes;
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(left: BorderSide(width: 1))
                                    ),
                                    child: Image.asset("assets/images/barcode.png")
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Address",style: TextStyle(
                            color: Colori.verde_scuro,
                            fontSize: 16
                        ),),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(color: Colori.verde_scuro),
                          cursorColor: Colori.verde_scuro,
                          controller: _address,
                          decoration: InputDecoration(
                            border:OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colori.verde_scuro)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colori.verde_scuro,width: 2)
                            ),
                            prefixIcon: Icon(Icons.account_balance_wallet,color: Colori.grigio,),
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
                                    _address.text=barcodeScanRes;
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
                        SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colori.verde_scuro),
                                  padding: MaterialStateProperty.all(EdgeInsets.only(left:100,right: 100,top: 25,bottom: 25))
                              ),
                              onPressed: ()async {
                                if(formKey.currentState!.validate()){
                                  final prefs = await SharedPreferences.getInstance();
                                  Socket.connect( _url.text, int.parse(_port.text), timeout: Duration(seconds: 2)).then((socket) async {
                                    await prefs.setString("url", _url.text);
                                    await prefs.setString("port", _port.text);
                                    await prefs.setString("address", _address.text);
                                    print(_address.text);
                                    if(_address.text==Address.creditore) {
                                      Navigator.pushReplacement(context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              HomePage(connesso: 1,
                                                address: _address.text,),
                                        ),);
                                    }
                                    if(_address.text==Address.spv)
                                      {
                                        Navigator.pushReplacement(context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                HomePage_Cartolarizzatore(connesso: 1,
                                                  address: _address.text,),
                                          ),);
                                      }
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
                                  color: Colors.black
                              ),)),
                        )
                      ],
                    ),
                  )


                ],
              )


          ),
        ),
      ),
    );
  }

}