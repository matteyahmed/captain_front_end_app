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
                        return tableData(
                          '${checklist.boatName}',
                          '${checklist.createdBy}',
                          '${checklist.tripDate?.day}-${checklist.tripDate?.month}-${checklist.tripDate?.year}',

                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: checklists.length,
              //     itemBuilder: (context, index) {
              //       return SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: DataTable(
              //           columns: headerColumns,
              //           rows: [
              //             tableData(
              //               '${checklists[index].boatName}',
              //               '${checklists[index].createdBy}',
              //               '${checklists[index].tripDate}',
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
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
            // Navigator.of(context, rootNavigator: true).pushNamed(
            //     '/tripSheetForm',
            //     arguments: {'apiUrl': widget.apiUrl, 'token': widget.token})
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
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       toolbarHeight: 100,
  //       leading: IconButton(
  //           icon: Icon(Icons.arrow_back),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           }),
  //       title: Text(
  //         'CHECK LIST',
  //         style: TextStyle(
  //           color: Colors.grey.shade800,
  //           fontSize: 20,
  //         ),
  //       ),
  //     ),
  //     // BODY
  //     body: RefreshIndicator(
  //       onRefresh: _handleRefresh,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 30),
  //         child: ListView.builder(
  //           itemCount: checklists.length,
  //           itemBuilder: (context, index) {
  //             return DataTable(
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.grey),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               columnSpacing: 30,
  //               columns: headerColumns,
  //               rows: [
  //                 tableData(
  //                   '${checklists[index].boatName}',
  //                   '${checklists[index].createdBy}',
  //                   '${checklists[index].tripDate}',
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       ),
  //     ),

  //   );

  // }

  DataRow tableData(String boat, String captain, String date,) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(
          boat,
          style: const TextStyle(fontSize: 8),
          textAlign: TextAlign.center,
        
        )),
        DataCell(Text(
          captain,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        )),
        DataCell(Text(
          date,
          style: const TextStyle(fontSize: 10),
                 textAlign: TextAlign.center,
        )),
      ],
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
}
