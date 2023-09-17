import 'dart:convert';
import 'dart:async';

import 'package:captain_app_2/components/form_cards.dart';

import 'package:flutter/material.dart';

import 'components/side_nav.dart';

import 'package:http/http.dart' as http;

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'api/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final String apiUrl;
  final String token;

  const ProfileScreen({
    super.key,
    required this.apiUrl,
    required this.token,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ApiService _apiService = ApiService();

  Map<String, dynamic>? profileData;
  bool isLoading = false;

  late String token;

  late final WebSocketChannel channel;

  final StreamController<dynamic> _streamController =
      StreamController<dynamic>();

  dynamic dataFromChannel1;

  Future<void> _handleRefresh() async {
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    token = widget.token; // Assign widget.token to tokenKey here
    final String fullToken = token;
    String tokenKey = fullToken.substring(0, 8);

    channel = IOWebSocketChannel.connect(
      Uri.parse("ws://10.0.2.2:8000/ws/blang/?token=$tokenKey"),
    );

    channel.stream.listen((dynamic data) {
      setState(() {
        _streamController.add(data);
      });
    });
  }

  @override
  void dispose() {
    _streamController.close();
    channel.sink.close();
    super.dispose();
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
        print('This is from the Profile Screen: $profileData');
        isLoading = false;

        final String fullToken = token;
        String tokenKey = fullToken.substring(0, 8);
        final channel = IOWebSocketChannel.connect(
          Uri.parse("ws://10.0.2.2:8000/ws/boat/?token=$tokenKey"),
          // Uri.parse("ws://10.0.2.2:8000/ws/mycaptain/?token=dda5c57d"),
        );

        /// Listen for all incoming data
        channel.stream.listen(
          (data) {
            _streamController.add(data);
          },
          onError: (error) => print(error),
        );
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
    return MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.blueGrey[99],
          useMaterial3: true,
        ),
        title: 'Welcome ',
        home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            title: Text(
              'ARRIVA',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 20,
                letterSpacing: 2.5,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
          drawer: SideNav(
            apiUrl: widget.apiUrl,
            token: widget.token,
          ),
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, Captain:',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          '${profileData?['captain']?['first_name'] ?? 'None'} ${profileData?['captain']?['last_name'] ?? 'None'}'
                              .toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<dynamic>(
                    stream: _streamController.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot1) {
                      if (snapshot1.hasError) {
                        print(snapshot1.error);
                      }

                      if (snapshot1.connectionState == ConnectionState.active &&
                          snapshot1.hasData) {
                        // print(snapshot1.data);
                        dynamic dataFromChannel1 = jsonDecode(snapshot1.data);

                        if (dataFromChannel1['boat'] != null &&
                            dataFromChannel1['boat']['name'] != null) {
                          // Store the data from channel 1 in dataFromChannel1
                          // You can display data from channel 1 here
                          String boatName =
                              dataFromChannel1['boat']?['name'] ?? '';
                          String boatContact =
                              dataFromChannel1['boat']?['contact'] ?? '';
                          String boatType =
                              dataFromChannel1['boat']?['type'] ?? '';
                          // Access the 'tripsheet' list

                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.sailing_outlined,
                                          color: Colors.grey[800],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          boatName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              FourCards(),
                            ],
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  size: 200,
                                ),
                                Text(
                                  'No boat attached!',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ),
          // bottomNavigationBar:
          //     BottomNavigationBar(items: <BottomNavigationBarItem>[
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.home),
          //     label: 'Home',
          //     backgroundColor: Colors.green,
          //   ),
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.home),
          //     label: 'Home',
          //     backgroundColor: Colors.green,
          //   ),
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.home),
          //     label: 'Home',
          //     backgroundColor: Colors.green,
          //   ),
          // ]),
        ));
  }

  Padding FourCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FormCards(
                  formIcon: Icons.u_turn_right_sharp,
                  formCardName: "Trip Sheet",
                  cardUrl: '/tripSheet',
                  apiUrl: widget.apiUrl,
                  token: widget.token,
                ),

                // ElevatedButton(

                //   child: Text('Hello'),

                //   onPressed: () {
                //     // Navigator.pop(context);
                //     // Navigator.pushNamed(context, '/tripSheet');
                //     // Navigator.pushNamed(
                //     //   context,
                //     //   '/tripSheet',
                //     //   arguments: {
                //     //     'apiUrl': ApiConstants.baseUrl +
                //     //         ApiConstants.userProfileEndpoint,
                //     //     'token': token,
                //     //   },
                //     // );
                //     Navigator.of(context, rootNavigator: true)
                //         .pushNamed("/tripSheet", arguments: {
                //       'apiUrl': ApiConstants.baseUrl +
                //           ApiConstants.userProfileEndpoint,
                //       'token': token,
                //     });
                //   },
                // ),

                FormCards(
                  formIcon: Icons.checklist_sharp,
                  formCardName: "Check List",
                  cardUrl: '/tripSheet',
                  apiUrl: widget.apiUrl,
                  token: widget.token,
                ),
              ],
            ),
            Row(
              children: [
                FormCards(
                  formIcon: Icons.fact_check_outlined,
                  formCardName: "Fuel Sheet",
                  cardUrl: '/tripSheet',
                  apiUrl: widget.apiUrl,
                  token: widget.token,
                ),
                FormCards(
                  formIcon: Icons.install_mobile,
                  formCardName: "Item Req",
                  cardUrl: '/tripSheet',
                  apiUrl: widget.apiUrl,
                  token: widget.token,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoatTable() {
    if (profileData?['captain']?['boat'] != null) {
      return Center(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Boat Name',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Boat Type',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Boat Contact',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Boat Serial',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Boat Location',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${profileData?['captain']?['boat']['name'] ?? 'None'}',
                      ),
                      Text(
                        '${profileData?['captain']?['boat']['type'] ?? 'None'}',
                      ),
                      Text(
                        '${profileData?['captain']?['boat']['contact'] ?? 'None'}',
                      ),
                      Text(
                        '${profileData?['captain']?['boat']['serial'] ?? 'None'}',
                      ),
                      Text(
                        '${profileData?['captain']?['boat']['location'] ?? 'None'}',
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Text('');
    }
  }
}
