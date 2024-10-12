class Address {
  final int shippingAddressId;
  final int customerId;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String updatedAt;

  Address({
    required this.shippingAddressId,
    required this.customerId,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.updatedAt,
  });

  // Factory constructor to create an Address object from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      shippingAddressId: json['shippingAddressId'],
      customerId: json['customerId'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zipCode: json['zipCode'],
      updatedAt: json['updatedAt'],
    );
  }

  // Method to convert Address object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'shippingAddressId': shippingAddressId,
      'customerId': customerId,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'updatedAt': updatedAt,
    };
  }
}
