import 'dart:convert';
import 'package:e_store/models/User.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = "https://ah.egroup.co.ke/shop/portal/api";
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse("$_baseUrl//auth/customer-login");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final accessToken = responseData['message']['access_token'];
        final customerInfo = responseData['message']['customer_info'];
        final user = User.fromJson(customerInfo);
        return {
          'token': accessToken,
          'user': user,
        };
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<bool> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String msisdn,
    required String username,
    required String passwordHash,
  }) async {
    final url = Uri.parse('$_baseUrl/customer/create');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'msisdn': msisdn,
      'username': username,
      'passwordHash': passwordHash,
    });
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
