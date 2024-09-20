class Product {
  final int productId;
  final String title;
  final String description;
  final double price;
  final double discount;
  final int quantity;
  final String unitOfMeasurement;
  final int stockBalance;
  final int categoryId;
  final int merchantId;
  final Merchant merchant;
  final List<ProductImage> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.unitOfMeasurement,
    required this.stockBalance,
    required this.categoryId,
    required this.merchantId,
    required this.merchant,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      discount: json['discount'].toDouble(),
      quantity: json['quantity'],
      unitOfMeasurement: json['unit_of_measurement'],
      stockBalance: json['stock_balance'],
      categoryId: json['categoryId'],
      merchantId: json['merchantId'],
      merchant: Merchant.fromJson(json['merchant']),
      images: (json['images'] as List)
          .map((imageJson) => ProductImage.fromJson(imageJson))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'description': description,
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'unit_of_measurement': unitOfMeasurement,
      'stock_balance': stockBalance,
      'categoryId': categoryId,
      'merchantId': merchantId,
      'merchant': merchant.toJson(),
      'images': images.map((image) => image.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Merchant {
  final int merchantId;
  final String businessName;
  final String merchantType;
  final String subscriptionStatus;
  final String subscriptionEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Merchant({
    required this.merchantId,
    required this.businessName,
    required this.merchantType,
    required this.subscriptionStatus,
    required this.subscriptionEndDate,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      merchantId: json['merchant_id'],
      businessName: json['business_name'],
      merchantType: json['merchant_type'],
      subscriptionStatus: json['subscription_status'],
      subscriptionEndDate: json['subscription_end_date'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'merchant_id': merchantId,
      'business_name': businessName,
      'merchant_type': merchantType,
      'subscription_status': subscriptionStatus,
      'subscription_end_date': subscriptionEndDate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductImage {
  final int productImageId;
  final String imageUrl;

  ProductImage({
    required this.productImageId,
    required this.imageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      productImageId: json['product_image_id'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_image_id': productImageId,
      'image_url': imageUrl,
    };
  }
}
