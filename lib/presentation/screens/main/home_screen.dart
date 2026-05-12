import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../data/models/product_model.dart';
import '../product/product_detail_screen.dart';
import '../product/product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth    = Provider.of<AuthProvider>(context);
    final products = Provider.of<ProductProvider>(context);

    return GradientScaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(name: auth.currentUser?.name ?? 'Guest')),
          SliverToBoxAdapter(child: _SearchBar()),
          SliverToBoxAdapter(child: _BannerCard()),
          SliverToBoxAdapter(child: _Categories()),
          SliverToBoxAdapter(child: _SectionTitle('⭐ Featured Products', onSeeAll: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductListScreen()));
          })),
          SliverToBoxAdapter(child: _FeaturedRow(products: products.featuredProducts)),
          SliverToBoxAdapter(child: _SectionTitle('🔥 All Products', onSeeAll: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductListScreen()));
          })),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.72,
                crossAxisSpacing: 12, mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _ProductCard(product: products.products[i]),
                childCount: products.products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  const _Header({required this.name});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hello, ${name.split(' ').first} 👋', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            ShaderMask(
              shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
              child: const Text('BabyShopHub', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ]),
          GlassCard(
            radius: 16, padding: const EdgeInsets.all(10),
            child: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary, size: 22),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductListScreen())),
        child: GlassCard(
          radius: 16, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: const [
            Icon(Icons.search_rounded, color: AppTheme.textSecondary, size: 20),
            SizedBox(width: 10),
            Text('Search products...', style: TextStyle(color: AppTheme.textHint, fontSize: 14)),
          ]),
        ),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9B59FF), Color(0xFFE040FB), Color(0xFF00E5FF)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.r20),
        boxShadow: AppTheme.glow,
      ),
      child: Stack(children: [
        Positioned(right: -20, bottom: -20,
          child: Container(width: 140, height: 140,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), shape: BoxShape.circle)),
        ),
        Positioned(right: 40, top: -30,
          child: Container(width: 100, height: 100,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), shape: BoxShape.circle)),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: const Text('LIMITED OFFER', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
            const SizedBox(height: 10),
            const Text('Free Shipping', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
            const Text('on orders above \$50', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Text('Shop Now', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF9B59FF))),
            ),
          ]),
        ),
        const Positioned(right: 16, bottom: 8, child: Text('🛍️', style: TextStyle(fontSize: 60))),
      ]),
    );
  }
}

class _Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pp = Provider.of<ProductProvider>(context, listen: false);
    final cats = [
      {'label': 'Diapers', 'icon': '🧷', 'cat': ProductCategory.diapers},
      {'label': 'Food',    'icon': '🍼', 'cat': ProductCategory.babyFood},
      {'label': 'Clothes', 'icon': '👶', 'cat': ProductCategory.clothing},
      {'label': 'Toys',    'icon': '🧸', 'cat': ProductCategory.toys},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: cats.length,
            itemBuilder: (ctx, i) {
              final c = cats[i];
              return GestureDetector(
                onTap: () {
                  pp.filterByCategory(c['cat'] as String);
                  Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ProductListScreen()));
                },
                child: Column(children: [
                  GlassCard(
                    radius: 18, padding: const EdgeInsets.all(14),
                    child: Text(c['icon'] as String, style: const TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(height: 6),
                  Text(c['label'] as String, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionTitle(this.title, {required this.onSeeAll});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        GestureDetector(onTap: onSeeAll,
          child: ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: const Text('See All', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

class _FeaturedRow extends StatelessWidget {
  final List<ProductModel> products;
  const _FeaturedRow({required this.products});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 240,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemCount: products.length,
      itemBuilder: (ctx, i) => SizedBox(width: 160, child: _ProductCard(product: products[i])),
    ),
  );
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: GlassCard(
        padding: EdgeInsets.zero, radius: AppTheme.r16,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.r16)),
            child: CachedNetworkImage(
              imageUrl: product.imageUrls.first,
              height: 130, width: double.infinity, fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                height: 130, color: AppTheme.surface,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (_, __, ___) => Container(
                height: 130, color: AppTheme.surface,
                child: const Icon(Icons.image_outlined, color: AppTheme.textHint, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star_rounded, size: 13, color: AppTheme.gold),
                const SizedBox(width: 3),
                Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ]),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ShaderMask(
                  shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                  child: Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                GestureDetector(
                  onTap: () {
                    cart.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Added to cart ✨'),
                      backgroundColor: AppTheme.primary,
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ));
                  },
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
