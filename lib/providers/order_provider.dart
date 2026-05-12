import 'package:flutter/foundation.dart';
import '../data/models/cart_model.dart';

/// Order Provider - Local in-memory only (no Firebase)
class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load user orders (filtered by userId)
  Future<void> loadUserOrders(String userId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    _isLoading = false;
    notifyListeners();
  }

  /// Load all orders (Admin)
  Future<void> loadAllOrders() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    _isLoading = false;
    notifyListeners();
  }

  /// Create new order
  Future<String?> createOrder({
    required String userId,
    required List<CartItem> cartItems,
    required double subtotal,
    required double tax,
    required double shippingCost,
    required double total,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';

      final orderItems = cartItems
          .map((cartItem) => OrderItem(
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                productImage: cartItem.product.imageUrls.first,
                price: cartItem.product.price,
                quantity: cartItem.quantity,
              ))
          .toList();

      final order = OrderModel(
        id: orderId,
        userId: userId,
        items: orderItems,
        subtotal: subtotal,
        tax: tax,
        shippingCost: shippingCost,
        total: total,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        status: OrderStatus.processing,  // String hai, theek hai
        createdAt: DateTime.now(),
        trackingNumber: 'TRK${orderId.substring(orderId.length - 10)}',
        statusHistory: [
          OrderStatusHistory(
            status: OrderStatus.processing,
            timestamp: DateTime.now(),
            note: 'Order placed successfully',
          ),
        ],
      );

      _orders.insert(0, order);
      notifyListeners();
      return orderId;
    } catch (e) {
      _errorMessage = 'Failed to create order';
      notifyListeners();
      return null;
    }
  }

  /// Update order status (Admin)
  /// ✅ FIX: newStatus String type hai (OrderStatus ek class hai enum nahi)
  Future<bool> updateOrderStatus(String orderId, String newStatus,
      {String? note}) async {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex == -1) return false;

    // ✅ FIX: Valid status check — garbage value se bachao
    const validStatuses = [
      OrderStatus.processing,
      OrderStatus.confirmed,
      OrderStatus.shipped,
      OrderStatus.delivered,
      OrderStatus.cancelled,
    ];
    if (!validStatuses.contains(newStatus)) return false;

    final order = _orders[orderIndex];
    final updatedHistory = [...order.statusHistory];
    updatedHistory.add(OrderStatusHistory(
      status: newStatus,
      timestamp: DateTime.now(),
      note: note,
    ));

    _orders[orderIndex] = order.copyWith(
      status: newStatus,
      statusHistory: updatedHistory,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    return true;
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  /// ✅ FIX: String type use karo OrderStatus type nahi (class hai, enum nahi)
  List<OrderModel> getOrdersByStatus(String status) =>
      _orders.where((o) => o.status == status).toList();

  Future<bool> cancelOrder(String orderId) async =>
      await updateOrderStatus(orderId, OrderStatus.cancelled,
          note: 'Order cancelled by user');
}
