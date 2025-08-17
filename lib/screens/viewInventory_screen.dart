import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';
import '../services/inventory_service.dart';
import 'package:intl/intl.dart';

class ViewInventoryScreen extends StatefulWidget {
  @override
  _ViewInventoryScreenState createState() => _ViewInventoryScreenState();
}

class _ViewInventoryScreenState extends State<ViewInventoryScreen> {
  late InventoryController _controller;
  late Future<List<Map<String, dynamic>>> _inventoryHistoryFuture;

  @override
  void initState() {
    super.initState();
    _controller = InventoryController(InventoryService());
    _inventoryHistoryFuture = _controller.getInventory();
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat.yMd().add_jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inventory History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _inventoryHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final inventoryList = snapshot.data ?? [];

          if (inventoryList.isEmpty) {
            return Center(child: Text('No inventories found.'));
          }

          return ListView.builder(
            itemCount: inventoryList.length,
            itemBuilder: (context, index) {
              final product = inventoryList[index];
              final productName = product['name'];
              final sku = product['sku'];
              final price = product['price'];
              final createdAt = product['created_at'];

              return ListTile(
                title: Text(productName),
                subtitle: Text(
                  'Price: $price\nAdded: ${formatDate(createdAt)}\nExtraDetail: ${sku ?? 'No detail'}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
