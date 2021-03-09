import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

String session = 'perfil';
String ubicacionDenuncia = 'denuncia';
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

guardarPerfil(String id) async {
  final shared = await _prefs;
  shared.setString(session, id);
}

obtenerPerfil() async {
  final shared = await _prefs;
  return shared.getString(session);
}
guardarUbicacionDenuncia(Map ubicacion) async {
  final shared = await _prefs;
  shared.setString(ubicacionDenuncia, json.encode(ubicacion));
}
obtenerUbicacionDenuncia() async {
  final shared = await _prefs;
  return shared.getString(ubicacionDenuncia);
}
removeObtenerUbicacion() async {
  final shared = await _prefs;
  return shared.remove(ubicacionDenuncia);
}
