import 'package:captain_app_2/api/models/captain_model.dart';
import 'package:captain_app_2/api/models/engines_model.dart';
import 'package:flutter/material.dart';

import './api/api_service.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import './api/constants.dart';
import 'api/models/boat_model.dart';

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
  // VARIABLES
  ApiService _apiService = ApiService();
  bool isLoading = false;
  List<Map<String, dynamic>>? emptyBoats;
  List<Boat> boats = [];
  // bool isAssigned = true;
  Map<String, dynamic>? profileData;
  // Captain Details //
  String? isCaptainFirstName;
  String? isCaptainLastName;
  String? isCaptainBoat;
  String? isCaptainBoatSerial;
  String? isCaptainBoatType;
  String? isCaptainBoatLocation;
  String? isCaptainBoatBuiltDate;
  List<Engines>? isCaptainBoatEngines;
  //
  bool isBoat = false;
  int? boatId;
  bool shouldRedirect = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {});

    String? token = widget.token;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    http.Response response = await http.get(
      Uri.parse(widget.apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
        print(profileData);

        Captain captain = Captain.fromJson(profileData!['captain']);
        isCaptainFirstName = captain.firstName;
        isCaptainLastName = captain.lastName;
        isCaptainBoat = captain.boat!.name;
        isCaptainBoatSerial = captain.boat!.serial;
        isCaptainBoatType = captain.boat!.type;
        isCaptainBoatLocation = captain.boat!.location;
        isCaptainBoatEngines = captain.boat?.engines;
        isCaptainBoatBuiltDate = captain.boat?.built_date;
        // if (captain.boat != null && captain.boat!.engines != null) {
        //   isCaptainBoatEngines = captain.boat!.engines;
        // } else {
        //   // Handle the case when captain.boat is null or captain.boat.engines is null
        //   isCaptainBoatEngines = [];
        // }
        //
        isBoat = captain.boat != null;
        boatId = captain.boat?.id;

        // Map<String, dynamic>? boatData = profileData!['boat'];
        // isBoat = boatData == null; // Update the class-level variable
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
    print('Boat ID: $boatId');
    print('Is Boat: $isBoat');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('ChangeBoat'),
      ),
      body: SafeArea(
        child: isBoat ? isHasBoat(context) : isHasNoBoat(context),
      ),
    );
  }

  isHasBoat(BuildContext context) {
    print(isCaptainBoatEngines);
    // for(engine in isCaptainBoat)
    var sizedBox = SizedBox(
      height: 20,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.sailing_outlined,
          size: 65,
        ),
        Text(
          isCaptainBoat!,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        sizedBox,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 100),
          child: Table(
            border: TableBorder.all(
                width: 1, color: Colors.transparent), //table border
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Captain",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  TableCell(
                      child: Text(
                    '${isCaptainFirstName!} ${isCaptainLastName!}',
                    textAlign: TextAlign.end,
                  )),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Serial",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  TableCell(
                      child: Text(
                    isCaptainBoatSerial!,
                    textAlign: TextAlign.end,
                  )),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Type",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  TableCell(
                      child: Text(
                    isCaptainBoatType!,
                    textAlign: TextAlign.end,
                  )),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Location",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  TableCell(
                      child: Text(
                    isCaptainBoatLocation!,
                    textAlign: TextAlign.end,
                  )),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                      "Built Date",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  TableCell(
                      child: Text(
                    isCaptainBoatBuiltDate!,
                    textAlign: TextAlign.end,
                  )),
                ],
              ),
            ],
          ),
        ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     child: DataTable(
        //       // datatable widget
        //       columns: [
        //         // column to set the name
        //         DataColumn(
        //           label: Text('Serial'),
        //         ),
        //         DataColumn(
        //           label: Text('Type'),
        //         ),
        //         DataColumn(
        //           label: Text('Location'),
        //         ),
        //         DataColumn(
        //           label: Text('built Date'),
        //         ),
        //       ],

        //       rows: [
        //         // row to set the values
        //         DataRow(cells: [
        //           DataCell(Text(isCaptainBoatSerial!)),
        //           DataCell(Text(isCaptainBoatType!)),
        //           DataCell(Text(isCaptainBoatLocation!)),
        //           DataCell(Text(isCaptainBoatBuiltDate!)),
        //         ]),
        //       ],
        //     ),
        //   ),
        // ),
        sizedBox,
        // sizedBox()
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  Icons.person_outlined,
                  size: 65,
                ),
                Text(
                  '${isCaptainFirstName!} ${isCaptainLastName!}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch(
                  value: isBoat,
                  activeColor: Colors.blue,
                  onChanged: (newValue) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      isBoat = newValue;
                    });

                    _apiService.OnOffCaptain(boatId, isBoat, widget.token);
                  },
                ),
                Text(
                  'Leave Boat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),

        // Text(isCaptainBoatEngines!.toString()),
      ],
    );
  }

  Column isHasNoBoat(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Boat>>(
          future: _apiService.selectBoats(widget.token),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Boat> boatList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: boatList.map((boat) {
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(boat.name!), // Display boat name
                          Switch(
                            value: boat.isAssigned,
                            onChanged: (newValue) {
                              setState(() {
                                boat.isAssigned = newValue;
                                boatId = boat
                                    .id; // Set the correct boat ID based on the current boat.
                              });
                              _apiService.OnOffCaptain(
                                  boatId, newValue, widget.token);
                              FocusScope.of(context).unfocus();

                              print(
                                  'Boat Name: ${boat.name}, Boat ID: $boatId');
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ],
    );
  }

  DataColumn myDataColumn(String name) {
    return DataColumn(
      label: Text(
        name,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
}
