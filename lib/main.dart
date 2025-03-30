//Don't really need to make changes on this page just the home_page
//This gets rid of alittle of the clutter in home page

import 'package:flutter/material.dart';
import 'package:project1/pages/favorites_page.dart';
import 'package:project1/pages/home_page.dart';
import 'package:project1/pages/recipe_page.dart';


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
      home: HomeNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    FavoritesPage(),
    RecipePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recipes',
          ),
        ],
      ),
    );
  }
}
