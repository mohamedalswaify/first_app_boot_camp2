class ProductModel {
  final int id;
  final String uid;
  final String name;
  final double price;
  final int categoryId;
  final String? categoryName; // لو تحب تعرض الاسم لو الـ API بيرجّعه
  final int qty;
  final int reservedQty;
  final String? description;
  final String? imageUrl;

  ProductModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.qty,
    required this.reservedQty,
    this.categoryName,
    this.description,
    this.imageUrl,
  });

  int get availableQty => qty - reservedQty;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // دعم بعض الأسماء البديلة لو الـ API مختلف
    final id = json['id'] ?? json['Id'];
    final name = json['productName'] ??
        json['ProductName'] ??
        json['name'] ??
        json['Name'];
    final price = json['price'] ?? json['Price'] ?? 0;
    final categoryId = json['categoryId'] ?? json['CategoryId'] ?? 0;
    final qty = json['qty'] ?? json['Qty'] ?? 0;
    final reserved = json['reservedQty'] ?? json['ReservedQty'] ?? 0;

    return ProductModel(
      id: id is String ? int.tryParse(id) ?? 0 : (id ?? 0),
      uid: json['uid'] ?? json['Uid'] ?? '',
      name: name ?? '',
      price: (price is int) ? price.toDouble() : (price as num).toDouble(),
      categoryId:
          categoryId is String ? int.tryParse(categoryId) ?? 0 : categoryId,
      qty: qty is String ? int.tryParse(qty) ?? 0 : qty,
      reservedQty: reserved is String ? int.tryParse(reserved) ?? 0 : reserved,
      categoryName: json['categoryName'] ??
          json['CategoryName'] ??
          json['category']?['name'],
      description: json['description'] ?? json['Description'],
      imageUrl: json['imageUrl'] ?? json['ImageUrl'] ?? json['image'],
    );
  }
}
