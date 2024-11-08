// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'back_check_company_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackCheckCompanyInfoModel _$BackCheckCompanyInfoModelFromJson(
        Map<String, dynamic> json) =>
    BackCheckCompanyInfoModel(
      json['aboutUs'] as String,
      json['address'] as String,
      json['id'] as int,
      json['introduction'] as String,
      json['logo'] as String,
      json['mail'] as String,
      json['name'] as String,
      json['phone'] as String,
      json['productName'] as String,
      json['website'] as String,
      (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$BackCheckCompanyInfoModelToJson(
        BackCheckCompanyInfoModel instance) =>
    <String, dynamic>{
      'aboutUs': instance.aboutUs,
      'address': instance.address,
      'id': instance.id,
      'introduction': instance.introduction,
      'logo': instance.logo,
      'mail': instance.mail,
      'name': instance.name,
      'phone': instance.phone,
      'productName': instance.productName,
      'website': instance.website,
      'score': instance.score,
    };
