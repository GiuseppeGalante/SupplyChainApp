

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> Leggi_Tutto()
async {
  var url = Uri.parse('http://192.168.143.12:5000/api/v1/namespaces/default/apis/gas_6/query/getVoti');
  http.Response response = await http.post(url,
    headers: <String, String>{
       'accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',},
    body: jsonEncode({
      'input': {'i':'0'}
    }),
  );
  var data = jsonDecode(response.body);
  var data_f=data["output"];
  return data_f;
}

Future<int> Scrivi(String p,String s,int v)
async {
  var url = Uri.parse('http://192.168.143.12:5000/api/v1/namespaces/default/apis/gas_6/invoke/setVoto');
  http.Response response = await http.post(url,
    headers: <String, String>{
      'accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',},
    body: jsonEncode({
      'input': {'p':p.toString(), 's':s.toString(),'voto':v.toString()}
    }),
  );
  var data = response.statusCode;
  return data;
}

Future<int> Invia_Messaggio_Privato(String message,String to)
async {
  final prefs = await SharedPreferences.getInstance();
  var a=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var link="/api/v1/messages/private";
  var url_formattato="http://"+a+":"+p+link;
  var url = Uri.parse(url_formattato);
  http.Response response = await http.post(url,
    headers: <String, String>{
      'accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',},
    body: jsonEncode({
      'data':[{'value':message.toString()}],'group': {"members":[{'identity':to.toString()}]}
    }),
  );
  var data = response.statusCode;
  return data;
}

Future<String> getBalance(String address)
async {
  /*final prefs = await SharedPreferences.getInstance();
  var u=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var a=prefs.getString('address')??'0';
  var link="/api/v1/tokens/balances";
  var url_formattato="http://"+u+":"+p+link;
  var url = Uri.parse(url_formattato);
  http.Response response = await http.get(url);
  List data = jsonDecode(response.body);
  String data_f="0";

  for(int i=0;i<data.length;i++) {
    if (data[i]['key'] == a)
      data_f = data[i]['balance'];
  }
  return data_f;*/
  return "0";
}




