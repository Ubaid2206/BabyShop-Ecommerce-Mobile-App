import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.login(email: _emailCtrl.text.trim(), password: _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(auth.errorMessage ?? 'Login failed'),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: AppTheme.glow,
                    ),
                    child: const Center(child: Text('👶', style: TextStyle(fontSize: 46))),
                  ),
                ),
                const SizedBox(height: 28),
                ShaderMask(
                  shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                  child: const Text('Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Sign in to continue shopping',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                ),
                const SizedBox(height: 40),
                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'your@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter email';
                    if (!v.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter password';
                    if (v.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<AuthProvider>(
                  builder: (_, auth, __) => GradientButton(
                    text: 'Sign In',
                    icon: Icons.login_rounded,
                    isLoading: auth.isLoading,
                    onPressed: auth.isLoading ? null : _login,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(color: AppTheme.textSecondary)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: ShaderMask(
                        shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                        child: const Text('Register', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Demo credentials
                GlassCard(
                  padding: const EdgeInsets.all(AppTheme.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: const [
                        Icon(Icons.key_rounded, color: AppTheme.gold, size: 18),
                        SizedBox(width: 8),
                        Text('Demo Credentials', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      ]),
                      const SizedBox(height: 10),
                      _demoRow('Admin', 'admin@babyshophub.com', 'admin123'),
                      const SizedBox(height: 6),
                      _demoRow('Customer', 'sara@example.com', '123456'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _demoRow(String role, String email, String pass) {
    return GestureDetector(
      onTap: () {
        _emailCtrl.text = email;
        _passCtrl.text = pass;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(role, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(email, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))),
          const Icon(Icons.touch_app_rounded, size: 16, color: AppTheme.textHint),
        ]),
      ),
    );
  }
}
