import 'dart:convert';


import 'package:captain_app_2/api/constants.dart';
import 'package:captain_app_2/api/token_share.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:captain_app_2/tripsheet_form.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'api/api_service.dart';
import 'api/models/trip_sheet_model.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  ApiService _apiService = ApiService();
  List<dynamic>? profileData;
  final _firebaseMessaging = FirebaseMessaging.instance;
// final userID =   FirebaseAuth.instance.currentUser!.uid;
final user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  String? captainName = '';
  String? captainFirstName = '';

  String? captainLastName = '';

  @override
  void initState()  {
    super.initState();
     fetchData();
getFCM();
    
  
  }

  Future<void> getFCM() async {
    final FCMToken = await _firebaseMessaging.getToken();
       if (user != null) {
  String uid = user!.uid;
  print('User ID: $uid');
} else {
  print('No user signed in');
}
    print("Fire base Token: ${FCMToken}");
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> _handleRefresh() async {
    // Call the fetchData function to refresh the data
    await fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    // String? token = widget.token;
    String? token = await TokenService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    http.Response response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.tripSheetViewEndpoint),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
        isLoading = false;

        // print(" this is from${profileData}");
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
    List<DataRow> _buildDataRows() {
      List<DataRow> dataRows = [];

      if (profileData != null) {
        for (var dataEntry in profileData!) {
          dataRows.add(
            DataRow(
              cells: <DataCell>[
                DataCell(TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return detailPage(dataEntry);
                        });
                  },
                  child: Text(dataEntry['boat_name'].toString(),
                      style: TextStyle(fontSize: 10, color: Colors.deepOrangeAccent.shade400)),
                )),
                DataCell(Text(dataEntry['trip_from'].toString(),
                    style: TextStyle(fontSize: 10))),
                DataCell(Text(dataEntry['trip_to'].toString(),
                    style: TextStyle(fontSize: 10))),
                DataCell(
                  Text(
                    DateFormat('MMM-dd-yy')
                        .format(DateTime.parse(dataEntry['trip_date'])),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                // Add more DataCells for other fields as needed.
              ],
            ),
          );
        }
      }

      return dataRows;
    }

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            'TRIP SHEET',
            style: TextStyle(color: Colors.grey.shade800, fontSize: 20),
          )),
      // drawer: const SideNav()
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.grey[800],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '$captainName'.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                Center(
                  child: Text('RECENT'),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      DataTable(
                        columnSpacing: 5,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: [
                          DataColumn(
                              label: Text(
                            'Boat',
                          )),
                          DataColumn(label: Text('From')),
                          DataColumn(label: Text('To')),
                          DataColumn(label: Text('Date')),
                          // Add more DataColumns for other fields as needed.
                        ],
                        rows: _buildDataRows(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
            Navigator.push(context,
                SlidePageRoute(page: TripSheetForm(), context: context)),
          },
        ),
      ),
    );
  }

  AlertDialog detailPage(dataEntry) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 30,),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text(dataEntry['boat_name'].toString(),
                style: TextStyle(fontSize: 20,)),
                     Text(
              DateFormat('MMM-dd-yy')
                  .format(DateTime.parse(dataEntry['trip_date'])),
              style: TextStyle(fontSize: 15),
            ),
      ]),
      content: SingleChildScrollView(
        child: Column(
          children: [
         
            SizedBox(
              height: 5,
            ),
         
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trip From',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text(dataEntry['trip_from'].toString(),
                    style: TextStyle(fontSize: 10))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trip To',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text(dataEntry['trip_to'].toString(),
                    style: TextStyle(fontSize: 10))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Petrol Fill',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text("${dataEntry['petrol_fill_in_today']} liters",
                    style: TextStyle(fontSize: 10))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number Of Guests',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text("${dataEntry['number_of_guests']}",
                    style: TextStyle(fontSize: 10))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trip Start Time',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text("${dataEntry['trip_start_time']}",
                    style: TextStyle(fontSize: 10))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trip End Time',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text("${dataEntry['trip_end_time']}",
                    style: TextStyle(fontSize: 10))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
