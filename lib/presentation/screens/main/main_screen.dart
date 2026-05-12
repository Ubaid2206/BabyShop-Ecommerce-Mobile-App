import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import 'home_screen.dart';
import '../product/product_list_screen.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.isAdmin) return const AdminDashboardScreen();

    final screens = [
      const HomeScreen(),
      const ProductListScreen(),
      const CartScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.bg1,
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: _BottomNav(index: _index, onTap: (i) => setState(() => _index = i)),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cartCount = Provider.of<CartProvider>(context).totalQuantity;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0x88000000),
            border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(icon: Icons.home_rounded, outlineIcon: Icons.home_outlined, label: 'Home', active: index == 0, onTap: () => onTap(0)),
                  _NavItem(icon: Icons.grid_view_rounded, outlineIcon: Icons.grid_view_outlined, label: 'Shop', active: index == 1, onTap: () => onTap(1)),
                  _CartNavItem(count: cartCount, active: index == 2, onTap: () => onTap(2)),
                  _NavItem(icon: Icons.receipt_long_rounded, outlineIcon: Icons.receipt_long_outlined, label: 'Orders', active: index == 3, onTap: () => onTap(3)),
                  _NavItem(icon: Icons.person_rounded, outlineIcon: Icons.person_outline_rounded, label: 'Profile', active: index == 4, onTap: () => onTap(4)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, outlineIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.outlineIcon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (active)
            ShaderMask(
              shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
              child: Icon(icon, color: Colors.white, size: 24),
            )
          else
            Icon(outlineIcon, color: AppTheme.textSecondary, size: 24),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(
            fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: active ? AppTheme.primary : AppTheme.textSecondary,
          )),
        ]),
      ),
    );
  }
}

class _CartNavItem extends StatelessWidget {
  final int count;
  final bool active;
  final VoidCallback onTap;
  const _CartNavItem({required this.count, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(clipBehavior: Clip.none, children: [
            if (active)
              ShaderMask(
                shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 24),
              )
            else
              const Icon(Icons.shopping_bag_outlined, color: AppTheme.textSecondary, size: 24),
            if (count > 0)
              Positioned(
                top: -6, right: -6,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
                  child: Center(child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
                ),
              ),
          ]),
          const SizedBox(height: 3),
          Text('Cart', style: TextStyle(
            fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: active ? AppTheme.primary : AppTheme.textSecondary,
          )),
        ]),
      ),
    );
  }
}
