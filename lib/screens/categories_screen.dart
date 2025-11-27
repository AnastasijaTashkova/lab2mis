import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'meals_screen.dart';
import 'meal_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService api = ApiService();
  late Future<List<Category>> _future;
  List<Category> _all = [];
  List<Category> _filtered = [];
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = api.fetchCategories();
    _future.then((list) {
      setState(() {
        _all = list;
        _filtered = list;
      });
    }).catchError((err) {
      // handled in FutureBuilder too
    });
  }

  void _onSearchChanged() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _all.where((c) => c.name.toLowerCase().contains(q)).toList();
    });
  }

  void _openRandom() async {
    try {
      final meal = await api.randomMeal();
      if (meal != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal.id, preloaded: meal)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории јадења'),
        actions: [
          IconButton(onPressed: _openRandom, icon: const Icon(Icons.casino)),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _future,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Грешка: \${snapshot.error}'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => _onSearchChanged(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Пребарај категории...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (ctx, i) {
                    final cat = _filtered[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => MealsScreen(category: cat.name)));
                      },
                      child: CategoryCard(category: cat),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

