// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FAQModel _$FAQModelFromJson(Map<String, dynamic> json) => FAQModel(
      json['content'] as String,
      json['createTime'] as int,
      json['id'] as int,
      json['title'] as String,
      json['updateTime'] as int,
    );

Map<String, dynamic> _$FAQModelToJson(FAQModel instance) => <String, dynamic>{
      'content': instance.content,
      'createTime': instance.createTime,
      'id': instance.id,
      'title': instance.title,
      'updateTime': instance.updateTime,
    };
