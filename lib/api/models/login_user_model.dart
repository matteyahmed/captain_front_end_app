import 'dart:convert';
import 'user_model.dart';

LoginUserModel loginUserModelFromJson(String str) =>
    LoginUserModel.fromJson(json.decode(str));

String loginUserModelToJson(LoginUserModel data) => json.encode(data.toJson());

class LoginUserModel {
  DateTime expiry;
  String token;
  User user;

  LoginUserModel({
    required this.expiry,
    required this.token,
    required this.user,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) => LoginUserModel(
        expiry: DateTime.parse(json["expiry"]),
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "expiry": expiry.toIso8601String(),
        "token": token,
        "user": user.toJson(),
      };
}

// class LoginUserModel {
//   DateTime expiry;
//   String tokenKey;
//   User user;

//   LoginUserModel({
//     required this.expiry,
//     required this.tokenKey,
//     required this.user,
//   });

//   factory LoginUserModel.fromJson(Map<String, dynamic> json) => LoginUserModel(
//         expiry: DateTime.parse(json["expiry"]),
//         tokenKey: json["token_key"],
//         user: User.fromJson(json["user"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "expiry": expiry.toIso8601String(),
//         "token_key": tokenKey,
//         "user": user.toJson(),
//       };
// }
