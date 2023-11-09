import 'package:captain_app_2/api/constants.dart';
import 'package:captain_app_2/api/models/engines_model.dart';
import 'package:captain_app_2/api/token_share.dart';
import 'package:flutter/material.dart';
import 'api/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api/models/captain_model.dart';

class CheckListForm extends StatefulWidget {
  final String apiUrl;
  final String token;
  const CheckListForm({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<CheckListForm> createState() => _CheckListFormState();
}

class _CheckListFormState extends State<CheckListForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApiService _apiService = ApiService();

  bool _isPressed = false;

  Map<String, dynamic>? profileData;
  bool isLoading = false;
  String? captainName;
  String? captainBoat;

  bool isButtonPressed = false;

  List<Engines> boatEngines = [];

  final hullRemarks = TextEditingController();
  String? hullCondition = 'w';

  final seatRemarks = TextEditingController();
  String? seatCondition = 'w';

  final sideCanvasRemarks = TextEditingController();
  String? sideCanvasCondition = 'w';

  final lifeJacketRemarks = TextEditingController();
  String? lifeJacketCondition = 'w';

  final navigationRemarks = TextEditingController();
  String? navigationCondition = 'w';

  final ropeRemarks = TextEditingController();
  String? ropeCondition = 'w';

  final fenderRemarks = TextEditingController();
  String? fenderCondition = 'w';

  final engineRemarks = TextEditingController();
  String? engineCondition = 'w';

  final lubeOilRemarks = TextEditingController();
  String? lubeOilCondition = 'w';

  final batteryRemarks = TextEditingController();
  String? batteryCondition = 'w';

  final generatorBeltRemarks = TextEditingController();
  String? generatorBeltCondition = 'w';

  final generatorSensorRemarks = TextEditingController();
  String? generatorSensorCondition = 'w';

  final generatorRunningHourRemarks = TextEditingController();
  final maintenanceRequirements = TextEditingController();

  final engine1Remarks = TextEditingController();
  final engine2Remarks = TextEditingController();
  final engine3Remarks = TextEditingController();
  final engine4Remarks = TextEditingController();

  String? engine1Condition = 'w';
  String? engine2Condition = 'w';
  String? engine3Condition = 'w';
  String? engine4Condition = 'w';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    hullRemarks.dispose();
    seatRemarks.dispose();
    sideCanvasRemarks.dispose();
    lifeJacketRemarks.dispose();
    navigationRemarks.dispose();
    ropeRemarks.dispose();
    fenderRemarks.dispose();
    engineRemarks.dispose();
    lubeOilRemarks.dispose();
    batteryRemarks.dispose();
    generatorBeltRemarks.dispose();
    generatorSensorRemarks.dispose();
    generatorRunningHourRemarks.dispose();
    maintenanceRequirements.dispose();
    engine1Remarks.dispose();
    engine2Remarks.dispose();
    engine3Remarks.dispose();
    engine4Remarks.dispose();

    super.dispose();
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
      Uri.parse(ApiConstants.baseUrl + ApiConstants.userProfileEndpoint),
      headers: headers,
    );

