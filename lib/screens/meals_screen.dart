import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final ApiService api = ApiService();
  late Future<List<Meal>> _future;
  List<Meal> _all = [];
  List<Meal> _filtered = [];
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = api.fetchMealsByCategory(widget.category);
    _future.then((list) {
      setState(() {
        _all = list;
        _filtered = list;
      });
    }).catchError((err) {});
  }

  Future<void> _onSearch() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) {
      setState(() => _filtered = List.from(_all));
      return;
    }
    try {
      final results = await api.searchMeals(q);
      final idsInCategory = _all.map((e) => e.id).toSet();
      setState(() {
        _filtered = results.where((m) => idsInCategory.contains(m.id)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search failed: \$e')));
    }
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
        title: Text('Јадења: ${widget.category}'),
        actions: [IconButton(onPressed: _openRandom, icon: const Icon(Icons.casino))],
      ),
      body: FutureBuilder<List<Meal>>(
        future: _future,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Грешка: ${snapshot.error}'));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Пребарај јадења во категоријата...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _onSearch(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _onSearch, child: const Text('Пребарај')),
                  ],
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
                    final meal = _filtered[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal.id)));
                      },
                      child: MealGridItem(meal: meal),
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

