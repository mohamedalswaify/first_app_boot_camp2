import 'package:first_app_boot_camp2/All_screens/home_screen.dart';
import 'package:first_app_boot_camp2/core/features/Auth/presentation/screens/login_screen.dart';
import 'package:first_app_boot_camp2/core/features/categories/presentation/screens/categories_screen.dart';
import 'package:first_app_boot_camp2/core/features/products/presentation/screens/product_list_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black)),
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                trailing: const Icon(Icons.arrow_forward),
                subtitle: Text('data'),
                onTap: () {
                  // الانتقال للـ HomeScreen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                }),
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black)),
                leading: const Icon(Icons.category),
                title: const Text('categories'),
                trailing: const Icon(Icons.arrow_forward),
                subtitle: Text('data'),
                onTap: () {
                  // الانتقال للـ HomeScreen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CategoriesScreen(),
                    ),
                  );
                }),
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black)),
                leading: const Icon(Icons.production_quantity_limits),
                title: const Text('products'),
                trailing: const Icon(Icons.arrow_forward),
                subtitle: Text('data'),
                onTap: () {
                  // الانتقال للـ HomeScreen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProductListScreen(),
                    ),
                  );
                }),
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black)),
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward),
                subtitle: Text('data'),
                onTap: () {
                  // الانتقال للـ HomeScreen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                }),
            ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black)),
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Logout'),
                trailing: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                subtitle: Text('data'),
                onTap: () {
                  // الانتقال للـ HomeScreen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
