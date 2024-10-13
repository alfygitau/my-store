class Order {
  final int charge;
  final int orderId;
  final Customer customer;
  final String createdAt;
  final String updatedAt;
  final int customerId;
  final bool isDelivery;
  final List<OrderItem> orderItems;
  final String orderStatus;
  final String paymentMethod;
  final String paymentStatus;
  final int shippingAddressId;

  Order({
    required this.charge,
    required this.orderId,
    required this.customer,
    required this.createdAt,
    required this.updatedAt,
    required this.customerId,
    required this.isDelivery,
    required this.orderItems,
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.shippingAddressId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      charge: json['charge'],
      orderId: json['orderId'],
      customer: Customer.fromJson(json['customer']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      customerId: json['customerId'],
      isDelivery: json['isDelivery'] == 1, // Assuming 1 for true, 0 for false
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      orderStatus: json['orderStatus'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      shippingAddressId: json['shippingAddressId'],
    );
  }
}

class Customer {
  final String email;
  final String msisdn;
  final String lastName;
  final String username;
  final String firstName;
  final int customerId;

  Customer({
    required this.email,
    required this.msisdn,
    required this.lastName,
    required this.username,
    required this.firstName,
    required this.customerId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      email: json['email'],
      msisdn: json['msisdn'],
      lastName: json['lastName'],
      username: json['username'],
      firstName: json['firstName'],
      customerId: json['customerId'],
    );
  }
}

class OrderItem {
  final double price;
  final String title;
  final int discount;
  final Merchant merchant;
  final int quantity;
  final int productId;
  final String description;

  OrderItem({
    required this.price,
    required this.title,
    required this.discount,
    required this.merchant,
    required this.quantity,
    required this.productId,
    required this.description,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      price: json['price'].toDouble(),
      title: json['title'],
      discount: json['discount'],
      merchant: Merchant.fromJson(json['merchant']),
      quantity: json['quantity'],
      productId: json['productId'],
      description: json['description'],
    );
  }
}

class Merchant {
  final int merchantId;
  final String businessName;
  final String merchantType;
  final String subscriptionStatus;

  Merchant({
    required this.merchantId,
    required this.businessName,
    required this.merchantType,
    required this.subscriptionStatus,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      merchantId: json['merchantId'],
      businessName: json['businessName'],
      merchantType: json['merchantType'],
      subscriptionStatus: json['subscriptionStatus'],
    );
  }
}
