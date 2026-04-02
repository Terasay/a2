class FoodCategory {
  final String id;
  final String name;

  FoodCategory({required this.id, required this.name});

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class FoodItem {
  final String name;
  final double price;
  final String remark;
  final String typeId;
  final double score;
  final String imageUrl;

  FoodItem({
    required this.name,
    required this.price,
    required this.remark,
    required this.typeId,
    required this.score,
    required this.imageUrl,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      remark: json['remark'] ?? '',
      typeId: json['type_id'] ?? '',
      score: double.tryParse(json['score'].toString()) ?? 0.0,
      imageUrl: json['image_url'] ?? '',
    );
  }
}