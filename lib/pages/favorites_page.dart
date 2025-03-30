

import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<String> bookmarkedMeals;

  const FavoritesPage({Key? key, required this.bookmarkedMeals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Favorite Meals'),
      ),
      body: ListView.builder(
        itemCount: bookmarkedMeals.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(bookmarkedMeals[index]),
            ),
          );
        },
      ),
    );
  }
}
