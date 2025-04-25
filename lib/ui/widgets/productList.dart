import 'package:demo/blocs/product/product_bloc.dart';
import 'package:demo/blocs/product/product_event.dart';
import 'package:demo/blocs/product/product_state.dart';
import 'package:demo/ui/widgets/animatedProductCard.dart';
import 'package:demo/ui/widgets/emptyState.dart';
import 'package:demo/ui/widgets/errorState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        print('STATE: ${state.runtimeType}');
        print('ProductList state::::: $state');
        if (state is ProductDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product deleted successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is ProductError) {
          print('ProductList error::::: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (state is ProductLoaded) {
              if (state.products.isEmpty) {
                return EmptyState(
                  onRetry:
                      () => context.read<ProductBloc>().add(LoadProducts()),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return AnimatedProductCard(
                    product: product,
                    index: index,
                    onDismissed: () {
                      if (int.tryParse(product.id) != null) {
                        context.read<ProductBloc>().add(
                          DeleteProduct(id: int.parse(product.id)),
                        );
                      }
                    },
                  );
                },
              );
            } else if (state is ProductError) {
              return ErrorState(
                message: state.message,
                onRetry: () => context.read<ProductBloc>().add(LoadProducts()),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
