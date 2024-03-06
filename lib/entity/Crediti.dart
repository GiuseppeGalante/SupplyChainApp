


import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref();
class Credito
{
 //late DatabaseReference id;
  String id="";
  String originator="";
  List<dynamic>transazioni=[];
  String solvibilita="";
  String stato="";
  String valore="";
  String id_credito_emesso="";
  String id_credito_pagato="";
  String id_credito_ceduto="";
  String id_credito_cartolarizzato="";
  String tipo_valore="";
  String proprietario="";

  Map<String, dynamic> toJson({bool hide=false})
  {
    return {
      "id_credito_emesso":id_credito_emesso,
      "id_credito_ceduto":id_credito_ceduto,
      "id_credito_pagato":id_credito_pagato,
      "tipo_valore":tipo_valore,
      "stato":stato,
      "id":id,
    };
  }
}

Future<int> Crea_Credito(String originator,List<dynamic> transazioni,String solvibilita,String valore,String stato,String tipo,String proprietario)
async {
  final prefs = await SharedPreferences.getInstance();
  var a=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var link="/api/v1/namespaces/default/apis/Crediti/invoke/salva_credito";
  var url_formattato="http://"+a+":"+p+link;
  var url = Uri.parse(url_formattato);
  http.Response response = await http.post(url,
    headers: <String, String>{
      'accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',},
    body: jsonEncode({
      'input': {'elenco_transazioni':transazioni,'originator':originator,'solvibilita':solvibilita,'stato':stato,'valore':valore,"tipo_valore":tipo,"proprietario":proprietario}
    }),
  );
  var data = response.body;
  Map<String, dynamic> map = jsonDecode(data);
  String id;
  if(response.statusCode==202) {
    id = map['tx'];
    Credito c=new Credito();
    c.id_credito_emesso=id;
    c.id_credito_pagato="";
    c.id_credito_ceduto="";
    c.tipo_valore=tipo;
    c.stato=stato;
    saveCredito(c);
  }

  return response.statusCode;
}


Future<int> Crea_Credito_Ceduto(String originator,List<dynamic> transazioni,String solvibilita,String valore,String stato,String tipo,String proprietario,String id_credito_originale)
async {
  final prefs = await SharedPreferences.getInstance();
  var a=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var link="/api/v1/namespaces/default/apis/Crediti/invoke/salva_credito";
  var url_formattato="http://"+a+":"+p+link;
  var url = Uri.parse(url_formattato);
  http.Response response = await http.post(url,
    headers: <String, String>{
      'accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',},
    body: jsonEncode({
      'input': {'elenco_transazioni':transazioni,'originator':originator,'solvibilita':solvibilita,'stato':stato,'valore':valore,"tipo_valore":tipo,"proprietario":proprietario}
    }),
  );
  var data = response.body;
  Map<String, dynamic> map = jsonDecode(data);
  String id;
  if(response.statusCode==202) {
    id = map['tx'];
    Credito c=new Credito();
    c.id_credito_pagato="";
    c.id_credito_ceduto=id;
    c.tipo_valore=tipo;
    c.stato=stato;
    updateCredito(id_credito_originale,"Ceduto",c.id_credito_ceduto);
  }

  return response.statusCode;
}

Future<int> Crea_Credito_Cartolarizzato(String originator,List<dynamic> transazioni,String solvibilita,String valore,String stato,String tipo,String proprietario,String id_credito_originale)
async {
  final prefs = await SharedPreferences.getInstance();
  var a=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var link="/api/v1/namespaces/default/apis/Crediti/invoke/salva_credito";
  var url_formattato="http://"+a+":"+p+link;
  var url = Uri.parse(url_formattato);
  http.Response response = await http.post(url,
    headers: <String, String>{
      'accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',},
    body: jsonEncode({
      'input': {'elenco_transazioni':transazioni,'originator':originator,'solvibilita':solvibilita,'stato':stato,'valore':valore,"tipo_valore":tipo,"proprietario":proprietario}
    }),
  );
  var data = response.body;
  Map<String, dynamic> map = jsonDecode(data);
  String id;
  if(response.statusCode==202) {
    id = map['tx'];
    Credito c=new Credito();
    c.id_credito_pagato="";
    c.id_credito_cartolarizzato=id;
    c.tipo_valore=tipo;
    c.stato=stato;
    updateCredito_Cartolarizzato(id_credito_originale,"Cartolarizzato",c.id_credito_cartolarizzato);
  }

  return response.statusCode;
}






