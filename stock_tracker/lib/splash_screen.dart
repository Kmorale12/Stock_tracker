import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      
      bool isLoggedIn = false; 
      Navigator.pushReplacementNamed(
        context,
        isLoggedIn ? '/stock_feed' : '/login',
      );
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Stock Tracker',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
