import 'dart:async';

import 'package:movil_denuncias/Services/shared_preferences.dart';
import 'package:movil_denuncias/components/default_button.dart';
import 'package:movil_denuncias/constants.dart';
import 'package:movil_denuncias/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../../components/botones.dart';
import 'package:location/location.dart' as loc;

class BodyMapa extends StatefulWidget {
  @override
  _BodyMapaState createState() => _BodyMapaState();
}

class _BodyMapaState extends State<BodyMapa> {
  MapboxMapController mapController;
  double latitud, longitud,markerLatitud,markerLongitud;
  String referencias,calles;
  bool gpsActivado = false;
  String marker = 'assets/images/ubi2.png';
  loc.Location location = loc.Location();

  position() {
    try {
      location.onLocationChanged.listen((loc.LocationData currentLocation) {
        
        if (mounted) {
          setState(() {            
            print(currentLocation.latitude);
            print(currentLocation.longitude);
            latitud = currentLocation.latitude;
            longitud = currentLocation.longitude;
          });
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future checkGps() async {
    try {
      if (!await location.serviceEnabled()) {
        await location.requestService();
        if(await location.serviceEnabled()){
          setState(() {
            gpsActivado = true;
            position();
          });
        }
      } else {
        setState(() {
          gpsActivado = true;
          return position();
        });
      }
      
    } on Exception catch (e) {
      print('ERROR $e');
    }
  }

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  @override
  void dispose() {
    if (latitud != null) {
      mapController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return latitud == null
        ? Padding(
            padding: EdgeInsets.all(20),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                gpsActivado==false
                ? DefaultButton(
                  text: 'Activar ubicación',
                  press: () async {
                    await checkGps();
                  },
                )
                : Center(child: CircularProgressIndicator(strokeWidth: 1))
              ],
            )),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: viewMap(),
                  height: getProportionateScreenHeight(500),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                escribirUbicacion()
              ],
            ),
          );
  }

  addSymbolMap([coordinates]) async {
    mapController.addSymbol(SymbolOptions(
        zIndex: 1,
        geometry: LatLng(
            coordinates.latitude,
            coordinates
                .longitude), // location is 0.0 on purpose for this example
        iconImage: marker,
        iconSize: 0.25));
    await mapController.clearSymbols();
  }

  viewMap() {
    return MapboxMap(
      onStyleLoadedCallback: () {
        mapController.addSymbol(SymbolOptions(
            geometry: LatLng(latitud, longitud),
            iconImage: marker,
            iconSize: 0.25,
            iconColor: 'blue'));
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(latitud, longitud), zoom: 16.5),
      styleString: MapboxStyles.MAPBOX_STREETS,
      compassEnabled: false,
      rotateGesturesEnabled: false,
      onMapClick: (point, coordinates) {
        addSymbolMap(coordinates);
        setState(() {
          markerLatitud = coordinates.latitude;
          markerLongitud = coordinates.longitude;          
        });
      },
      onMapCreated: onMapCreated,
    );
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  escribirUbicacion() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 8, right: 8),
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.black87),
            decoration:
                InputDecoration(hintText: "Calles", focusColor: kPrimaryColor),
            onChanged: (String valor) {
              setState(() {
                calles = valor;
              });
            },
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          TextFormField(
            maxLines: 1,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                hintText: "Referencia", focusColor: kPrimaryColor),
            onChanged: (String valor) {
              setState(() {
                referencias = valor;
              });
            },
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          RaisedButton(
              //color: kPrimaryColor,
              textColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text('Continuar'),
              onPressed: () {
                obtenerDatosUbicacion();
              }),
        ],
      ),
    );
  }

  obtenerDatosUbicacion() async {

    if (latitud != null && longitud != null && referencias != null && calles != null) {
      Map ubicacion = {
        'latitud': markerLatitud == null ? latitud : markerLatitud,
        'longitud': markerLongitud == null ? longitud: markerLongitud,
        'referencia': referencias,
        'calles': calles
      };
      await guardarUbicacionDenuncia(ubicacion);
      if(markerLatitud!=null){
        mostrarMensaje('Se tomó la posición marcada en el mapa', context, 3);
      }
      Navigator.pop(context);
    } else {
      mostrarMensaje('Llena los campos', context, 3);
    }
  }
}
