import 'package:demo/blocs/auth/auth_bloc.dart';
import 'package:demo/blocs/auth/auth_event.dart';
import 'package:demo/blocs/product/product_bloc.dart';
import 'package:demo/ui/screens/product_form_screen.dart';
import 'package:demo/ui/widgets/animatedFAB.dart';
import 'package:demo/ui/widgets/appBar.dart';
import 'package:demo/ui/widgets/productList.dart';
import 'package:demo/ui/widgets/customSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.purple.shade400],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Products',
                onLogout: () => context.read<AuthBloc>().add(LogoutRequested()),
              ),
              CustomSearchBar(),
              const Expanded(child: ProductList()),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFAB(
        onPressed: () {
          print('Navigating to ProductFormScreen');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<ProductBloc>(),
                    child: const ProductFormScreen(),
                  ),
            ),
          );
        },
      ),
    );
  }
}

// class _AppBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: const Text(
//         'Products',
//         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       ),
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.logout, color: Colors.white),
//           onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
//         ),
//       ],
//     );
//   }
// }
