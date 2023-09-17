import 'dart:developer';

import 'package:captain_app_2/api/models/boat_model.dart';

import 'constants.dart';
import 'models/login_user_model.dart';
import 'models/profile_model.dart';
import 'models/trip_sheet_model.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

class ApiService {
  Future<LoginUserModel?> loginUser(String username, String password) async {
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
      print(e.toString());
    }
    return null; // Return Null if the Login Request Fails
  }

  Future<String> OnOffCaptain(
    int? boat_id,
    bool is_assigned,
    String token,
  ) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.onOffCaptain);
      var body = jsonEncode({
        'boat_id': boat_id,
        'is_assigned': is_assigned,
        'token': token,
      });
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
  // Future<List<String>> selectBoats(String token) async {
  //   List<String> boatNames = [];

  //   try {
  //     final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.allBoats);
  //     final response =
  //         await http.get(url, headers: {'Authorization': 'Token $token'});

  //     if (response.statusCode == 200) {
  //       List<dynamic> boatDataList = jsonDecode(response.body);
  //       for (var boatData in boatDataList) {
  //         Boat boat = Boat.fromJson(boatData);
  //         boatNames.add(boat.name!);
  //       }
  //       return boatNames;
  //     } else {
  //       throw Exception('Failed to load boats');
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     print(e.toString());
  //     return [];
  //   }
  // }

  Future<String?> submitTripSheet(
    String tripFrom,
    String tripTo,
    int numberOfGuests,
    int petrolFillInToday,
    String tripStartTime,
    String tripEndTime,
    int tripStartUsedPetrol,
    int tripEndUsedPetrol,
    String token,
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
