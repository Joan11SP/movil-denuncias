import 'dart:convert';
import 'dart:ui';

import 'package:movil_denuncias/Services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Map perfil;
  obtenerFoto() {
    return FutureBuilder(
      future: obtenerPerfil(),
      builder: (context, snapshot) { 
        perfil = json.decode(snapshot.data);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }else{
          if(perfil["picture"] != null){
            return 
            CircleAvatar(
              child: Image.network(perfil["picture"]['data']['url']),
            );
          }else{
            return CircleAvatar(
              backgroundImage:AssetImage("assets/images/Profile Image.png"),
            );
          }
        }
      },
    );
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          obtenerFoto(),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {},
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
