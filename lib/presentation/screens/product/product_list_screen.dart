import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../data/models/product_model.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchCtrl = TextEditingController();
  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pp = Provider.of<ProductProvider>(context);
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [
        const SizedBox(height: 90),
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: GlassCard(
            radius: 16, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: pp.searchProducts,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search baby products...',
                border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                fillColor: Colors.transparent, filled: true,
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
                        onPressed: () { _searchCtrl.clear(); pp.searchProducts(''); setState(() {}); })
                    : null,
              ),
            ),
          ),
        ),
        // Filter chips
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: pp.categories.length,
            itemBuilder: (_, i) {
              final cat = pp.categories[i];
              final selected = pp.selectedCategory == cat;
              return GestureDetector(
                onTap: () => pp.filterByCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: selected ? AppTheme.primaryGradient : null,
                    color: selected ? null : AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected ? Colors.transparent : AppTheme.border),
                    boxShadow: selected ? AppTheme.glow : [],
                  ),
                  child: Text(cat, style: TextStyle(
                    color: selected ? Colors.white : AppTheme.textSecondary,
                    fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  )),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Grid
        Expanded(
          child: pp.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
              : pp.products.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                      Text('😔', style: TextStyle(fontSize: 60)),
                      SizedBox(height: 12),
                      Text('No products found', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                    ]))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.70,
                        crossAxisSpacing: 12, mainAxisSpacing: 12,
                      ),
                      itemCount: pp.products.length,
                      itemBuilder: (ctx, i) => _ProductCard(product: pp.products[i]),
                    ),
        ),
      ]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final inCart = cart.isInCart(product.id);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: GlassCard(
        padding: EdgeInsets.zero, radius: AppTheme.r16,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.r16)),
              child: CachedNetworkImage(
                imageUrl: product.imageUrls.first,
                height: 140, width: double.infinity, fit: BoxFit.cover,
                placeholder: (_, __) => Container(height: 140, color: AppTheme.surface,
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary))),
                errorWidget: (_, __, ___) => Container(height: 140, color: AppTheme.surface,
                  child: const Icon(Icons.image_outlined, color: AppTheme.textHint, size: 40)),
              ),
            ),
            if (!product.isInStock)
              Positioned.fill(child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.r16)),
                ),
                child: const Center(child: Text('Out of Stock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
              )),
          ]),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.star_rounded, size: 13, color: AppTheme.gold),
                const SizedBox(width: 2),
                Text('${product.rating.toStringAsFixed(1)} (${product.reviewCount})', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ShaderMask(
                  shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                  child: Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                GestureDetector(
                  onTap: product.isInStock ? () {
                    cart.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Added to cart ✨'),
                      backgroundColor: AppTheme.primary, duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ));
                  } : null,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      gradient: product.isInStock ? AppTheme.primaryGradient : null,
                      color: product.isInStock ? null : AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(inCart ? Icons.shopping_bag_rounded : Icons.add_rounded, color: Colors.white, size: 18),
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
