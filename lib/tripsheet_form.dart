import 'package:captain_app_2/api/constants.dart';
import 'package:captain_app_2/api/token_share.dart';
import 'package:flutter/material.dart';
import 'api/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import 'api/models/captain_model.dart';

import 'components/drop_down.dart';

class TripSheetForm extends StatefulWidget {
  const TripSheetForm({super.key});
  @override
  _TripSheetFormState createState() => _TripSheetFormState();
}

class _TripSheetFormState extends State<TripSheetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const List<String> _fruitOptions = <String>[ 
    'apple', 
    'banana', 
    'orange', 
    'mango', 
    'grapes', 
    'watermelon', 
    'kiwi', 
    'strawberry', 
    'sugarcane', 
  ]; 
  

  ApiService _apiService = ApiService();
  Map<String, dynamic>? profileData;
  bool _isPressed = false;
  // List<dynamic>? profileData;
  bool isLoading = false;
  String? captainName;
  String? captainBoat;

  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  final _numberOfGuestController = TextEditingController();
  final _petrolFillInController = TextEditingController();

  final _tripStartController = TextEditingController();
  final _tripEndController = TextEditingController();

  final _startPetrolController = TextEditingController();
  final _endPetrolController = TextEditingController();

  String _fromValue = 'Airport';
  String _toValue = 'Airport';

  TimeOfDay? _selectedTripStartTime;
  TimeOfDay? _selectedTripEndTime;
  DateTime _tripStartDate = DateTime.now();
  DateTime _tripEndDate = DateTime.now();

  // Declare a FocusNode

  @override
  void initState() {
    super.initState();
    // fetchData(); // Call the fetchData method when the widget is initialized
    fetchData();
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
        print('The Captain Name is: $captainName');
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );

    if (selectedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      setState(() {
        // _tripStartController.text = selectedTime.format(context);
        // _tripEndController.text = selectedTime.format(context);
        if (isStartTime) {
          _selectedTripStartTime = selectedTime;
          _tripStartDate = selectedDateTime;
          _tripStartController.text = DateFormat.Hm().format(selectedDateTime);
        } else {
          _selectedTripEndTime = selectedTime;
          _tripEndDate = selectedDateTime;
          _tripEndController.text = DateFormat.Hm().format(selectedDateTime);
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final int numberOfGuests =
          int.tryParse(_numberOfGuestController.text) ?? 0;
      final int petrolFillInToday =
          int.tryParse(_petrolFillInController.text) ?? 0;
      final String tripStartTime = _tripStartController.text;
      final String tripEndTime = _tripEndController.text;
      final int tripStartUsedPetrol =
          int.tryParse(_startPetrolController.text) ?? 0;
      final int tripEndUsedPetrol =
          int.tryParse(_endPetrolController.text) ?? 0;

      setState(() {
        _isPressed = true;
      });
      String? token = await TokenService.getToken();
      // Form is valid, proceed with form submission logic
      var submitTripSheet = await _apiService.submitTripSheet(
        _fromValue,
        _toValue,
        petrolFillInToday,
        numberOfGuests,
        tripStartTime,
        tripEndTime,
        tripStartUsedPetrol,
        tripEndUsedPetrol,
      );
      // print(_formKey.currentState!);
      FocusScope.of(context).unfocus();
      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Form submitted successfully: $submitTripSheet'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      await Future.delayed(Duration(seconds: 2));

      Navigator.of(context).popUntil((route) {
        return route.settings.name == '/profile';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'CREATE TRIPSHEET',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
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
            ),
            // SingleChildScrollView(
            //   child: MyTripSheetForm(),
            // ),
            SingleChildScrollView(
              child: captainName != null
                  ? MyTripSheetForm()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  Form MyTripSheetForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: Text(
              'create'.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          TripSheetDropDown(onFromChanged: (newValue) {
            setState(() {
              _fromValue = newValue;
            });
          }, onToChanged: (newValue) {
            setState(() {
              _toValue = newValue;
            });
          }),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child:
                        numberInputField('No. Guest', _numberOfGuestController),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: numberInputField(
                        'Petrol Fill Today', _petrolFillInController),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: dateInputField(
                        'Trip Start', _tripStartController, true),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child:
                        dateInputField('Trip End', _tripEndController, false),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: numberInputField(
                        'Start Patrol Used', _startPetrolController),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: numberInputField(
                        'End Patrol Used', _endPetrolController),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text('clear'),
                  style:
                      TextButton.styleFrom(foregroundColor: Colors.grey[900]),
                  onPressed: () {
                    _numberOfGuestController.clear();
                    _petrolFillInController.clear();
                    _tripStartController.clear();
                    _tripEndController.clear();
                    _startPetrolController.clear();
                    _endPetrolController.clear();
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white),
                  onPressed: () {
                    _isPressed == false ? _submitForm() : null;
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    } else if (int.tryParse(value) == null && double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }



  TextFormField numberInputField(
      String name, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: name,
          labelStyle: TextStyle(color: Colors.black),
          errorStyle: TextStyle(
            color: Colors.red,
            height: 0.01,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8.0),
            gapPadding: 23,
          ),
        ),
        onSaved: (String? value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: _validateNotEmpty);
  }

  TextFormField dateInputField(
      String name, TextEditingController controller, bool isStartTime) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 0.5),
        ),
        labelText: name,
        errorStyle: TextStyle(
          color: Colors.red,
          height: 0.01,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
          gapPadding: 23,
        ),
      ),
      readOnly: true,
      onTap: () async {
        _selectTime(isStartTime);
      },
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please Fill the Dates";
        }
      },
    );
  }
}
