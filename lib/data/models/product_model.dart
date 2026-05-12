class ProductCategory {
  static const String diapers  = 'Diapers';
  static const String babyFood = 'Baby Food';
  static const String clothing = 'Clothing';
  static const String toys     = 'Toys';
  static const List<String> all = [diapers, babyFood, clothing, toys];
}

class ProductModel {
  final String id, name, description, category, brand, ageRange;
  final double price;
  final List<String> imageUrls, features;
  final int stockQuantity, reviewCount;
  double rating;
  final bool isFeatured;
  final List<Review> reviews;
  final DateTime createdAt;
  DateTime? updatedAt;

  ProductModel({
    required this.id, required this.name, required this.description,
    required this.price, required this.category, required this.imageUrls,
    required this.stockQuantity, required this.rating, required this.reviewCount,
    required this.brand, this.features = const [], this.ageRange = '',
    this.isFeatured = false, this.reviews = const [], required this.createdAt,
    this.updatedAt,
  });

  bool get isInStock => stockQuantity > 0;

  ProductModel copyWith({
    String? name, String? description, double? price, int? stockQuantity,
    double? rating, int? reviewCount, List<Review>? reviews, DateTime? updatedAt,
  }) => ProductModel(
    id: id, name: name ?? this.name, description: description ?? this.description,
    price: price ?? this.price, category: category, imageUrls: imageUrls,
    stockQuantity: stockQuantity ?? this.stockQuantity, rating: rating ?? this.rating,
    reviewCount: reviewCount ?? this.reviewCount, brand: brand,
    features: features, ageRange: ageRange, isFeatured: isFeatured,
    reviews: reviews ?? this.reviews, createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class Review {
  final String id, userId, userName, comment;
  final double rating;
  final DateTime createdAt;
  Review({required this.id, required this.userId, required this.userName, required this.comment, required this.rating, required this.createdAt});
}
