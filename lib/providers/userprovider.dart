import 'dart:convert';
import 'dart:developer';
import 'package:captain_app_2/api/models/captain_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../api/api_service.dart';
import 'package:flutter/material.dart';

class UserSocketProvider with ChangeNotifier {
  BuildContext? _context;
  BuildContext? get context => _context;

  ApiService _apiService = ApiService();
  WebSocketChannel? _channel;
  CaptainSocket? _captain;
  String? captainFullName;
  String? captainName;
  String? captainBoat;

  UserSocketProvider(BuildContext context) {
    _context = context;
    fetchSocketData();
  }

  Future<void> fetchSocketData() async {
    try {
      final channel = await _apiService.getSocketCaptain(context);
      if (channel != null) {
        _channel = channel;

        _channel!.stream.listen(
          (data) {
            print("This is from User WebSocket Provider: ${data}");
            final jsonData = json.decode(data);
            print("Parsed JSON Data: $jsonData");
            _captain = CaptainSocket.fromJson(jsonData['captain']);
            print("Captain Object: $_captain");
            if (_captain != null) {
              print("from the WebSocket too: ${_captain!.boat}");
              print("from the WebSocket too: ${_captain!.name}");
              print(
                  "from the WebSocket too: ${_captain!.firstName} ${_captain!.lastName}");
              captainBoat = _captain!.boat;
              // captainFullName = "${_captain!.firstName} ${_captain!.lastName}";
              captainName = _captain!.name;
              captainFullName = "${_captain!.firstName} ${_captain!.lastName}";
            } else {
              print(
                  "Captain object is null or name is not present in JSON data.");
            }
            notifyListeners();
          },
          onError: (error) {
            print("WebSocket error: $error");
            // Handle error scenario or notify user.
          },
        );
      }
    } catch (e) {
      print("Error fetching socket data: $e");
      // Handle the error in the API service call or during WebSocket connection setup.
    }
  }
}
