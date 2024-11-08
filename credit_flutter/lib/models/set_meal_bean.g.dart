// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_meal_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetMealBean _$SetMealBeanFromJson(Map<String, dynamic> json) => SetMealBean(
      json['id'] as int,
      (json['originalPrice'] as num).toDouble(),
      (json['price'] as num).toDouble(),
      json['recommend'] as int,
      json['subTitle'] as String,
      json['title'] as String,
      json['type'] as int,
    )..isSelect = false;

Map<String, dynamic> _$SetMealBeanToJson(SetMealBean instance) =>
    <String, dynamic>{
      'id': instance.id,
      'originalPrice': instance.originalPrice,
      'price': instance.price,
      'recommend': instance.recommend,
      'subTitle': instance.subTitle,
      'title': instance.title,
      'type': instance.type,
      'isSelect': instance.isSelect,
    };
