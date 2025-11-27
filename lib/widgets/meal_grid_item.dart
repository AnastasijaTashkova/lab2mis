import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealGridItem extends StatelessWidget {
  final Meal meal;
  const MealGridItem({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: meal.thumbnail,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (c, u) => const Center(child: CircularProgressIndicator()),
                errorWidget: (c, u, e) => const Center(child: Icon(Icons.error)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(meal.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

