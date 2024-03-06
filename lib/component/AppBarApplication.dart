import 'package:flutter/material.dart';

class AppBarApplication extends StatelessWidget implements PreferredSizeWidget
{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text("Wallet",style: TextStyle(
                  fontSize:22,
                  fontWeight: FontWeight.bold
              ),),
              Text("Connesso", style: TextStyle(
                  fontSize: 12
              ),),
            ]
        ),
      ),


      actions: [
        Padding(
            padding: EdgeInsets.only(right: 15),
          child: Container(

              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:  Image.asset("assets/images/profile.webp"),
              )
          ),
        )

      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}