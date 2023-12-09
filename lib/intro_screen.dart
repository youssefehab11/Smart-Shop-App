
import 'package:flutter/material.dart';
import 'package:graduationproject/auth_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'main.dart';
import 'navigationbar_controller_screen.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
    splashIconSize: 300,
    backgroundColor: Colors.white,
    splash:Image.asset("assets/images/Logo.jpg",width: MediaQuery.of(context).size.width-100,),
    animationDuration:const Duration(seconds: 1),
     nextScreen: islogin == false ? AuthScreen() : NavigationBarController());
  }
}
