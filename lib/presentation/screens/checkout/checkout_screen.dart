import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/auth_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController(text: 'Sara Khan');
  final _phoneCtrl   = TextEditingController(text: '+92 300 1234567');
  final _addressCtrl = TextEditingController(text: '123 Baby Lane, DHA');
  final _cityCtrl    = TextEditingController(text: 'Lahore');
  int _payMethod = 0; // 0=COD, 1=Card, 2=JazzCash

  final _payments = [
    {'icon': '💵', 'label': 'Cash on Delivery'},
    {'icon': '💳', 'label': 'Credit/Debit Card'},
    {'icon': '📱', 'label': 'JazzCash'},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    final cart = Provider.of<CartProvider>(context, listen: false);
    final orders = Provider.of<OrderProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final orderId = await orders.createOrder(
      userId: auth.currentUser!.id,
      cartItems: cart.items,
      subtotal: cart.subtotal,
      tax: cart.tax,
      shippingCost: cart.shippingCost,
      total: cart.total,
      shippingAddress: '${_nameCtrl.text}, ${_addressCtrl.text}, ${_cityCtrl.text} | ${_phoneCtrl.text}',
      paymentMethod: _payments[_payMethod]['label']!,
    );

    if (!mounted) return;
    if (orderId != null) {
      cart.clearCart();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: orderId)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return GradientScaffold(
      appBar: AppBar(title: const Text('Checkout'), backgroundColor: Colors.transparent),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 90, 16, 120),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Delivery Info
            _sectionTitle('📦 Delivery Information'),
            const SizedBox(height: 12),
            GlassCard(child: Column(children: [
              _field(_nameCtrl, 'Full Name', Icons.person_outline, (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              _field(_phoneCtrl, 'Phone Number', Icons.phone_outlined, (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              _field(_addressCtrl, 'Street Address', Icons.location_on_outlined, (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              _field(_cityCtrl, 'City', Icons.location_city_outlined, (v) => v!.isEmpty ? 'Required' : null),
            ])),
            const SizedBox(height: 24),
            // Payment
            _sectionTitle('💳 Payment Method'),
            const SizedBox(height: 12),
            ...List.generate(_payments.length, (i) => GestureDetector(
              onTap: () => setState(() => _payMethod = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: _payMethod == i ? const LinearGradient(colors: [Color(0x449B59FF), Color(0x22E040FB)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                  color: _payMethod == i ? null : AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.r16),
                  border: Border.all(color: _payMethod == i ? AppTheme.primary : AppTheme.border, width: _payMethod == i ? 2 : 1),
                ),
                child: Row(children: [
                  Text(_payments[i]['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 14),
                  Text(_payments[i]['label']!, style: TextStyle(fontWeight: FontWeight.w600, color: _payMethod == i ? AppTheme.textPrimary : AppTheme.textSecondary)),
                  const Spacer(),
                  if (_payMethod == i) Container(width: 20, height: 20,
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 13)),
                ]),
              ),
            )),
            const SizedBox(height: 24),
            // Order summary
            _sectionTitle('🧾 Order Summary'),
            const SizedBox(height: 12),
            GlassCard(child: Column(children: [
              ...cart.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Expanded(child: Text(item.product.name, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13), overflow: TextOverflow.ellipsis)),
                  Text('x${item.quantity}', style: const TextStyle(color: AppTheme.textHint, fontSize: 12)),
                  const SizedBox(width: 8),
                  Text('\$${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                ]),
              )),
              const Divider(color: AppTheme.border),
              _sumRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
              _sumRow('Tax (8%)', '\$${cart.tax.toStringAsFixed(2)}'),
              _sumRow('Shipping', cart.shippingCost == 0 ? 'FREE 🎉' : '\$${cart.shippingCost.toStringAsFixed(2)}', color: cart.shippingCost == 0 ? AppTheme.success : null),
              const Divider(color: AppTheme.border),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Total', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                ShaderMask(
                  shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                  child: Text('\$${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ]),
            ])),
          ]),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<OrderProvider>(
          builder: (_, ord, __) => GradientButton(
            text: 'Place Order',
            icon: Icons.check_circle_outline_rounded,
            isLoading: ord.isLoading,
            onPressed: ord.isLoading ? null : _placeOrder,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary));

  Widget _field(TextEditingController ctrl, String label, IconData icon, String? Function(String?) validator) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: validator,
    );
  }

  Widget _sumRow(String label, String val, {Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      Text(val, style: TextStyle(fontWeight: FontWeight.w600, color: color ?? AppTheme.textPrimary, fontSize: 13)),
    ]),
  );
}
