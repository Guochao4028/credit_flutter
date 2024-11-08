// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentBean _$CommentBeanFromJson(Map<String, dynamic> json) => CommentBean(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => CommentDataBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$CommentBeanToJson(CommentBean instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

CommentDataBean _$CommentDataBeanFromJson(Map<String, dynamic> json) =>
    CommentDataBean(
      json['backCompanyId'] as int,
      json['content'] as String,
      json['createTime'] as int,
      json['id'] as int,
      json['likeCount'] as int,
      json['selfLike'] as int,
    );

Map<String, dynamic> _$CommentDataBeanToJson(CommentDataBean instance) =>
    <String, dynamic>{
      'backCompanyId': instance.backCompanyId,
      'content': instance.content,
      'createTime': instance.createTime,
      'id': instance.id,
      'likeCount': instance.likeCount,
      'selfLike': instance.selfLike,
    };
