import 'package:flutter/material.dart';
import 'package:project1/pages/favorites_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> mealList = [
    'Brussels Sprouts',
    'Caesar Salad',
    'Multigrain Crackers (Gluten Free)',
    'Frittata',
    'Steak',
  ];

  // Change weeklyMeals to store a list of meals for each day
  final Map<String, List<String>> weeklyMeals = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  // A set to hold bookmarked meals
  Set<String> bookmarkedMeals = Set<String>();

  @override
  void initState() {
    super.initState();
    _loadBookmarkedMeals();
  }

  // Load bookmarked meals from SharedPreferences
  Future<void> _loadBookmarkedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedMeals = prefs.getStringList('bookmarkedMeals')?.toSet() ?? {};
    });
  }

  // Save bookmarked meals to SharedPreferences
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
    _saveBookmarkedMeals(); // Save after toggling
  }

  // Navigate to the FavoritesPage and pass the bookmarkedMeals
  void _goToFavoritesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(bookmarkedMeals: bookmarkedMeals.toList()),
      ),
    );
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
            onPressed: _goToFavoritesPage, // Navigate to the FavoritesPage
          ),
        ],
      ),
      body: Column(
        children: [
          // List of meals with drag functionality
          Expanded(
            child: Column(
              children: mealList.map((meal) {
                return Draggable<String>( 
                  data: meal,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blueGrey.withOpacity(0.5),
                      child: Text(meal),
                    ),
                  ),
                  childWhenDragging: Container(),
                  child: Card(
                    child: ListTile(
                      title: Text(meal),
                      trailing: GestureDetector(
                        onTap: () => _toggleBookmark(meal),
                        child: Icon(
                          bookmarkedMeals.contains(meal)
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

          // SizedBox to contain the days and the drag targets for the meals
          SizedBox(
            height: 250,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Monday', 'Tuesday', 'Wednesday'].map((day) {
                    return Expanded(
                      child: DragTarget<String>(
                        onAccept: (meal) {
                          setState(() {
                            // Add the meal to the list for the respective day
                            weeklyMeals[day]?.add(meal);
                          });
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Card(
                            color: candidateData.isEmpty ? Colors.white : Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(day),
                                  // Display all meals for the day
                                  ...weeklyMeals[day]!.map((meal) {
                                    return Text(
                                      meal,
                                      style: TextStyle(fontWeight: FontWeight.bold),
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
                  children: ['Thursday', 'Friday', 'Saturday', 'Sunday'].map((day) {
                    return Expanded(
                      child: DragTarget<String>(
                        onAccept: (meal) {
                          setState(() {
                            // Add the meal to the list for the respective day
                            weeklyMeals[day]?.add(meal);
                          });
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Card(
                            color: candidateData.isEmpty ? Colors.white : Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(day),
                                  // Display all meals for the day
                                  ...weeklyMeals[day]!.map((meal) {
                                    return Text(
                                      meal,
                                      style: TextStyle(fontWeight: FontWeight.bold),
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
