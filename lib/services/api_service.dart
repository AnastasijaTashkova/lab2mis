import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$_base/categories.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final map = json.decode(res.body) as Map<String, dynamic>;
      final list = map['categories'] as List<dynamic>;
      return list.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load categories: ${res.statusCode}');
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$_base/filter.php?c=${Uri.encodeComponent(category)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final map = json.decode(res.body) as Map<String, dynamic>;
      final list = map['meals'] as List<dynamic>?;
      if (list == null) return [];
      return list.map((e) => Meal.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load meals for $category: ${res.statusCode}');
  }

  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse('$_base/search.php?s=${Uri.encodeComponent(query)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final map = json.decode(res.body) as Map<String, dynamic>;
      final list = map['meals'] as List<dynamic>?;
      if (list == null) return [];
      return list.map((e) => Meal.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to search meals: ${res.statusCode}');
  }

  Future<MealDetail?> lookupMeal(String id) async {
    final url = Uri.parse('$_base/lookup.php?i=${Uri.encodeComponent(id)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final map = json.decode(res.body) as Map<String, dynamic>;
      final list = map['meals'] as List<dynamic>?;
      if (list == null || list.isEmpty) return null;
      return MealDetail.fromJson(list.first as Map<String, dynamic>);
    }
    throw Exception('Failed to lookup meal: ${res.statusCode}');
  }

  Future<MealDetail?> randomMeal() async {
    final url = Uri.parse('$_base/random.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final map = json.decode(res.body) as Map<String, dynamic>;
      final list = map['meals'] as List<dynamic>?;
      if (list == null || list.isEmpty) return null;
      return MealDetail.fromJson(list.first as Map<String, dynamic>);
    }
    throw Exception('Failed to fetch random meal: ${res.statusCode}');
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/category.dart';
// import '../models/meal.dart';
// import '../models/meal_detail.dart';

// class ApiService {
//   static const _base = 'https://www.themealdb.com/api/json/v1/1';

//   Future<List<Category>> fetchCategories() async {
//     final url = '$_base/categories.php';
//     final res = await http.get(Uri.parse(url));
//     if (res.statusCode == 200) {
//       final map = json.decode(res.body);
//       final list = map['categories'] as List<dynamic>;
//       return list.map((e) => Category.fromJson(e)).toList();
//     }
//     throw Exception('Failed to load categories');
//   }

//   Future<List<Meal>> fetchMealsByCategory(String category) async {
//     final url = '$_base/filter.php?c=\${Uri.encodeComponent(category)}';
//     final res = await http.get(Uri.parse(url));
//     if (res.statusCode == 200) {
//       final map = json.decode(res.body);
//       final list = map['meals'] as List<dynamic>?;
//       if (list == null) return [];
//       return list.map((e) => Meal.fromJson(e)).toList();
//     }
//     throw Exception('Failed to load meals');
//   }

//   Future<List<Meal>> searchMeals(String query) async {
//     final url = '$_base/search.php?s=\${Uri.encodeComponent(query)}';
//     final res = await http.get(Uri.parse(url));
//     if (res.statusCode == 200) {
//       final map = json.decode(res.body);
//       final list = map['meals'] as List<dynamic>?;
//       if (list == null) return [];
//       return list.map((e) => Meal.fromJson(e)).toList();
//     }
//     throw Exception('Failed to search meals');
//   }

//   Future<MealDetail?> lookupMeal(String id) async {
//     final url = '$_base/lookup.php?i=\${Uri.encodeComponent(id)}';
//     final res = await http.get(Uri.parse(url));
//     if (res.statusCode == 200) {
//       final map = json.decode(res.body);
//       final list = map['meals'] as List<dynamic>?;
//       if (list == null || list.isEmpty) return null;
//       return MealDetail.fromJson(list.first);
//     }
//     throw Exception('Failed to lookup meal');
//   }

//   Future<MealDetail?> randomMeal() async {
//     final url = '$_base/random.php';
//     final res = await http.get(Uri.parse(url));
//     if (res.statusCode == 200) {
//       final map = json.decode(res.body);
//       final list = map['meals'] as List<dynamic>?;
//       if (list == null || list.isEmpty) return null;
//       return MealDetail.fromJson(list.first);
//     }
//     throw Exception('Failed to fetch random meal');
//   }
// }

