/// *
/// -  @Date: 2022-11-01 15:04
/// -  @LastEditTime: 2022-11-23 16:28
/// -  @Description:
///
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsDetailsModel _$NewsDetailsModelFromJson(Map<String, dynamic> json) =>
    NewsDetailsModel(
      json['content'] as String,
      json['coverImage'] as String?,
      json['createTime'] as String,
      json['description'] as String,
      json['from'] as String,
      json['keyword'] as String,
      json['newsId'] as int,
      json['releaseTime'] as String,
      json['title'] as String,
      json['top'] as int,
      json['type'] ?? 1 as int,
    );

Map<String, dynamic> _$NewsDetailsModelToJson(NewsDetailsModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'coverImage': instance.coverImage,
      'createTime': instance.createTime,
      'description': instance.description,
      'from': instance.from,
      'keyword': instance.keyword,
      'newsId': instance.newsId,
      'releaseTime': instance.releaseTime,
      'title': instance.title,
      'top': instance.top,
      'type': instance.type,
    };
