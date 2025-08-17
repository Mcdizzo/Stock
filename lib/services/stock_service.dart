import 'package:supabase_flutter/supabase_flutter.dart';

class StockService {
  final supabase = Supabase.instance.client;

  /// Get all products with their available stock (stock in - sales)
  Future<List<Map<String, dynamic>>> getAvailableStocks() async {
    // Fetch all products
    final productsResponse = await supabase.from('products').select();

    if (productsResponse.isEmpty) return [];

    List<Map<String, dynamic>> result = [];

    for (var product in productsResponse) {
      final productId = product['id'];

      // Total stock in
      final stockInResponse = await supabase
          .from('stock')
          .select('quantity')
          .eq('product_id', productId);

      int totalStockIn = stockInResponse.fold<int>(
        0,
        (sum, e) => sum + (e['quantity'] as int? ?? 0),
      );

      // Total sales
      final salesResponse = await supabase
          .from('sales')
          .select('quantity')
          .eq('product_id', productId);

      int totalSales = salesResponse.fold<int>(
        0,
        (sum, e) => sum + (e['quantity'] as int? ?? 0),
      );

      // Available stock
      int available = totalStockIn - totalSales;

      result.add({
        'id': product['id'],
        'name': product['name'],
        'sku': product['sku'],
        'available_stock': available,
      });
    }

    return result;
  }
}
