import 'dart:io';

import 'package:captain_app_2/api/api_service.dart';
import 'package:captain_app_2/api/constants.dart';
import 'package:captain_app_2/api/token_share.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api/models/captain_model.dart';

class fuelSheetForm extends StatefulWidget {

  const fuelSheetForm({
    super.key,

  });

  @override
  State<fuelSheetForm> createState() => _fuelSheetFormState();
}

class _fuelSheetFormState extends State<fuelSheetForm> {
  ApiService _apiService = ApiService();
  Map<String, dynamic>? profileData;
  bool isLoading = false;
  String? captainName;
  String? captainBoat;
  bool _isPressed = false;

  final TextEditingController deliveryNoteController = TextEditingController();
  final TextEditingController litersController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    deliveryNoteController.dispose();
    litersController.dispose();
    super.dispose();
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
        title: Text('CREATE FUELSHEET'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
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
            Text('CREATE'),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              controller: deliveryNoteController,
              decoration: InputDecoration(
                labelText: 'Delivery Note No.', isDense: true, // Added this
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              controller: litersController,
              decoration: InputDecoration(
                labelText: 'Liters', isDense: true, // Added this
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
                 ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Implement image selection logic here
                    _pickImageFromGallery();
                  },
                  child: Text('Select Image'),
                ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
               if (_selectedImage == null) {
                  // Show a message on the screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select an image',
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
           
            Expanded(
              child: _selectedImage != null
                  ? Image.file(_selectedImage!)
                  : const Text('Please Select an Image'),
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
      // Get the text values from the controllers
      String deliveryNoteText = deliveryNoteController.text;
      String litersText = litersController.text;

      if (_selectedImage == null) {
        // Handle the case when no image is selected
        print('Please select an image');
        return;
      }

      int deliveryNote;
      int liters;

      try {
        deliveryNote = int.parse(deliveryNoteText);
        liters = int.parse(litersText);
      } catch (e) {
        // Handle the case when the strings cannot be parsed as integers
        print(
            'Invalid input. Delivery note and liters must be valid integers.');
        return;
      }

      var submitFuelSheet = await _apiService.submitFuelSheet(

        deliveryNote,
        liters,
        _selectedImage,
      );
      FocusScope.of(context).unfocus();
      final snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Form submitted successfully'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      await Future.delayed(Duration(seconds: 1));

      Navigator.pop(context);
      // Handle the response from the API as needed
      // print('Submitted successfully: $submitFuelSheet');
    } catch (error) {
      print("From FuelSheetForm $error");
    }
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }
}
