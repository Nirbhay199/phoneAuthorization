import 'package:flutter/material.dart';
class Homepage extends StatelessWidget {
  const Homepage({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child:RaisedButton(onPressed:(){
        Navigator.pop(context);
      } ,
      child: Text("LogOut"),
      ),),
    );
  }
}