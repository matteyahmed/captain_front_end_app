import 'boat_model.dart';

class Captain {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? dateOfBirth;
  String? joinedDate;
  String? terminated;
  Boat? boat;

  Captain(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.dateOfBirth,
      this.joinedDate,
      this.terminated,
      this.boat});

  Captain.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    dateOfBirth = json['date_of_birth'];
    joinedDate = json['joined_date'];
    terminated = json['terminated'];
    boat = json['boat'] != null ? new Boat.fromJson(json['boat']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['name'] = this.name;
    data['date_of_birth'] = this.dateOfBirth;
    data['joined_date'] = this.joinedDate;
    data['terminated'] = this.terminated;
    if (this.boat != null) {
      data['boat'] = this.boat?.toJson();
    }
    return data;
  }
}
