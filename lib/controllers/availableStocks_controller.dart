import 'package:flutter/material.dart';
import '../services/stock_service.dart';

class AvailableStocksController extends ChangeNotifier {
  final StockService _inventoryService = StockService();

  List<Map<String, dynamic>> availableStocks = [];
  bool isLoading = false;

  Future<void> fetchAvailableStocks() async {
    isLoading = true;
    notifyListeners();

    try {
      availableStocks = await _inventoryService.getAvailableStocks();
    } catch (e) {
      print('Error fetching available stocks: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> get lowStockItems {
    return availableStocks
        .where((item) => item['available_stock'] <= 0)
        .toList();
  }
}
