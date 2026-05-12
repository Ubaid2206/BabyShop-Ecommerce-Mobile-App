import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BabyShopHubApp());
}

class BabyShopHubApp extends StatelessWidget {
  const BabyShopHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'BabyShopHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        builder: (context, child) {
          if (kIsWeb) {
            return Scaffold(
              backgroundColor: const Color(0xFF050510),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: ClipRect(child: child!),
                ),
              ),
            );
          }
          return child!;
        },
        home: const SplashScreen(),
      ),
    );
  }
}
