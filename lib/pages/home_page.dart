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
    'Multigrain Crackers',
    'Frittata',
    'Steak',
  ];

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
    _loadBookmarkedMeals();
  }

  Future<void> _loadBookmarkedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedMeals = prefs.getStringList('bookmarkedMeals')?.toSet() ?? {};
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
            onPressed: _goToFavoritesPage,
          ),
        ],
      ),
      body: Column(
        children: [
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
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(mealImages[meal] ?? 'assets/images/default.png'),
                      ),
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