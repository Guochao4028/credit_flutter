/// *
/// -  @Date: 2023-02-15 14:50
/// -  @LastEditTime: 2023-03-15 18:54
/// -  @Description:
///
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'back_check_company_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackCheckCompanyListModel _$BackCheckCompanyListModelFromJson(
        Map<String, dynamic> json) =>
    BackCheckCompanyListModel(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) =>
              BackCheckCompanyListItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$BackCheckCompanyListModelToJson(
        BackCheckCompanyListModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

BackCheckCompanyListItemModel _$BackCheckCompanyListItemModelFromJson(
        Map<String, dynamic> json) =>
    BackCheckCompanyListItemModel(
      json['id'] as int,
      json['introduction'] as String,
      json['logo'] as String,
      json['name'] as String,
      json['productName'] as String,
      (json['score'] ?? 0 as num).toDouble(),
      json['commentCount'] as int,
    );

Map<String, dynamic> _$BackCheckCompanyListItemModelToJson(
        BackCheckCompanyListItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'introduction': instance.introduction,
      'logo': instance.logo,
      'name': instance.name,
      'productName': instance.productName,
      'score': instance.score,
      'commentCount': instance.commentCount,
    };
