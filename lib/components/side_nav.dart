
import 'package:captain_app_2/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../profile_screen.dart';

import 'nav_anim_builder.dart';

class SideNav extends StatefulWidget {
  final String apiUrl;
  final String token;


  const SideNav({
    required this.apiUrl, 
    required this.token,

    super.key});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  ApiService _apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            accountName: Text(''),
            accountEmail: Text('Hllo@hello.com'),
            currentAccountPicture: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Image.asset(
                "images/arriva_logo.png",
                width: 600,
              ),
            ),
          ),
          sideLinks(context, 'Boat', '/changeboat',Icons.sailing ),
          sideLinks(context, 'Leave Request', '/leaveRequestForm', Icons.beach_access),
                 ListTile(
            leading: const Icon(Icons.logout, ),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 12, ),
            ),
            onTap: () async {
              // await _apiServices.logoutUser(context);
              // SystemNavigator.pop();
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Log Out ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    content: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        await _apiService.logoutUser(context);
                        SystemNavigator.pop();
                      },
                      child: Text("Yes"),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

ListTile sideLinks(BuildContext context, String title, String route, IconData iconData) {
  return ListTile(
    leading: Icon(iconData), // Use the iconData parameter to create the Icon
    title: Text(
      title,
      style: TextStyle(fontSize: 12, color: Colors.black),
    ),
    onTap: () {
      Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pushNamed(route,
          arguments: {'apiUrl': widget.apiUrl, 'token': widget.token});
    },
  );
}

}
