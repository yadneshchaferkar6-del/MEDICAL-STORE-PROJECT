import 'package:flutter/material.dart';

void main() {
  runApp(const MediQuickApp());
}

class MediQuickApp extends StatelessWidget {
  const MediQuickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediQuick Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF15A999),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F8F8),
      ),
      home: const MedicalStoreHomePage(),
    );
  }
}

class Product {
  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.inStock,
  });

  final String name;
  final String category;
  final double price;
  final double rating;
  final bool inStock;
}

class MedicalStoreHomePage extends StatefulWidget {
  const MedicalStoreHomePage({super.key});

  @override
  State<MedicalStoreHomePage> createState() => _MedicalStoreHomePageState();
}

class _MedicalStoreHomePageState extends State<MedicalStoreHomePage> {
  final List<Product> _products = const [
    Product(name: 'Paracetamol 500mg', category: 'Pain Relief', price: 4.99, rating: 4.8, inStock: true),
    Product(name: 'Vitamin C Tablets', category: 'Supplements', price: 8.50, rating: 4.6, inStock: true),
    Product(name: 'Digital Thermometer', category: 'Devices', price: 12.99, rating: 4.4, inStock: true),
    Product(name: 'Hand Sanitizer 500ml', category: 'Hygiene', price: 6.25, rating: 4.7, inStock: false),
    Product(name: 'Cough Syrup', category: 'Cold & Flu', price: 7.25, rating: 4.3, inStock: true),
  ];

  final TextEditingController _searchController = TextEditingController();
  final List<Product> _cart = <Product>[];
  String _selectedCategory = 'All';

  List<String> get _categories => <String>{'All', ..._products.map((Product p) => p.category)}.toList();

  List<Product> get _filteredProducts {
    final String query = _searchController.text.toLowerCase().trim();
    return _products.where((Product product) {
      final bool inCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      final bool matchesQuery = product.name.toLowerCase().contains(query);
      return inCategory && matchesQuery;
    }).toList();
  }

  double get _cartTotal => _cart.fold<double>(0, (double sum, Product p) => sum + p.price);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediQuick Store', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: Badge(label: Text('${_cart.length}'), child: const Icon(Icons.shopping_cart_checkout)),
            onPressed: _showCartSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 12),
              _buildCategoryChips(),
              const SizedBox(height: 14),
              Text('Popular Products', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Expanded(
                child: _filteredProducts.isEmpty
                    ? const Center(child: Text('No products match your search.'))
                    : ListView.separated(
                        itemCount: _filteredProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, int index) => _buildProductTile(_filteredProducts[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCartSheet,
        icon: const Icon(Icons.receipt_long),
        label: Text('Checkout (\$${_cartTotal.toStringAsFixed(2)})'),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF15A999), Color(0xFF0D8A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Health, Our Priority', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('Order trusted medicines and wellness products quickly.', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search medicines, devices, supplements...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((String category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: category == _selectedCategory,
              onSelected: (_) => setState(() => _selectedCategory = category),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductTile(Product product) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(product.category),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 3),
                Text(product.rating.toStringAsFixed(1)),
                const SizedBox(width: 10),
                Text(
                  product.inStock ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(color: product.inStock ? Colors.green : Colors.red, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0D8A8A))),
            ElevatedButton(
              onPressed: product.inStock
                  ? () {
                      setState(() => _cart.add(product));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
                    }
                  : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: _cart.isEmpty
              ? const Center(child: Text('Your cart is empty.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cart Summary', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cart.length,
                        itemBuilder: (_, int index) => ListTile(
                          dense: true,
                          title: Text(_cart[index].name),
                          trailing: Text('\$${_cart[index].price.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${_cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() => _cart.clear());
                          ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Place Order'),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
