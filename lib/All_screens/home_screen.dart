import 'package:first_app_boot_camp2/core/features/categories/presentation/screens/categories_screen.dart';
import 'package:first_app_boot_camp2/core/features/products/presentation/screens/product_list_screen.dart';
import 'package:first_app_boot_camp2/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _titles = const ['الرئيسية', 'التصنيفات', 'المنتجات', 'حسابي'];

  late final _pages = <Widget>[
    const _HomeTab(),
    const CategoriesScreen(),
    const ProductListScreen(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(_titles[_index]),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      // المحتوى
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),

      // زر أسفل للتنقل
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined), label: 'التصنيفات'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined), label: 'المنتجات'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),

      // (اختياري) زر عائم للسلة
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.shopping_cart_outlined),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/// التبويبات (مكانك تربطها بشاشاتك الحقيقية)

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('مرحباً بك 👋',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text('هذه هي الصفحة الرئيسية للتطبيق.'),
      ],
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('قائمة التصنيفات'));
  }
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('قائمة المنتجات'));
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('الملف الشخصي'));
  }
}
