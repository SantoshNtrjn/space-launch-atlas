import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/launch_provider.dart';
import 'screens/landing_screen.dart';
import 'screens/launch_list_screen.dart';
import 'screens/filter_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LaunchProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Launch Atlas',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(color: Colors.black),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(),
        '/launch_list': (context) => LaunchListScreen(),
        '/filter': (context) => FilterScreen(),
      },
    );
  }
}