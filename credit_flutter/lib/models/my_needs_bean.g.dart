// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_needs_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyNeedsBean _$MyNeedsBeanFromJson(Map<String, dynamic> json) => MyNeedsBean(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => MyNeedsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$MyNeedsBeanToJson(MyNeedsBean instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

MyNeedsData _$MyNeedsDataFromJson(Map<String, dynamic> json) => MyNeedsData(
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

Map<String, dynamic> _$MyNeedsDataToJson(MyNeedsData instance) =>
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
