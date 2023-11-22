import 'dart:convert';
import 'dart:async';

import 'package:captain_app_2/api/token_share.dart';
import 'package:captain_app_2/checklist_form.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'api/api_service.dart';
import 'api/constants.dart';

import 'api/models/check_list.dart';

import 'package:intl/intl.dart';

import 'components/nav_anim_builder.dart';

class CheckListScreen extends StatefulWidget {
  final String apiUrl;
  final String token;

  const CheckListScreen({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  ApiService _apiService = ApiService();
  List<CheckList> checklists = [];
  bool isLoading = false;
  String? captainName = '';

  

  Future<void> _handleRefresh() async {
    // Call the fetchData function to refresh the data
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
      Uri.parse(ApiConstants.baseUrl + ApiConstants.checkListViewEndPoint),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        checklists.clear();
        List<dynamic> checkListData = jsonDecode(response.body);

        for (var data in checkListData) {
          CheckList checkList = CheckList.fromJson(data);
          checklists.add(checkList);
        }
        isLoading = false;

        // for (var checklist in checklists) {
        //   print("Checklist ID: ${checklist.id}");
        //   print("Hull Condition: ${checklist.batteryCondition}");
        //   // Print other fields or use the data as needed
        // }
      });
    }
  }

  late List<DataColumn> headerColumns = [
    tableHeader('Boat'),
    tableHeader('Created'),
    tableHeader('Date'),
  ];

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
        title: Text('CHECK LIST'),
      ),
      /* BODY */
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      columns: headerColumns,
                      rows: checklists.map((checklist) {
                        // return tableData(
                        //   '${checklist.boatName}',
                        //   '${checklist.createdBy}',
                        //   '${checklist.tripDate?.day}-${checklist.tripDate?.month}-${checklist.tripDate?.year}',

                        // );
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              TextButton(
                                onPressed: () {
                                  _showDetailsDialog(checklist);
                                },
                                child: Text(
                                  '${checklist.boatName}',
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.deepOrange),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${checklist.createdBy}',
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${checklist.tripDate?.day}-${checklist.tripDate?.month}-${checklist.tripDate?.year}',
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
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
            Navigator.push(
                context,
                SlidePageRoute(
                    page: CheckListForm(
                      apiUrl: widget.apiUrl,
                      token: widget.token,
                    ),
                    context: context)),
          },
        ),
      ),
    );
  }

  DataColumn tableHeader(String title) {
    return DataColumn(
      label: Expanded(
        child: Text(
          title,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  void _showDetailsDialog(CheckList checklist) {
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
                Text('${checklist.boatName}',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Text(
                  '${checklist.tripDate?.day}-${checklist.tripDate?.month}-${checklist.tripDate?.year}',
                  style: TextStyle(fontSize: 15),
                ),
              ]),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                              Divider(color: Colors.grey[400]),
                addItems('Hull', checklist.hullCondition),
                addItems('Seat', checklist.seatCondition),
                addItems('Side Canvas', checklist.sideCanvasCondition),
                addItems('Life Jacket', checklist.lifeJacketCondition),
                addItems('Navigation', checklist.navigationCondition),
                addItems('Ropes', checklist.ropeCondition),
                addItems('Fenders', checklist.fenderCondition),
                addItems('Lube Oil', checklist.lubeOilCondition),
                addItems('Battery', checklist.batteryCondition),
                addItems('Generator Belt', checklist.generatorBeltCondition),
                addItems('Sensors', checklist.generatorSensorCondition),
                Divider(color: Colors.grey[400]),
          
              ],
            ),
          ),
        );
      },
    );
  }
Row addItems(
  String title,
  String? checklist,
) {
  var icon;

  switch (checklist) {
    case 'w':
      icon = Icon(Icons.check, color: Colors.green,);
      break;
    case 'd':
      icon = Icon(Icons.warning_rounded, color: Colors.deepOrange,);
      break;
    default:
      icon = Icon(Icons.error_outline);
      break;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title),
      // Text('${checklist}'),
      icon,
    ],
  );
}
  // Row addItems(
  //   String title,
  //   String? checklist,
    
  // ) {

  //   return Row(
      
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(title),
  //       Text('${checklist}'),
  //     ],
  //   );
  // }
}
