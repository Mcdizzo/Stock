// services/sales_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryService {
  final supabase = Supabase.instance.client;

  Future<void> addInventory(String name, String sku, int price) async {
    final user = supabase.auth.currentUser;
    final response = await supabase.from('products').insert({
      'user_id': user!.id,
      'name': name,
      'sku': sku,
      'price': price,
    });

    final errorMessage = response?.error?.message ?? 'Unknown error';
    if (errorMessage != 'Unknown error') {
      throw Exception(errorMessage);
    }
  }

  Future<List<Map<String, dynamic>>> fetchInventory() async {
    final data = await supabase
        .from('products')
        .select('id, name, sku, price, created_at')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}
