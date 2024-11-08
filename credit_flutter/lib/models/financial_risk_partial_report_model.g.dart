// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_risk_partial_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialRiskPartialReportModel _$FinancialRiskPartialReportModelFromJson(
        Map<String, dynamic> json) =>
    FinancialRiskPartialReportModel(
      CreditReportDigest.fromJson(
          json['creditReportDigest'] as Map<String, dynamic>),
      json['summary'] as String,
      Outline.fromJson(json['outline'] as Map<String, dynamic>),
      DigestMap.fromJson(json['digestMap'] as Map<String, dynamic>),
      json['reportDeclare'] as String,
      ReportInfo.fromJson(json['reportInfo'] as Map<String, dynamic>),
      Detail.fromJson(json['detail'] as Map<String, dynamic>),
      InputMap.fromJson(json['inputMap'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FinancialRiskPartialReportModelToJson(
        FinancialRiskPartialReportModel instance) =>
    <String, dynamic>{
      'creditReportDigest': instance.creditReportDigest,
      'summary': instance.summary,
      'outline': instance.outline,
      'digestMap': instance.digestMap,
      'reportDeclare': instance.reportDeclare,
      'reportInfo': instance.reportInfo,
      'detail': instance.detail,
      'inputMap': instance.inputMap,
    };

CreditReportDigest _$CreditReportDigestFromJson(Map<String, dynamic> json) =>
    CreditReportDigest(
      json['reportId'] as String,
      json['name'] as String,
      json['idNo'] as String,
      json['mobile'] as String,
      json['sex'] ?? "",
      json['householdAddr'] as String,
      json['birthday'] as int,
      json['reviewStatus'] as int,
      json['financeRiskLevel'] as String,
      json['riskScore'] as int,
      json['failNum'] as int,
      json['failItemNum'] as int,
      json['riskLevel'] as String,
      json['createTime'] as int,
    );

Map<String, dynamic> _$CreditReportDigestToJson(CreditReportDigest instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'name': instance.name,
      'idNo': instance.idNo,
      'mobile': instance.mobile,
      'sex': instance.sex,
      'householdAddr': instance.householdAddr,
      'birthday': instance.birthday,
      'reviewStatus': instance.reviewStatus,
      'financeRiskLevel': instance.financeRiskLevel,
      'riskScore': instance.riskScore,
      'failNum': instance.failNum,
      'failItemNum': instance.failItemNum,
      'riskLevel': instance.riskLevel,
      'createTime': instance.createTime,
    };

Outline _$OutlineFromJson(Map<String, dynamic> json) => Outline();

Map<String, dynamic> _$OutlineToJson(Outline instance) => <String, dynamic>{};

DigestMap _$DigestMapFromJson(Map<String, dynamic> json) => DigestMap(
      DigestMapInfo.fromJson(json['digestMapInfo'] as Map<String, dynamic>),
      (json['digestListInfo'] as List<dynamic>)
          .map((e) => DigestListInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DigestMapToJson(DigestMap instance) => <String, dynamic>{
      'digestMapInfo': instance.digestMapInfo,
      'digestListInfo': instance.digestListInfo,
    };

DigestMapInfo _$DigestMapInfoFromJson(Map<String, dynamic> json) =>
    DigestMapInfo();

Map<String, dynamic> _$DigestMapInfoToJson(DigestMapInfo instance) =>
    <String, dynamic>{};

DigestListInfo _$DigestListInfoFromJson(Map<String, dynamic> json) =>
    DigestListInfo(
      json['result'] as String,
      json['level'] as String,
      json['name'] as String,
      json['risk'] as String,
      json['remark'] as String,
    );

Map<String, dynamic> _$DigestListInfoToJson(DigestListInfo instance) =>
    <String, dynamic>{
      'result': instance.result,
      'level': instance.level,
      'name': instance.name,
      'risk': instance.risk,
      'remark': instance.remark,
    };

ReportInfo _$ReportInfoFromJson(Map<String, dynamic> json) => ReportInfo(
      json['birthday'] as String,
      json['orgName'] as String,
      json['riskLevel'] as String,
      json['completeTime'] as int,
      json['userId'] as String,
      json['isEffective'] as int,
      json['modifyTime'] as int,
      json['tplName'] as String,
      json['createTime'] as int,
      json['objectiveStatus'] as int,
      json['id'] as String,
      json['tplId'] as String,
      json['isContainOffline'] as int,
      json['status'] as int,
    );

Map<String, dynamic> _$ReportInfoToJson(ReportInfo instance) =>
    <String, dynamic>{
      'birthday': instance.birthday,
      'orgName': instance.orgName,
      'riskLevel': instance.riskLevel,
      'completeTime': instance.completeTime,
      'userId': instance.userId,
      'isEffective': instance.isEffective,
      'modifyTime': instance.modifyTime,
      'tplName': instance.tplName,
      'createTime': instance.createTime,
      'objectiveStatus': instance.objectiveStatus,
      'id': instance.id,
      'tplId': instance.tplId,
      'isContainOffline': instance.isContainOffline,
      'status': instance.status,
    };

Detail _$DetailFromJson(Map<String, dynamic> json) => Detail(
      Online_loan.fromJson(json['138'] as Map<String, dynamic>),
      Finance.fromJson(json['148'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      '138': instance.onlineLoan,
      '148': instance.finance,
    };

Online_loan _$Online_loanFromJson(Map<String, dynamic> json) => Online_loan(
      (json['queryCost'] as num).toDouble(),
      json['itemId'] as String,
      json['itemName'] as String,
      json['callSuccess'] as bool,
      (json['itemData'] as List<dynamic>)
          .map((e) => ItemData138.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['itemCode'] as String,
      json['isOffline'] as int,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$Online_loanToJson(Online_loan instance) =>
    <String, dynamic>{
      'queryCost': instance.queryCost,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'callSuccess': instance.callSuccess,
      'itemData': instance.itemData138,
      'itemCode': instance.itemCode,
      'isOffline': instance.isOffline,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData138 _$ItemData138FromJson(Map<String, dynamic> json) => ItemData138(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as String,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData138ToJson(ItemData138 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

Finance _$FinanceFromJson(Map<String, dynamic> json) => Finance(
      (json['queryCost'] as num).toDouble(),
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] as List<dynamic>)
          .map((e) => ItemData148.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['isOffline'] as int,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$FinanceToJson(Finance instance) => <String, dynamic>{
      'queryCost': instance.queryCost,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData148,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'isOffline': instance.isOffline,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData148 _$ItemData148FromJson(Map<String, dynamic> json) => ItemData148(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as String,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData148ToJson(ItemData148 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

InputMap _$InputMapFromJson(Map<String, dynamic> json) => InputMap(
      json['certificateNumber2'] as String,
      json['birthday'] ?? "",
      json['certificateNumber3'] as String,
      json['report_notify_url'] as String,
      json['certificateNumber1'] as String,
      json['internationalEduNumber2'] as String,
      json['internationalEduNumber1'] as String,
      json['sex'] ?? "",
      json['mobile'] as String,
      json['idNo'] as String,
      json['certificationRequire'] as String,
      json['diplomaNumber'] as String,
      json['isSendSignSms'] as String,
      json['diplomaNumber3'] as String,
      json['internationalEduNumber'] as String,
      json['certificateNumber'] as String,
      json['areaType'] as int,
      json['name'] as String,
      json['diplomaNumber1'] as String,
      json['diplomaNumber2'] as String,
      json['tplId'] as String,
      json['age'] ?? 0,
    );

Map<String, dynamic> _$InputMapToJson(InputMap instance) => <String, dynamic>{
      'certificateNumber2': instance.certificateNumber2,
      'birthday': instance.birthday,
      'certificateNumber3': instance.certificateNumber3,
      'report_notify_url': instance.reportNotifyUrl,
      'certificateNumber1': instance.certificateNumber1,
      'internationalEduNumber2': instance.internationalEduNumber2,
      'internationalEduNumber1': instance.internationalEduNumber1,
      'sex': instance.sex,
      'mobile': instance.mobile,
      'idNo': instance.idNo,
      'certificationRequire': instance.certificationRequire,
      'diplomaNumber': instance.diplomaNumber,
      'isSendSignSms': instance.isSendSignSms,
      'diplomaNumber3': instance.diplomaNumber3,
      'internationalEduNumber': instance.internationalEduNumber,
      'certificateNumber': instance.certificateNumber,
      'areaType': instance.areaType,
      'name': instance.name,
      'diplomaNumber1': instance.diplomaNumber1,
      'diplomaNumber2': instance.diplomaNumber2,
      'tplId': instance.tplId,
      'age': instance.age,
    };
