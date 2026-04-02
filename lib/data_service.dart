import 'dart:convert';
import 'package:flutter/services.dart';
import 'models.dart';

class DataService {
  static Future<List<FoodItem>> loadFoodMenu() async {
    final String response = await rootBundle.loadString('assets/json/food_menu.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => FoodItem.fromJson(json)).toList();
  }

  static Future<List<FoodCategory>> loadFoodCategories() async {
    final String response = await rootBundle.loadString('assets/json/food_type.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => FoodCategory.fromJson(json)).toList();
  }
}