import 'package:flutter/material.dart';
import 'package:project1/database/database_helper.dart';
import 'package:project1/pages/recipe_details_page.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> _filteredRecipes = [];

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _searchController.addListener(_filterRecipes);
  }

  Future<void> _loadRecipes() async {
    final data = await DatabaseHelper().getRecipes();
    setState(() {
      _recipes = data;
    });
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes =
          _recipes.where((recipe) {
            final name = recipe['name'].toLowerCase();
            final description = recipe['description']?.toLowerCase() ?? '';
            return name.contains(query) || description.contains(query);
          }).toList();
    });
  }

  Future<void> _showAddRecipeDialog() async {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Add New Recipe"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Recipe Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _ingredientsController,
                  decoration: InputDecoration(labelText: 'Ingredients'),
                ),
                TextField(
                  controller: _instructionsController,
                  decoration: InputDecoration(labelText: 'Instructions'),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  _nameController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text("Save"),
                onPressed: () async {
                  String name = _nameController.text.trim();
                  String desc = _descriptionController.text.trim();
                  String ingredients = _ingredientsController.text.trim();
                  String instructions = _instructionsController.text.trim();

                  if (name.isNotEmpty) {
                    await DatabaseHelper().insertRecipe({
                      'name': name,
                      'description': desc,
                      'ingredients': ingredients,
                      'instructions': instructions,
                    });

                    _nameController.clear();
                    _descriptionController.clear();
                    Navigator.of(context).pop();
                    _loadRecipes();
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search recipes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _filteredRecipes.isEmpty
                    ? Center(child: Text('No recipes yet.'))
                    : ListView.builder(
                      itemCount: _filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _filteredRecipes[index];
                        return ListTile(
                          title: Text(recipe['name']),
                          subtitle: Text(recipe['description']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        RecipeDetailPage(recipe: recipe),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecipeDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Recipe',
      ),
    );
  }
}