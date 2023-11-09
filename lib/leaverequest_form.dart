import 'dart:convert';
import 'dart:math';

import 'package:captain_app_2/api/api_service.dart';
import 'package:captain_app_2/api/constants.dart';
import 'package:captain_app_2/api/models/captain_model.dart';
import 'package:captain_app_2/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaveRequstForm extends StatefulWidget {
  final String apiUrl;
  final String token;
  const LeaveRequstForm({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<LeaveRequstForm> createState() => _LeaveRequstFormState();
}

class _LeaveRequstFormState extends State<LeaveRequstForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isPressed = false;
  bool isLoading = false;
  Map<String, dynamic>? profileData;
  List<dynamic>? leaveRequests;
  String? captainName;
  String? captainBoat;

  final _LeaveType = TextEditingController();
  String? selectedLeaveType;
  final _numberOfDays = TextEditingController();
  final _leaveStartDate = TextEditingController();
  final _leaveEndDate = TextEditingController();

  DateTime _dateTime = DateTime.now();

  List<DropdownMenuItem<dynamic>> _dropdownItems = [
    DropdownMenuItem(
      value: 'n',
      child: Text('None'),
    ),
    DropdownMenuItem(
      value: 'd',
      child: Text('Off Days'),
    ),
    DropdownMenuItem(
      value: 'a',
      child: Text('Annual'),
    ),
    DropdownMenuItem(
      value: 'p',
      child: Text('Public Holidays'),
    ),
    DropdownMenuItem(
      value: 'f',
      child: Text('Family Obligations'),
    ),
    DropdownMenuItem(
      value: 'o',
      child: Text('Other'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchLeaveRequest(); // Call the fetchData method when the widget is initialized
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
        captainBoat = captain.boat?.name;
        // print('The Captain Name is: $captainName');
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchLeaveRequest() async {
    setState(() {
      isLoading = true;
    });
    String? token = widget.token;
    var url = ApiConstants.baseUrl + ApiConstants.leaveRequestView;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        leaveRequests = jsonDecode(response.body);
        isLoading = false;
        print("this is from Leave request Screen: $leaveRequests");
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // print(_LeaveType.text);
      // print(_numberOfDays.text);
      // print(_leaveStartDate.text);
      // print(_leaveEndDate.text);
      final String leaveType = _LeaveType.text;
      final int numberOfDays = int.parse(_numberOfDays.text);
      final String leaveStartDate = _leaveStartDate.text;
      final String leaveEndDate = _leaveEndDate.text;
      setState(() {
        _isPressed = true;
      });
      try {
        var submitLeaveRequest = await _apiService.submitLeaveRequest(
            widget.token,
            leaveType,
            numberOfDays,
            leaveStartDate,
            leaveEndDate);

        FocusScope.of(context).unfocus();
        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text('Form submitted successfully: $submitLeaveRequest'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await Future.delayed(Duration(seconds: 2));

        Navigator.of(context).popUntil((route) {
          return route.settings.name == '/profile';
        });
      } catch (error) {
        print("Error $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('LEAVE REQUEST'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _captainInfoRow(),
                    _captainBoatRow(),
                  ],
                ),
              ),
              Text('CREATE'),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: myLeaveRequestForm(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  height: 218,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text('Created'),
                            ),
                            DataColumn(
                              label: Text('Captain'),
                            ),
                            DataColumn(
                              label: Text('Type'),
                            ),
                            DataColumn(
                              label: Text('Days'),
                            ),
                            DataColumn(
                              label: Text('Start'),
                            ),
                            DataColumn(
                              label: Text('End'),
                            ),
                          ],
                          rows: leaveRequests != null
                              ? leaveRequests!.map((leaves) {
                                  String createdAt = leaves['created_at'];
                                  String createdBy = leaves['created_by'];
                                  String leaveType = leaves['leave_type'];
                                  int numberOfDays = leaves['number_of_days'];
                                  String leaveStart =
                                      leaves['leave_start_date'];
                                  String leaveEnd = leaves['leave_end_date'];
                                  return DataRow(cells: [
                                    DataCell(Text(createdAt)),
                                    DataCell(Text(createdBy)),
                                    DataCell(Text(leaveType)),
                                    DataCell(Text(numberOfDays.toString())),
                                    DataCell(Text(leaveStart)),
                                    DataCell(Text(leaveEnd)),
                                  ]);
                                }).toList()
                              : [],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              leaveRequests != null ? leaveRequests!.length : 0,
                          itemBuilder: (context, index) {
                            var leaves = leaveRequests![index];
                            // Extract other data you need for the list items.
                            String created_at = leaves['created_at'];
                            String createdBy = leaves['created_by'];
                            String leaveType = leaves['leave_type'];
                            int numberOfDays = leaves['number_of_days'];
                            String leaveStart = leaves['leave_start_date'];
                            String leaveEnd = leaves['leave_end_date'];

                            // Create a widget for each item in the leaveRequests list.
                            // return ListTile(
                            //   title: Text(createdBy),
                            //   subtitle: Text(leaveType),
                            //   // Add more information as needed.
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form myLeaveRequestForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Leave Type',
                isDense: true,
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
              ),
              items: _dropdownItems,
              onChanged: (value) {
                // Handle the selected value here
                setState(() {
                  selectedLeaveType = value;
                  _LeaveType.text = selectedLeaveType ?? '';
                  print('LeaveType text from Print: ${_LeaveType.text}');
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _numberOfDays,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter Number of Days";
                }
                return null;
              },
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: InputDecoration(
                labelText: 'Number of Days', isDense: true, // Added this
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 280,
                  child: TextFormField(
                    controller: _leaveStartDate,
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please select a Leave Start Date";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Leave Start Date',
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _dateTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _dateTime = selectedDate;
                        // Update the text field's controller with the selected date
                        _leaveStartDate.text =
                            selectedDate.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 280,
                  child: TextFormField(
                    controller: _leaveEndDate,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please select a Leave End Date";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Leave End Date',
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    DateTime? selectedEndDate = await showDatePicker(
                      context: context,
                      initialDate: _dateTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                    );
                    if (selectedEndDate != null) {
                      setState(() {
                        _dateTime = selectedEndDate;
                        // Update the text field's controller with the selected date
                        _leaveEndDate.text =
                            selectedEndDate.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  _isPressed == false ? _submitForm() : null;
                },
                child: Text(
                  'Submit',
                )),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget _captainInfoRow() {
    return Row(
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
    );
  }

  Widget _captainBoatRow() {
    return Row(
      children: [
        Icon(
          Icons.sailing_outlined,
          color: Colors.grey[800],
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          captainBoat ?? 'No boat assigned'.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
