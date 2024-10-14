import 'dart:convert';
import 'package:e_store/models/Address.dart';
import 'package:http/http.dart' as http;

class AddressService {
  final String baseUrl = 'https://ah.egroup.co.ke/shop/portal/api';

  Future<bool> createAddress(
      Map<String, dynamic> addressData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/address/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addressData),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Address>?> getCustomerAddresses(
      String token, String customerId) async {
    final url = Uri.parse('$baseUrl/address/get/$customerId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('message')) {
          final List<dynamic> addressList = data['message'];
          return addressList.map((json) => Address.fromJson(json)).toList();
        }
      }
      return null;
    } catch (error) {
      return null;
    }
  }
}
