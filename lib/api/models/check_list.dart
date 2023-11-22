import 'boat_model.dart';
import 'engines_model.dart';

import 'dart:convert';

List<CheckList> CheckListFromJson(String str) =>
    List<CheckList>.from(json.decode(str).map((x) => CheckList.fromJson(x)));

String CheckListToJson(List<CheckList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckList {
  int? id;
  String? createdBy;
  String? boatName;
  String? hullCondition;
  String? seatCondition;
  String? sideCanvasCondition;
  String? lifeJacketCondition;
  String? navigationCondition;
  String? ropeCondition;
  String? fenderCondition;
  String? engineCondition;
  String? lubeOilCondition;
  String? batteryCondition;
  String? generatorBeltCondition;
  String? generatorSensorCondition;
  DateTime? tripDate;

  String? hullRemarks;
  String? seatRemarks;
  String? sideCanvasRemarks;
  String? lifeJacketRemarks;
  String? navigationRemarks;
  String? ropeRemarks;
  String? fenderRemarks;
  String? engineRemarks;
  String? lubeOilRemarks;
  String? batteryRemarks;
  String? generatorBeltRemarks;
  String? generatorSensorRemarks;
  String? generatorRunningHourRemarks;
  String? maintenanceRequirements;

  String? engine1Remarks;
  String? engine1Condition;

  String? engine2Remarks;
  String? engine2Condition;

  String? engine3Remarks;
  String? engine3Condition;

  String? engine4Remarks;
  String? engine4Condition;
  // dynamic engine1;
  // dynamic engine2;
  // dynamic engine3;
  // dynamic engine4;
  // List<String?> enginesConditions; // Use a list for engine conditions
  // List<String?> enginesRemarks; // Use a list for engine remarks

  // Map<String, String?> enginesConditions = {}; // Store engine conditions
  // Map<String, String?> enginesRemarks = {};   // Store engine remarks

  CheckList({
    this.id,
    this.createdBy,
    this.boatName,
    this.hullCondition,
    this.seatCondition,
    this.sideCanvasCondition,
    this.lifeJacketCondition,
    this.navigationCondition,
    this.ropeCondition,
    this.fenderCondition,
    this.lubeOilCondition,
    this.batteryCondition,
    this.generatorBeltCondition,
    this.generatorSensorCondition,
    this.tripDate,
    this.hullRemarks,
    this.seatRemarks,
    this.sideCanvasRemarks,
    this.lifeJacketRemarks,
    this.navigationRemarks,
    this.ropeRemarks,
    this.fenderRemarks,
    this.engineCondition,
    this.engineRemarks,
    this.lubeOilRemarks,
    this.batteryRemarks,
    this.generatorBeltRemarks,
    this.generatorSensorRemarks,
    this.generatorRunningHourRemarks,
    this.maintenanceRequirements,

    this.engine1Remarks,
    this.engine1Condition,

    this.engine2Remarks,
    this.engine2Condition,

    this.engine3Remarks,
    this.engine3Condition,

    this.engine4Condition,
    this.engine4Remarks,
    // this.engine1,
    // this.engine2,
    // this.engine3,
    // this.engine4,
  });

  factory CheckList.fromJson(Map<String, dynamic> json) => CheckList(
        id: json["id"],
        createdBy: json["created_by"],
        boatName: json["boat_name"],
        hullCondition: json["hull_condition"],
        seatCondition: json["seat_condition"],
        sideCanvasCondition: json["side_canvas_condition"],
        lifeJacketCondition: json["life_jacket_condition"],
        navigationCondition: json["navigation_condition"],
        ropeCondition: json["rope_condition"],
        fenderCondition: json["fender_condition"],
        lubeOilCondition: json["lube_oil_condition"],
        batteryCondition: json["battery_condition"],
        generatorBeltCondition: json["generator_belt_condition"],
        generatorSensorCondition: json["generator_sensor_condition"],
        tripDate: DateTime.parse(json["trip_date"]),
        hullRemarks: json["hull_remarks"],
        seatRemarks: json["seat_remarks"],
        sideCanvasRemarks: json["side_canvas_remarks"],
        lifeJacketRemarks: json["life_jacket_remarks"],
        navigationRemarks: json["navigation_remarks"],
        ropeRemarks: json["rope_remarks"],
        fenderRemarks: json["fender_remarks"],
        engineCondition: json["engine_condition"],
        engineRemarks: json["engine_remarks"],
        lubeOilRemarks: json["lube_oil_remarks"],
        batteryRemarks: json["battery_remarks"],
        generatorBeltRemarks: json["generator_belt_remarks"],
        generatorSensorRemarks: json["generator_sensor_remarks"],
        generatorRunningHourRemarks: json["generator_running_hour_remarks"],
        maintenanceRequirements: json["maintenance_requirements"] == null
            ? null
            : json["maintenance_requirements"],

        engine1Remarks: json["engine_1_remarks"],
        engine1Condition: json["engine_1_condition"],


        engine2Remarks: json["engine_2_remarks"],
        engine2Condition: json["engine_2_condition"],

        engine3Remarks: json["engine_3_remarks"],
        engine3Condition: json["engine_3_condition"],

        engine4Remarks: json["engine_4_remarks"],
        engine4Condition: json["engine_4_condition"],
        // engine1: json["engine_1"],
        // engine2: json["engine_2"],
        // engine3: json["engine_3"],
        // engine4: json["engine_4"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "boat_name": boatName,
        "hull_condition": hullCondition,
        "seat_condition": seatCondition,
        "side_canvas_condition": sideCanvasCondition,
        "life_jacket_condition": lifeJacketCondition,
        "navigation_condition": navigationCondition,
        "rope_condition": ropeCondition,
        "fender_condition": fenderCondition,
        "lube_oil_condition": lubeOilCondition,
        "battery_condition": batteryCondition,
        "generator_belt_condition": generatorBeltCondition,
        "generator_sensor_condition": generatorSensorCondition,
        "trip_date": tripDate?.toIso8601String(),
        "hull_remarks": hullRemarks,
        "seat_remarks": seatRemarks,
        "side_canvas_remarks": sideCanvasRemarks,
        "life_jacket_remarks": lifeJacketRemarks,
        "navigation_remarks": navigationRemarks,
        "rope_remarks": ropeRemarks,
        "fender_remarks": fenderRemarks,
        "engine_condition": engineCondition,
        "engine_remarks": engineRemarks,
        "lube_oil_remarks": lubeOilRemarks,
        "battery_remarks": batteryRemarks,
        "generator_belt_remarks": generatorBeltRemarks,
        "generator_sensor_remarks": generatorSensorRemarks,
        "generator_running_hour_remarks": generatorRunningHourRemarks,
        "maintenance_requirements":
            maintenanceRequirements == null ? null : maintenanceRequirements,

        "engine_1_remarks": engine1Remarks,
        "engine_1_condition": engine1Condition,

        "engine_2_remarks": engine2Remarks,
        "engine_2_condition": engine2Condition,

        "engine_3_remarks": engine3Remarks,
        "engine_3_condition": engine3Condition,

        "engine_4_condition": engine4Condition,
        "engine_4_remarks": engine4Remarks,
        // "engine_1": engine1,
        // "engine_2": engine2,
        // "engine_3": engine3,
        // "engine_4": engine4,
      };
}

// class CheckList {
//   int? id;
//   String? createdBy;
//   String? tripDate;
//   String? hullCondition;
//   String? hullRemarks;
//   String? seatCondition;
//   String? seatRemarks;
//   String? sideCanvasCondition;
//   String? sideCanvasRemarks;
//   String? lifeJacketCondition;
//   String? lifeJacketRemarks;
//   String? navigationCondition;
//   String? navigationRemarks;
//   String? ropeCondition;
//   String? ropeRemarks;
//   String? fenderCondition;
//   String? fenderRemarks;
//   String? engineCondition;
//   String? engineRemarks;
//   String? lubeOilCondition;
//   String? lubeOilRemarks;
//   String? batteryCondition;
//   String? batteryRemarks;
//   String? generatorBeltCondition;
//   String? generatorBeltRemarks;
//   String? generatorSensorCondition;
//   String? generatorSensorRemarks;
//   String? generatorRunningHourRemarks;
//   String? maintenanceRequirements;
//   String? engine1Condition;
//   String? engine1Remarks;
//   String? engine2Condition;
//   String? engine2Remarks;
//   String? engine3Condition;
//   String? engine3Remarks;
//   String? engine4Condition;
//   String? engine4Remarks;
//   Boat? boatName;
//   Engines? engine1;
//   Engines? engine2;
//   Engines? engine3;
//   Engines? engine4;

//   CheckList(
//       {this.id,
//       this.createdBy,
//       this.tripDate,
//       this.hullCondition,
//       this.hullRemarks,
//       this.seatCondition,
//       this.seatRemarks,
//       this.sideCanvasCondition,
//       this.sideCanvasRemarks,
//       this.lifeJacketCondition,
//       this.lifeJacketRemarks,
//       this.navigationCondition,
//       this.navigationRemarks,
//       this.ropeCondition,
//       this.ropeRemarks,
//       this.fenderCondition,
//       this.fenderRemarks,
//       this.engineCondition,
//       this.engineRemarks,
//       this.lubeOilCondition,
//       this.lubeOilRemarks,
//       this.batteryCondition,
//       this.batteryRemarks,
//       this.generatorBeltCondition,
//       this.generatorBeltRemarks,
//       this.generatorSensorCondition,
//       this.generatorSensorRemarks,
//       this.generatorRunningHourRemarks,
//       this.maintenanceRequirements,
//       this.engine1Condition,
//       this.engine1Remarks,
//       this.engine2Condition,
//       this.engine2Remarks,
//       this.engine3Condition,
//       this.engine3Remarks,
//       this.engine4Condition,
//       this.engine4Remarks,
//       this.boatName,
//       this.engine1,
//       this.engine2,
//       this.engine3,
//       this.engine4});

//   CheckList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     createdBy = json['created_by'];
//     tripDate = json['trip_date'];
//     hullCondition = json['hull_condition'];
//     hullRemarks = json['hull_remarks'];
//     seatCondition = json['seat_condition'];
//     seatRemarks = json['seat_remarks'];
//     sideCanvasCondition = json['side_canvas_condition'];
//     sideCanvasRemarks = json['side_canvas_remarks'];
//     lifeJacketCondition = json['life_jacket_condition'];
//     lifeJacketRemarks = json['life_jacket_remarks'];
//     navigationCondition = json['navigation_condition'];
//     navigationRemarks = json['navigation_remarks'];
//     ropeCondition = json['rope_condition'];
//     ropeRemarks = json['rope_remarks'];
//     fenderCondition = json['fender_condition'];
//     fenderRemarks = json['fender_remarks'];
//     engineCondition = json['engine_condition'];
//     engineRemarks = json['engine_remarks'];
//     lubeOilCondition = json['lube_oil_condition'];
//     lubeOilRemarks = json['lube_oil_remarks'];
//     batteryCondition = json['battery_condition'];
//     batteryRemarks = json['battery_remarks'];
//     generatorBeltCondition = json['generator_belt_condition'];
//     generatorBeltRemarks = json['generator_belt_remarks'];
//     generatorSensorCondition = json['generator_sensor_condition'];
//     generatorSensorRemarks = json['generator_sensor_remarks'];
//     generatorRunningHourRemarks = json['generator_running_hour_remarks'];
//     maintenanceRequirements = json['maintenance_requirements'];
//     engine1Condition = json['engine_1_condition'];
//     engine1Remarks = json['engine_1_remarks'];
//     engine2Condition = json['engine_2_condition'];
//     engine2Remarks = json['engine_2_remarks'];
//     engine3Condition = json['engine_3_condition'];
//     engine3Remarks = json['engine_3_remarks'];
//     engine4Condition = json['engine_4_condition'];
//     engine4Remarks = json['engine_4_remarks'];
//     boatName = json['boat_name'] != null ?  Boat.fromJson(json['boat_name']) : null;
//     engine1 = json['engine_1'] != null ?  Engines.fromJson(json['engine_1']) : null;
//     engine2 = json['engine_2'] != null ?  Engines.fromJson(json['engine_2']) : null;
//     engine3 = json['engine_3'] != null ?  Engines.fromJson(json['engine_3']) : null;
//     engine4 = json['engine_3'] != null ?  Engines.fromJson(json['engine_3']) : null;

//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['created_by'] = this.createdBy;
//     data['trip_date'] = this.tripDate;
//     data['hull_condition'] = this.hullCondition;
//     data['hull_remarks'] = this.hullRemarks;
//     data['seat_condition'] = this.seatCondition;
//     data['seat_remarks'] = this.seatRemarks;
//     data['side_canvas_condition'] = this.sideCanvasCondition;
//     data['side_canvas_remarks'] = this.sideCanvasRemarks;
//     data['life_jacket_condition'] = this.lifeJacketCondition;
//     data['life_jacket_remarks'] = this.lifeJacketRemarks;
//     data['navigation_condition'] = this.navigationCondition;
//     data['navigation_remarks'] = this.navigationRemarks;
//     data['rope_condition'] = this.ropeCondition;
//     data['rope_remarks'] = this.ropeRemarks;
//     data['fender_condition'] = this.fenderCondition;
//     data['fender_remarks'] = this.fenderRemarks;
//     data['engine_condition'] = this.engineCondition;
//     data['engine_remarks'] = this.engineRemarks;
//     data['lube_oil_condition'] = this.lubeOilCondition;
//     data['lube_oil_remarks'] = this.lubeOilRemarks;
//     data['battery_condition'] = this.batteryCondition;
//     data['battery_remarks'] = this.batteryRemarks;
//     data['generator_belt_condition'] = this.generatorBeltCondition;
//     data['generator_belt_remarks'] = this.generatorBeltRemarks;
//     data['generator_sensor_condition'] = this.generatorSensorCondition;
//     data['generator_sensor_remarks'] = this.generatorSensorRemarks;
//     data['generator_running_hour_remarks'] = this.generatorRunningHourRemarks;
//     data['maintenance_requirements'] = this.maintenanceRequirements;
//     data['engine_1_condition'] = this.engine1Condition;
//     data['engine_1_remarks'] = this.engine1Remarks;
//     data['engine_2_condition'] = this.engine2Condition;
//     data['engine_2_remarks'] = this.engine2Remarks;
//     data['engine_3_condition'] = this.engine3Condition;
//     data['engine_3_remarks'] = this.engine3Remarks;
//     data['engine_4_condition'] = this.engine4Condition;
//     data['engine_4_remarks'] = this.engine4Remarks;

//     if (this.boatName != null) {data['boat_name'] = this.boatName?.toJson();}
//     if (this.engine1 != null) {data['engine_1'] = this.engine1?.toJson();}
//     if (this.engine2 != null) {data['engine_2'] = this.engine2?.toJson();}
//     if (this.engine3 != null) {data['engine_3'] = this.engine3?.toJson();}
//     if (this.engine4 != null) {data['engine_4'] = this.engine4?.toJson();}
//     return data;
//   }
// }