import 'package:movil_denuncias/screens/Denunciar/components/denuncia_form.dart';
import 'package:flutter/material.dart';

class DenunciaView extends StatelessWidget {
  static String routeName = '/denunciar';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Denunciar')),
      body: FormDenuncia(),    
    );
  }
}