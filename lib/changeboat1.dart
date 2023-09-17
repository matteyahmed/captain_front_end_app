import 'package:captain_app_2/api/models/boat_model.dart';
import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'api/api_service.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'api/constants.dart';
import 'api/models/captain_model.dart';

class ChangeBoat extends StatefulWidget {
  final String apiUrl;
  final String token;
  const ChangeBoat({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<ChangeBoat> createState() => _ChangeBoatState();
}

class _ChangeBoatState extends State<ChangeBoat> {
  ApiService _apiService = ApiService();
  String? boatName;
  String? captainBoat;
  int? boatId;
  String? socketData;
  bool isAssigned = false;

  List<Map<String, dynamic>>? emptyBoats;
  bool isLoading = false;

  late String token;

  List<Boat> boats = [];

  late final WebSocketChannel channel;

  final StreamController<dynamic> _streamController =
      StreamController<dynamic>();

  dynamic dataFromChannel1;

  Future<void> _handleRefresh() async {
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    token = widget.token; // Assign widget.token to tokenKey here
    final String fullToken = token;
    String tokenKey = fullToken.substring(0, 8);

    channel = IOWebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8000/ws/changeboat/?token=$tokenKey"),
    );
  }

  @override
  void dispose() {
    _streamController.close();
    channel.sink.close();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    String? token = widget.token;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    http.Response response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.allBoats),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        emptyBoats =
            (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
        print('This is API data: $emptyBoats');
        boatName = emptyBoats?[0]['name'];

        boats = emptyBoats!
            .map((boatMap) => Boat(
                  captain: boatMap['captain'] ?? 'None',
                  name: boatMap['name'],
                  isAssigned: boatMap['captain'] != null,
                ))
            .toList();

        // print("Number of Boats from Api ${boats.length}");

        isLoading = false;

        channel.stream.listen(
          (data) {
            _streamController.add(data);
            socketData = data;
            print('This is WEBSOCKET DATA ${data}');
          },
          onError: (error) => print(error),
        );
      });
    } else {
      setState(() {
        isLoading = false;
        throw Exception('Failed to Load');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('Change Boat'),
      ),
      body: SafeArea(
        child: isAssigned ? isHasBoat(context) : isHasNoBoat(context, boats),
        // child: boats.any((boat) => boat.isAssigned)
        //     ? isHasBoat(context)
        //     : isHasNoBoat(context, boats),
      ),
    );
  }

  Column isHasBoat(BuildContext context) {
    return Column(
      children: [Text('Has Boat')],
    );
  }

  Column isHasNoBoat(BuildContext context, boats) {
    return Column(
      children: [Text('Has No Boat')],
    );
  }

  // ListView isHasBoat(
  //   BuildContext context,
  // ) {
  //   return ListView(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(30.0),
  //         child: Row(
  //           children: [
  //             Icon(
  //               Icons.sailing_outlined,
  //               color: Colors.grey[800],
  //             ),
  //             SizedBox(
  //               width: 5,
  //             ),
  //             Text(
  //               ' Your are captain of ${captainBoat}' ??
  //                   'No boat assigned'.toUpperCase(),
  //               style: Theme.of(context).textTheme.labelLarge,
  //             ),
  //           ],
  //         ),
  //       ),
  //       Switch(
  //         value: isAssigned,
  //         activeColor: Colors.red,
  //         onChanged: (newValue) {
  //           // This is called when the user toggles the switch.
  //           setState(() {
  //             isAssigned = newValue;
  //           });

  //           _apiService.OnOffCaptain(boatId!, isAssigned, token);
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Column isHasNoBoat(
  //   BuildContext context,
  //   List<Boat> boats,
  // ) {
  //   print('Number of boats: ${boats.length}');
  //   return Column(
  //     children: [
  //       Flexible(
  //         child: ListView.builder(
  //           itemCount: boats.length,
  //           itemBuilder: (context, index) {
  //             Boat boat = boats[index];
  //             return Card(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(right: 30),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Expanded(
  //                       child: ListTile(
  //                         title: Text(boat.name!),
  //                         subtitle: Text(boat.captain ?? 'No Captain'),

  //                         // Other properties you want to display...
  //                       ),
  //                     ),
  //                     Switch(
  //                         activeColor: Colors.red,
  //                         value: boat.isAssigned,
  //                         onChanged: (newValue) {
  //                           setState(() {
  //                             boat.isAssigned = newValue;
  //                             print(
  //                                 'Changed assignment for boat with id: ${boat.name}');
  //                           });
  //                         }),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
