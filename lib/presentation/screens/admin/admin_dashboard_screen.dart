import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_model.dart';
import '../auth/login_screen.dart';

// ✅ Typed class — no more 'as Color' cast crash
class _StatItem {
  final String icon;
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.icon, required this.label, required this.value, required this.color});
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = ['Dashboard', 'Products', 'Orders'];
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: ShaderMask(
          shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
          child: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
              }
            },
          ),
        ],
      ),
      body: Column(children: [
        const SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlassCard(
            padding: const EdgeInsets.all(4),
            radius: 16,
            child: Row(children: List.generate(tabs.length, (i) => Expanded(child: GestureDetector(
              onTap: () => setState(() => _tab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: _tab == i ? AppTheme.primaryGradient : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(tabs[i], textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13,
                    color: _tab == i ? Colors.white : AppTheme.textSecondary)),
              ),
            )))),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(child: IndexedStack(index: _tab, children: const [
          _DashboardTab(),
          _ProductsTab(),
          _OrdersTab(),
        ])),
      ]),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);
    final orders   = Provider.of<OrderProvider>(context);

    // ✅ _StatItem — Map<String,Object> gone, no 'as Color' cast needed
    final stats = [
      _StatItem(icon: '📦', label: 'Total Products', value: '${products.products.length}',                                color: AppTheme.primary),
      _StatItem(icon: '🛒', label: 'Total Orders',   value: '${orders.orders.length}',                                    color: AppTheme.accent),
      _StatItem(icon: '✅', label: 'Delivered',       value: '${orders.getOrdersByStatus(OrderStatus.delivered).length}',  color: AppTheme.success),
      _StatItem(icon: '⏳', label: 'Processing',      value: '${orders.getOrdersByStatus(OrderStatus.processing).length}', color: const Color(0xFFFFD740)),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1.5,
            crossAxisSpacing: 12, mainAxisSpacing: 12,
          ),
          itemCount: stats.length,
          itemBuilder: (_, i) {
            final s = stats[i];
            return GlassCard(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.icon,  style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text(s.value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: s.color)), // ✅ no cast
                Text(s.label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ));
          },
        ),
        const SizedBox(height: 24),
        const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 12),
        if (orders.orders.isEmpty)
          GlassCard(child: const Center(child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('No orders yet', style: TextStyle(color: AppTheme.textSecondary)),
          )))
        else
          ...orders.orders.take(5).map((o) => _MiniOrderRow(order: o)),
      ]),
    );
  }
}

class _MiniOrderRow extends StatelessWidget {
  final OrderModel order;
  const _MiniOrderRow({required this.order});

  String _emoji(String s) {
    switch (s) {
      case OrderStatus.processing: return '⏳';
      case OrderStatus.confirmed:  return '✅';
      case OrderStatus.shipped:    return '🚚';
      case OrderStatus.delivered:  return '🎉';
      case OrderStatus.cancelled:  return '❌';
      default: return '📦';
    }
  }

  Color _color(String s) {
    switch (s) {
      case OrderStatus.processing: return const Color(0xFFFFD740);
      case OrderStatus.confirmed:  return const Color(0xFF00E5FF);
      case OrderStatus.shipped:    return AppTheme.primary;
      case OrderStatus.delivered:  return AppTheme.success;
      case OrderStatus.cancelled:  return AppTheme.error;
      default: return AppTheme.accent;
    }
  }

  @override
  Widget build(BuildContext context) => GlassCard(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    child: Row(children: [
      Text(_emoji(order.status), style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(order.id,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppTheme.textPrimary),
          overflow: TextOverflow.ellipsis),
        Text('${order.items.length} item(s)',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('\$${order.total.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _color(order.status).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(order.status,
            style: TextStyle(color: _color(order.status), fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ]),
    ]),
  );
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab();
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(child: Text('${products.products.length} Products',
            style: const TextStyle(color: AppTheme.textSecondary))),
          GradientButton(text: '+ Add', onPressed: () {}, width: 90),
        ]),
      ),
      const SizedBox(height: 12),
      Expanded(child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: products.products.length,
        itemBuilder: (_, i) {
          final p = products.products[i];
          return GlassCard(padding: const EdgeInsets.all(12), child: Row(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.child_care_rounded, color: AppTheme.primary, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(p.category, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              const SizedBox(height: 2),
              Text('\$${p.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary)),
            ])),
            Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: p.isInStock ? AppTheme.success.withOpacity(0.2) : AppTheme.error.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(p.isInStock ? 'In Stock' : 'Out',
                  style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: p.isInStock ? AppTheme.success : AppTheme.error,
                  )),
              ),
              const SizedBox(height: 6),
              const Icon(Icons.edit_outlined, color: AppTheme.textSecondary, size: 16),
            ]),
          ]));
        },
      )),
    ]);
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    if (orders.orders.isEmpty) {
      return const Center(
        child: Text('No orders yet', style: TextStyle(color: AppTheme.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: orders.orders.length,
      itemBuilder: (_, i) {
        final o = orders.orders[i];
        return GlassCard(padding: const EdgeInsets.all(14), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(o.id,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppTheme.textPrimary),
                overflow: TextOverflow.ellipsis)),
              Text('\$${o.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.primary)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text('${o.items.length} items • ${o.paymentMethod}',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))),
              PopupMenuButton<String>(
                color: AppTheme.bg2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (val) => orders.updateOrderStatus(o.id, val),
                itemBuilder: (_) => [
                  OrderStatus.processing,
                  OrderStatus.confirmed,
                  OrderStatus.shipped,
                  OrderStatus.delivered,
                  OrderStatus.cancelled,
                ].map((s) => PopupMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(color: AppTheme.textPrimary)),
                )).toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(o.status,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                  ]),
                ),
              ),
            ]),
          ],
        ));
      },
    );
  }
}