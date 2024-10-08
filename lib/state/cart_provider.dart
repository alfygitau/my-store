import 'package:e_store/models/Cart.dart';
import 'package:e_store/models/Product.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final Cart _cart = Cart(cartId: UniqueKey().toString(), products: []);

  Cart get cart => _cart;

  bool isInCart(Product product) {
    return _cart.products
        .any((item) => item.product.productId == product.productId);
  }

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

  void addOrIncreaseQuantity(Product product, String productId) {
    final existingItemIndex = _cart.products
        .indexWhere((item) => item.product.productId.toString() == productId);

    if (existingItemIndex >= 0) {
      _cart.products[existingItemIndex].quantity++;
    } else {
      _cart.products.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final existingItemIndex = _cart.products
        .indexWhere((item) => item.product.productId.toString() == productId);
    if (existingItemIndex >= 0) {
      int currentQuantity = _cart.products[existingItemIndex].quantity;
      if (currentQuantity > 1) {
        _cart.products[existingItemIndex].quantity--;
      } else if (currentQuantity == 1) {
        _cart.products.removeAt(existingItemIndex);
      }
    }

    notifyListeners();
  }

  int getQuantity(String productId) {
    final existingItemIndex = _cart.products
        .indexWhere((item) => item.product.productId.toString() == productId);
    if (existingItemIndex >= 0) {
      return _cart.products[existingItemIndex].quantity;
    }
    return 0;
  }
}
