import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressService {
  final String baseUrl = 'https://ah.egroup.co.ke/shop/portal/api';

  Future<bool> createAddress(Map<String, dynamic> addressData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/address/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(addressData),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create address: ${response.body}');
      return false;
    }
  }
}
