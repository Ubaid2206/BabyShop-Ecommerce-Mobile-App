import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/auth_provider.dart';
import '../checkout/checkout_screen.dart';
import '../auth/login_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          if (cart.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => _ClearDialog(onConfirm: cart.clearCart),
              ),
            ),
        ],
      ),
      body: cart.isEmpty
          ? _EmptyCart()
          : Column(children: [
              const SizedBox(height: 90),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: cart.items.length,
                  itemBuilder: (_, i) => _CartItem(item: cart.items[i]),
                ),
              ),
              _OrderSummary(cart: cart),
            ]),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('🛒', style: TextStyle(fontSize: 80)),
      const SizedBox(height: 16),
      const Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      const SizedBox(height: 8),
      const Text('Add some baby goodies!', style: TextStyle(color: AppTheme.textSecondary)),
    ]));
  }
}

class _CartItem extends StatelessWidget {
  final dynamic item;
  const _CartItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: item.product.imageUrls.first,
            width: 80, height: 80, fit: BoxFit.cover,
            placeholder: (_, __) => Container(width: 80, height: 80, color: AppTheme.surface),
            errorWidget: (_, __, ___) => Container(width: 80, height: 80, color: AppTheme.surface, child: const Icon(Icons.image_outlined, color: AppTheme.textHint)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: Text('\$${item.product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Row(children: [
            GlassCard(
              radius: 10, padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                InkWell(onTap: () => cart.decreaseQuantity(item.id),
                  child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.remove_rounded, size: 16, color: AppTheme.textPrimary))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary))),
                InkWell(onTap: () => cart.increaseQuantity(item.id),
                  child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.add_rounded, size: 16, color: AppTheme.textPrimary))),
              ]),
            ),
            const Spacer(),
            Text('\$${item.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => cart.removeFromCart(item.id),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.delete_outline_rounded, color: AppTheme.error, size: 18),
              ),
            ),
          ]),
        ])),
      ]),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartProvider cart;
  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return GlassCard(
      radius: 0,
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Column(children: [
        _row(context, 'Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
        _row(context, 'Tax (8%)', '\$${cart.tax.toStringAsFixed(2)}'),
        _row(context, 'Shipping', cart.shippingCost == 0 ? 'FREE 🎉' : '\$${cart.shippingCost.toStringAsFixed(2)}',
          valueColor: cart.shippingCost == 0 ? AppTheme.success : null),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: AppTheme.border),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: Text('\$${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
          ),
        ]),
        const SizedBox(height: 14),
        GradientButton(
          text: 'Proceed to Checkout',
          icon: Icons.arrow_forward_rounded,
          onPressed: () {
            if (!auth.isAuthenticated) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
          },
        ),
      ]),
    );
  }

  Widget _row(BuildContext context, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor ?? AppTheme.textPrimary)),
      ]),
    );
  }
}

class _ClearDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _ClearDialog({required this.onConfirm});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🗑️', style: TextStyle(fontSize: 40)),
        const SizedBox(height: 12),
        const Text('Clear Cart?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        const Text('Remove all items from cart?', style: TextStyle(color: AppTheme.textSecondary), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(foregroundColor: AppTheme.textSecondary, side: const BorderSide(color: AppTheme.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Cancel'),
          )),
          const SizedBox(width: 12),
          Expanded(child: GradientButton(text: 'Clear', onPressed: () { onConfirm(); Navigator.pop(context); })),
        ]),
      ])),
    );
  }
}
