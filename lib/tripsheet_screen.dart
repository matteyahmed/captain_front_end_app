import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:captain_app_2/tripsheet_form.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'api/models/captain_model.dart';
import 'api/models/boat_model.dart';
import 'api/models/engines_model.dart';
import 'api/models/trip_sheet_model.dart';

import 'components/nav_anim_builder.dart';

class TripSheetScreen extends StatefulWidget {
  final String apiUrl;
  final String token;

  const TripSheetScreen({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<TripSheetScreen> createState() => _TripSheetScreenState();
}

class _TripSheetScreenState extends State<TripSheetScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = false;
  String? captainName = '';
  String? captainFirstName = '';
  String? captainLastName = '';

  late String token;

  late final WebSocketChannel channel;

  final StreamController<dynamic> _streamController =
      StreamController<dynamic>();

  dynamic dataFromChannel1;

  Future<void> _handleRefresh() async {
    // Call the fetchData function to refresh the data
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

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
      Uri.parse(widget.apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
        isLoading = false;

        Captain captain = Captain.fromJson(profileData!['captain']);
        captainName = captain.name;
        captainFirstName = captain.firstName;
        captainLastName = captain.lastName;

        print('Captain Name is: $captainName');

        final String fullToken = token;
        String tokenKey = fullToken.substring(0, 8);
        final channel = IOWebSocketChannel.connect(
          Uri.parse("ws://10.0.2.2:8000/ws/boat/?token=$tokenKey"),
        );

        /// Listen for all incoming data
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
        toolbarHeight: 100,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'TRIP SHEET',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 20,
          ),
        ),
      ),
      // drawer: const SideNav(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          children: [
            WebSocketView(streamController: _streamController),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
          elevation: 10.0,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
          backgroundColor: Colors.black,
          onPressed: () => {
            // Navigator.of(context, rootNavigator: true).pushNamed(
            //     '/tripSheetForm',
            //     arguments: {'apiUrl': widget.apiUrl, 'token': widget.token})
            Navigator.push(
                context,
                SlidePageRoute(
                    page: TripSheetForm(
                      apiUrl: widget.apiUrl,
                      token: widget.token,
                    ),
                    context: context)),
          },
        ),
      ),
    );
  }
}

class WebSocketView extends StatelessWidget {
  const WebSocketView({
    super.key,
    required StreamController streamController,
  }) : _streamController = streamController;

  final StreamController _streamController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot1) {
        if (snapshot1.hasError) {
          print(snapshot1.error);
        }

        if (snapshot1.connectionState == ConnectionState.active &&
            snapshot1.hasData) {
          dynamic dataFromChannel1 = jsonDecode(snapshot1.data);
          print(dataFromChannel1);
          if (dataFromChannel1['boat'] != null &&
              dataFromChannel1['boat']['name'] != null) {
            Boat boat = Boat.fromJson(dataFromChannel1['boat']);
            String boatName = boat.name!;
            String boatType = boat.type!;
            String boatCaptain = boat.captain!;

            List<Engines>? boatEngines = boat.engines;
            List<Tripsheet>? tripSheets = boat.tripsheet;

            if (tripSheets != null && tripSheets.isNotEmpty) {
              List<Widget> tripSheetTextWidgets = [];
              List<DataRow> dataRows = [];
              for (Tripsheet tripsheet in tripSheets) {
                String trip_from = tripsheet.tripFrom!;
                String trip_to = tripsheet.tripTo!;
                int numberOfGuests = tripsheet.numberOfGuests!;
                String tripDate = tripsheet.tripDate!;
                int petrolFillInToday = tripsheet.petrolFillInToday!;
                String tripCaptain = tripsheet.createdBy!;
                String formattedTripDate =
                    DateFormat('MMM-dd-yy').format(DateTime.parse(tripDate));

                dataRows.add(DataRow(
                  cells: <DataCell>[
                    DataCell(Text(
                      formattedTripDate,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      trip_from,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      trip_to,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Center(
                      child: Text(
                        tripCaptain.toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                    )),
                  ],
                ));
              }
              tripSheetTextWidgets.add(
                DataTable(
                  // Set the color for the column headers

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  columnSpacing: 30,
                  columns: [
                    myDataColumn('Date'),
                    myDataColumn('From'),
                    myDataColumn('To'),
                    myDataColumn('Captain'),
                  ],
                  rows: dataRows,
                ),
              );
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.grey[800],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '$boatCaptain'.toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.sailing_outlined,
                                  color: Colors.grey[800],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  boatName,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        "RECENT",
                        style: Theme.of(context).textTheme.labelLarge,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: tripSheetTextWidgets,
                  ),
                ],
              );
            } else {
              print('No Trips available');
              return const Center(
                child: Column(
                  children: [
                    Text('Hello'),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    size: 200,
                  ),
                  Text(
                    'No boat attached!',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
        }
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
          ],
        ));
      },
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
