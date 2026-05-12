import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/cart_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Order Detail'), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 90, 16, 40),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Status Card
          GlassCard(child: Row(children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(16)),
              child: const Center(child: Text('📦', style: TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Order ID', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Text(order.id, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontSize: 13)),
              const SizedBox(height: 4),
              Text(DateFormat('EEEE, dd MMM yyyy - hh:mm a').format(order.createdAt),
                style: const TextStyle(color: AppTheme.textHint, fontSize: 11)),
            ])),
          ])),
          const SizedBox(height: 14),
          // Items
          _label('🛍️ Ordered Items'),
          const SizedBox(height: 10),
          GlassCard(child: Column(children: [
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.child_care_rounded, color: AppTheme.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text('Qty: ${item.quantity}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ])),
                Text('\$${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              ]),
            )),
            const Divider(color: AppTheme.border),
            _sumRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
            _sumRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
            _sumRow('Shipping', order.shippingCost == 0 ? 'FREE' : '\$${order.shippingCost.toStringAsFixed(2)}', color: order.shippingCost == 0 ? AppTheme.success : null),
            const Divider(color: AppTheme.border),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textPrimary)),
              ShaderMask(
                shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                child: Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white)),
              ),
            ]),
          ])),
          const SizedBox(height: 14),
          // Delivery
          _label('🚚 Delivery Info'),
          const SizedBox(height: 10),
          GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _infoRow(Icons.location_on_outlined, 'Address', order.shippingAddress),
            const SizedBox(height: 10),
            _infoRow(Icons.payment_outlined, 'Payment', order.paymentMethod),
            if (order.trackingNumber != null) ...[
              const SizedBox(height: 10),
              _infoRow(Icons.local_shipping_outlined, 'Tracking', order.trackingNumber!),
            ],
          ])),
          const SizedBox(height: 14),
          // Timeline
          _label('📍 Order Timeline'),
          const SizedBox(height: 10),
          GlassCard(child: Column(children: [
            ...order.statusHistory.asMap().entries.map((e) {
              final isLast = e.key == order.statusHistory.length - 1;
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Column(children: [
                  Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
                  ),
                  if (!isLast) Container(width: 2, height: 36, color: AppTheme.border),
                ]),
                const SizedBox(width: 12),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(e.value.status, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontSize: 13)),
                    if (e.value.note != null) Text(e.value.note!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    Text(DateFormat('dd MMM, hh:mm a').format(e.value.timestamp),
                      style: const TextStyle(color: AppTheme.textHint, fontSize: 11)),
                  ]),
                )),
              ]);
            }),
          ])),
        ]),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary));

  Widget _sumRow(String l, String v, {Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      Text(v, style: TextStyle(fontWeight: FontWeight.w600, color: color ?? AppTheme.textPrimary)),
    ]),
  );

  Widget _infoRow(IconData icon, String label, String value) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, color: AppTheme.primary, size: 18),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500, fontSize: 13)),
    ])),
  ]);
}
