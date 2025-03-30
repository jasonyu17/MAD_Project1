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
    );
  }
}
