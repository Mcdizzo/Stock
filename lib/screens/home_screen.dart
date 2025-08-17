import 'package:flutter/material.dart';
import 'package:stock/controllers/auth_contoller.dart';
import 'package:stock/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    final authController = AuthController(AuthService());
    authController.logout(context);
  }

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock App Dashboard')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStockCard(
              context,
              icon: Icons.inventory,
              title: 'Inventory',
              color: const Color.fromARGB(255, 239, 217, 19),
              onTap: () => _navigateTo(context, '/inventory'),
            ),
            _buildStockCard(
              context,
              icon: Icons.add_box,
              title: 'Stock In',
              color: Colors.green,
              onTap: () => _navigateTo(context, '/stockIn'),
            ),
            _buildStockCard(
              context,
              icon: Icons.remove_circle,
              title: 'Stock Out',
              color: Colors.red,
              onTap: () => _navigateTo(context, '/stockOut'),
            ),
            _buildStockCard(
              context,
              icon: Icons.inventory,
              title: 'Available Stocks',
              color: Colors.blue,
              onTap: () => _navigateTo(context, '/availableStock'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
