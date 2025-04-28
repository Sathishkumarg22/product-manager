import 'package:bloc_test/bloc_test.dart';
import 'package:demo/blocs/product/product_bloc.dart';
import 'package:demo/blocs/product/product_event.dart';
import 'package:demo/blocs/product/product_state.dart';
import 'package:demo/models/product.dart';
import 'package:demo/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('Bloc Success Scenarios:', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    const dashBoardUrl = 'https://fakestoreapi.com/products';

    List<dynamic> data = [
      {
        "id": 1,
        "title": "Fjallraven Foldsack No. 1 Backpack, Fits 15 Laptops",
        "price": 109.95,
        "description": "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
      },
    ];

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
    });

    blocTest<ProductBloc, ProductState>(
      "When data is empty",
      setUp: () {
        dioAdapter.onGet(
          dashBoardUrl,
          (request) => request.reply(200, []),
        );
      },
      build: () => ProductBloc(productRepository: ProductRepository(dio: dio)),
      act: (bloc) => bloc.add(LoadProducts()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        ProductLoading(),
        ProductLoaded(products: const []),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      "When data is not empty",
      setUp: () {
        dioAdapter.onGet(
          dashBoardUrl,
          (request) => request.reply(200, data),
        );
      },
      build: () => ProductBloc(productRepository: ProductRepository(dio: dio)),
      act: (bloc) => bloc.add(LoadProducts()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        ProductLoading(),
        ProductLoaded(
          products: [
            Product.fromJson(data[0]),
          ],
        ),
      ],
    );
  });

  group('Error scenarios:', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    const dashBoardUrl = 'https://fakestoreapi.com/products';

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
    });

    blocTest<ProductBloc, ProductState>(
      "emits failure when initial response is null",
      setUp: () {
        dioAdapter.onGet(
          dashBoardUrl,
          (request) => request.reply(200, null),
        );
      },
      build: () => ProductBloc(productRepository: ProductRepository(dio: dio)),
      act: (bloc) => bloc.add(LoadProducts()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        ProductLoading(),
        ProductError(error: 'Unknown error', message: 'Unexpected error: null'),
      ],
    );
  });
}
