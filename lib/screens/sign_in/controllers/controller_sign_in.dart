import 'dart:convert';

import 'package:movil_denuncias/Api/api_persona.dart';
import 'package:movil_denuncias/Services/shared_preferences.dart';
import 'package:movil_denuncias/components/botones.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movil_denuncias/screens/profile/profile_screen.dart';

enviarLogin(data,context) async {
  try {
    http.Response response = await apiLogin(data);
    var respuestaLogin = json.decode(response.body);
    Navigator.pop(context);
    if(response.statusCode == 200 && respuestaLogin['ok'] == 1){
      await guardarPerfil(respuestaLogin['identificador']);
      Navigator.popAndPushNamed(context, ProfileScreen.routeName);
    } 
    else{
      mostrarMensaje(respuestaLogin['mensaje'], context, 3);
    }
  } on Exception catch (e) {
    print(e);
    Navigator.pop(context);
    mostrarMensaje('Vuelve a intentarlo', context, 3);
  }
}