import 'package:first_app_boot_camp2/core/features/products/presentation/widgets/thumb_images.dart';
import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductListItem({super.key, required this.product, this.onTap});

  String _priceText(double v) {
    // تنسيق بسيط للسعر – عدّله حسب عملتك
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2);
  }

  Color _stockColor(int available) {
    if (available <= 0) return Colors.red;
    if (available < 5) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final available = product.availableQty;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // صورة
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: ThumbImages(url: product.imageUrl),
                ),
              ),
              const SizedBox(width: 12),

              // نصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    // الفئة + السعر
                    Row(
                      children: [
                        if (product.categoryName != null &&
                            product.categoryName!.isNotEmpty)
                          Flexible(
                            child: Text(
                              product.categoryName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 12.5),
                            ),
                          ),
                        if (product.categoryName != null &&
                            product.categoryName!.isNotEmpty)
                          const SizedBox(width: 8),
                        Text(
                          '${_priceText(product.price)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // حالة المخزون
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _stockColor(available).withOpacity(.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: _stockColor(available).withOpacity(.4)),
                          ),
                          child: Text(
                            available > 0
                                ? 'Available: $available'
                                : 'Out of stock',
                            style: TextStyle(
                              color: _stockColor(available),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('Qty: ${product.qty}',
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 12)),
                        const SizedBox(width: 8),
                        Text('Reserved: ${product.reservedQty}',
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
