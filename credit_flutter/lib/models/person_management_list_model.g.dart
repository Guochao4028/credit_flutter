// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_management_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonManagementListModel _$PersonManagementListModelFromJson(
        Map<String, dynamic> json) =>
    PersonManagementListModel(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) =>
              PersonManagementListItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$PersonManagementListModelToJson(
        PersonManagementListModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

PersonManagementListItemModel _$PersonManagementListItemModelFromJson(
        Map<String, dynamic> json) =>
    PersonManagementListItemModel(
      json['companyId'] as int,
      json['createTimeTs'] as int,
      json['id'] as int,
      json['jobTitle'] as String,
      json['name'] as String,
      json['phone'] as String,
      json['status'] as int,
      json['updateTimeTs'] as int,
      json['userId'] as int,
    );

Map<String, dynamic> _$PersonManagementListItemModelToJson(
        PersonManagementListItemModel instance) =>
    <String, dynamic>{
      'companyId': instance.companyId,
      'createTimeTs': instance.createTimeTs,
      'id': instance.id,
      'jobTitle': instance.jobTitle,
      'name': instance.name,
      'phone': instance.phone,
      'status': instance.status,
      'updateTimeTs': instance.updateTimeTs,
      'userId': instance.userId,
    };
