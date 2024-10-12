class User {
  final int customerId;
  final String firstName;
  final String lastName;
  final String email;
  final String msisdn;
  final String username;
  final bool isActive;

  User({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.msisdn,
    required this.username,
    required this.isActive,
  });

  // You can also add a method to create a user from a JSON response if needed
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      customerId: json['customerId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      msisdn: json['msisdn'],
      username: json['username'],
      isActive: json['isActive'],
    );
  }

  // Method to convert UserModel to JSON (optional, for requests)
  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'msisdn': msisdn,
      'username': username,
      'isActive': isActive,
    };
  }
}
