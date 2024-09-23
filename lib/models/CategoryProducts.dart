// ignore_for_file: file_names

class CategoryProduct {
  final double price;
  final String title;
  final List<CategoryProductImage> images;
  final int discount;
  final CategoryProductsMerchant merchant;
  final int quantity;
  final int categoryId;
  final String createdAt;
  final int merchantId;
  final int productId;
  final String updatedAt;
  final String description;
  final int stockBalance;
  final String unitOfMeasurement;

  CategoryProduct({
    required this.price,
    required this.title,
    required this.images,
    required this.discount,
    required this.merchant,
    required this.quantity,
    required this.categoryId,
    required this.createdAt,
    required this.merchantId,
    required this.productId,
    required this.updatedAt,
    required this.description,
    required this.stockBalance,
    required this.unitOfMeasurement,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      price: (json['price'] as num).toDouble(),
      title: json['title'] as String,
      images: (json['images'] as List<dynamic>)
          .map((imageJson) => CategoryProductImage.fromJson(imageJson))
          .toList(),
      discount: json['discount'] as int,
      merchant: CategoryProductsMerchant.fromJson(json['merchant']),
      quantity: json['quantity'] as int,
      categoryId: json['categoryId'] as int,
      createdAt: json['created_at'] as String,
      merchantId: json['merchantId'] as int,
      productId: json['product_id'] as int,
      updatedAt: json['updated_at'] as String,
      description: json['description'] as String,
      stockBalance: json['stock_balance'] as int,
      unitOfMeasurement: json['unit_of_measurement'] as String,
    );
  }
}

class CategoryProductsMerchant {
  final int merchantId;
  final String businessName;
  final String merchantType;
  final String subscriptionStatus;
  final String subscriptionEndDate;
  final String createdAt;
  final String updatedAt;

  CategoryProductsMerchant({
    required this.merchantId,
    required this.businessName,
    required this.merchantType,
    required this.subscriptionStatus,
    required this.subscriptionEndDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryProductsMerchant.fromJson(Map<String, dynamic> json) {
    return CategoryProductsMerchant(
      merchantId: json['merchant_id'] as int,
      businessName: json['business_name'] as String,
      merchantType: json['merchant_type'] as String,
      subscriptionStatus: json['subscription_status'] as String,
      subscriptionEndDate: json['subscription_end_date'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class CategoryProductImage {
  final int productImageId;
  final String imageUrl;

  CategoryProductImage({
    required this.productImageId,
    required this.imageUrl,
  });

  factory CategoryProductImage.fromJson(Map<String, dynamic> json) {
    return CategoryProductImage(
      productImageId: json['product_image_id'] as int,
      imageUrl: json['image_url'] as String,
    );
  }
}
