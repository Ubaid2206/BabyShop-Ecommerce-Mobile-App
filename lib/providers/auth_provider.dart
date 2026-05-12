import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

/// Authentication Provider - Local only (no Firebase)
class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Demo accounts (in real app, use a backend API)
  static final List<Map<String, dynamic>> _demoAccounts = [
    {
      'id': 'admin_001',
      'name': 'Admin User',
      'email': 'admin@babyshophub.com',
      'password': 'admin123',
      'role': 'admin',
    },
    {
      'id': 'user_001',
      'name': 'Sara Khan',
      'email': 'sara@example.com',
      'password': '123456',
      'role': 'customer',
    },
  ];

  // Local registered users (in-memory for session)
  final List<Map<String, dynamic>> _registeredUsers = [..._demoAccounts];

  /// Initialize auth state from SharedPreferences
  Future<void> initAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('logged_in_user_id');
      if (savedUserId != null) {
        final userData = _registeredUsers.firstWhere(
          (u) => u['id'] == savedUserId,
          orElse: () => {},
        );
        if (userData.isNotEmpty) {
          _currentUser = _buildUserModel(userData);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading auth state: $e');
    }
  }

  UserModel _buildUserModel(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      role: data['role'] ?? 'customer',
      addresses: (data['addresses'] as List?)
              ?.map((a) => Address.fromMap(a))
              .toList() ?? [],
      paymentMethods: (data['paymentMethods'] as List?)
              ?.map((p) => PaymentMethod.fromMap(p))
              .toList() ?? [],
      createdAt: DateTime.now(),
    );
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Check if email already exists
      final exists = _registeredUsers.any((u) => u['email'] == email);
      if (exists) {
        _isLoading = false;
        _errorMessage = 'This email is already registered.';
        notifyListeners();
        return false;
      }

      // Create new user
      final newUser = {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'name': name,
        'email': email,
        'password': password,
        'role': 'customer',
        'addresses': [],
        'paymentMethods': [],
      };
      _registeredUsers.add(newUser);

      _currentUser = _buildUserModel(newUser);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_in_user_id', _currentUser!.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Find user
      final userData = _registeredUsers.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => {},
      );

      if (userData.isEmpty) {
        _isLoading = false;
        _errorMessage = 'Invalid email or password.';
        notifyListeners();
        return false;
      }

      _currentUser = _buildUserModel(userData);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_in_user_id', _currentUser!.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Login failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('logged_in_user_id');
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }

  /// Reset password (local simulation)
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 800));

      final exists = _registeredUsers.any((u) => u['email'] == email);
      _isLoading = false;

      if (!exists) {
        _errorMessage = 'No account found with this email.';
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to send reset email.';
      notifyListeners();
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        updatedAt: DateTime.now(),
      );

      // Update in registered users list
      final idx = _registeredUsers.indexWhere((u) => u['id'] == _currentUser!.id);
      if (idx != -1) {
        _registeredUsers[idx]['name'] = _currentUser!.name;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Add address
  Future<bool> addAddress(Address address) async {
    if (_currentUser == null) return false;

    final updatedAddresses = List<Address>.from(_currentUser!.addresses);
    if (address.isDefault) {
      final reset = updatedAddresses
          .map((a) => Address(
                id: a.id, fullName: a.fullName, phoneNumber: a.phoneNumber,
                addressLine1: a.addressLine1, addressLine2: a.addressLine2,
                city: a.city, state: a.state, postalCode: a.postalCode,
                country: a.country, isDefault: false,
              ))
          .toList();
      updatedAddresses.clear();
      updatedAddresses.addAll(reset);
    }
    updatedAddresses.add(address);
    _currentUser = _currentUser!.copyWith(addresses: updatedAddresses);
    notifyListeners();
    return true;
  }

  /// Add payment method
  Future<bool> addPaymentMethod(PaymentMethod paymentMethod) async {
    if (_currentUser == null) return false;

    final updatedMethods = List<PaymentMethod>.from(_currentUser!.paymentMethods);
    updatedMethods.add(paymentMethod);
    _currentUser = _currentUser!.copyWith(paymentMethods: updatedMethods);
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
