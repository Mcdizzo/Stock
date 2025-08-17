// services/sales_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SalesService {
  final supabase = Supabase.instance.client;

  /// Fetch all products for the dropdown/autocomplete
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final data = await supabase
        .from('products')
        .select('id, name, sku')
        .order('name', ascending: true); // alphabetical
    return List<Map<String, dynamic>>.from(data);
  }

  /// Insert a stock record
  Future<void> addSale(String productId, int saleQuantity) async {
    // 1. Get total stock in
    final stockResponse = await supabase
        .from('stock')
        .select('quantity')
        .eq('product_id', productId);

    final totalStockIn = stockResponse.fold<int>(
      0,
      (sum, row) => sum + (row['quantity'] as int),
    );

    // 2. Get total sales
    final salesResponse = await supabase
        .from('sales')
        .select('quantity')
        .eq('product_id', productId);

    final totalSales = salesResponse.fold<int>(
      0,
      (sum, row) => sum + (row['quantity'] as int),
    );

    final available = totalStockIn - totalSales;

    // 3. Check stock before inserting
    if (saleQuantity > available) {
      throw Exception(
        'Not enough stock. Available: $available, Requested: $saleQuantity',
      );
    }

    // 4. Insert sale
    await supabase.from('sales').insert({
      'product_id': productId,
      'quantity': saleQuantity,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchSalesHistory() async {
    final data = await supabase
        .from('sales')
        .select('id, product_id, quantity, created_at, products(name, sku)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}
