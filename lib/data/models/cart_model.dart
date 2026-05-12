class CartItem {
  final String id;
  final dynamic product; // ProductModel
  final int quantity;

  CartItem({required this.id, required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal, tax, shippingCost, total;
  final String shippingAddress, paymentMethod;
  String status;
  final DateTime createdAt;
  DateTime? updatedAt;
  final String? trackingNumber;
  final List<OrderStatusHistory> statusHistory;

  OrderModel({
    required this.id, required this.userId, required this.items,
    required this.subtotal, required this.tax, required this.shippingCost,
    required this.total, required this.shippingAddress, required this.paymentMethod,
    required this.status, required this.createdAt, this.updatedAt,
    this.trackingNumber, required this.statusHistory,
  });

  OrderModel copyWith({
    String? status, List<OrderStatusHistory>? statusHistory, DateTime? updatedAt,
  }) => OrderModel(
    id: id, userId: userId, items: items, subtotal: subtotal, tax: tax,
    shippingCost: shippingCost, total: total, shippingAddress: shippingAddress,
    paymentMethod: paymentMethod, status: status ?? this.status,
    createdAt: createdAt, updatedAt: updatedAt ?? this.updatedAt,
    trackingNumber: trackingNumber, statusHistory: statusHistory ?? this.statusHistory,
  );
}

class OrderItem {
  final String productId, productName, productImage;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId, required this.productName, required this.productImage,
    required this.price, required this.quantity,
  });

  double get totalPrice => price * quantity;
}

class OrderStatusHistory {
  final String status;
  final DateTime timestamp;
  final String? note;
  OrderStatusHistory({required this.status, required this.timestamp, this.note});
}

class OrderStatus {
  static const String processing = 'Processing';
  static const String confirmed  = 'Confirmed';
  static const String shipped    = 'Shipped';
  static const String delivered  = 'Delivered';
  static const String cancelled  = 'Cancelled';
}
