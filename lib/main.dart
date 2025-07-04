import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MoneyManagementApp());
}

class MoneyManagementApp extends StatelessWidget {
  const MoneyManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
