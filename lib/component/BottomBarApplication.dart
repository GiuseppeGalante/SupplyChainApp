
import 'package:flutter/material.dart';
import 'package:supply_chain_securitization/component/Colori.dart';

class BottomBarApplication extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.only(top:20,bottom: 20,left:50,right: 50),
      child:Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colori.grigio
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home,color: Colors.white,),
              onPressed: () {
                // Aggiungere qui l'azione da eseguire quando si seleziona l'icona Home
              },
            ),
            IconButton(
              icon: Icon(Icons.search,color: Colors.white,),
              onPressed: () {
                // Aggiungere qui l'azione da eseguire quando si seleziona l'icona Cerca
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications,color: Colors.white,),
              onPressed: () {
                // Aggiungere qui l'azione da eseguire quando si seleziona l'icona Notifiche
              },
            ),
            IconButton(
              icon: Icon(Icons.person,color: Colors.white,),
              onPressed: () {
                // Aggiungere qui l'azione da eseguire quando si seleziona l'icona Profilo
              },
            ),
          ],
        ),
      ),
    );
  }

}