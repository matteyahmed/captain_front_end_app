
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';


import 'package:captain_app_2/providers/userprovider.dart';

import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';

import 'components/side_nav.dart';

import 'package:http/http.dart' as http;

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
    final _firebaseMessaging = FirebaseMessaging.instance;
  ApiService _apiService = ApiService();
  IOWebSocketChannel? _webSocketChannel;
  Map<String, dynamic>? profileData;
  String? captainFullName;
  String? captainName;
  String? captainBoat;
  bool isBoat = false;

  @override
  void initState() async {
    super.initState();

    
    final FCMToken = await _firebaseMessaging.getToken();
    await _apiService.sendFCMtoken(FCMToken);
    Provider.of<UserSocketProvider>(context, listen: false).fetchSocketData();
    _apiService.getSocketCaptain(context);
  }

  @override
  void dispose() {
    // Close the WebSocket when the screen is disposed.
    _webSocketChannel?.sink.close();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    Provider.of<UserSocketProvider>(context, listen: false).fetchSocketData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 100, title: Text('ARRIVA')),
      drawer: SideNav(
        apiUrl: widget.apiUrl,
        token: widget.token,
      ),
      body: Consumer<UserSocketProvider>(builder: (context, value, child) {
        final isBoat = value.captainBoat;
        captainFullName = value.captainFullName;
        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headers(value, isBoat),
                    SizedBox(height: 40),
                    Text('Welcome, Captain:',
                        style: TextStyle(
                          color: Colors.grey[800],
                        fontWeight: FontWeight.w400,
                              fontSize: 12,
                        )),
                    SizedBox(height: 10),
                    Text(
                      // '${value.captainFullName}',
                      captainFullName.toString(),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w300,
                        fontSize: 35,
                      ),
                    ),
                    if (isBoat == null)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Icon(
                              Icons.warning_rounded,
                              size: 200,
                            ),
                            Text('No Boat '),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 500,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ProfileCards(
                                  title: 'Trip Sheet',
                                  link: '/tripSheet',
                                  icon: Icons.u_turn_right_sharp,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                ProfileCards(
                                    title: 'Fuel Seet',
                                    link: '/fuelSheetScreen',
                                    icon: Icons.fact_check_outlined),
                              ],
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                      ProfileCards(
                                    title: 'Check List',
                                    link: '/checkList',
                                    icon: Icons.checklist_sharp),
                                SizedBox(height: 25),
                                  ProfileCards(
                                    title: 'Item Request',
                                    link: '/itemRequestScreen',
                                    icon: Icons.install_mobile)
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ), // Removed
            ],
          ),
        );
      }
          // },
          ),
    );
  }

  Row headers(UserSocketProvider value, String? isBoat) {
    return Row(
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
              // '${value.captainName}'.toUpperCase(),
              '${value.captainName}'.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed('/changeboat',
                arguments: {'apiUrl': widget.apiUrl, 'token': widget.token});
          },
          child: Row(
            children: [
              Icon(
                Icons.sailing,
                color: Colors.grey[800],
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${value.captainBoat}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileCards extends StatelessWidget {
  String title;
  String link;
  IconData icon;
  ProfileCards({
    required this.title,
    required this.link,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(link);
      },
      child: Container(
        width: 150,
        height: 180,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 20.0, // soften the shadow
              spreadRadius: 1.5, //extend the shadow
              offset: Offset(
                0.0, // Move to right 5  horizontally
                0.0, // Move to bottom 5 Vertically
              ),
            )
          ],
          color: Colors.black87,
          borderRadius:
              BorderRadius.circular(20.0), // Adjust the radius as needed
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: Colors.white),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        )),
      ),
    );
  }
}
