// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListModel _$OrderListModelFromJson(Map<String, dynamic> json) =>
    OrderListModel(
      json['total'] as int,
      (json['data'] as List<dynamic>)
          .map((e) => OrderDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['pageSize'] as int,
      json['currentPage'] as int,
    );

Map<String, dynamic> _$OrderListModelToJson(OrderListModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'data': instance.detailsList,
      'pageSize': instance.pageSize,
      'currentPage': instance.currentPage,
    };

OrderDetailsModel _$OrderDetailsModelFromJson(Map<String, dynamic> json) =>
    OrderDetailsModel(
      (json['amount'] as num).toDouble(),
      json['companyId'] ?? 0 as int,
      json['createTimeTs'] as int,
      json['id'] as int,
      json['invoiceId'] as int,
      json['invoiceStatus'] as int,
      json['invoiceValid'] as int,
      json['payTimeTs'] as int,
      json['payType'] as int,
      json['phone'] as String,
      json['quantity'] as int,
      json['remark'] as String,
      json['reportAuthId'] as int,
      json['reportIdCard'] as String,
      json['reportType'] as int,
      json['reportUserName'] as String,
      json['reportUserType'] as int,
      json['status'] as int,
      json['type'] as int,
      json['unit'] as int,
      json['updateTimeTs'] as int,
      json['userId'] as int,
    );

Map<String, dynamic> _$OrderDetailsModelToJson(OrderDetailsModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'createTimeTs': instance.createTimeTs,
      'id': instance.id,
      'companyId': instance.companyId,
      'invoiceId': instance.invoiceId,
      'invoiceStatus': instance.invoiceStatus,
      'invoiceValid': instance.invoiceValid,
      'payTimeTs': instance.payTimeTs,
      'payType': instance.payType,
      'phone': instance.phone,
      'quantity': instance.quantity,
      'remark': instance.remark,
      'reportAuthId': instance.reportAuthId,
      'reportIdCard': instance.reportIdCard,
      'reportType': instance.reportType,
      'reportUserName': instance.reportUserName,
      'reportUserType': instance.reportUserType,
      'status': instance.status,
      'type': instance.type,
      'unit': instance.unit,
      'updateTimeTs': instance.updateTimeTs,
      'userId': instance.userId,
    };
