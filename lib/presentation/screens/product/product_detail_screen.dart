import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imgIndex = 0;
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final inCart = cart.isInCart(widget.product.id);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        backgroundColor: Colors.transparent,
        actions: [
          Stack(children: [
            IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: () => Navigator.pop(context)),
            if (cart.itemCount > 0)
              Positioned(top: 8, right: 8, child: Container(
                width: 14, height: 14,
                decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
                child: Center(child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700))),
              )),
          ]),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Image carousel
              SizedBox(
                height: 300,
                child: Stack(children: [
                  PageView.builder(
                    itemCount: widget.product.imageUrls.length,
                    onPageChanged: (i) => setState(() => _imgIndex = i),
                    itemBuilder: (_, i) => CachedNetworkImage(
                      imageUrl: widget.product.imageUrls[i], fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppTheme.surface, child: const Center(child: CircularProgressIndicator(color: AppTheme.primary))),
                      errorWidget: (_, __, ___) => Container(color: AppTheme.surface, child: const Icon(Icons.image_outlined, color: AppTheme.textHint, size: 60)),
                    ),
                  ),
                  if (widget.product.imageUrls.length > 1)
                    Positioned(bottom: 12, left: 0, right: 0,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(widget.product.imageUrls.length, (i) =>
                        AnimatedContainer(duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _imgIndex == i ? 20 : 8, height: 8,
                          decoration: BoxDecoration(
                            gradient: _imgIndex == i ? AppTheme.primaryGradient : null,
                            color: _imgIndex == i ? null : AppTheme.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      )),
                    ),
                ]),
              ),
              // Details
              Padding(
                padding: const EdgeInsets.all(AppTheme.md),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(20)),
                      child: Text(widget.product.category, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.product.isInStock ? AppTheme.success.withOpacity(0.2) : AppTheme.error.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(widget.product.isInStock ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          size: 13, color: widget.product.isInStock ? AppTheme.success : AppTheme.error),
                        const SizedBox(width: 4),
                        Text(widget.product.isInStock ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                            color: widget.product.isInStock ? AppTheme.success : AppTheme.error)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Text(widget.product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text('by ${widget.product.brand}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(children: [
                    RatingBarIndicator(
                      rating: widget.product.rating,
                      itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppTheme.gold),
                      itemCount: 5, itemSize: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewCount} reviews)',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ]),
                  const SizedBox(height: 16),
                  ShaderMask(
                    shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
                    child: Text('\$${widget.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                  if (widget.product.ageRange.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(children: [
                        const Text('👶', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text('Age Range: ${widget.product.ageRange}', style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text('Description', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  const SizedBox(height: 8),
                  Text(widget.product.description, style: const TextStyle(color: AppTheme.textSecondary, height: 1.6)),
                  if (widget.product.features.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Features', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(height: 10),
                    ...widget.product.features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle)),
                        const SizedBox(width: 10),
                        Text(f, style: const TextStyle(color: AppTheme.textSecondary)),
                      ]),
                    )),
                  ],
                  const SizedBox(height: 100),
                ]),
              ),
            ]),
          ),
        ),
        // Bottom bar
        GlassCard(
          radius: 0,
          padding: EdgeInsets.fromLTRB(AppTheme.md, AppTheme.md, AppTheme.md, MediaQuery.of(context).padding.bottom + AppTheme.md),
          child: Row(children: [
            // Qty
            GlassCard(
              radius: AppTheme.r12, padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(icon: const Icon(Icons.remove_rounded, size: 18), onPressed: _qty > 1 ? () => setState(() => _qty--) : null, padding: const EdgeInsets.all(4), constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
                Text('$_qty', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.textPrimary)),
                IconButton(icon: const Icon(Icons.add_rounded, size: 18), onPressed: () => setState(() => _qty++), padding: const EdgeInsets.all(4), constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GradientButton(
                text: inCart ? 'Update Cart' : 'Add to Cart',
                icon: Icons.shopping_bag_rounded,
                onPressed: widget.product.isInStock ? () {
                  for (int i = 0; i < _qty; i++) cart.addToCart(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Added to cart! ✨'),
                    backgroundColor: AppTheme.primary, duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                } : null,
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
