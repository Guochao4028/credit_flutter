// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demand_details_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandDetailsBean _$DemandDetailsBeanFromJson(Map<String, dynamic> json) =>
    DemandDetailsBean(
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

Map<String, dynamic> _$DemandDetailsBeanToJson(DemandDetailsBean instance) =>
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
