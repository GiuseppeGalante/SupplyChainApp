

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref();
class Transazione
{
    //late DatabaseReference id;
    String id="";
    String id_transazione_emessa="";
    String id_transazione_raggruppata="";
    String id_transazione_pagata="";
    String venditore="";
    String acquirente="";
    String prezzo="";
    String solvibilita="";
    String stato="";
    String tipo_prezzo="";


    Map<String, dynamic> toJson({bool hide=false})
    {
        return {
            "id_transazione_emessa":id_transazione_emessa,
            "id_transazione_raggruppata":id_transazione_raggruppata,
            "id_transazione_pagata":id_transazione_pagata,
            "venditore":venditore,
            "acquirente":acquirente,
            "stato":stato,
            "tipo_prezzo":tipo_prezzo,
            "id":id,
            //"id":id.key,
        };
    }

    DatabaseReference saveTransazione(transazione)
    {

        var id= ref.child("transazioni/").push();
        transazione.id = id.key;
        id.set(transazione.toJson());
        return id;
    }

    
}

Future<List<Transazione>> getTransazioni(String address) async
{
    DatabaseEvent dataSnapshot = (await ref.child('transazioni/')
        .orderByChild("venditore")
        .equalTo(address).once()) as DatabaseEvent;
    Transazione transazione;
    List<Transazione> transazioni=[];
    if(dataSnapshot.snapshot.value != null)
    {
        Map<dynamic, dynamic> values=dataSnapshot.snapshot.value as Map;
        values.forEach((key,values) async =>{
            transazione = new Transazione(),
            transazione.id_transazione_emessa=values["id_transazione_emessa"],
            transazione.id_transazione_raggruppata=values["id_transazione_raggruppata"],
            transazione.id_transazione_pagata=values["id_transazione_pagata"],
            transazione.venditore=values["venditore"],
            transazione.acquirente=values["acquirente"],
            transazione.stato=values["stato"],
            transazione.id=values["id"],
            transazioni.add(transazione),
        }
        );
    }
    return transazioni;
}

Future<int> Crea_Transazione(String venditore,String acquirente,String prezzo,String solvibilita,String stato,String tipo)
async {
    final prefs = await SharedPreferences.getInstance();
    var a=prefs.getString('url')??'0';
    var p=prefs.getString('port')??'0';
    var link="/api/v1/namespaces/default/apis/Transazioni/invoke/setTransazione";
    var url_formattato="http://"+a+":"+p+link;
    print(url_formattato);
    var url = Uri.parse(url_formattato);
    http.Response response = await http.post(url,
        headers: <String, String>{
            'accept': 'application/json',
            'Request-Timeout': '2m0s',
            'Content-Type': 'application/json',},
        body: jsonEncode({
            'input': {'venditore':venditore, 'acquirente':acquirente,'prezzo':prezzo,'solvibilita':solvibilita,'stato':stato,'tipo_prezzo':tipo}
        }),
    );
    var data = response.body;
    Map<String, dynamic> map = jsonDecode(data);
    String id;
    if(response.statusCode==202) {
        id = map['tx'];
        Transazione t=new Transazione();
        Transazione tr=new Transazione();
        t.acquirente=acquirente;
        t.venditore=venditore;
        t.stato=stato;
        t.id_transazione_emessa=id;
        t.tipo_prezzo=tipo;
        tr.saveTransazione(t);
    }

    return response.statusCode;
}

Future<int> Crea_Transazione_Ragguppata(String venditore,String acquirente,String prezzo,String solvibilita,String stato,String id_transazione_originale,String tipo_prezzo)
async {
    final prefs = await SharedPreferences.getInstance();
    var a=prefs.getString('url')??'0';
    var p=prefs.getString('port')??'0';
    var link="/api/v1/namespaces/default/apis/Transazioni/invoke/setTransazione";
    var url_formattato="http://"+a+":"+p+link;
    var url = Uri.parse(url_formattato);
    http.Response response = await http.post(url,
        headers: <String, String>{
            'accept': 'application/json',
            'Request-Timeout': '2m0s',
            'Content-Type': 'application/json',},
        body: jsonEncode({
            'input': {'venditore':venditore, 'acquirente':acquirente,'prezzo':prezzo,'solvibilita':solvibilita,'stato':stato,'tipo_prezzo':tipo_prezzo}
        }),
    );
    var data = response.body;
    Map<String, dynamic> map = jsonDecode(data);
    String id;
    if(response.statusCode==202) {
        id = map['tx'];
        Transazione t=new Transazione();
        Transazione tr=new Transazione();
        t.acquirente=acquirente;
        t.venditore=venditore;
        t.stato=stato;
        t.id_transazione_raggruppata=id;
        updateTransazione(id_transazione_originale,t.id_transazione_raggruppata,"Raggruppata");
    }

    return response.statusCode;
}



Future<Transazione> getTransazioneById(String id)
async{
    Transazione t=new Transazione();
    final prefs = await SharedPreferences.getInstance();
    var a=prefs.getString('url')??'0';
    var p=prefs.getString('port')??'0';
    var link="/api/v1/transactions/"+id+"/operations";
    var url_formattato="http://"+a+":"+p+link;
    var url = Uri.parse(url_formattato);
    http.Response response = await http.get(url);
    List list = jsonDecode(response.body);
    String pr=list[0]["input"]["input"]["prezzo"];
    t.acquirente=list[0]["input"]["input"]["acquirente"];
    t.venditore=list[0]["input"]["input"]["venditore"];
    t.tipo_prezzo=list[0]["input"]["input"]["tipo_prezzo"];

    if(t.tipo_prezzo=="int")
        t.prezzo=pr.substring(0,pr.length-18);
    else
        t.prezzo=(double.parse(pr.substring(0,pr.length-18))/100).toString();
    t.solvibilita=list[0]["input"]["input"]["solvibilita"];
    t.stato=list[0]["input"]["input"]["stato"];
    t.id_transazione_emessa=list[0]["tx"];
    return t;
}


Future<void> updateTransazione(String transazione,String id_transazione,String stato)
{
    var id_update= ref.child("transazioni/").child(transazione).update({
        'stato':stato,
        'id_transazione_raggruppata':id_transazione,
    });

    return id_update;
}

