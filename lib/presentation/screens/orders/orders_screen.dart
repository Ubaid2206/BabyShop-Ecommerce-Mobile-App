import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../data/models/cart_model.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.currentUser != null) {
        Provider.of<OrderProvider>(context, listen: false).loadUserOrders(auth.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    return GradientScaffold(
      appBar: AppBar(title: const Text('My Orders'), backgroundColor: Colors.transparent, automaticallyImplyLeading: false),
      body: orders.orders.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Text('📋', style: TextStyle(fontSize: 80)),
              SizedBox(height: 16),
              Text('No orders yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              SizedBox(height: 8),
              Text('Your orders will appear here', style: TextStyle(color: AppTheme.textSecondary)),
            ]))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 100),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: orders.orders.length,
              itemBuilder: (_, i) => _OrderCard(order: orders.orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.processing: return const Color(0xFFFFD740);
      case OrderStatus.confirmed:  return const Color(0xFF00E5FF);
      case OrderStatus.shipped:    return AppTheme.primary;
      case OrderStatus.delivered:  return AppTheme.success;
      case OrderStatus.cancelled:  return AppTheme.error;
      default: return AppTheme.textSecondary;
    }
  }

  String get _statusEmoji {
    switch (order.status) {
      case OrderStatus.processing: return '⏳';
      case OrderStatus.confirmed:  return '✅';
      case OrderStatus.shipped:    return '🚚';
      case OrderStatus.delivered:  return '🎉';
      case OrderStatus.cancelled:  return '❌';
      default: return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order))),
      child: GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(_statusEmoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(order.id, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: _statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(order.status, style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 10),
        const Divider(color: AppTheme.border),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${order.items.length} item${order.items.length > 1 ? 's' : ''}',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 2),
            Text(DateFormat('dd MMM yyyy').format(order.createdAt),
              style: const TextStyle(color: AppTheme.textHint, fontSize: 12)),
          ]),
          ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: Text('\$${order.total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          const Text('View Details', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppTheme.primary),
        ]),
      ])),
    );
  }
}
