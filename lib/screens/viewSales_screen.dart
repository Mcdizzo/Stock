import 'package:flutter/material.dart';
import '../controllers/sales_controller.dart';
import '../services/sales_service.dart';
import 'package:intl/intl.dart';

class ViewSalesScreen extends StatefulWidget {
  @override
  _ViewSalesScreenState createState() => _ViewSalesScreenState();
}

class _ViewSalesScreenState extends State<ViewSalesScreen> {
  late SalesController _controller;
  late Future<List<Map<String, dynamic>>> _salesHistoryFuture;

  @override
  void initState() {
    super.initState();
    _controller = SalesController(SalesService());
    _salesHistoryFuture = _controller.getSalesHistory();
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat.yMd().add_jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sales History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _salesHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final salesList = snapshot.data ?? [];

          if (salesList.isEmpty) {
            return Center(child: Text('No sales entries found.'));
          }

          return ListView.builder(
            itemCount: salesList.length,
            itemBuilder: (context, index) {
              final stock = salesList[index];
              final product = stock['products'];
              final productName = product != null
                  ? "${product['name']} (${product['sku']})"
                  : "Unknown Product";
              final quantity = stock['quantity'];
              final createdAt = stock['created_at'];

              return ListTile(
                title: Text(productName),
                subtitle: Text(
                  'Quantity: $quantity\nSold: ${formatDate(createdAt)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
