import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'splash_screen.dart';
import 'login_screen.dart';
import 'stock_feed_screen.dart';
import 'settings_screen.dart';
import 'news_feed_screen.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StockTrackerApp());
}

class StockTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Stock Tracker App',
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
              bodyMedium: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue,
              textTheme: ButtonTextTheme.primary,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueAccent,
              elevation: 0,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              secondary: Colors.blueAccent,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
              bodyMedium: TextStyle(color: Colors.grey[300], fontSize: 16),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue,
              textTheme: ButtonTextTheme.primary,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey,
              elevation: 0,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          themeMode: currentMode, // Dynamic theme
          home: SplashScreen(), // Set SplashScreen as the default starting point
          routes: {
            '/login': (context) => LoginScreen(),
            '/stock_feed': (context) => StockFeedScreen(),
            '/settings': (context) => SettingsScreen(themeNotifier: themeNotifier),
            '/news_feed': (context) => NewsFeedScreen(),
          },
        );
      },
    );
  }
}
