import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:v_mate_project/screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VmaTe',
        theme: ThemeData(
          canvasColor: Colors.blue[200],
          primarySwatch: Colors.lightBlue,
        ),
        home: FutureBuilder(builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          return Login();
        }));
  }
}
