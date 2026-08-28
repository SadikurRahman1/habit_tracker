import 'package:flutter/material.dart';

class CategoryIcons {
  static const Map<String, IconData> icons = {
    'fitness_center': Icons.fitness_center,
    'work': Icons.work,
    'school': Icons.school,
    'favorite': Icons.favorite,
    'shopping_cart': Icons.shopping_cart,
    'sports_soccer': Icons.sports_soccer,
    'music_note': Icons.music_note,
    'movie': Icons.movie,
    'restaurant': Icons.restaurant,
    'travel': Icons.travel_explore,
    'health_and_safety': Icons.health_and_safety,
    'engineering': Icons.engineering,
    'psychology': Icons.psychology,
    'grass': Icons.grass,
    'pets': Icons.pets,
    'code': Icons.code,
    'draw': Icons.draw,
    'camera': Icons.camera,
    'meditation': Icons.self_improvement,
    'volunteer': Icons.volunteer_activism,
    'book': Icons.menu_book,
    'gaming': Icons.sports_esports,
    'coffee': Icons.coffee,
    'bike': Icons.directions_bike,
    'run': Icons.directions_run,
    'car': Icons.directions_car,
    'home': Icons.home,
    'sleep': Icons.bedtime,
    'water': Icons.water_drop,
    'local_drink': Icons.local_drink,
    'spa': Icons.spa,
    'brush': Icons.brush,
    'palette': Icons.palette,
    'nature': Icons.nature_people,
    'child_care': Icons.child_care,
    'beach': Icons.beach_access,
    'lightbulb': Icons.lightbulb,
    'star': Icons.star,
    'celebration': Icons.celebration,
    'emoji': Icons.emoji_emotions,
  };

  static List<MapEntry<String, IconData>> getIconsList() {
    return icons.entries.toList();
  }

  static IconData getIcon(String iconName) {
    return icons[iconName] ?? Icons.category;
  }

  static String getIconName(IconData iconData) {
    for (var entry in icons.entries) {
      if (entry.value == iconData) {
        return entry.key;
      }
    }
    return 'category';
  }
}
