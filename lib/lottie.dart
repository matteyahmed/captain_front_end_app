import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnim extends StatelessWidget {
  const LottieAnim({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Under Construction'),
      ),
      body: Center(
        child: LottieBuilder.network('https://lottie.host/2b822b53-3839-45b0-917d-78c5eb241f84/6NrAivs0om.json'),
      ),
    );
  }
}