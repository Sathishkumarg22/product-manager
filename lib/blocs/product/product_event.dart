import 'package:demo/models/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;

  const AddProduct({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final Product product;

  const UpdateProduct({required this.product});

  @override
  List<Object> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final int id;

  const DeleteProduct({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object> get props => [query];
}