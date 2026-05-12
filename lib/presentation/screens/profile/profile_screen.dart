import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return GradientScaffold(
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.transparent, automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 90, 16, 100),
        child: Column(children: [
          // Avatar
          Center(child: Stack(children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle, boxShadow: AppTheme.glow),
              child: Center(child: Text(
                user != null ? user.name.substring(0, 1).toUpperCase() : '?',
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800, color: Colors.white),
              )),
            ),
            Positioned(bottom: 0, right: 0, child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle, border: Border.all(color: AppTheme.bg1, width: 2)),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 15),
            )),
          ])),
          const SizedBox(height: 14),
          if (user != null) ...[
            ShaderMask(
              shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
              child: Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
            const SizedBox(height: 4),
            Text(user.email, style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(20)),
              child: Text(user.role.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
          ],
          const SizedBox(height: 28),
          // Stats
          Row(children: [
            _Stat('🛒', '0', 'Orders'),
            const SizedBox(width: 12),
            _Stat('⭐', '0', 'Reviews'),
            const SizedBox(width: 12),
            _Stat('💰', '\$0', 'Spent'),
          ]),
          const SizedBox(height: 24),
          // Menu items
          _MenuItem(icon: Icons.person_outline_rounded, label: 'Edit Profile', onTap: () {}),
          _MenuItem(icon: Icons.location_on_outlined, label: 'My Addresses', onTap: () {}),
          _MenuItem(icon: Icons.credit_card_outlined, label: 'Payment Methods', onTap: () {}),
          _MenuItem(icon: Icons.receipt_long_outlined, label: 'My Orders', onTap: () {}),
          _MenuItem(icon: Icons.favorite_outline_rounded, label: 'Wishlist', onTap: () {}),
          _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
          _MenuItem(icon: Icons.help_outline_rounded, label: 'Help & Support', onTap: () {}),
          const SizedBox(height: 8),
          // Logout
          GlassCard(
            padding: const EdgeInsets.all(4),
            child: ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.logout_rounded, color: AppTheme.error, size: 20),
              ),
              title: const Text('Logout', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w700)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.error),
              onTap: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Text('BabyShopHub v1.0.0', style: const TextStyle(color: AppTheme.textHint, fontSize: 12)),
        ]),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String emoji, value, label;
  const _Stat(this.emoji, this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(child: GlassCard(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 4),
      ShaderMask(
        shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
        child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
      ),
      Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
    ]),
  ));
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GlassCard(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(4),
    child: ListTile(
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textHint),
      onTap: onTap,
    ),
  );
}
