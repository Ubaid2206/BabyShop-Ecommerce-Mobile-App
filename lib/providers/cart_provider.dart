import 'package:flutter/foundation.dart';
import '../data/models/cart_model.dart';
import '../data/models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  bool get isEmpty  => _items.isEmpty;
  int  get itemCount => _items.length;
  int  get totalQuantity => _items.fold(0, (sum, i) => sum + i.quantity);

  bool isInCart(String productId) => _items.any((i) => i.product.id == productId);

  double get subtotal    => _items.fold(0, (sum, i) => sum + i.totalPrice);
  double get tax         => subtotal * 0.08;
  double get shippingCost => subtotal >= 50 ? 0 : 4.99;
  double get total       => subtotal + tax + shippingCost;

  void addToCart(ProductModel product) {
    final idx = _items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      _items[idx] = CartItem(id: _items[idx].id, product: product, quantity: _items[idx].quantity + 1);
    } else {
      _items.add(CartItem(id: DateTime.now().millisecondsSinceEpoch.toString(), product: product, quantity: 1));
    }
    notifyListeners();
  }

  void increaseQuantity(String itemId) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx >= 0) {
      _items[idx] = CartItem(id: _items[idx].id, product: _items[idx].product, quantity: _items[idx].quantity + 1);
      notifyListeners();
    }
  }

  void decreaseQuantity(String itemId) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        _items[idx] = CartItem(id: _items[idx].id, product: _items[idx].product, quantity: _items[idx].quantity - 1);
      } else {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
