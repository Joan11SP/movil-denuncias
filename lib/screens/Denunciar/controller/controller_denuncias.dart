import 'dart:io';
import 'package:movil_denuncias/Services/shared_preferences.dart';
import 'package:movil_denuncias/screens/profile/profile_screen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:movil_denuncias/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:movil_denuncias/components/botones.dart';

pedirPersmisos() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.storage,
  ].request();
  return statuses;
}

enviarDenuncia(Map denuncia, List imagenes, context) async {
  try {
    print(imagenes);
    var req =
        http.MultipartRequest('POST', Uri.parse('$urlServicio/crear-denuncia'));
    print('$urlServicio/crear-denuncia');
    req.fields.addAll({
      'id_persona': denuncia['id_persona'].toString(),
      "hora": denuncia['hora'].toString(),
      'fecha': denuncia['fecha'].toString(),
      'descripcion': denuncia['descripcion'].toString(),
      'referencia': denuncia['referencia'].toString(),
      'calles': denuncia['calles'].toString(),
      'latitud': denuncia['latitud'].toString(),
      'longitud': denuncia['longitud'].toString()
    });
    for (var i = 0; i < imagenes.length; i++) {
      req.files.add(await http.MultipartFile.fromPath(
        'images',
        imagenes[i]['imagen'],
        contentType: MediaType('image', imagenes[i]['extension']),
      ));
    }

    http.StreamedResponse res = await req.send();
    var responseData = await res.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var respuesta = json.decode(responseString);
    mostrarMensaje(respuesta['mensaje'], context, 3);
    if (respuesta['ok'] == 1) {
      await removeObtenerUbicacion();
      Navigator.popAndPushNamed(context, ProfileScreen.routeName);
    }
  } on Exception catch (e) {
    print(e);
    mostrarMensaje('Vuelve a intentarlo', context, 2);
    Navigator.pop(context);
  }
}

