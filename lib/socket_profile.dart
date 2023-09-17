import 'dart:convert';
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';

import 'components/side_nav.dart';

import 'package:http/http.dart' as http;

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class MyProfile extends StatefulWidget {
  final String apiUrl;
  final String token;
  const MyProfile({required this.apiUrl, required this.token, super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Map<String, dynamic>? profileData;
  bool isLoading = false;

  late String token;
  late final WebSocketChannel channel;

  final StreamController<dynamic> _streamController =
      StreamController<dynamic>();

  Future<void> _handleRefresh() async {
    await fetchData();
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    token = widget.token;
    final String fullToken = token;
    String tokenKey = fullToken.substring(0, 8);
    channel = IOWebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8000/ws/blang/?token=$tokenKey"),
    );

    channel.stream.listen((dynamic data) {
      setState(() {
        _streamController.add(data);
      });
    });
  }

  @override
  void dispose() {
    _streamController.close();
    channel.sink.close();
    super.dispose();
  }

  // FETCH DATA METHOD
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    String? token = widget.token;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token'
    };

    http.Response response =
        await http.get(Uri.parse(widget.apiUrl), headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
        isLoading = false;

        final String fulltoken = token;
        String tokenKey = fulltoken.substring(0, 8);
        final channel = IOWebSocketChannel.connect(
          Uri.parse("ws://10.0.2.2:8000/ws/boat/?token=$tokenKey"),
        );

        channel.stream.listen(
          (data) {
            _streamController.add(data);
          },
          onError: (error) => print(error),
        );
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetchdata'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('data'),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(children: []),
        ));
  }
}
