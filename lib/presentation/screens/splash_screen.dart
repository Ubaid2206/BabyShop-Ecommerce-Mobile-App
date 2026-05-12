import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import 'auth/login_screen.dart';
import 'main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _logoScale = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoFade = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.5)));
    _textFade = Tween(begin: 0.0, end: 1.0).animate(_textCtrl);
    _textSlide = Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    _logoCtrl.forward().then((_) => _textCtrl.forward());
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    await Provider.of<AuthProvider>(context, listen: false).initAuthState();
    await Provider.of<ProductProvider>(context, listen: false).initializeProducts();
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => auth.isAuthenticated ? const MainScreen() : const LoginScreen(),
    ));
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _logoFade,
                child: Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: AppTheme.glow,
                  ),
                  child: const Center(
                    child: Text('👶', style: TextStyle(fontSize: 58)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppTheme.primaryGradient.createShader(b),
                      child: const Text(
                        'BabyShopHub',
                        style: TextStyle(
                          fontSize: 34, fontWeight: FontWeight.w800,
                          color: Colors.white, letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Everything for your little one ✨',
                      style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 36, height: 36,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
