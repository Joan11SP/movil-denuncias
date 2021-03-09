import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movil_denuncias/screens/MisDenuncias/components/body.dart';

class MisDenuncias extends StatelessWidget {
  static String routName = '/mis_denuncias';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MisDenunciasBody(),
    );
  }
}