import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FacebookLogin facebookSignIn = new FacebookLogin();

Future loginFacebook(context) async {
  try {
    await facebookSignIn.logOut();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        
        final graphResponse = await http.post(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${accessToken.token}');
        final profile = json.decode(graphResponse.body);
        return profile;
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.pop(context);
        print('Login cancelled by the user.'.toUpperCase());
        break;
      case FacebookLoginStatus.error:
        print('fallo login ${result.errorMessage}');
        Navigator.pop(context);
        break;
    }
  } on Exception catch (e) {
    print('ERROR => ${e.toString()}');
  }
}