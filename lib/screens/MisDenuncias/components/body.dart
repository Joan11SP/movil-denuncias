import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movil_denuncias/screens/MisDenuncias/controller_misdenuncias.dart';
import 'package:movil_denuncias/size_config.dart';

class MisDenunciasBody extends StatefulWidget {
  @override
  _MisDenunciasState createState() => _MisDenunciasState();
}

class _MisDenunciasState extends State<MisDenunciasBody> {
  var denuncias = [];

  getDenuncias() async {
    try {
      denuncias = await buscarDenuncias(context);
      if (mounted) {
        setState(() {
          return denuncias;
        });
      }
    } on Exception catch (e) {}
  }

  mostrarDenuncias() {
    if (denuncias != null && denuncias.length > 0) {
      return ListView.builder(
        itemCount:denuncias.length,
        itemBuilder: (context, int i) {
          return Row(
            children: <Widget>[
              Container(
                  height: 120,
                  child: Image.network(denuncias[i]['imagenes'][0]) // Edit this
                  ),
              Expanded(
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(denuncias[i]['descripcion'], // Edit this
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Expanded(
                          child: Text(denuncias[i]['fecha'] +
                              " " +
                              denuncias[i]['hora'])) // Edit this
                    ],
                  ),
                ),
              )
            ],
          );
        },
      );
    } else {
      return Center(child: Text('Aun no has denunciado'));
    }
  }

  @override
  Widget build(BuildContext context) {
    getDenuncias();
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(50)),
      child: Card(elevation: 4, child: mostrarDenuncias()),
    );
  }
}
