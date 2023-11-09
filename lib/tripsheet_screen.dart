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

  bool isLoading = false;
  String? captainName = '';
  String? captainFirstName = '';

  String? captainLastName = '';

  @override
  void initState() {
    super.initState();
    fetchData();
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
                DataCell(Text(dataEntry['boat_name'].toString(),
                    style: TextStyle(fontSize: 10))),
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
                SizedBox(height: 20,),
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
            // Navigator.of(context, rootNavigator: true).pushNamed(
            //     '/tripSheetForm',
            //     arguments: {'apiUrl': widget.apiUrl, 'token': widget.token})
            Navigator.push(
                context,
                SlidePageRoute(
                    page: TripSheetForm(),
                    context: context)),
          },
        ),
      ),
    );
  }
}