DatabaseReference saveCredito(credito)
{

  var id= ref.child("crediti").push();
  credito.id = id.key;
  id.set(credito.toJson());
  return id;
}

Future<List<Credito>> getCrediti(String stato) async
{
  List<Credito> crediti=[];
 DatabaseEvent dataSnapshot = (await ref.child('crediti/')
      .orderByChild("stato")
      .equalTo(stato).once()) as DatabaseEvent;
  Credito credito;
  if(dataSnapshot.snapshot.value != null)
  {
    Map<dynamic, dynamic> values=dataSnapshot.snapshot.value as Map;
    values.forEach((key,values) async =>{
      credito = new Credito(),
      credito.id_credito_emesso=values["id_credito_emesso"],
      credito.id_credito_pagato=values["id_credito_pagato"],
      credito.id_credito_ceduto=values["id_credito_ceduto"],
      credito.stato=values["stato"],
      credito.tipo_valore=values["tipo_valore"],
      credito.id=values["id"],
      crediti.add(credito),
    }
    );
  }
  print(crediti.length);
  return crediti;
}

Future<Credito> getCreditoById(String id)
async{
  Credito c=new Credito();
  final prefs = await SharedPreferences.getInstance();
  var a=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var link="/api/v1/transactions/"+id+"/operations";
  var url_formattato="http://"+a+":"+p+link;
  var url = Uri.parse(url_formattato);
  http.Response response = await http.get(url);
  List list = jsonDecode(response.body);
  String pr=list[0]["input"]["input"]["valore"];
  c.transazioni=list[0]["input"]["input"]["elenco_transazioni"];
  c.originator=list[0]["input"]["input"]["originator"];
  c.solvibilita=list[0]["input"]["input"]["solvibilita"];
  c.valore=list[0]["input"]["input"]["valore"];
  c.tipo_valore=list[0]["input"]["input"]["tipo_valore"];
  if(c.tipo_valore=="int")
    c.valore=pr.substring(0,pr.length-18);
  else
    c.valore=(double.parse(pr.substring(0,pr.length-18))/100).toString();
  c.id_credito_emesso=list[0]["tx"];
  c.stato=list[0]["input"]["input"]["stato"];
  print(c.valore);
  return c;
}

Future<Credito> getCreditoById_No_Format_Number(String id)
async{
  Credito c=new Credito();
  final prefs = await SharedPreferences.getInstance();
  var a=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var link="/api/v1/transactions/"+id+"/operations";
  var url_formattato="http://"+a+":"+p+link;
  var url = Uri.parse(url_formattato);
  http.Response response = await http.get(url);
  List list = jsonDecode(response.body);
  c.valore==list[0]["input"]["input"]["valore"];
  c.transazioni=list[0]["input"]["input"]["elenco_transazioni"];
  c.originator=list[0]["input"]["input"]["originator"];
  c.solvibilita=list[0]["input"]["input"]["solvibilita"];
  c.valore=list[0]["input"]["input"]["valore"];
  c.tipo_valore=list[0]["input"]["input"]["tipo_valore"];
  c.id_credito_emesso=list[0]["tx"];
  c.stato=list[0]["input"]["input"]["stato"];
  return c;
}




Future<void> updateCredito(String credito,String stato,String id_credito_ceduto)
{
  var id_update= ref.child("crediti/").child(credito).update({
    'stato':stato,
    'id_credito_ceduto':id_credito_ceduto,
  });

  return id_update;
}

Future<void> updateCredito_Cartolarizzato(String credito,String stato,String id_credito_cartolarizzato)
{
  var id_update= ref.child("crediti/").child(credito).update({
    'stato':stato,
    'id_credito_cartolarizzato':id_credito_cartolarizzato,
  });

  return id_update;
}

