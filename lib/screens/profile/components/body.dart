import 'package:movil_denuncias/screens/Denunciar/denuncia_view.dart';
import 'package:movil_denuncias/screens/MisDenuncias/misdenuncias_screen.dart';
import 'package:movil_denuncias/size_config.dart';
import 'package:flutter/material.dart';

import 'profile_menu.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          //ProfilePic(),
          ProfileMenu(
            text: "Mi perfil",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Denunciar",
            icon: "assets/icons/denunciar.svg",
            press: () {
              Navigator.pushNamed(context, DenunciaView.routeName);
            },
          ),
          ProfileMenu(
            text: "Mis Denuncias",
            icon: "assets/icons/misdenuncias.svg",
            press: () {
              Navigator.pushNamed(context, MisDenuncias.routName);
            },
          ),
          ProfileMenu(
            text: "Ayuda",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Cerrar Sesión",
            icon: "assets/icons/Log out.svg",
            press: () {},
          ),
          Image.asset(
                  'assets/images/logo.png',
                  height: getProportionateScreenHeight(120),
                  width: getProportionateScreenWidth(150),
                ),
        ],
      ),
    );
  }
}
