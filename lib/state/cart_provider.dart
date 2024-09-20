import 'package:e_store/models/Cart.dart';
import 'package:e_store/models/Product.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Cart _cart = Cart(cartId: UniqueKey().toString(), products: []);

  Cart get cart => _cart;

  void addProduct(Product product, [int quantity = 1]) {
    final existingItemIndex = _cart.products
        .indexWhere((item) => item.product.productId == product.productId);
    if (existingItemIndex >= 0) {
      _cart.products[existingItemIndex].quantity += quantity;
    } else {
      _cart.products.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _cart.products
        .removeWhere((item) => item.product.productId.toString() == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.products.clear();
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final existingItemIndex = _cart.products
        .indexWhere((item) => item.product.productId.toString() == productId);
    if (existingItemIndex >= 0) {
      _cart.products[existingItemIndex].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final existingItemIndex = _cart.products
        .indexWhere((item) => item.product.productId.toString() == productId);
    if (existingItemIndex >= 0) {
      if (_cart.products[existingItemIndex].quantity > 1) {
        _cart.products[existingItemIndex].quantity--;
      } else {
        _cart.products
            .removeAt(existingItemIndex);
      }
      notifyListeners();
    }
  }
}
