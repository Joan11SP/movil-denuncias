import 'package:movil_denuncias/Services/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

login(Map facebookprofile,context) async {
    try {
      //await guardarPerfil(facebookprofile);
  //    Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
    } on Exception catch (e) {
      print('ERROR => ${e.toString()}');
    }
    
}
