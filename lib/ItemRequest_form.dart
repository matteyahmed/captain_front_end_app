import 'package:captain_app_2/api/api_service.dart';
import 'package:captain_app_2/api/constants.dart';
import 'package:captain_app_2/api/token_share.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api/models/captain_model.dart';
import 'dart:convert';

class ItemRequestForm extends StatefulWidget {
  final String apiUrl;
  final String token;
  const ItemRequestForm({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<ItemRequestForm> createState() => _ItemRequestFormState();
}

class _ItemRequestFormState extends State<ItemRequestForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isPressed = false;
  bool isLoading = false;
  Map<String, dynamic>? profileData;
  String? captainName;
  String? captainBoat;
  List<TextEditingController> itemtController = [];
  List<TextEditingController> qtyController = [];
  List<String> browserOptions = [
    "Cif",
    "Clean cleen",
    "Cockroach killer",
    "Deck brush",
    "Fender F6",
    "Glass cleaner",
    "Harpic",
    "Hand hard sponge",
    "Joy",
    "Life jacket",
    "Maama",
    "Racor Filter",
    "Rainview",
    "Repair Kit",
    "Rope",
    "Sponge dozen",
    "Steel wool",
    "Suzuki Engine oil 5 Ltrs",
    "Suzuki Gasket (O Ring)",
    "Suzuki Gear Oil 350ml",
    "Suzuki Gear Oil 800ml",
    "Suzuki Oil Filter",
    "Suzuki Racor Filter (small)",
    "Suzuki Spark Plug",
    "Water 1500ml Case",
    "Water 500ml Case",
    "Wd40",
    "Yamaha 4stroke Engine oil 4 Ltrs",
    "Yamaha Coolant",
    "Yamaha Gasket (O Ring)",
    "Yamaha Gear Oil750 ml (Yamalube)",
    "Yamaha Oil Filter",
    "Yamaha Racor Filter (big)",
    "Yamaha raco (small)",
    "Yamaha Spark Plug",
    "Yamalube oil 2 stroke 4ltr lubricanta",
  ];

  bool showForm = false;

  List<String> selectedBrowserOptions = [];
  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchData method when the widget is initialized
  }

  void _submitForm(String token, List<TextEditingController> itemtController,
      List<TextEditingController> qtyController) async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      List<String> selectedItems = [];
      List<int> quantities = [];

      for (int i = 0; i < selectedBrowserOptions.length; i++) {
        selectedItems.add(selectedBrowserOptions[i]);
        quantities
            .add(int.tryParse(qtyController[i].text) ?? 0); // Convert to int
      }
      setState(() {
        _isPressed = true;
      });
      try {
        String? response =
            await _apiService.submitItemRequest(selectedItems, quantities);
        FocusScope.of(context).unfocus();
        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Form submitted successfully',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await Future.delayed(Duration(seconds: 2));

              Navigator.of(context).popUntil((route) {
        return route.settings.name == '/profile';
      });
      } catch (error) {
        print('Error submitting item request: $error');
      }
      print('submitted from form');
    }
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
        print('The Item Request Form: $profileData');
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
        title: Text('CREATE ITEM REQUEST'),
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
                  children: [
                    _captainInfoRow(),
                    _captainBoatRow(),
                  ],
                ),
              ),
              // if(showForm)
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 35.0,
                          icon: Icon(Icons.add_circle_outline, color: Colors.grey.shade500,),
                          onPressed: () {
                            setState(() {
                              addItem();
                            });
                          },
                        ),
                        SizedBox(width: 30),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Colors.grey.shade500,),
                              iconSize: 35.0,
                          onPressed: () {
                            removeLastItem();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 310,
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                          color: Colors.grey.shade800,
                        )),
                      ),
                      child: myForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (qtyController.isEmpty) {
                    // Show a message on the screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please Submit an Item ',
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  _isPressed == false
                      ? _submitForm(
                          widget.token, itemtController, qtyController)
                      : null;
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    foregroundColor: Colors.white),
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Form myForm() {
    return Form(
      key: _formKey,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        itemCount: itemtController.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue itemtController) {
                    return browserOptions
                        .where((option) => option
                            .toLowerCase()
                            .contains(itemtController.text.toLowerCase()))
                        .toList();
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                          onFieldSubmitted) =>
                      TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter an Item";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Items',
                            isDense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 30),
                          )),
                  onSelected: (String value) {
                    setState(() {
                      selectedBrowserOptions[index] = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: qtyController[index],
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  autofocus: false,
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text('QTY'),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          );
        },
      ),
    );
  }

  void addItem() {
    selectedBrowserOptions.add('');

    // Check the length of selectedBrowserOptions
    if (selectedBrowserOptions.length < itemtController.length) {
      selectedBrowserOptions.add(''); // Add a default value
    }
    itemtController.add(TextEditingController());
    qtyController.add(TextEditingController());
  }

  void removeLastItem() {
    if (itemtController.isNotEmpty) {
      setState(() {
        itemtController.last.clear();
        qtyController.last.clear();
        itemtController.last.dispose();
        qtyController.last.dispose();
        itemtController.removeLast();
        qtyController.removeLast();
        selectedBrowserOptions.removeLast();
      });
    }
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
