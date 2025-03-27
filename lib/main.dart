//Don't really need to make changes on this page just the home_page
//This gets rid of alittle of the clutter in home page

import 'package:flutter/material.dart';
import 'package:project1/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planning App',
      theme: ThemeData(
      ),
      home: const MealPlanningScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

