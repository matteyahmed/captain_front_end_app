import 'package:captain_app_2/profile_screen.dart';
import 'package:flutter/material.dart';

import './api/constants.dart';

import 'api/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   final secureStorage = FlutterSecureStorage();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  ApiService _apiService = ApiService();
  

  void _loginUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.error,
                size: 50,
                color: Colors.pink,
              ),
            ],
          ),
          content: const Text('Please Enter both username and password'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        ),
      );
      return;
    }
    await secureStorage.write(key: 'username', value: username);
    await secureStorage.write(key: 'password', value: password);
    var login = await _apiService.loginUser(username, password);

    if (login != null) {
      // Login Successful
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          alignment: Alignment.center,
          title: const Text('Success'),
          content: const Text('Login Successful'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: {
                    'apiUrl':
                        ApiConstants.baseUrl + ApiConstants.userProfileEndpoint,
                    'token': login.token,
                  },
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ProfileScreen(
                //         // apiUrl: 'http://10.0.2.2:8000/api/profile/',
                //         apiUrl: ApiConstants.baseUrl +
                //             ApiConstants.userProfileEndpoint,
                //         token: login.token),
                //   ),
                // ); // Navigate to the profile screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Login Failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          alignment: Alignment.bottomCenter,
          title: const Text('Error'),
          content: const Text(
            'Invalid username or password.',
            selectionColor: Colors.pink,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    // Call the API service to login the user
  }
  @override
  void initState() {
    super.initState();

    // Check if there are saved credentials and autofill the input fields
    secureStorage.read(key: 'username').then((value) {
      if (value != null) {
        _usernameController.text = value;
      }
    });

    secureStorage.read(key: 'password').then((value) {
      if (value != null) {
        _passwordController.text = value;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // padding: const EdgeInsets.all(25.0),

        padding: const EdgeInsets.only(top: 100, right: 25, left: 25),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0), // Adjust the top padding value as needed
              child: Image.asset("images/arriva_logo.png",height: 100,),
            ),
            const Icon(
              Icons.person,
              size: 32,
              color: Colors.pink,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                filled: true, // Set filled to true
                fillColor: Colors.white, // Set the fillColor to white
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              ),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true, // Set filled to true
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0)),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
                onPressed: _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  shadowColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
            const SizedBox(height: 20),
            Text(
              'Welcome to Arriva Captain\'s App V-0.4',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue[900],
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
