import 'package:stock/screens/addInventory_screen.dart';
import 'package:stock/screens/addSales_screen.dart';
import 'package:stock/screens/addStock_screen.dart';
import 'package:stock/screens/availableStock_screen.dart';
import 'package:stock/screens/home_screen.dart';
import 'package:stock/screens/inventory_screen.dart';
import 'package:stock/screens/stockin_screen.dart';
import 'package:stock/screens/stockout_screen.dart';
import 'package:stock/screens/viewInventory_screen.dart';
import 'package:stock/screens/viewSales_screen.dart';
import 'package:stock/screens/viewStockIn_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'controllers/auth_contoller.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ezhznvvseffybnzcydvz.supabase.co', // Your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV6aHpudnZzZWZmeWJuemN5ZHZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwMjMxNjEsImV4cCI6MjA3MDU5OTE2MX0.H59yPVQsQFQUVjYM7w3h9VBzWo6RZuvnINiIHQDXvUY', // Add your anon key here
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            AuthScreen(authController: AuthController(authService)),
        '/home': (context) => HomeScreen(),
        '/inventory': (context) => InventoryScreen(),
        '/addProducts': (context) => AddInventoryScreen(),
        '/viewInventory': (context) => ViewInventoryScreen(),
        '/stockIn': (context) => StockInScreen(),
        '/addStock': (context) => AddStockScreen(),
        '/viewStockIn': (context) => ViewStockInScreen(),
        '/stockOut': (context) => StockOutScreen(),
        '/addSales': (context) => AddSalesScreen(),
        '/viewSales': (context) => ViewSalesScreen(),
        '/availableStock': (context) => AvailableStocksScreen(),
      },
    );
  }
}
