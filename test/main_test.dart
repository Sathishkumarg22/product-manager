import 'package:demo/blocs/auth/auth_bloc.dart';
import 'package:demo/blocs/auth/auth_event.dart';
import 'package:demo/blocs/auth/auth_state.dart';
import 'package:demo/blocs/product/product_bloc.dart';
import 'package:demo/blocs/product/product_event.dart';
import 'package:demo/main.dart';
import 'package:demo/repositories/auth_repository.dart';
import 'package:demo/repositories/product_repository.dart';
import 'package:demo/services/storage_service.dart';
import 'package:demo/ui/screens/login_screen.dart';
import 'package:demo/ui/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'main_test.mocks.dart';

@GenerateMocks([AuthRepository, ProductRepository, StorageService, AuthBloc, ProductBloc])
void main() {
  late MockAuthRepository mockAuthRepository;
  late MockProductRepository mockProductRepository;
  late MockStorageService mockStorageService;
  late MockAuthBloc mockAuthBloc;
  late MockProductBloc mockProductBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockProductRepository = MockProductRepository();
    mockStorageService = MockStorageService();
    mockAuthBloc = MockAuthBloc();
    mockProductBloc = MockProductBloc();
  });

  Widget buildTestableWidget(Widget child, {AuthState? authState}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
        ),
        BlocProvider<ProductBloc>.value(
          value: mockProductBloc,
        ),
        RepositoryProvider.value(value: mockAuthRepository),
        RepositoryProvider.value(value: mockProductRepository),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('MyApp Widget Tests', () {
    testWidgets('displays LoginScreen when AuthBloc state is AuthUnauthenticated', (WidgetTester tester) async {
      // Arrange
      when(mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthUnauthenticated()));

      // Act
      await tester.pumpWidget(
        buildTestableWidget(
          MyApp(
            authRepository: mockAuthRepository,
            productRepository: mockProductRepository,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(ProductListScreen), findsNothing);
    });

    testWidgets('displays ProductListScreen when AuthBloc state is AuthAuthenticated', (WidgetTester tester) async {
      // Arrange
      when(mockAuthBloc.state).thenReturn(AuthAuthenticated(token: 'valid_token'));
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthAuthenticated(token: 'valid_token')));

      // Act
      await tester.pumpWidget(
        buildTestableWidget(
          MyApp(
            authRepository: mockAuthRepository,
            productRepository: mockProductRepository,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProductListScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('sets up MultiProvider with AuthBloc and ProductBloc', (WidgetTester tester) async {
      // Arrange
      when(mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthUnauthenticated()));

      // Act
      await tester.pumpWidget(
        buildTestableWidget(
          MyApp(
            authRepository: mockAuthRepository,
            productRepository: mockProductRepository,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(
        Provider.of<AuthBloc>(tester.element(find.byType(MyApp)), listen: false),
        isNotNull,
      );
      expect(
        Provider.of<ProductBloc>(tester.element(find.byType(MyApp)), listen: false),
        isNotNull,
      );
      expect(
        Provider.of<AuthRepository>(tester.element(find.byType(MyApp)), listen: false),
        equals(mockAuthRepository),
      );
      expect(
        Provider.of<ProductRepository>(tester.element(find.byType(MyApp)), listen: false),
        equals(mockProductRepository),
      );
    });

    testWidgets('triggers AppStarted event on AuthBloc and LoadProducts on ProductBloc', (WidgetTester tester) async {
      // Arrange
      when(mockAuthBloc.state).thenReturn(AuthUnauthenticated());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthUnauthenticated()));
      when(mockAuthBloc.add(any)).thenReturn(null);
      when(mockProductBloc.add(any)).thenReturn(null);

      // Act
      await tester.pumpWidget(
        MyApp(
          authRepository: mockAuthRepository,
          productRepository: mockProductRepository,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      verify(mockAuthBloc.add(AppStarted())).called(1);
      verify(mockProductBloc.add(LoadProducts())).called(1);
    });
  });
}