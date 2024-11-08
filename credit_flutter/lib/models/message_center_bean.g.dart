// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_center_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCenterBean _$MessageCenterBeanFromJson(Map<String, dynamic> json) =>
    MessageCenterBean(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$MessageCenterBeanToJson(MessageCenterBean instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['businessId'] as int,
      json['companyId'] ?? 0,
      json['createTimeTs'] as int,
      json['id'] as int,
      json['readStatus'] as int,
      json['title'] as String,
      json['type'] as int,
      json['updateTimeTs'] as int,
      json['userId'] as int,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'businessId': instance.businessId,
      'companyId': instance.companyId,
      'createTimeTs': instance.createTimeTs,
      'id': instance.id,
      'readStatus': instance.readStatus,
      'title': instance.title,
      'type': instance.type,
      'updateTimeTs': instance.updateTimeTs,
      'userId': instance.userId,
    };
