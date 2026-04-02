import 'package:flutter/material.dart';
import 'dart:math';
import 'models.dart';
import 'data_service.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<FoodItem> _recommendedFood = [];
  List<FoodItem> _hotFood = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Загружаем и фильтруем данные
  Future<void> _loadData() async {
    final allFood = await DataService.loadFoodMenu();
    
    // Оставляем только блюда с рейтингом 4.5 и выше
    final highRated = allFood.where((item) => item.score >= 4.5).toList();
    
    setState(() {
      highRated.shuffle(Random()); // Перемешиваем
      _recommendedFood = highRated.take(5).toList(); // Берем 5 штук
      
      highRated.shuffle(Random()); // Снова перемешиваем
      _hotFood = highRated.take(5).toList(); // Берем еще 5 штук
      
      _isLoading = false; // Выключаем загрузку
    });
  }

  // ТВОЯ ЗАДАЧА: Написать этот виджет!
  Widget _buildHorizontalList(String title, List<FoodItem> items) {
    // Подсказка: здесь нужно вернуть Column.
    // Внутри Column должен быть:
    // 1. Text(title) - заголовок списка
    // 2. SizedBox(height: 250, child: ListView.builder(...)) - сам горизонтальный список
    
    return Container(); // Замени эту строчку на свой код
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildHorizontalList('Recommended', _recommendedFood),
          const SizedBox(height: 16),
          _buildHorizontalList('Hot', _hotFood),
        ],
      ),
    );
  }
}