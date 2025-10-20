import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';
import '../../data/services/category_api_service.dart';
import '../widgets/category_list_item.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
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
      _filtered = q.isEmpty
          ? _all
          : _all.where((c) => c.name.toLowerCase().contains(q)).toList();
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
        title: const Text('Category List'),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // المحتوى
            Expanded(
              child: FutureBuilder<List<CategoryModel>>(
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
                        physics: const AlwaysScrollableScrollPhysics(),
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
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final c = _filtered[i];
                        return CategoryListItem(
                          category: c,
                          onTap: () {
                            // TODO: الانتقال لشاشة الدورات الخاصة بهذا التصنيف
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

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // صورة وهمية
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          // نصوص وهمية
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _block(width: 160, height: 14),
                const SizedBox(height: 8),
                _block(width: 90, height: 10),
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
