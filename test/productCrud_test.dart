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
  late Dio dio;
  late DioAdapter dioAdapter;
  late ProductRepository productRepository;
  const productUrl = 'https://fakestoreapi.com/products';

  final sampleProduct = Product(
    id: '123',
    name: 'Test Product',
    price: 10.5,
    imageUrl: 'https://example.com/image.png',
    description: 'Test Description',
    category: 'Test Category',
  );

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
    productRepository = ProductRepository(dio: dio);
  });

  group('ProductBloc Add/Update/Delete Tests:', () {
    blocTest<ProductBloc, ProductState>(
      'Add Product Success',
      setUp: () {
        dioAdapter.onPost(
          productUrl,
          (server) => server.reply(201, sampleProduct.toJson()),
          data: sampleProduct.toJson(),
        );
      },
      build: () => ProductBloc(productRepository: productRepository),
      act: (bloc) => bloc.add(AddProduct(product: sampleProduct)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        ProductLoading(),
        ProductAdded(),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'Update Product Success',
      setUp: () {
        dioAdapter.onPut(
          '$productUrl/${sampleProduct.id}',
          (server) => server.reply(200, sampleProduct.toJson()),
          data: sampleProduct.toJson(),
        );
      },
      build: () => ProductBloc(productRepository: productRepository),
      act: (bloc) => bloc.add(UpdateProduct(product: sampleProduct)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        ProductLoading(),
        ProductUpdated(),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'Delete Product Success',
      setUp: () {
        dioAdapter.onDelete(
          '$productUrl/${sampleProduct.id}',
          (server) => server.reply(200, {}),
        );
      },
      build: () => ProductBloc(productRepository: productRepository),
      act: (bloc) => bloc.add(DeleteProduct(id: int.parse(sampleProduct.id))),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        ProductLoading(),
        ProductDeleted(),
      ],
    );
  });
}
