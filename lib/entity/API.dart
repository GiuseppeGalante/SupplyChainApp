

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


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




