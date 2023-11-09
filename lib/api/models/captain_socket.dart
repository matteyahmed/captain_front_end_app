class SocketCaptain {
  CaptainSocket? captain;

  SocketCaptain({this.captain});

  SocketCaptain.fromJson(Map<String, dynamic> json) {
    captain =
        json['captain'] != null ? new CaptainSocket.fromJson(json['captain']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.captain != null) {
      data['captain'] = this.captain!.toJson();
    }
    return data;
  }
}

class CaptainSocket {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? dateOfBirth;
  String? joinedDate;
  String? terminated;
  String? boat;

  CaptainSocket(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.dateOfBirth,
      this.joinedDate,
      this.terminated,
      this.boat});

  CaptainSocket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    dateOfBirth = json['date_of_birth'];
    joinedDate = json['joined_date'];
    terminated = json['terminated'];
    boat = json['boat'];
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
    data['boat'] = this.boat;
    return data;
  }
}
