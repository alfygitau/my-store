import 'dart:convert';
import 'package:e_store/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  String? _lastRoute;

  User? get user => _user;

  String? get token => _token;

  void setUserAndToken(User user, String token) {
    _user = user;
    _token = token;

    notifyListeners();
  }

  void clearUserAndToken() {
    _user = null;
    _token = null;

    notifyListeners();
  }

  bool isAuthenticated() {
    if (_token == null) {
      return false;
    }
    final expiryDate = getExpiryDateFromToken(_token!);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  DateTime getExpiryDateFromToken(String token) {

    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = parts[1];
    final decodedPayload =
        utf8.decode(base64Url.decode(base64Url.normalize(payload)));
    final payloadMap = json.decode(decodedPayload);
    final expiryTimeInSeconds = payloadMap['exp'];
    return DateTime.fromMillisecondsSinceEpoch(expiryTimeInSeconds * 1000);
  }

  void setLastRoute(String route) {
    _lastRoute = route;
  }

  String? getLastRoute() {
    return _lastRoute;
  }

  void clearLastRoute() {
    _lastRoute = null;
  }
}
