import 'package:movil_denuncias/screens/Denunciar/denuncia_view.dart';
import 'package:movil_denuncias/screens/MapBox/mapbox_view.dart';
import 'package:flutter/widgets.dart';
import 'package:movil_denuncias/screens/MisDenuncias/misdenuncias_screen.dart';
import 'package:movil_denuncias/screens/complete_profile/complete_profile_screen.dart';
import 'package:movil_denuncias/screens/forgot_password/forgot_password_screen.dart';
import 'package:movil_denuncias/screens/otp/otp_screen.dart';
import 'package:movil_denuncias/screens/profile/profile_screen.dart';
import 'package:movil_denuncias/screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/Denunciar/components/denuncia_form.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  DenunciaView.routeName : (context) => DenunciaView(),
  FormDenuncia.routName:(context) => FormDenuncia(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  MapaScreen.routeName: (context) => MapaScreen(),
  MisDenuncias.routName: (context) => MisDenuncias()
};
