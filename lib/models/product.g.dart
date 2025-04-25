// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: Product._stringFromJson(json['id']),
  name: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrl: json['image'] as String,
  description: json['description'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.name,
  'price': instance.price,
  'image': instance.imageUrl,
  'description': instance.description,
  'category': instance.category,
};
