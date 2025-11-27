import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String? mealId;
  final MealDetail? preloaded;
  const MealDetailScreen({super.key, this.mealId, this.preloaded});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService api = ApiService();
  late Future<MealDetail?> _future;

  @override
  void initState() {
    super.initState();
    if (widget.preloaded != null) {
      _future = Future.value(widget.preloaded);
    } else if (widget.mealId != null && widget.mealId!.isNotEmpty) {
      _future = api.lookupMeal(widget.mealId!);
    } else {
      _future = Future.value(null);
    }
  }

  Future<void> _openYoutube(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Рецепт')),
      body: FutureBuilder<MealDetail?>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('Грешка: ${snap.error}'));
          final meal = snap.data;
          if (meal == null) return const Center(child: Text('Рецептот не е пронајден'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl: meal.thumbnail,
                    placeholder: (c, u) => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                    errorWidget: (c, u, e) => const SizedBox(height: 200, child: Center(child: Icon(Icons.error))),
                  ),
                ),
                const SizedBox(height: 12),
                Text(meal.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Категорија: ${meal.category} • Регион: ${meal.area}'),
                const SizedBox(height: 12),
                const Text('Состојки', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                // Display ingredient-measure pairs using parallel lists
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: meal.ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = meal.ingredients[index];
                    final measure = index < meal.measures.length ? meal.measures[index] : '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text('- $ingredient ${measure.isNotEmpty ? ': $measure' : ''}'),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Text('Инструкции', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(meal.instructions),
                const SizedBox(height: 12),
                if (meal.youtube.isNotEmpty) ...[
                  const Text('YouTube', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _openYoutube(meal.youtube),
                    child: Text(meal.youtube, style: const TextStyle(color: Colors.blue)),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

