class Recipe {
  final String? idMeal;
  final String? strMeal;
  final String? strMealThumb;
  final String? strInstructions;

  Recipe({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
      strInstructions: json['strInstructions'],
    );
  }
}
