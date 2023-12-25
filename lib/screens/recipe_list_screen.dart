// recipe_list_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/screens/recipe_details_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late List<Recipe> recipes;
  late List<Recipe> filteredRecipes;

  @override
  void initState() {
    super.initState();
    recipes = [];
    filteredRecipes = [];
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Check if 'meals' key exists and is a non-null list
      if (data.containsKey('meals') && data['meals'] is List) {
        final List<dynamic> meals = data['meals'];

        setState(() {
          recipes = meals.map((meal) => Recipe.fromJson(meal)).toList();
          filteredRecipes = recipes;
        });
      } else {
        // Handle the case where 'meals' key is missing or not a list
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  void _filterRecipes(String query) {
    setState(() {
      filteredRecipes = recipes
          .where((recipe) =>
              recipe.strMeal.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => _filterRecipes(query),
              decoration: const InputDecoration(
                labelText: 'Search Recipes',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(recipe: filteredRecipes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          recipe.strMeal,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            recipe.strMealThumb,
            width: 100,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsScreen(recipe: recipe),
            ),
          );
        },
      ),
    );
  }
}
