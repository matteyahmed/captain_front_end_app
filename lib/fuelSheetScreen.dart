import 'package:captain_app_2/FuelSheetForm.dart';
import 'package:captain_app_2/api/constants.dart';
import 'package:captain_app_2/api/token_share.dart';
import 'package:captain_app_2/components/nav_anim_builder.dart';
import 'package:captain_app_2/itemRequest_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

class FuelSheetScreen extends StatefulWidget {
  final String apiUrl;
  final String token;
  const FuelSheetScreen({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<FuelSheetScreen> createState() => _FuelSheetScreenState();
}

class _FuelSheetScreenState extends State<FuelSheetScreen> {
  // Map<String, dynamic>? profileData;
  List<dynamic>? profileData;
  bool isLoading = false;

  String? captainName;
  String? captainBoat;
  String? image;

  Future<void> _handleRefresh() async {
    // Call the fetchData function to refresh the data
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchData method when the widget is initialized
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    String? token = await TokenService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    http.Response response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.fuelSheetView),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
        isLoading = false;
        // print("From FuelSheet View: ${profileData}");

        // for (var item in profileData!) {
        //   // FuelSheetModel captain = FuelSheetModel.fromJson(item);
        //   print('The Captain Name is: ${item}');
        // }
      });
    } else {
      setState(() {
        isLoading = false;
        print("Nothing to show from Fuel SHeet");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            'FUEL SHEETS',
          )),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
            itemCount: profileData != null ? profileData!.length : 0,
            itemBuilder: (context, index) {
              var item = profileData![index];

              String captainName = item['created_by'];
              String captainBoat = item['boat'];
              int noteNumber = item['delivery_note_number'];
              int liters = item['liters'];
              String date = item['created_date'];
              DateTime dateTime = DateTime.parse(date);
              String formattedDate =
                  DateFormat.yMMMEd().format(dateTime); // Chan
              String formattedTime = DateFormat.H().format(dateTime); // Chan

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  elevation: 1,
                  child: GestureDetector(
                    onTap: () {
                      _showDetailsDialog(
                          captainName, captainBoat, noteNumber,liters, formattedDate);
                    },
                    child: ListTile(
                      leading: Icon(Icons.fact_check_outlined),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(captainBoat, textAlign: TextAlign.start),
                                Text('Captain: ${captainName.toUpperCase()}',
                                    style: TextStyle(fontSize: 10)),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Add this line to align the text to the left
                                children: [
                                  Text('Note Number: ${noteNumber}',
                                      style: TextStyle(fontSize: 10)),
                                  Text('Liters: $liters',
                                      style: TextStyle(fontSize: 10)),
                                  Text('Date: $formattedDate', style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
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
            Navigator.push(context,
                SlidePageRoute(page: fuelSheetForm(), context: context)),
          },
        ),
      ),
    );
  }

  void _showDetailsDialog(
    String captainBoat,
    String captainName,
    int noteNumber,
    int liters,
    String formattedDate,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(captainName,
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Text(captainBoat.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                      )),
                ]),
            content: SingleChildScrollView(
                child: Column(
              children: [
                // Text(captainBoat),
                addItems('Note Number', noteNumber.toString()),
                addItems('Liters', noteNumber.toString()),
                addItems('Date', formattedDate)

              ],
            )),
          );
        });
  }
    Row addItems(
    String title,
    String? checklist,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text('${checklist}'),
      ],
    );
  }
}
