import 'package:supabase_flutter/supabase_flutter.dart';

class StockInService {
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
  Future<void> addStock(String productId, int quantity) async {
    final user = supabase.auth.currentUser;

    await supabase.from('stock').insert({
      'user_id': user!.id,
      'product_id': productId,
      'quantity': quantity,
    });
  }

  Future<List<Map<String, dynamic>>> fetchStockHistory() async {
    final data = await supabase
        .from('stock')
        .select('id, product_id, quantity, created_at, products(name, sku)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}
