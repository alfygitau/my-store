// ignore_for_file: file_names

class SigleProduct {
  final int price;
  final String title;
  final List<SingleProductImage> images;
  final int discount;
  final SigleProductMerchant merchant;
  final int quantity;
  final int categoryId;
  final String createdAt;
  final int merchantId;
  final int productId;
  final String updatedAt;
  final String description;
  final int stockBalance;
  final String unitOfMeasurement;

  SigleProduct({
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

  factory SigleProduct.fromJson(Map<String, dynamic> json) {
    return SigleProduct(
      price: json['price'],
      title: json['title'],
      images: (json['images'] as List<dynamic>)
          .map((imageJson) => SingleProductImage.fromJson(imageJson))
          .toList(),
      discount: json['discount'],
      merchant: SigleProductMerchant.fromJson(json['merchant']),
      quantity: json['quantity'],
      categoryId: json['categoryId'],
      createdAt: json['created_at'],
      merchantId: json['merchantId'],
      productId: json['product_id'],
      updatedAt: json['updated_at'],
      description: json['description'],
      stockBalance: json['stock_balance'],
      unitOfMeasurement: json['unit_of_measurement'],
    );
  }
}

class SigleProductMerchant {
  final String createdAt;
  final String updatedAt;
  final int merchantId;
  final String businessName;
  final String merchantType;
  final String subscriptionStatus;
  final String subscriptionEndDate;

  SigleProductMerchant({
    required this.createdAt,
    required this.updatedAt,
    required this.merchantId,
    required this.businessName,
    required this.merchantType,
    required this.subscriptionStatus,
    required this.subscriptionEndDate,
  });

  factory SigleProductMerchant.fromJson(Map<String, dynamic> json) {
    return SigleProductMerchant(
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      merchantId: json['merchant_id'],
      businessName: json['business_name'],
      merchantType: json['merchant_type'],
      subscriptionStatus: json['subscription_status'],
      subscriptionEndDate: json['subscription_end_date'],
    );
  }
}

class SingleProductImage {
  final String imageUrl;
  final int productImageId;

  SingleProductImage({
    required this.imageUrl,
    required this.productImageId,
  });

  factory SingleProductImage.fromJson(Map<String, dynamic> json) {
    return SingleProductImage(
      imageUrl: json['image_url'],
      productImageId: json['product_image_id'],
    );
  }
}
