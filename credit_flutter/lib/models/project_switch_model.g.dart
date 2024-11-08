// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_switch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectSwitchModel _$ProjectSwitchModelFromJson(Map<String, dynamic> json) =>
    ProjectSwitchModel(
      json['total'] as int,
      json['pages'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$ProjectSwitchModelToJson(ProjectSwitchModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'pages': instance.pages,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      json['createTime'] as int,
      json['description'] as String,
      json['id'] as int,
      json['jsonParam'] as String,
      json['status'] as int,
      json['updateTime'] as int,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'createTime': instance.createTime,
      'description': instance.description,
      'id': instance.id,
      'jsonParam': instance.jsonParam,
      'status': instance.status,
      'updateTime': instance.updateTime,
    };
