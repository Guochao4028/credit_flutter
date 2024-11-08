// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demand_center_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandCenterBean _$DemandCenterBeanFromJson(Map<String, dynamic> json) =>
    DemandCenterBean(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => DemandCenterData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$DemandCenterBeanToJson(DemandCenterBean instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

DemandCenterData _$DataFromJson(Map<String, dynamic> json) => DemandCenterData(
      (json['budget'] ?? -1).toDouble(),
      json['createTime'] as int,
      json['days'] as int,
      json['description'] as String,
      json['id'] as int,
      json['phone'] as String,
      json['reportDetail'] as String,
      json['status'] as int,
      json['title'] as String,
      json['userId'] as int,
      json['validTime'] as int,
    );

Map<String, dynamic> _$DataToJson(DemandCenterData instance) =>
    <String, dynamic>{
      'budget': instance.budget,
      'createTime': instance.createTime,
      'days': instance.days,
      'description': instance.description,
      'id': instance.id,
      'phone': instance.phone,
      'reportDetail': instance.reportDetail,
      'status': instance.status,
      'title': instance.title,
      'userId': instance.userId,
      'validTime': instance.validTime,
    };
