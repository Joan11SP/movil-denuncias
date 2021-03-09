import 'dart:convert';

import 'package:movil_denuncias/constants.dart';
import 'package:http/http.dart' as http;
import 'package:movil_denuncias/models/model_Persona.dart';

apiLogin(data){  
  return http.post('$urlServicio/login-persona', body: loginToJson(data),headers: headers);
}
crearPersona(persona){
  return http.post('$urlServicio/crear-persona', body: userToJson(persona),headers: headers);
}
filtrarDenuncias(persona){
  return http.post('$urlServicio/filtrar-denuncias',body: {'id_persona':persona});
}