import 'dart:io';

class FuelSheetModel {
  int? id;
  String? createdBy;
  String? boat;
  File? image; // Change this t
  String? createdDate;
  int? deliveryNoteNumber;
  int? liters;

  FuelSheetModel(
      {this.id,
      this.createdBy,
      this.boat,
      this.image,
      this.createdDate,
      this.deliveryNoteNumber,
      this.liters});

  FuelSheetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    boat = json['boat'];
    image = json['image'];
    createdDate = json['created_date'];
    deliveryNoteNumber = json['delivery_note_number'];
    liters = json['liters'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['boat'] = this.boat;
    data['image'] = this.image;
    data['created_date'] = this.createdDate;
    data['delivery_note_number'] = this.deliveryNoteNumber;
    data['liters'] = this.liters;
    return data;
  }
}