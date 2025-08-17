// controllers/stock_controller.dart
import '../services/stockin_service.dart';

class StockInController {
  final StockInService _stockService;

  StockInController(this._stockService);

  /// Fetch products for dropdown
  Future<List<Map<String, dynamic>>> getProducts() async {
    return await _stockService.fetchProducts();
  }

  /// Add stock using selected product ID
  Future<void> addStock(String productId, int quantity) async {
    if (productId.isEmpty) {
      throw Exception('Please select a product');
    }
    if (quantity <= 0) {
      throw Exception('Quantity must be greater than zero');
    }
    await _stockService.addStock(productId, quantity);
  }

  Future<List<Map<String, dynamic>>> getStockHistory() async {
    return await _stockService.fetchStockHistory();
  }
}
