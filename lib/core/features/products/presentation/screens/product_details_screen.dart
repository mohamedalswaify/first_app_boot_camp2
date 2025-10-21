import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';
import '../../data/services/product_api_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _api = ProductApiService();
  late Future<ProductModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<ProductModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('❌ حدث خطأ أثناء تحميل المنتج:\n${snapshot.error}',
                  textAlign: TextAlign.center),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('لا توجد بيانات للمنتج'));
          }

          final p = snapshot.data!;
          final available = p.availableQty;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المنتج
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: p.imageUrl != null && p.imageUrl!.isNotEmpty
                        ? Image.network(
                            p.imageUrl!,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                ),
                const SizedBox(height: 16),

                // الاسم والسعر
                Text(
                  p.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'SAR ${p.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // الفئة
                if (p.categoryName != null)
                  Text(
                    'Category: ${p.categoryName}',
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                const SizedBox(height: 12),

                // الكمية المتاحة
                Text(
                  available > 0
                      ? 'Available Quantity: $available'
                      : 'Out of stock',
                  style: TextStyle(
                    color: available > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // الوصف
                if (p.description != null && p.description!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.description!,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ],
                  ),
                const SizedBox(height: 40),

                // الأزرار
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ Added to cart'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: available > 0
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🛒 Proceed to checkout'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.payment),
                        label: const Text('Buy Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 60, color: Colors.grey),
    );
  }
}
