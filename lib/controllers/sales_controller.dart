// controllers/sales_controller.dart
import 'package:flutter/material.dart';

import '../services/sales_service.dart';

class SalesController extends ChangeNotifier {
  final SalesService _salesService;

  SalesController(this._salesService);

  Future<List<Map<String, dynamic>>> getProducts() async {
    return await _salesService.fetchProducts();
  }

  Future<String?> addSale({
    required String productId,
    required int quantity,
  }) async {
    try {
      await _salesService.addSale(productId, quantity);
      notifyListeners();
      return null; // null = success
    } catch (e) {
      return e.toString(); // return error message
    }
  }

  Future<List<Map<String, dynamic>>> getSalesHistory() async {
    return await _salesService.fetchSalesHistory();
  }
}
