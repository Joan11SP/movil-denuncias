import 'package:movil_denuncias/Services/shared_preferences.dart';
import 'package:movil_denuncias/screens/profile/profile_screen.dart';
import 'package:movil_denuncias/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:movil_denuncias/routes.dart';
import 'package:movil_denuncias/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Denuncias',
      theme: theme(),
      home: FutureBuilder(
        future: obtenerPerfil(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data != null){
              return ProfileScreen();
            }else{
              return SignInScreen();
            } 
          }else{
            return Text('');
          }       
        },
      ),
      routes: routes,
    );
  }
}
