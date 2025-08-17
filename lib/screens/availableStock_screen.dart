import 'package:flutter/material.dart';
import '../services/stock_service.dart'; // your service that fetches stock data

class AvailableStocksScreen extends StatefulWidget {
  const AvailableStocksScreen({super.key});

  @override
  State<AvailableStocksScreen> createState() => _AvailableStocksScreenState();
}

class _AvailableStocksScreenState extends State<AvailableStocksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<Map<String, dynamic>> allStocks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchStocks();
  }

  Future<void> _fetchStocks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final inventoryService = StockService(); // your service
      final stocks = await inventoryService.getAvailableStocks();

      setState(() {
        allStocks = stocks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching stocks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lowStockItems = allStocks
        .where((item) => item['available_stock'] <= 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Stocks"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All Stocks"),
            Tab(text: "Out of Stock"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildStockList(allStocks),
                _buildStockList(lowStockItems),
              ],
            ),
    );
  }

  Widget _buildStockList(List<Map<String, dynamic>> stockList) {
    if (stockList.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    return ListView.builder(
      itemCount: stockList.length,
      itemBuilder: (context, index) {
        final item = stockList[index];
        return ListTile(
          title: Text("${item['name']} (${item['sku']})"),
          subtitle: Text("Available: ${item['available_stock']}"),
        );
      },
    );
  }
}
