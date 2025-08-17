import 'package:flutter/material.dart';
import '../controllers/stockin_controller.dart';
import '../services/stockin_service.dart';

class AddStockScreen extends StatefulWidget {
  @override
  _AddStockScreenState createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _quantityController = TextEditingController();
  late StockInController _controller;
  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic>? _selectedProduct; // stores selected product

  // You might want to fetch product list from DB to show in dropdown (optional)
  // For now, user inputs product ID manually

  @override
  void initState() {
    super.initState();
    _controller = StockInController(StockInService());
    _loadProducts();
  }

  void _loadProducts() async {
    try {
      final products = await _controller.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load products: $e')));
    }
  }

  void _submit() async {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select a product')));
      return;
    }

    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    try {
      await _controller.addStock(_selectedProduct!['id'], quantity);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Stock added successfully')));
      _quantityController.clear();
      setState(() => _selectedProduct = null);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Stock')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Autocomplete<Map<String, dynamic>>(
              displayStringForOption: (option) =>
                  "${option['name']} (${option['sku']})",
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return _products;
                }
                return _products.where(
                  (product) =>
                      product['name'].toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ) ||
                      product['sku'].toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                );
              },
              onSelected: (selected) {
                _selectedProduct = selected;
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Select Product (Name or SKU)',
                      ),
                    );
                  },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text('Add Stock')),
          ],
        ),
      ),
    );
  }
}
