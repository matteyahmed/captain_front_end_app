import 'package:captain_app_2/changeboat1.dart';
import 'package:flutter/material.dart';

import '../profile_screen.dart';

import 'nav_anim_builder.dart';

class SideNav extends StatefulWidget {
  final String apiUrl;
  final String token;

  const SideNav({required this.apiUrl, required this.token, super.key});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
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
          sideLinks(context, 'Boat', '/changeboat'),
          sideLinks(context, 'Trip Sheet', '/tripSheet'),

          // const Divider(),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: const ExpansionTile(
              leading: Icon(Icons.percent),
              title: Text('ExpansionTile 3'),
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'This is tile number 3',
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile sideLinks(BuildContext context, String title, String route) {
    return ListTile(
      leading: const Icon(Icons.person, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(route,
            arguments: {'apiUrl': widget.apiUrl, 'token': widget.token});
      },
    );
  }
}
