import 'dart:convert';

Persona userFromJson(String str) => Persona.fromJson(json.decode(str));

String userToJson(Persona data) => json.encode(data.toJson());
Persona loginFromJson(String str) => Persona.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());
class Persona{

  String password;
  String firstName;
  String lastName;
  String email;
  String photo;
  int type;
  Persona({this.password,this.email,this.firstName,this.lastName,this.photo,this.type});
  
  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
        firstName: json["first_name"],
        lastName: json["last_name"],
        password: json["password"],
        email: json["email"],
        photo: json['photo']
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
        "email": email,
        "photo":photo
      };
}

class Login{

  String password;
  String email;
  Login({this.password,this.email});
  factory Login.fromJson(Map<String, dynamic> json) => Login(
        email:  json['email'],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email":email,
        "password": password,
      };
}