import 'package:movil_denuncias/Controllers/controller_inicio_sesion.dart';
import 'package:movil_denuncias/components/botones.dart';
import 'package:flutter/material.dart';
import 'package:movil_denuncias/Services/facebook.dart';
import 'package:movil_denuncias/components/no_account_text.dart';
import 'package:movil_denuncias/components/socal_card.dart';
import 'package:movil_denuncias/models/model_Persona.dart';
import 'package:movil_denuncias/screens/sign_in/controllers/controller_sign_in.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Persona persona= new Persona();

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Image.asset(
                  'assets/images/mi barrio.jpeg',
                  height: getProportionateScreenHeight(150),
                  width: getProportionateScreenWidth(250),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () async {
                        mostrarLoading(context);
                        Map facebookprofile = await loginFacebook(context);
                        Map persona = {
                          'email':facebookprofile['email'],
                          'first_name':facebookprofile['first_name'],
                          'last_name':facebookprofile['last_name'],
                          'foto':facebookprofile['picture']['data']['url']
                        };

                        if(facebookprofile != null){
                          await enviarFacebook(persona,context);                          
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
