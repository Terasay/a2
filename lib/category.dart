import 'package:flutter/material.dart';
import 'models.dart';
import 'data_service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<FoodCategory> _categories = [];
  List<FoodItem> _allFood = [];
  String? _selectedCategoryId;
  bool _isLoading = true;
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final categories = await DataService.loadFoodCategories();
    final allFood = await DataService.loadFoodMenu();

    if (!mounted) return;

    setState(() {
      _allFood = allFood;
      _categories = categories;
      _selectedCategoryId = categories.isNotEmpty ? categories.first.id : null;
      _isLoading = false;
    });
  }

  List<FoodItem> _filteredFood() {
    if (_selectedCategoryId == null) {
      return [];
    }

    return _allFood
        .where((item) => item.typeId == _selectedCategoryId)
        .toList();
  }

  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  void _increaseQuantity(String key) {
    final current = _quantities[key] ?? 0;
    setState(() {
      _quantities[key] = current + 1;
    });
  }

  void _decreaseQuantity(String key) {
    final current = _quantities[key] ?? 0;
    if (current == 0) return;

    setState(() {
      if (current == 1) {
        _quantities.remove(key);
      } else {
        _quantities[key] = current - 1;
      }
    });
  }

  Widget _buildCategoryTile(FoodCategory category) {
    final isSelected = category.id == _selectedCategoryId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: isSelected ? Colors.orange.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _selectCategory(category.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Text(
              category.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.orange.shade900 : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodTile(FoodItem item) {
    final quantityKey = '${item.typeId}_${item.name}';
    final quantity = _quantities[quantityKey] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to food detail page.
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/${item.imageUrl}',
                  width: 78,
                  height: 78,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.remark,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}  •  ⭐ ${item.score.toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (quantity > 0) ...[
                    IconButton(
                      onPressed: () => _decreaseQuantity(quantityKey),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$quantity'),
                  ],
                  IconButton(
                    onPressed: () => _increaseQuantity(quantityKey),
                    icon: const Icon(Icons.add_circle, color: Colors.orange),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _filteredFood();

    if (_categories.isEmpty) {
      return const Center(child: Text('No categories found'));
    }

    return Column(
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Category',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 160,
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return _buildCategoryTile(category);
                  },
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No food in this category'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _buildFoodTile(item);
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
