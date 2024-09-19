import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiUrl = 'https://example.com/api/v1/products';

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['products'];
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
