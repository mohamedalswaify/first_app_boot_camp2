import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';
import '../../data/services/category_api_service.dart';
import '../widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _api = CategoryApiService();
  final _searchCtrl = TextEditingController();

  late Future<List<CategoryModel>> _future;
  List<CategoryModel> _all = [];
  List<CategoryModel> _filtered = [];

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

  Future<List<CategoryModel>> _load() async {
    final data = await _api.getCategories();
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
        _filtered =
            _all.where((c) => c.name.toLowerCase().contains(q)).toList();
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
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // شريط البحث
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // المحتوى
            Expanded(
              child: FutureBuilder<List<CategoryModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // حالة التحميل
                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 4),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // عدّلها حسب الموبايل/التابلت
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.86,
                      ),
                      itemCount: 6,
                      itemBuilder: (_, __) => const _SkeletonCard(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('حدث خطأ أثناء تحميل التصنيفات'),
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
                        children: const [
                          SizedBox(height: 60),
                          Icon(Icons.folder_off, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Center(child: Text('لا توجد تصنيفات')),
                          SizedBox(height: 400),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 4),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.86,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final c = _filtered[i];
                        return CategoryCard(
                          category: c,
                          onTap: () {
                            // TODO: افتح شاشة قائمة الدورات الخاصة بالصنف
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => CoursesByCategoryScreen(categoryId: c.id)));
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
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEDEDED),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _block(width: 120),
                const SizedBox(height: 8),
                _block(width: 80, height: 10),
              ],
            ),
          )
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
