import 'package:e_store/models/User.dart';
import 'package:flutter/material.dart'; // Import the UserModel

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  String? _lastRoute;

  // Getter for user
  User? get user => _user;

  // Getter for token
  String? get token => _token;

  // Method to set both user and token after login
  void setUserAndToken(User user, String token) {
    _user = user;
    _token = token;

    // Notify listeners to rebuild UI or react to changes
    notifyListeners();
  }

  // Method to clear the user and token on logout
  void clearUserAndToken() {
    _user = null;
    _token = null;

    // Notify listeners about the changes
    notifyListeners();
  }

  // Check if the user is authenticated (token is present)
  bool isAuthenticated() {
    return _token != null;
  }

  // Store the last route before login
  void setLastRoute(String route) {
    _lastRoute = route;
  }

  // Get the last route after login
  String? getLastRoute() {
    return _lastRoute;
  }

  // Clear the last route after navigating
  void clearLastRoute() {
    _lastRoute = null;
  }
}
