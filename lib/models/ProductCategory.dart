// ignore_for_file: file_names

class ProductCategory {
  final String name;
  final int categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String description;

  // Constructor with required named parameters
  ProductCategory({
    required this.name,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
  });

  // Factory constructor for creating a ProductCategory instance from a JSON map
  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      name: json['name'] as String,
      categoryId: json['categoryId'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      description: json['description'] as String,
    );
  }

  // Method to convert a ProductCategory instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categoryId': categoryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'description': description,
    };
  }
}
