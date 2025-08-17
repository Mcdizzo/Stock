import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';
import '../services/inventory_service.dart';

class AddInventoryScreen extends StatefulWidget {
  @override
  _AddInventoryScreenState createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  late InventoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = InventoryController(InventoryService());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    final sku = _skuController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;

    try {
      await _controller.addInventory(name, sku, price);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Product added successfully!')));
      _nameController.clear();
      _skuController.clear();
      _priceController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Sale')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product name'),
            ),
            TextField(
              controller: _skuController,
              decoration: InputDecoration(labelText: 'Product detail'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text('Add Product')),
          ],
        ),
      ),
    );
  }
}
