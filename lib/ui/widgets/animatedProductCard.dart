import 'package:demo/models/product.dart';
import 'package:demo/ui/widgets/animatedDismissibleBackground.dart';
import 'package:demo/ui/widgets/product_card.dart';
import 'package:flutter/material.dart';

class AnimatedProductCard extends StatefulWidget {
  final Product product;
  final int index;
  final VoidCallback onDismissed;

  const AnimatedProductCard({
    super.key,
    required this.product,
    required this.index,
    required this.onDismissed,
  });

  @override
  _AnimatedProductCardState createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dismissible(
          key: Key(widget.product.id.toString()),
          onDismissed: (_) => widget.onDismissed(),
          background: AnimatedDismissibleBackground(),
          child: ProductCard(product: widget.product),
        ),
      ),
    );
  }
}