    if (response.statusCode == 200) {
      setState(() {
        profileData = jsonDecode(response.body);
        isLoading = false;

        Captain captain = Captain.fromJson(profileData!['captain']);
        captainName = captain.name;
        captainBoat = captain.boat?.name;
        boatEngines = captain.boat!.engines!;
        print('The Captain Name is: $captainName');
        print('The Captain Name is: $captainName');
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'CREATE CHECKLIST',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            captainBoat ?? 'No boat assigned'.toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Expanded(child: MyCheckListForm()),
              Expanded(
                child: captainBoat != null
                    ? MyCheckListForm()
                    : Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 200,
                          ),
                          Text(
                            'No boat Assaigned',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form MyCheckListForm() {
    return Form(
      child: SingleChildScrollView(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: Text(
                'create'.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DynamicDropdownTextField(
              title: 'hull',
              controller: hullRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  hullCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Seat',
              controller: seatRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  seatCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Side Canvas',
              controller: sideCanvasRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  sideCanvasCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Life Jackets',
              controller: lifeJacketRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  lifeJacketCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Navigation/Lights',
              controller: navigationRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  navigationCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Rope',
              controller: ropeRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  ropeCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Fender',
              controller: fenderRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  fenderCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Engine',
              controller: engineRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  engineCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Lube Oil',
              controller: lubeOilRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  lubeOilCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Battery',
              controller: batteryRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  batteryCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Generator Belt',
              controller: generatorBeltRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  generatorBeltCondition = value;
                });
              },
            ),
            DynamicDropdownTextField(
              title: 'Generator Sensor',
              controller: generatorSensorRemarks,
              dropdownItems: ['w', 'd'],
              dropdownLabels: ['Good', 'Bad'],
              onDropdownChanged: (String? value) {
                // Handle the selected dropdown value (Good or Bad) here
                setState(() {
                  generatorSensorCondition = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: generatorRunningHourRemarks,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: InputDecoration(
                labelText: 'Generator Runnin Hours',
                isDense: true, // Added this
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: maintenanceRequirements,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Extra information',
                isDense: true, // Added this
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('ENGINES'),
            Container(
                height: 250, // Set an appropriate height
                child: boatEngines.isNotEmpty
                    ? ListView.builder(
                        itemCount: boatEngines.length,
                        itemBuilder: (BuildContext context, int index) {
                          final engines = boatEngines[index];
                          final engineLabel =
                              '${engines.serial} (${engines.status})';

                          final TextEditingController remarksController =
                              TextEditingController();

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Serial: ${engines.serial}'),
                                      Text('Position: ${engines.status}'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: remarksController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    decoration: InputDecoration(
                                      labelText: 'Running hours',
                                      isDense: true, // Added this
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (text) {
                                      if (index == 0) {
                                        engine1Remarks.text = text;
                                      } else if (index == 1) {
                                        engine2Remarks.text = text;
                                      } else if (index == 2) {
                                        engine3Remarks.text = text;
                                      } else if (index == 3) {
                                        engine4Remarks.text = text;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Text('No Engines Attached Yet')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (engine1Remarks.text.isEmpty) {
                  // Show a message on the screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please Fill Engine Running Hours',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                _isPressed == false ? _submitForm() : null; 
              },
              child: Text('Submit'),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      _isPressed = true;
    });
    try {
      var submitCheckList = await _apiService.sampleSubmitCheckList(
          hullCondition,
          hullRemarks.text,
          seatCondition,
          seatRemarks.text,
          sideCanvasCondition,
          sideCanvasRemarks.text,
          lifeJacketCondition,
          lifeJacketRemarks.text,
          navigationCondition,
          navigationRemarks.text,
          ropeCondition,
          ropeRemarks.text,
          fenderCondition,
          fenderRemarks.text,
          engineCondition,
          engineRemarks.text,
          lubeOilCondition,
          lubeOilRemarks.text,
          batteryCondition,
          batteryRemarks.text,
          generatorBeltCondition,
          generatorBeltRemarks.text,
          generatorSensorCondition,
          generatorSensorRemarks.text,
          generatorRunningHourRemarks.text,
          maintenanceRequirements.text,
          engine1Remarks.text,
          engine2Remarks.text,
          engine3Remarks.text,
          engine4Remarks.text);

      // After the form is successfully submitted, navigate back to the previous screen
      FocusScope.of(context).unfocus();
      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Form submitted successfully'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      await Future.delayed(Duration(seconds: 2));

            Navigator.of(context).popUntil((route) {
        return route.settings.name == '/profile';
      });
      print('After popping navigator'); // Debug print after Navigator.pop
    } catch (error) {
      print('Form submit Error: $error');
    }
  }
}

// void _submitForm() {
//   // You can access the selected values using _selectedHullDropdownItem
//   // and _selectedSeatDropdownItem for different fields.

//   String hullRemarksText = hullRemarks.text;
//   String seatRemarksText = seatRemarks.text;

//   print('Hull Condition: $hullCondition');
//   print('Hull Remarks: $hullRemarksText');
//   print('Seat Condition: $seatCondition');
//   print('Seat Remarks: $seatRemarksText');

//   // Perform the submission logic here.
// }

class DynamicDropdownTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final List<String> dropdownItems;
  final List<String> dropdownLabels;
  final ValueChanged<String?> onDropdownChanged;

  DynamicDropdownTextField({
    Key? key,
    required this.title,
    required this.controller,
    required this.dropdownItems,
    required this.dropdownLabels,
    required this.onDropdownChanged,
  }) : super(key: key);

  @override
  _DynamicDropdownTextFieldState createState() =>
      _DynamicDropdownTextFieldState();
}

class _DynamicDropdownTextFieldState extends State<DynamicDropdownTextField> {
  String? _selectedDropdownItem;

  @override
  void initState() {
    super.initState();
    _selectedDropdownItem = 'w'; // Set initial value to "Good" ("w")
    widget.controller.text =
        ''; // Set the text field initial value as an empty string
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title.toUpperCase()),
                DropdownButton<String>(
                  value: _selectedDropdownItem,
                  items: List.generate(
                    widget.dropdownItems.length,
                    (index) {
                      return DropdownMenuItem<String>(
                        value: widget.dropdownItems[index],
                        child: Text(widget.dropdownLabels[index]), // Use labels
                      );
                    },
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedDropdownItem = value;
                      widget.onDropdownChanged(value);

                      if (value == 'w') {
                        widget.controller.text = 'Good';
                      } else {
                        widget.controller.text =
                            ''; // Set the text field initial value as an empty string
                      }
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible:
                  _selectedDropdownItem == 'd', // Show when "Bad" is selected
              child: TextFormField(
                controller: widget.controller,
                decoration: InputDecoration(
                  // labelText: 'Reason it is bad',
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),

                  hintText: 'Reason',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
