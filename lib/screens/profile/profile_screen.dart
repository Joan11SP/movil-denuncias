import 'package:flutter/material.dart';
import 'package:movil_denuncias/size_config.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      
      body: Padding(
        padding: EdgeInsets.only(top:getProportionateScreenHeight(100)),
        child: Body(),
      ),
      //bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
