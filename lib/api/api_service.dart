import 'dart:developer';

import 'package:captain_app_2/api/models/boat_model.dart';
import 'package:captain_app_2/api/token_share.dart';

import 'package:web_socket_channel/io.dart';

import 'constants.dart';
import 'models/login_user_model.dart';
import 'models/profile_model.dart';

import 'models/trip_sheet_model.dart';
import 'models/check_list.dart';
import 'models/fuel_sheet.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import 'dart:io';
import 'dart:convert';

class ApiService {
  Future<LoginUserModel?> loginUser(
    String username,
    String password,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.loginUserEndpoint);
      var body = jsonEncode({'username': username, 'password': password});
      var response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        LoginUserModel model = loginUserModelFromJson(response.body);
        TokenService.saveToken(model.token);
        String token = model.token;
        String name = model.user.toString();
        DateTime exp = model.expiry;

        print(response.statusCode);
        print(token);
        // print(exp);
        // print(name);

        // print(token);
        return model;
      } else {
        throw Exception('Failed to Load');
      }
    } catch (e) {
      log(e.toString());
      print("hello ${e.toString()}");
    }
    return null; // Return Null if the Login Request Fails
  }


  Future<String?> sendFCMtoken(String? FCMToken,) async {
    try {
      final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getFcm);
      var body = jsonEncode({"fcm_token": FCMToken,});
      String? token = await TokenService.getToken();
      var response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      print('FCM TOKEN RESPONSE: ${response.body}');

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        return responseData['fcm_token'];
      } else {
        print("Failed to submit trip sheet");
        throw Exception("Failed to submit FCM TOKEN");
      }
    } catch (e) {
      log(e.toString());
    }
  }


  Future<String?> logoutUser(context) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.logOutUserEndpoint);
      String? token = await TokenService.getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      };

      var response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print("LogOut Successful");
        return null;
      } else {
        // Handle the case when the logout request returns an error status code.
        // You may want to display an error message or take other actions here.
        return "Logout failed"; // Or you can return an error message.
      }
    } catch (e) {
      log(e.toString());
      // Handle the case when an exception occurs during the logout process.
      return "An error occurred"; // Or you can return an error message.
    }
  }

  Future<String> OnOffCaptain(
    int? boat_id,
    bool is_assigned,
    String token,
  ) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.onOffCaptain);
      var body = jsonEncode(
          {'boat_id': boat_id, 'is_assigned': is_assigned, 'token': token});
      var response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        //

        print('this is from the backend: $responseData');

        // return Tripsheet.fromJson(responseData);
        return responseData['message'];
      } else {
        print("Failed to submit change Captain");
        throw Exception("Failed change Captain");
      }
    } catch (e) {
      log(e.toString());
      print(e.toString());
      throw e;
    }
  }

  Future<IOWebSocketChannel?> getSocketCaptain(context) async {
    try {
      String? token = await TokenService.getToken();
      String tokenKey = token!.substring(0, 8);

      final channel = IOWebSocketChannel.connect(Uri.parse(
          SocketConstants.baseSocket +
              SocketConstants.socketCaptain +
              tokenKey));

      return channel;
    } catch (e) {
      print("Error from services: ${e.toString()}");
      return null; // Return null in case of an error.
    }
  }

  Future<List<Boat>> selectBoats(String token) async {
    List<Boat> boats = [];

    try {
      final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.allBoats);
      final response =
          await http.get(url, headers: {'Authorization': 'Token $token'});

      if (response.statusCode == 200) {
        List<dynamic> boatDataList = jsonDecode(response.body);
        for (var boatData in boatDataList) {
          Boat boat = Boat.fromJson(boatData);
          boats.add(boat);
        }
        return boats;
      } else {
        throw Exception('Failed to load boats');
      }
    } catch (e) {
      log(e.toString());
      print(e.toString());
      return [];
    }
  }

  Future<String?> updateItemRequest(int ids, String received) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.itemUpdateReqeust);
      var body = jsonEncode({
        "id": ids,
        "received": received,
      });

      String? token = await TokenService.getToken();
      var response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('this is from the backend: $responseData');
        return responseData['message']; // Return success message
      } else {
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        print("Failed to Update ItemRequest");
        return "Failed to Update ItemRequest"; // Return error message
      }
    } catch (e) {
      print('Network Error: $e');
      return "Network Error: $e"; // Return network error message
    }
  }
  // Future<String?> updateItemRequest(int ids, String received) async {
  //   try {
  //     var url =
  //         Uri.parse(ApiConstants.baseUrl + ApiConstants.ItemUpdateReqeust);
  //     var body = jsonEncode({
  //       "id": ids,
  //       "received": received,
  //     });

  //     String? token = await TokenService.getToken();
  //     var response = await http.post(
  //       url,
  //       body: body,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Token $token',
  //       },
  //     );

  //     if (response.statusCode == 201) {
  //       var responseData = jsonDecode(response.body);
  //       print('this is from the backend: $responseData');

  //       // return Tripsheet.fromJson(responseData);
  //       return responseData['message'];
  //     } else {
  //       print('Response Status Code: ${response.statusCode}');
  //       print('Response Body: ${response.body}');
  //       print("Failed to Update ItemRequest");
  //       throw Exception("Failed to Update ItemRequest Exection");
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     print('Network Error: $e');
  //     throw Exception('Network Error: $e');
  //   }
  // }

  Future<String?> submitItemRequest(
      List<String> selectedItems, List<int> quantities) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.itemRequestSubmit);
      var requestData = {
        'items': <Map<String, dynamic>>[],
      };
      for (int i = 0; i < selectedItems.length; i++) {
        requestData['items']!.add({
          'item': selectedItems[i],
          'quantity': quantities[i],
        });
      }
      var body = jsonEncode(requestData);

      String? token = await TokenService.getToken();
      var response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print('this is from the backend: $responseData');

        // return Tripsheet.fromJson(responseData);
        return responseData['message'];
      } else {
        print("Failed to submit trip sheet");
        throw Exception("Failed to submit Check List");
      }
    } catch (error) {
      log(error.toString());
      print(error.toString());
      throw error;
    }
  }

  Future<String?> submitFuelSheet(
      int? deliveryNoteNumber, int? liters, File? image) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.fuelSheetSubmit);
      String base64EncodedImage = base64Encode(image!.readAsBytesSync());
      final timestamp = DateTime.now()
          .toIso8601String(); // Example: "2023-10-11T15:30:45.123456"
      final uniqueFilename = 'fuelSheet_$timestamp.jpg';

      // Create a multipart request
      var request = http.MultipartRequest('POST', url)
        ..fields['delivery_note_number'] = deliveryNoteNumber.toString()
        ..fields['liters'] = liters.toString()
        ..files.add(http.MultipartFile.fromBytes(
          'image',
          base64Decode(base64EncodedImage), // Decode the base64-encoded image
          filename: uniqueFilename,
        ));

      // Set the 'Authorization' header
      String? token = await TokenService.getToken();
      request.headers['Authorization'] = 'Token $token';

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        // print('this is from the backend: $responseData');

        // return Tripsheet.fromJson(responseData);
        return responseData['message'];
      } else {
        print("Failed to submit trip sheet");
        throw Exception("Failed to submit Check List");
      }
    } catch (e) {
      log(e.toString());
      print(e.toString());
    }
  }

  Future<String?> sampleSubmitCheckList(
    String? hullCondition,
    String? hullRemarks,
    String? seatCondition,
    String? seatRemarks,
    String? sideCanvasCondition,
    String sideCanvasRemarks,
    String? lifeJacketCondition,
    String lifeJacketRemarks,
    String? navigationCondition,
    String navigationRemarks,
    String? ropeCondition,
    String ropeRemarks,
    String? fenderCondition,
    String fenderRemarks,
    String? engineCondition,
    String engineRemarks,
    String? lubeOilCondition,
    String lubeOilRemarks,
    String? batteryCondition,
    String batteryRemarks,
    String? generatorBeltCondition,
    String generatorBeltRemarks,
    String? generatorSensorCondition,
    String generatorSensorRemarks,
    String generatorRunningHourRemarks,
    String maintenanceRequirements,
    String engine_1Remarks,
    String engine_2Remarks,
    String engine_3Remarks,
    String engine_4Remarks,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.checkListFormSubmit);
      var body = jsonEncode({
        "hull_condition": hullCondition,
        "hull_remarks": hullRemarks,

        "seat_condition": seatCondition,
        "seat_remarks": seatRemarks,

        "side_canvas_condition": sideCanvasCondition,
        "side_canvas_remarks": sideCanvasRemarks,

        "life_jacket_condition": lifeJacketCondition,
        "life_jacket_remarks": lifeJacketRemarks,

        "rope_condition": ropeCondition,
        "rope_remarks": ropeRemarks,

        "navigation_condition": navigationCondition,
        "navigation_remarks": navigationRemarks,

        "fender_condition": fenderCondition,
        "fender_remarks": fenderRemarks,

        "engine_condition": fenderCondition,
        "engine_remarks": engineRemarks,

        "lube_oil_condition": lubeOilCondition,
        "lube_oil_remarks": lubeOilRemarks,

        "battery_condition": batteryCondition,
        "battery_remarks": batteryRemarks,

        "generator_belt_condition": generatorBeltCondition,
        "generator_belt_remarks": generatorBeltRemarks,

        "generator_sensor_condition": generatorSensorCondition,
        "generator_sensor_remarks": generatorSensorRemarks,

        "generator_running_hour_remarks": generatorRunningHourRemarks,
        "maintenance_requirements": maintenanceRequirements,

        "engine_1_remarks": engine_1Remarks,
        // "engine_1_condition" : engine1Condition,

        "engine_2_remarks": engine_2Remarks,
        // "engine_2_condition" : engine2Condition,

        "engine_3_remarks": engine_3Remarks,
        "engine_4_remarks": engine_4Remarks,
        // "engine_3_condition" : engine3Condition,
      });

      // Loop through the enginesRemarks list and add them to the JSON object

      print('API Request Body: $body');
      String? token = await TokenService.getToken();
      var response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print('this is from the backend: $responseData');

        // return Tripsheet.fromJson(responseData);
        return responseData['message'];
      } else {
        print("Failed to submit trip sheet");
        throw Exception("Failed to submit Check List");
      }
    } catch (e) {
      log(e.toString());
      print(e.toString());
      throw e;
    }
  }

  Future<String?> submitLeaveRequest(
    String token,
    String? leave_type,
    int? number_of_days,
    String? leave_start_date,
    String? leave_end_date,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.leaveRequestSubmit);
      var body = jsonEncode({
        "leave_type": leave_type,
        "number_of_days": number_of_days,
        "leave_start_date": leave_start_date,
        "leave_end_date": leave_end_date
      });
      var response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print('this is from the backend: $responseData');

        // return Tripsheet.fromJson(responseData);
        return responseData['message'];
      } else {
        print("Failed to submit leave Request");
        throw Exception("Failed to submit leave Request");
      }
    } catch (error) {
      log(error.toString());
      print(error.toString());
      throw error;
    }
  }

  Future<String?> submitTripSheet(
    String tripFrom,
    String tripTo,
    int numberOfGuests,
    int petrolFillInToday,
    String tripStartTime,
    String tripEndTime,
    int tripStartUsedPetrol,
    int tripEndUsedPetrol,
  ) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.tripSheetSubmitEndpoint);
      var body = jsonEncode({
        "trip_from": tripFrom,
        "trip_to": tripTo,
        "number_of_guests": numberOfGuests,
        "petrol_fill_in_today": petrolFillInToday,
        "trip_start_time": tripStartTime,
        "trip_end_time": tripEndTime,
        "trip_start_used_petrol": tripStartUsedPetrol,
        "trip_end_used_petrol": tripEndUsedPetrol,
      });
      print('API Request Body: $body');
      String? token = await TokenService.getToken();
      var response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print('this is from the backend: $responseData');

        // return Tripsheet.fromJson(responseData);
        return responseData['message'];
      } else {
        print("Failed to submit trip sheet");
        throw Exception("Failed to submit trip sheet");
      }
    } catch (e) {
      log(e.toString());
      print(e.toString());
      throw e;
    }
  }

  Future<ProfileModel?> fetchProfile(String token) async {
    try {
      final url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.userProfileEndpoint);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Token {$token}'},
      );

      if (response.statusCode == 200) {
        ProfileModel model = ProfileModelFromJson(response.body);
        return model;
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      log(e.toString());
      print(e.toString());
      return null;
    }
  }
}
