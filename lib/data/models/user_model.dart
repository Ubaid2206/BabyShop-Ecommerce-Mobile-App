class UserModel {
  final String id, name, email, role;
  final String? phoneNumber, profileImageUrl;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final DateTime createdAt;
  DateTime? updatedAt;

  UserModel({
    required this.id, required this.name, required this.email, required this.role,
    this.phoneNumber, this.profileImageUrl, this.addresses = const [],
    this.paymentMethods = const [], required this.createdAt, this.updatedAt,
  });

  bool get isAdmin => role == 'admin';

  UserModel copyWith({String? name, String? phoneNumber, String? profileImageUrl,
    List<Address>? addresses, List<PaymentMethod>? paymentMethods, DateTime? updatedAt}) {
    return UserModel(
      id: id, name: name ?? this.name, email: email, role: role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      createdAt: createdAt, updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Address {
  final String id, fullName, phoneNumber, addressLine1, city, state, postalCode, country;
  final String? addressLine2;
  final bool isDefault;

  Address({
    required this.id, required this.fullName, required this.phoneNumber,
    required this.addressLine1, this.addressLine2, required this.city,
    required this.state, required this.postalCode, this.country = 'Pakistan',
    this.isDefault = false,
  });

  factory Address.fromMap(Map<String, dynamic> m) => Address(
    id: m['id'], fullName: m['fullName'], phoneNumber: m['phoneNumber'],
    addressLine1: m['addressLine1'], addressLine2: m['addressLine2'],
    city: m['city'], state: m['state'], postalCode: m['postalCode'],
    country: m['country'] ?? 'Pakistan', isDefault: m['isDefault'] ?? false,
  );
}

class PaymentMethod {
  final String id, type, lastFour;
  final bool isDefault;

  PaymentMethod({required this.id, required this.type, required this.lastFour, this.isDefault = false});

  factory PaymentMethod.fromMap(Map<String, dynamic> m) => PaymentMethod(
    id: m['id'], type: m['type'], lastFour: m['lastFour'], isDefault: m['isDefault'] ?? false,
  );
}
