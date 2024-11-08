// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_home_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportHomeBean _$ReportHomeBeanFromJson(Map<String, dynamic> json) =>
    ReportHomeBean(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => ReportHomeDataBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$ReportHomeBeanToJson(ReportHomeBean instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

ReportHomeDataBean _$ReportHomeDataBeanFromJson(Map<String, dynamic> json) =>
    ReportHomeDataBean(
      json['authorizationStatus'] as int,
      json['buyStatus'] as int,
      json['checkStatus'] as int,
      json['createTimeTs'] as int,
      json['id'] as int,
      json['idCardNameCode'] as String,
      json['idCardNumCode'] as String,
      json['rejectionReason'] as String,
      json['reportType'] as int,
      json['reportId'] as String,
    );

Map<String, dynamic> _$ReportHomeDataBeanToJson(ReportHomeDataBean instance) =>
    <String, dynamic>{
      'authorizationStatus': instance.authorizationStatus,
      'buyStatus': instance.buyStatus,
      'checkStatus': instance.checkStatus,
      'createTimeTs': instance.createTimeTs,
      'id': instance.id,
      'idCardNameCode': instance.idCardNameCode,
      'idCardNumCode': instance.idCardNumCode,
      'rejectionReason': instance.rejectionReason,
      'reportType': instance.reportType,
    };
