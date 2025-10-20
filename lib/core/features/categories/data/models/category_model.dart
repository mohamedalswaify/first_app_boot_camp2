class CategoryModel {
  final int id;
  final String name;
  final String? imageUrl;
  final int productCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.productCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : (json['id'] ?? 0),
      name: json['name'] ?? json['nameAr'] ?? json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image'] ?? json['iconUrl'],
      productCount: json['productCount'] ?? json['count'] ?? 0,
    );
  }
}
