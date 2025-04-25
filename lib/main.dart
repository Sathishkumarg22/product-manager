import 'package:demo/blocs/auth/auth_bloc.dart';
import 'package:demo/blocs/auth/auth_event.dart';
import 'package:demo/blocs/auth/auth_state.dart';
import 'package:demo/blocs/product/product_bloc.dart';
import 'package:demo/blocs/product/product_event.dart';
import 'package:demo/repositories/auth_repository.dart';
import 'package:demo/repositories/product_repository.dart';
import 'package:demo/services/storage_service.dart';
import 'package:demo/ui/screens/login_screen.dart';
import 'package:demo/ui/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();
  final authRepository = AuthRepository(storageService: storageService);
  final productRepository = ProductRepository();
  runApp(
    MyApp(authRepository: authRepository, productRepository: productRepository),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ProductRepository productRepository;

  const MyApp({
    required this.authRepository,
    required this.productRepository,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider(create: (context) => authRepository),
        RepositoryProvider(create: (context) => productRepository),
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(authRepository: authRepository)..add(AppStarted()),
        ),
        BlocProvider(
          create:
              (context) => ProductBloc(
                productRepository: context.read<ProductRepository>(),
              )..add(LoadProducts()),
        ),
      ],
      child: MaterialApp(
        title: 'Product Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const ProductListScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
