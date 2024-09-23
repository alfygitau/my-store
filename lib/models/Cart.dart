// ignore_for_file: file_names

import 'package:e_store/models/Product.dart';

class Cart {
  final String cartId;
  final List<CartItem> products;

  Cart({
    required this.cartId,
    required this.products,
  });

  int get totalQuantity {
    return products.fold(0, (total, item) => total + item.quantity);
  }

  double get totalPrice {
    return products.fold(
        0.0, (total, item) => total + (item.product.price * item.quantity));
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice {
    return product.price * quantity;
  }
}
