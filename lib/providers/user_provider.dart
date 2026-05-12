import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
}
