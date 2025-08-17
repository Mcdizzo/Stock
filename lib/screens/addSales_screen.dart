import 'package:flutter/material.dart';
import '../controllers/sales_controller.dart';
import '../services/sales_service.dart';

class AddSalesScreen extends StatefulWidget {
  @override
  _AddSalesScreenState createState() => _AddSalesScreenState();
}

class _AddSalesScreenState extends State<AddSalesScreen> {
  final _quantityController = TextEditingController();
  late SalesController _controller;
  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic>? _selectedProduct; // stores selected product

  // You might want to fetch product list from DB to show in dropdown (optional)
  // For now, user inputs product ID manually

  @override
  void initState() {
    super.initState();
    _controller = SalesController(SalesService());
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
      ).showSnackBar(const SnackBar(content: Text('Please select a product')));
      return;
    }

    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    final error = await _controller.addSale(
      productId: _selectedProduct!['id'],
      quantity: quantity,
    );

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sales added successfully')));
      _quantityController.clear();
      setState(() => _selectedProduct = null);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
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
      appBar: AppBar(title: Text('Add Sales')),
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
            ElevatedButton(onPressed: _submit, child: Text('Add Sale')),
          ],
        ),
      ),
    );
  }
}
