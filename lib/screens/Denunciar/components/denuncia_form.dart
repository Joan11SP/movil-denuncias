import 'dart:io';
import 'dart:ui';
import 'package:movil_denuncias/Services/shared_preferences.dart';
import 'package:movil_denuncias/components/botones.dart';
import 'package:movil_denuncias/components/default_button.dart';
import 'package:movil_denuncias/constants.dart';
import 'package:movil_denuncias/helper/keyboard.dart';
import 'package:movil_denuncias/screens/MapBox/mapbox_view.dart';
import 'package:movil_denuncias/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:location/location.dart' as loc;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controller/controller_denuncias.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;

class FormDenuncia extends StatefulWidget {
  static String routName = '/denuncia-form';
  @override
  _FormDenunciaState createState() => _FormDenunciaState();
}

class _FormDenunciaState extends State<FormDenuncia> {
  var imagenes = [];
  var enviarimagenes = [];
  File imagen;
  String _hour, _minute, _time;
  String dateTime;
  final picker = ImagePicker();
  Map ubicacionDenuncia;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String descripcion;
  loc.Location location = loc.Location();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _ubicacionController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
        print('DATE $selectedDate');
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;
        _timeController.text = _time;
      });
  }

  obtenerUbicacion() async {
    var denuncia = await obtenerUbicacionDenuncia();
    if(denuncia != null){
      ubicacionDenuncia = json.decode(denuncia);
      _ubicacionController.text = ubicacionDenuncia['calles'];
      print('UBICACION DEL MAPA $ubicacionDenuncia');
      setState(() {
        return ubicacionDenuncia;
      });
    }
  }

  @override
  void initState() {
    imagenes.length = 0;
    checkGps();
    super.initState();
  }
  @override
  void dispose() {
    removeObtenerUbicacion();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    obtenerUbicacion();
    return SingleChildScrollView(
      child: Form(
        key: _formKeyDenunciar,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ListTile(
              leading: IconButton(
                  icon: SvgPicture.asset("assets/icons/calendario.svg",
                      width: 35),
                  onPressed: () {
                    _selectDate(context);
                  }),
              title: TextFormField(
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  controller: _dateController,
                  enabled: false,
                  onChanged: (String val) {
                    setState(() {
                      _dateController.text = val.toString();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  )),
            ),
            ListTile(
              leading: IconButton(
                  icon: SvgPicture.asset("assets/icons/cronometro.svg",
                      width: 35),
                  onPressed: () {
                    _selectTime(context);
                  }),
              title: TextFormField(
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
                onChanged: (String val) {
                  setState(() {
                    _timeController.text = val.toString();
                  });
                },
                onTap: () {
                  _selectTime(context);
                },
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _timeController,
                decoration: InputDecoration(
                    labelText: 'Hora',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            ListTile(
              leading: IconButton(
                  icon: SvgPicture.asset("assets/icons/Location point.svg",
                      width: 35),
                  onPressed: () async {
                    var status = await Permission.location.status;
                    if (status.isGranted) {
                      Navigator.pushNamed(context, MapaScreen.routeName);
                    } else {
                      mostrarMensaje(
                          'Habilita los permisos de almacenamiento para continuar',
                          context,
                          3);
                      pedirPersmisos();
                    }
                  }),
              title: TextFormField(
                enabled: false,
                style: TextStyle(fontSize: 15),
                onSaved: (String val) {},
                keyboardType: TextInputType.text,
                controller: _ubicacionController,
                decoration: InputDecoration(
                    labelText: 'Ubicación',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Descripción",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                onChanged: (String val) {
                  setState(() {
                    descripcion = val;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DefaultButton(
                text: "Añadir imagenes",
                press: () async {
                  if (imagenes.length < imagenesPermitidas) {
                    mostrarLoading(context);
                    var status = await Permission.storage.status;
                    if (status.isGranted) {
                      selectImageGallery();
                    } else {
                      mostrarMensaje(
                          'Habilita los permisos de almacenamiento para continuar',
                          context,
                          3);
                      pedirPersmisos();
                      Navigator.pop(context);
                    }
                  } else {
                    mostrarMensaje(
                        'Número de imagenes permitidas $imagenesPermitidas \nPresiona sobre la imagen para eliminar',
                        context,
                        3);
                  }
                },
              ),
            ),
            mostrarImagenes(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DefaultButton(
                text: "Denunciar",
                press: () {
                  KeyboardUtil.hideKeyboard(context);
                  obtnerDatosDenuncia();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  selectImageGallery() async {
    try {
      final img = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        imagen = File(img.path);
        imagenes.add(imagen);
        var extension = path.extension(imagen.path);
        print('EXTENSION $extension');
        enviarimagenes.add({'imagen': imagen.path, 'extension': extension});
      });
      Navigator.pop(context);
    } on NoSuchMethodError catch (e) {
      Navigator.pop(context);
    } on PlatformException catch (e) {
      Navigator.pop(context);
    }
  }

  mostrarImagenes() {
    return ListView.builder(
      itemCount: imagenes.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  preguntarEliminarImagen(i);
                },
                child: Image.file(imagenes[i],
                    height: getProportionateScreenHeight(150),
                    width: getProportionateScreenWidth(350)),
              )
            ],
          ),
        );
      },
    );
  }

  preguntarEliminarImagen(int i) async {
    try {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('¿Esta seguro de eliminar la imagen?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                    KeyboardUtil.hideKeyboard(context);
                  },
                ),
                FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    setState(() {
                      imagenes.removeAt(i);
                      enviarimagenes.removeAt(i);
                      Navigator.pop(context);
                      KeyboardUtil.hideKeyboard(context);
                    });
                  },
                )
              ],
            );
          });
    } on AssertionError catch (e) {
      print(e);
    }
  }

  obtnerDatosDenuncia() async {
    
    
    try {
      if(ubicacionDenuncia !=null && enviarimagenes.length>0){
        mostrarLoading(context);
        Map denuncia = {
          'id_persona': await obtenerPerfil(),
          'referencia': ubicacionDenuncia['referencia'],
          'calles': ubicacionDenuncia['calles'],
          'hora': _timeController.text,
          'fecha': _dateController.text,
          'descripcion': descripcion,
          'latitud': ubicacionDenuncia['latitud'],
          'longitud': ubicacionDenuncia['longitud']
        };
        await enviarDenuncia(denuncia, enviarimagenes, context);
      }else{
        mostrarMensaje('Agrega la información correspondiente', context, 2);
      }
    } on Exception catch (e) {
      mostrarMensaje('Vuelve a intentarloo', context, 2);
      Navigator.pop(context);
    }
  }

  Future checkGps() async {
    try {
      if (!await location.serviceEnabled()) {
        await location.requestService();
      }
    } on Exception catch (e) {
      print('ERROR $e');
    }
  }

  final _formKeyDenunciar = GlobalKey<FormState>();
}
