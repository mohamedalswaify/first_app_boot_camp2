import 'package:first_app_boot_camp2/core/features/products/presentation/screens/product_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/widgets/app_drawer.dart';
import '../../data/models/product_model.dart';
import '../../data/services/product_api_service.dart';
import '../widgets/product_list_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _api = ProductApiService();
  final _searchCtrl = TextEditingController();

  late Future<List<ProductModel>> _future;
  List<ProductModel> _all = [];
  List<ProductModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _future = _load();
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_applyFilter);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<List<ProductModel>> _load() async {
    final data = await _api.getProducts();
    _all = data;
    _filtered = data;
    return data;
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = _all;
      } else {
        _filtered = _all.where((p) {
          final inName = p.name.toLowerCase().contains(q);
          final inCat = (p.categoryName ?? '').toLowerCase().contains(q);
          return inName || inCat;
        }).toList();
      }
    });
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search products or categories...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.separated(
                      itemCount: 6,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, __) => const _SkeletonRow(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('حدث خطأ أثناء تحميل المنتجات'),
                          const SizedBox(height: 8),
                          Text('${snapshot.error}',
                              style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => setState(() => _future = _load()),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_filtered.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 60),
                          Icon(Icons.inventory_2_outlined,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Center(child: Text('لا توجد منتجات')),
                          SizedBox(height: 400),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final p = _filtered[i];
                        return ProductListItem(
                          product: p,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsScreen(productId: p.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // اختياري: زر إضافة منتج
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _block(width: 160, height: 14),
                const SizedBox(height: 8),
                _block(width: 120, height: 12),
                const SizedBox(height: 8),
                _block(width: 100, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _block({double width = 100, double height = 14}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
