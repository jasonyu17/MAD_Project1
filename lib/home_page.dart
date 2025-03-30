import 'package:flutter/material.dart';

class Meals {
  String meal;
  bool completionStatus;
  Meals(this.meal, {this.completionStatus = false});
}

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlanScreen> {
 /* final List<String> mealImages = [
    'assets/images/brussels.jpeg',
    'assets/images/caesar.jpeg',
    'assets/images/cracker.jpeg',
    'assets/images/frittata.jpeg',
    'assets/images/steak.jpeg',
  ];  */

  final List<String> mealList = [
    'Brussels Sprouts',
    'Caesar Salad',
    'Multigrain Crackers (Gluten Free)',
    'Frittata',
    'Steak',
  ];

  final TextEditingController planController = TextEditingController();
  final List<Meals> plans = [];
  int? editingIndex;
  Map<String, List<Meals>> weeklyTasks = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Meal Plan Homepage'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder:
            (context, index) => Card(
              child: ListTile(
                /*leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(
                    mealImages[index % mealImages.length],
                  ),
                ), */
                title: Text(mealList[index % mealList.length]),
                trailing: const Icon(Icons.bookmark),
              ),
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index){
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home
              ),
              label: "Home"
              ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark
              ),
              label: "Favorites"
              ),
              BottomNavigationBarItem(
            icon: Icon(
              Icons.cookie_outlined
              ),
              label: "Recipes"
              ),
        ],
      ),
    );
  }
}


