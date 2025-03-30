import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe['name'] ?? 'Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe['description'] != null && recipe['description'].isNotEmpty)
                Text(
                  recipe['description'],
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              SizedBox(height: 20),
              Text("Ingredients:", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Text(recipe['ingredients'] ?? ''),
              SizedBox(height: 20),
              Text("Instructions:", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Text(recipe['instructions'] ?? ''),
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 0a1861252fb74ec551d631e3eb250ee4573fa8f0
