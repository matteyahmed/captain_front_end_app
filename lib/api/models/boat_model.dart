import 'trip_sheet_model.dart';
import 'engines_model.dart';

class Boat {
  int? id;
  late bool isAssigned;
  String? name;
  String? type;
  String? contact;
  String? serial;
  String? location;
  String? built_date;
  String? captain;
  List<Engines>? engines;
  List<Tripsheet>? tripsheet;

  Boat(
      {this.id,
      this.isAssigned = false,
      this.name,
      this.type,
      this.contact,
      this.serial,
      this.location,
      this.built_date,
      this.captain,
      this.engines,
      this.tripsheet});

  Boat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isAssigned = json['isAssigned'] ?? false;
    name = json['name'];
    type = json['type'];
    contact = json['contact'];
    serial = json['serial'];
    location = json['location'];
    built_date = json['built_date'];
    captain = json['captain'];

    if (json['engines'] != null) {
      engines = [];
      json['engines'].forEach((v) {
        engines!.add(new Engines.fromJson(v));
      });
    }
    if (json['tripsheet'] != null) {
      tripsheet = [];
      json['tripsheet'].forEach((v) {
        tripsheet!.add(Tripsheet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isAssigned'] = this.isAssigned;
    data['name'] = this.name;
    data['type'] = this.type;
    data['contact'] = this.contact;
    data['serial'] = this.serial;
    data['location'] = this.location;
    data['built_date'] = this.built_date;
    data['captain'] = this.captain;
    if (this.engines != null) {
      data['engines'] = this.engines?.map((v) => v.toJson()).toList();
    }
    if (this.tripsheet != null) {
      data['tripsheet'] = this.tripsheet?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
