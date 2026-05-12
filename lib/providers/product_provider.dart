import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';

/// Product Provider - Local data only (no Firebase)
class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<ProductModel> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => ['All', ...ProductCategory.all];

  /// Load local dummy products
  Future<void> initializeProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 600));

    _products = _getDummyProducts();
    _filteredProducts = _products;
    _isLoading = false;
    notifyListeners();
  }

  List<ProductModel> _getDummyProducts() {
    return [
      // ── Diapers ──────────────────────────────────────────────
      ProductModel(
        id: 'diaper_001',
        name: 'Pampers Premium Diapers Size 4',
        description: 'Ultra-soft, breathable diapers with 12-hour protection. Features wetness indicator and stretchy sides for perfect fit.',
        price: 29.99,
        category: ProductCategory.diapers,
        imageUrls: ['https://images.unsplash.com/photo-1563155921-7e0e1fa2e1c7?w=800'],
        stockQuantity: 150,
        rating: 4.8,
        reviewCount: 342,
        brand: 'Pampers',
        features: ['12-hour protection', 'Wetness indicator', 'Hypoallergenic'],
        ageRange: '9-15 kg',
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'diaper_002',
        name: 'Huggies Natural Care Wipes 3-Pack',
        description: 'Gentle baby wipes with 99% water. Alcohol-free and dermatologically tested for sensitive skin.',
        price: 15.99,
        category: ProductCategory.diapers,
        imageUrls: ['https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=800'],
        stockQuantity: 200,
        rating: 4.7,
        reviewCount: 256,
        brand: 'Huggies',
        features: ['99% water', 'Alcohol-free', 'Dermatologically tested'],
        ageRange: '0+ months',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'diaper_003',
        name: 'Luvs Ultra Leakguards Diapers',
        description: 'LeakGuard Core for up to 12 hours of overnight protection. Soft and comfortable for baby.',
        price: 22.49,
        category: ProductCategory.diapers,
        imageUrls: ['https://images.unsplash.com/photo-1519689609779-bae4e02e1adc?w=800'],
        stockQuantity: 120,
        rating: 4.5,
        reviewCount: 189,
        brand: 'Luvs',
        features: ['LeakGuard Core', 'Overnight protection', 'Stretchy sides'],
        ageRange: '6-10 kg',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),

      // ── Baby Food ─────────────────────────────────────────────
      ProductModel(
        id: 'food_001',
        name: 'Organic Baby Cereal - Rice',
        description: 'Iron-fortified organic rice cereal, perfect for baby\'s first solid food. Non-GMO and easy to digest.',
        price: 8.99,
        category: ProductCategory.babyFood,
        imageUrls: ['https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800'],
        stockQuantity: 120,
        rating: 4.6,
        reviewCount: 189,
        brand: 'Earth\'s Best',
        features: ['Organic', 'Iron-fortified', 'Non-GMO'],
        ageRange: '4+ months',
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'food_002',
        name: 'Fruit Puree Pouches Variety Pack',
        description: 'Organic fruit puree pouches in delicious flavors. No added sugar or preservatives.',
        price: 12.99,
        category: ProductCategory.babyFood,
        imageUrls: ['https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=800'],
        stockQuantity: 180,
        rating: 4.9,
        reviewCount: 412,
        brand: 'Plum Organics',
        features: ['Organic', 'No added sugar', 'BPA-free pouches'],
        ageRange: '6+ months',
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'food_003',
        name: 'Similac Pro-Advance Infant Formula',
        description: 'Premium infant formula with 2\'-FL HMO for immune support plus DHA and lutein for brain development.',
        price: 34.99,
        category: ProductCategory.babyFood,
        imageUrls: ['https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=800'],
        stockQuantity: 95,
        rating: 4.7,
        reviewCount: 278,
        brand: 'Similac',
        features: ['HMO immune support', 'DHA & Lutein', 'Iron-fortified'],
        ageRange: '0-12 months',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'food_004',
        name: 'Gerber Puffs Cereal Snack',
        description: 'Light and airy puffs that melt easily. Perfect first finger food for babies learning to self-feed.',
        price: 5.49,
        category: ProductCategory.babyFood,
        imageUrls: ['https://images.unsplash.com/photo-1586201375761-83865001e31c?w=800'],
        stockQuantity: 220,
        rating: 4.8,
        reviewCount: 534,
        brand: 'Gerber',
        features: ['Melt-in-mouth', 'Self-feeding practice', 'Whole grain'],
        ageRange: '8+ months',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),

      // ── Clothing ──────────────────────────────────────────────
      ProductModel(
        id: 'cloth_001',
        name: 'Organic Cotton Onesies 5-Pack',
        description: 'Super soft organic cotton onesies with snap closures. Machine washable and durable for everyday wear.',
        price: 19.99,
        category: ProductCategory.clothing,
        imageUrls: ['https://images.unsplash.com/photo-1522771930-78848d9293e8?w=800'],
        stockQuantity: 140,
        rating: 4.8,
        reviewCount: 523,
        brand: 'Carter\'s',
        features: ['100% organic cotton', 'Snap closures', 'Machine washable'],
        ageRange: '0-12 months',
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'cloth_002',
        name: 'Baby Sleep Sack - All Season',
        description: 'Cozy wearable blanket to keep baby warm and safe during sleep. TOG 1.0 suitable for all seasons.',
        price: 22.99,
        category: ProductCategory.clothing,
        imageUrls: ['https://images.unsplash.com/photo-1596870230751-ebdfce98ec42?w=800'],
        stockQuantity: 85,
        rating: 4.9,
        reviewCount: 367,
        brand: 'Halo',
        features: ['TOG 1.0', 'Two-way zipper', 'Safe sleep approved'],
        ageRange: '3-12 months',
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'cloth_003',
        name: 'Baby Booties & Mittens Set',
        description: 'Adorable booties and mittens set to keep little hands and feet warm. Elastic cuffs stay in place.',
        price: 9.99,
        category: ProductCategory.clothing,
        imageUrls: ['https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=800'],
        stockQuantity: 160,
        rating: 4.5,
        reviewCount: 145,
        brand: 'Gerber',
        features: ['Soft cotton blend', 'Elastic cuffs', 'Machine washable'],
        ageRange: '0-6 months',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'cloth_004',
        name: 'Baby Girl Floral Dress Set',
        description: 'Adorable floral dress with matching headband. Perfect for special occasions or everyday wear.',
        price: 17.99,
        category: ProductCategory.clothing,
        imageUrls: ['https://images.unsplash.com/photo-1612813281023-5ab5b6eda5bf?w=800'],
        stockQuantity: 75,
        rating: 4.7,
        reviewCount: 98,
        brand: 'Baby Gap',
        features: ['Soft fabric', 'Matching headband', 'Easy snap bottom'],
        ageRange: '3-18 months',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),

      // ── Toys ──────────────────────────────────────────────────
      ProductModel(
        id: 'toy_001',
        name: 'Soft Plush Teddy Bear',
        description: 'Cuddly teddy bear made with hypoallergenic materials. Perfect companion for your little one.',
        price: 16.99,
        category: ProductCategory.toys,
        imageUrls: ['https://images.unsplash.com/photo-1551486943-1f6c0b61c6c0?w=800'],
        stockQuantity: 110,
        rating: 4.9,
        reviewCount: 678,
        brand: 'Jellycat',
        features: ['Hypoallergenic', 'Machine washable', 'Safety tested'],
        ageRange: '0+ months',
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'toy_002',
        name: 'Activity Gym Play Mat',
        description: 'Colorful play mat with hanging toys and music. Encourages motor skills and sensory development.',
        price: 39.99,
        category: ProductCategory.toys,
        imageUrls: ['https://images.unsplash.com/photo-1596461396242-0b7c4ef22caa?w=800'],
        stockQuantity: 65,
        rating: 4.8,
        reviewCount: 234,
        brand: 'Fisher-Price',
        features: ['Music & lights', '5 hanging toys', 'Foldable for storage'],
        ageRange: '0-12 months',
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'toy_003',
        name: 'Rainbow Stacking Rings',
        description: 'Classic stacking toy that helps develop hand-eye coordination and problem-solving skills.',
        price: 11.99,
        category: ProductCategory.toys,
        imageUrls: ['https://images.unsplash.com/photo-1530325553241-4f6e7690cf36?w=800'],
        stockQuantity: 135,
        rating: 4.6,
        reviewCount: 201,
        brand: 'Melissa & Doug',
        features: ['BPA-free plastic', 'Bright colors', 'Educational toy'],
        ageRange: '6+ months',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'toy_004',
        name: 'Musical Crib Mobile',
        description: 'Soothing musical mobile with gentle melodies and rotating characters to help baby sleep.',
        price: 27.99,
        category: ProductCategory.toys,
        imageUrls: ['https://images.unsplash.com/photo-1515488764276-beab7607c1e6?w=800'],
        stockQuantity: 75,
        rating: 4.7,
        reviewCount: 312,
        brand: 'Tiny Love',
        features: ['15 melodies', 'Auto shut-off', 'Easy crib attachment'],
        ageRange: '0-5 months',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      ProductModel(
        id: 'toy_005',
        name: 'Baby Shape Sorter Cube',
        description: 'Colorful shape sorter with 6 different shapes to match and pop through. Great for learning!',
        price: 13.99,
        category: ProductCategory.toys,
        imageUrls: ['https://images.unsplash.com/photo-1596461423231-4b0b2b4e0c0f?w=800'],
        stockQuantity: 90,
        rating: 4.5,
        reviewCount: 167,
        brand: 'VTech',
        features: ['6 shape holes', 'Bright colors', 'BPA-free'],
        ageRange: '12+ months',
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
    ];
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery) ||
          product.brand.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ProductModel> get featuredProducts =>
      _products.where((p) => p.isFeatured).toList();

  Future<bool> addProduct(ProductModel product) async {
    _products.add(product);
    _applyFilters();
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      _applyFilters();
    }
    return true;
  }

  Future<bool> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
    _applyFilters();
    return true;
  }

  Future<bool> addReview(String productId, Review review) async {
    final product = getProductById(productId);
    if (product == null) return false;
    final updatedReviews = [...product.reviews, review];
    final newRating =
        updatedReviews.fold(0.0, (sum, r) => sum + r.rating) /
        updatedReviews.length;
    final updatedProduct = product.copyWith(
      reviews: updatedReviews,
      rating: newRating,
      reviewCount: updatedReviews.length,
      updatedAt: DateTime.now(),
    );
    return await updateProduct(updatedProduct);
  }
}
