class Tripsheet {
  int? id;
  String? tripFrom;
  String? tripTo;
  int? petrolFillInToday;
  int? numberOfGuests;
  String? tripStartTime;
  int? tripStartUsedPetrol;
  String? tripEndTime;
  int? tripEndUsedPetrol;
  String? tripDate;
  String? createdBy;
  int? boatName;

  Tripsheet(
      {this.id,
      this.tripFrom,
      this.tripTo,
      this.petrolFillInToday,
      this.numberOfGuests,
      this.tripStartTime,
      this.tripStartUsedPetrol,
      this.tripEndTime,
      this.tripEndUsedPetrol,
      this.tripDate,
      this.createdBy,
      this.boatName});

  Tripsheet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripFrom = json['trip_from'];
    tripTo = json['trip_to'];
    petrolFillInToday = json['petrol_fill_in_today'];
    numberOfGuests = json['number_of_guests'];
    tripStartTime = json['trip_start_time'];
    tripStartUsedPetrol = json['trip_start_used_petrol'];
    tripEndTime = json['trip_end_time'];
    tripEndUsedPetrol = json['trip_end_used_petrol'];
    tripDate = json['trip_date'];
    createdBy = json['created_by'];
    boatName = json['boat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_from'] = this.tripFrom;
    data['trip_to'] = this.tripTo;
    data['petrol_fill_in_today'] = this.petrolFillInToday;
    data['number_of_guests'] = this.numberOfGuests;
    data['trip_start_time'] = this.tripStartTime;
    data['trip_start_used_petrol'] = this.tripStartUsedPetrol;
    data['trip_end_time'] = this.tripEndTime;
    data['trip_end_used_petrol'] = this.tripEndUsedPetrol;
    return data;
  }
}
