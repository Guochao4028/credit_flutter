// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_replace_company_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectReplaceCompanyBean _$SelectReplaceCompanyBeanFromJson(
        Map<String, dynamic> json) =>
    SelectReplaceCompanyBean(
      json['accountPerson'] as String,
      json['authorizationCode'] as String,
      (json['balance'] as num).toDouble(),
      json['certCode'] as String,
      json['companyAddress'] as String,
      json['contact'] as String,
      json['contactWay'] as String,
      json['createTime'] as String,
      json['headImgUrl'] as String,
      json['id'] as int,
      json['idCardImg'] as String,
      json['lastLoginTime'] as String,
      json['legalPersonName'] as String,
      json['legalPersonPhone'] as String,
      json['licenceImg'] as String,
      json['licenceName'] as String,
      json['loginIp'] as String,
      json['mainIndustry'] as String,
      json['maturityTime'] as String,
      json['name'] as String,
      json['nature'] as String,
      json['peopleNum'] as int,
      json['refusedReason'] as String,
      json['scale'] as String,
      json['updateTime'] as String,
      json['valid'] as int,
      json['verifiedStatus'] as int,
      json['vipStatus'] as int,
      json['vipType'] as int,
    );

Map<String, dynamic> _$SelectReplaceCompanyBeanToJson(
        SelectReplaceCompanyBean instance) =>
    <String, dynamic>{
      'accountPerson': instance.accountPerson,
      'authorizationCode': instance.authorizationCode,
      'balance': instance.balance,
      'certCode': instance.certCode,
      'companyAddress': instance.companyAddress,
      'contact': instance.contact,
      'contactWay': instance.contactWay,
      'createTime': instance.createTime,
      'headImgUrl': instance.headImgUrl,
      'id': instance.id,
      'idCardImg': instance.idCardImg,
      'lastLoginTime': instance.lastLoginTime,
      'legalPersonName': instance.legalPersonName,
      'legalPersonPhone': instance.legalPersonPhone,
      'licenceImg': instance.licenceImg,
      'licenceName': instance.licenceName,
      'loginIp': instance.loginIp,
      'mainIndustry': instance.mainIndustry,
      'maturityTime': instance.maturityTime,
      'name': instance.name,
      'nature': instance.nature,
      'peopleNum': instance.peopleNum,
      'refusedReason': instance.refusedReason,
      'scale': instance.scale,
      'updateTime': instance.updateTime,
      'valid': instance.valid,
      'verifiedStatus': instance.verifiedStatus,
      'vipStatus': instance.vipStatus,
      'vipType': instance.vipType,
    };
