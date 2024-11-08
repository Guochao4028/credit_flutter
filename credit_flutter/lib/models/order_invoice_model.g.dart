// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderInvoiceModel _$OrderInvoiceModelFromJson(Map<String, dynamic> json) =>
    OrderInvoiceModel(
      json['content'] as String,
      json['createTimeTs'] as int,
      json['id'] as int,
      json['invoiceClass'] as int,
      json['mail'] as String,
      json['orderId'] as int,
      json['tax'] as String,
      json['titleName'] as String,
      json['titleType'] as int,
      json['type'] as int,
    );

Map<String, dynamic> _$OrderInvoiceModelToJson(OrderInvoiceModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'createTimeTs': instance.createTimeTs,
      'id': instance.id,
      'invoiceClass': instance.invoiceClass,
      'mail': instance.mail,
      'orderId': instance.orderId,
      'tax': instance.tax,
      'titleName': instance.titleName,
      'titleType': instance.titleType,
      'type': instance.type,
    };
