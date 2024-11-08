// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_report_home_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyReportHomeBean _$CompanyReportHomeBeanFromJson(
        Map<String, dynamic> json) =>
    CompanyReportHomeBean(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => CompanyReportHomeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$CompanyReportHomeBeanToJson(
        CompanyReportHomeBean instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

CompanyReportHomeData _$CompanyReportHomeDataFromJson(
        Map<String, dynamic> json) =>
    CompanyReportHomeData(
      json['authorizationStatus'] as int,
      json['checkStatus'] as int,
      json['companyName'] as String,
      json['createTimeTs'] as int,
      json['id'] as int,
      json['rejectionReason'] as String,
      json['selectUser'] as String,
      json['reportId'] as String?,
      json['reportAuthId'] as int,
      json['phone'] as String,
      json['orderId'] as int,
      json['reportType'] as int,
    );

Map<String, dynamic> _$CompanyReportHomeDataToJson(
        CompanyReportHomeData instance) =>
    <String, dynamic>{
      'authorizationStatus': instance.authorizationStatus,
      'checkStatus': instance.checkStatus,
      'companyName': instance.companyName,
      'createTimeTs': instance.createTimeTs,
      'id': instance.id,
      'reportId': instance.reportId,
      'selectUser': instance.selectUser,
      'rejectionReason': instance.rejectionReason,
      'phone': instance.phone,
      'orderId': instance.orderId,
      'reportAuthId': instance.reportAuthId,
      'reportType': instance.reportType,
    };
