import 'package:flutter/material.dart';
import '../controllers/stockin_controller.dart';
import '../services/stockin_service.dart';
import 'package:intl/intl.dart';

class ViewStockInScreen extends StatefulWidget {
  @override
  _ViewStockInScreenState createState() => _ViewStockInScreenState();
}

class _ViewStockInScreenState extends State<ViewStockInScreen> {
  late StockInController _controller;
  late Future<List<Map<String, dynamic>>> _stockHistoryFuture;

  @override
  void initState() {
    super.initState();
    _controller = StockInController(StockInService());
    _stockHistoryFuture = _controller.getStockHistory();
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat.yMd().add_jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _stockHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stockList = snapshot.data ?? [];

          if (stockList.isEmpty) {
            return Center(child: Text('No stock entries found.'));
          }

          return ListView.builder(
            itemCount: stockList.length,
            itemBuilder: (context, index) {
              final stock = stockList[index];
              final product = stock['products'];
              final productName = product != null
                  ? "${product['name']} (${product['sku']})"
                  : "Unknown Product";
              final quantity = stock['quantity'];
              final createdAt = stock['created_at'];

              return ListTile(
                title: Text(productName),
                subtitle: Text(
                  'Quantity: $quantity\nAdded: ${formatDate(createdAt)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
