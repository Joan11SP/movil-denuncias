import 'dart:convert';
import 'package:movil_denuncias/Api/api_persona.dart';
import 'package:movil_denuncias/Services/shared_preferences.dart';
import 'package:movil_denuncias/components/botones.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

buscarDenuncias(context) async {
  try {
    String idpersona = await obtenerPerfil();
    http.Response response = await filtrarDenuncias(idpersona);
    var denuncias = json.decode(response.body);
    
    if(response.statusCode == 200){
      return denuncias['respuesta'];
    }
  } on Exception catch (e) {
    print(e);
    Navigator.pop(context);
    mostrarMensaje('Vuelve a intentarlo', context, 3);
  }
}