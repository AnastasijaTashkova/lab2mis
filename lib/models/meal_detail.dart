class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtube;
  final List<String> ingredients; 
  final List<String> measures; 

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.ingredients,
    required this.measures,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final List<String> ing = [];
    final List<String> meas = [];
    for (var i = 1; i <= 20; i++) {
      final ingKey = 'strIngredient\$i';
      final measKey = 'strMeasure\$i';
      final ingVal = (json[ingKey] ?? '').toString().trim();
      final measVal = (json[measKey] ?? '').toString().trim();
      if (ingVal.isNotEmpty && ingVal.toLowerCase() != 'null') {
        ing.add(ingVal);
        meas.add(measVal);
      }
    }

    return MealDetail(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      youtube: json['strYoutube'] ?? '',
      ingredients: ing,
      measures: meas,
    );
  }
}
