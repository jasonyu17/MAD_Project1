import 'package:flutter/material.dart';

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

  final Map<String, String?> weeklyMeals = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Meal Plan Homepage'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mealList.length,
              itemBuilder: (context, index) {
                return Draggable<String>(
                  data: mealList[index],
                  feedback: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.blueGrey.withOpacity(0.5),
                      child: Text(mealList[index]),
                    ),
                  ),
                  childWhenDragging: Container(),
                  child: Card(
                    child: ListTile(
                      title: Text(mealList[index]),
                      trailing: const Icon(Icons.bookmark),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Container(
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
                            weeklyMeals[day] = meal;
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
                                  if (weeklyMeals[day] != null)
                                    Text(
                                      weeklyMeals[day]!,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
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
                            weeklyMeals[day] = meal;
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
                                  if (weeklyMeals[day] != null)
                                    Text(
                                      weeklyMeals[day]!,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
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
