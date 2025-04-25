import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product extends Equatable {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(name: 'title')
  final String name;
  final double price;
  @JsonKey(name: 'image')
  final String imageUrl;
  final String? description;
  final String? category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  static String _stringFromJson(dynamic value) => value.toString();

  @override
  List<Object> get props => [id, name, price, imageUrl];
}