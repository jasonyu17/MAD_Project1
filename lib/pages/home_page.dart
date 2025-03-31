import 'package:flutter/material.dart';
import 'package:project1/pages/favorites_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1/database/database_helper.dart';

import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _recipes = [];

  final Map<String, String> mealImages = {
    'Brussels Sprouts': 'assets/brussels.png',
    'Caesar Salad': 'assets/caesar.png',
    'Multigrain Crackers': 'assets/crackers.png',
    'Frittata': 'assets/frittata.png',
    'Steak': 'assets/steak.png',
  };

  final Map<String, List<String>> weeklyMeals = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  Set<String> bookmarkedMeals = Set<String>();

  @override
  void initState() {
    super.initState();
    //DatabaseHelper().deleteDatabaseFile();
    _loadRecipesFromDb();
  }

  Future<void> _loadRecipesFromDb() async {
    final data = await DatabaseHelper().getRecipes();
    setState(() {
      _recipes = data;
    });
  }

  Future<void> _saveBookmarkedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarkedMeals', bookmarkedMeals.toList());
  }

  void _toggleBookmark(String meal) {
    setState(() {
      if (bookmarkedMeals.contains(meal)) {
        bookmarkedMeals.remove(meal);
      } else {
        bookmarkedMeals.add(meal);
      }
    });
    _saveBookmarkedMeals();
  }

  void _goToFavoritesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                FavoritesPage(bookmarkedMeals: bookmarkedMeals.toList()),
      ),
    );
  }

  void _toggleFavorite(int id, bool currentStatus) async {
    await DatabaseHelper().toggleFavorite(id, currentStatus);
    _loadRecipesFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Meal Plan Homepage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: _goToFavoritesPage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children:
                  _recipes.map((recipe) {
                    String name = recipe['name'];
                    String image = 'assets/images/default.png';
                    bool isFavorite = recipe['is_favorite'] == 1;

                    return Draggable<String>(
                      data: name,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.blueGrey.withOpacity(0.5),
                          child: Text(name),
                        ),
                      ),
                      childWhenDragging: Container(),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                (recipe['image_path'] != null &&
                                        File(recipe['image_path']).existsSync())
                                    ? FileImage(File(recipe['image_path']))
                                    : AssetImage('assets/images/default.png')
                                        as ImageProvider,
                          ),

                          title: Text(name),
                          trailing: GestureDetector(
                            onTap:
                                () => _toggleFavorite(recipe['id'], isFavorite),
                            child: Icon(
                              isFavorite
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          SizedBox(
            height: 250,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      ['Monday', 'Tuesday', 'Wednesday'].map((day) {
                        return Expanded(
                          child: DragTarget<String>(
                            onAccept: (meal) {
                              setState(() {
                                weeklyMeals[day]?.add(meal);
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Card(
                                color:
                                    candidateData.isEmpty
                                        ? Colors.white
                                        : Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(day),
                                      ...weeklyMeals[day]!.map((meal) {
                                        return Text(
                                          meal,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      ['Thursday', 'Friday', 'Saturday', 'Sunday'].map((day) {
                        return Expanded(
                          child: DragTarget<String>(
                            onAccept: (meal) {
                              setState(() {
                                weeklyMeals[day]?.add(meal);
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Card(
                                color:
                                    candidateData.isEmpty
                                        ? Colors.white
                                        : Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(day),
                                      ...weeklyMeals[day]!.map((meal) {
                                        return Text(
                                          meal,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
