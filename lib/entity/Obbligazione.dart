

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref();
class Obbligazione
{
    String valore="";
    String possessore="";
    String transazione="";
    String credito="";


    Map<String, dynamic> toJson({bool hide=false})
    {
      return {
        "valore":valore,
      };
    }
}

int massimoDivisore(int num) {
  int massimoDivisore = num;

  for (int i = 2; i <= num ~/ 2; i++) {
    if (num % i == 0) {
      massimoDivisore = i;
    }
  }
  return massimoDivisore;
}


Future<int> Crea_Obbligazione(String possessore,String transazione,String id_credito,String valore)
async {
  final prefs = await SharedPreferences.getInstance();
  var a=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var link="/api/v1/namespaces/default/apis/NFTAPI/invoke/safeMint";
  var url_formattato="http://"+a+":"+p+link;
  var url = Uri.parse(url_formattato);
  String resto=id_credito+","+transazione+","+valore;
  http.Response response = await http.post(url,
    headers: <String, String>{
      'accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',},
    body: jsonEncode({
      'input': {'to':possessore,'metadata':resto}
    }),
  );
  return response.statusCode;
}







DatabaseReference saveObbligazione(obbligazione)
{
  var id= ref.child("obbligazioni").push();
  obbligazione.id = id.key;
  id.set(obbligazione.toJson());
  return id;
}

Future<List<String>> getObbligazioni(String address)
async {
  final prefs = await SharedPreferences.getInstance();
  var u=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var a=prefs.getString('address')??'0';
  var link="/api/v1/tokens/balances?limit=1000";
  var url_formattato="http://"+u+":"+p+link;
  var url = Uri.parse(url_formattato);
  List<String> index=[];
  http.Response response = await http.get(url);
  List data = jsonDecode(response.body);
  for(int i=0;i<data.length;i++) {
    
    if (data[i]['key'] == a)
      {
         await getMetadataObbligazione(data[i]['tokenIndex']).then((value) => index.add(data[i]['tokenIndex']+","+value));
      }
  }
  return index.reversed.toList();
}

Future<String> getMetadataObbligazione(String tokenId)
async {
  final prefs = await SharedPreferences.getInstance();
  var a=prefs.getString('url')??'0';
  var p=prefs.getString('port')??'0';
  var link="/api/v1/namespaces/default/apis/NFTAPI/query/getMetadata";
  var url_formattato="http://"+a+":"+p+link;
  var url = Uri.parse(url_formattato);
  http.Response response = await http.post(url,
    headers: <String, String>{
      'accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',},
    body: jsonEncode({
      'input': {'tokenId':tokenId}
    }),
  );
  var data = response.body;
  Map<String, dynamic> map = jsonDecode(data);
  String metadata="";
  if(response.statusCode==200) {
    metadata = map['output'];
  }
  return metadata;
}






