import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../main/main_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String orderId;
  const OrderSuccessScreen({Key? key, required this.orderId}) : super(key: key);
  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> with TickerProviderStateMixin {
  late AnimationController _bounceCtrl, _fadeCtrl;
  late Animation<double> _bounce, _fade;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _bounce = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut));
    _fade   = Tween(begin: 0.0, end: 1.0).animate(_fadeCtrl);
    _bounceCtrl.forward().then((_) => _fadeCtrl.forward());
  }

  @override
  void dispose() { _bounceCtrl.dispose(); _fadeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(child: Padding(
        padding: const EdgeInsets.all(AppTheme.lg),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ScaleTransition(
            scale: _bounce,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle, boxShadow: AppTheme.glow),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 64),
            ),
          ),
          const SizedBox(height: 28),
          FadeTransition(opacity: _fade, child: Column(children: [
            ShaderMask(
              shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
              child: const Text('Order Placed! 🎉', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
            const SizedBox(height: 10),
            const Text('Your little one\'s goodies are on the way!', style: TextStyle(color: AppTheme.textSecondary, fontSize: 15), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            GlassCard(padding: const EdgeInsets.all(20), child: Column(children: [
              const Icon(Icons.receipt_long_rounded, color: AppTheme.primary, size: 36),
              const SizedBox(height: 10),
              const Text('Order ID', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(height: 4),
              Text(widget.orderId, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary), textAlign: TextAlign.center),
            ])),
            const SizedBox(height: 16),
            GlassCard(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _step('📦', 'Processing'),
              Container(height: 2, width: 40, color: AppTheme.primary),
              _step('🚚', 'Shipping'),
              Container(height: 2, width: 40, color: AppTheme.border),
              _step('🏠', 'Delivered'),
            ])),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Continue Shopping',
              icon: Icons.shopping_bag_outlined,
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainScreen()), (_) => false),
            ),
          ])),
        ]),
      )),
    );
  }

  Widget _step(String emoji, String label) => Column(children: [
    Text(emoji, style: const TextStyle(fontSize: 24)),
    const SizedBox(height: 4),
    Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
  ]);
}
