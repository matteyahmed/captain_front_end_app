class Engines {
  int? id;
  String? boat;
  String? name;
  String? type;
  String? model;
  String? serial;
  String? status;
  int? gear;

  Engines(
      {this.id,
      this.boat,
      this.name,
      this.type,
      this.model,
      this.serial,
      this.status,
      this.gear});

  @override
  String toString() {
    return 'Engines(id: $id, name: $name, type: $type, model: $model, serial: $serial, status: $status)';
  }

  Engines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    boat = json['boat'];
    name = json['name'];
    type = json['type'];
    model = json['model'];
    serial = json['serial'];
    status = json['status'];
    gear = json['gear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['boat'] = this.boat;
    data['name'] = this.name;
    data['type'] = this.type;
    data['model'] = this.model;
    data['serial'] = this.serial;
    data['status'] = this.status;
    data['gear'] = this.gear;
    return data;
  }
}
