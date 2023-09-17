import 'dart:convert';
import 'captain_model.dart';
import 'boat_model.dart';

ProfileModel ProfileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String ProfileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  Captain captain;
  Boat boat;

  ProfileModel({
    required this.captain,
    required this.boat,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        captain: Captain.fromJson(json["captain"]),
        boat: Boat.fromJson(json["captain"]["boat"]),
      );

  Map<String, dynamic> toJson() => {
        "captain": captain.toJson(),
        "boat": boat.toJson(),
      };
}
