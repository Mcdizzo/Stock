// controllers/sales_controller.dart
import '../services/inventory_service.dart';

class InventoryController {
  final InventoryService _inventoryService;

  InventoryController(this._inventoryService);

  Future<void> addInventory(String name, String sku, int price) async {
    if (name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
    if (price <= 0) {
      throw Exception('Price must be greater than zero');
    }

    await _inventoryService.addInventory(name, sku, price);
  }

  Future<List<Map<String, dynamic>>> getInventory() async {
    return await _inventoryService.fetchInventory();
  }
}
