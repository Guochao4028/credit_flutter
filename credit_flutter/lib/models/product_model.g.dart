/// *
/// -  @Date: 2023-02-16 13:54
/// -  @LastEditTime: 2023-03-31 15:27
/// -  @Description:
///
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      json['id'] as int,
      (json['originalPrice'] as num).toDouble(),
      (json['price'] as num).toDouble(),
      json['recommend'] as int,
      json['subTitle'] as String,
      json['title'] as String,
      json['type'] as int,
      json['iosProductId'] as String,
    )..isSelected = json['isSelected'] = false;

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'originalPrice': instance.originalPrice,
      'price': instance.price,
      'recommend': instance.recommend,
      'subTitle': instance.subTitle,
      'title': instance.title,
      'type': instance.type,
      'isSelected': instance.isSelected,
      'iosProductId': instance.iosProductId,
    };
