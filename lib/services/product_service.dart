import 'dart:convert';
import 'package:e_store/models/CategoryProducts.dart';
import 'package:e_store/models/Product.dart';
import 'package:e_store/models/ProductCategory.dart';
import 'package:e_store/models/SingleProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    const String apiUrl = 'https://ah.egroup.co.ke/shop/portal/api/product/';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsJson = data['message'];
        final List<Product> products = productsJson
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<SigleProduct> fetchProduct(String productId) async {
    final String apiUrl =
        'https://ah.egroup.co.ke/shop/portal/api/product/get/$productId/';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productJson = data['message'];
        return SigleProduct.fromJson(productJson);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Error fetching product: $e');
    }
  }

  Future<List<CategoryProduct>> fetchProductsByCategory(
      String categoryId) async {
    final String apiUrl =
        'https://ah.egroup.co.ke/shop/portal/api/product/category/$categoryId';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsJson = data['message'];
        final List<CategoryProduct> products = productsJson
            .map((productJson) => CategoryProduct.fromJson(productJson))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<ProductCategory>> fetchCategories() async {
    const String apiUrl = 'https://ah.egroup.co.ke/shop/portal/api/category/';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categoriesJson = data['message'];
        final List<ProductCategory> categories = categoriesJson
            .map((categoryJson) => ProductCategory.fromJson(categoryJson))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }
}
