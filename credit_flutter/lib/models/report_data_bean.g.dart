// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDataBean _$ReportDataBeanFromJson(Map<String, dynamic> json) =>
    ReportDataBean(
      CreditReportDigest.fromJson(
          json['creditReportDigest'] as Map<String, dynamic>),
      json['summary'] as String,
      DigestMap.fromJson(json['digestMap'] as Map<String, dynamic>),
      json['reportDeclare'] as String,
      ReportInfo.fromJson(json['reportInfo'] as Map<String, dynamic>),
      Detail.fromJson(json['detail'] as Map<String, dynamic>),
      InputMap.fromJson(json['inputMap'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReportDataBeanToJson(ReportDataBean instance) =>
    <String, dynamic>{
      'creditReportDigest': instance.creditReportDigest,
      'summary': instance.summary,
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
      json['sex'] as String,
      json['householdAddr'] as String,
      json['birthday'] as int,
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
      'riskLevel': instance.riskLevel,
      'createTime': instance.createTime,
    };

DigestMap _$DigestMapFromJson(Map<String, dynamic> json) => DigestMap(
      (json['digestListInfo'] as List<dynamic>)
          .map((e) => DigestListInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DigestMapToJson(DigestMap instance) => <String, dynamic>{
      'digestListInfo': instance.digestListInfo,
    };

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
      'status': instance.status,
    };

Detail _$DetailFromJson(Map<String, dynamic> json) => Detail(
      (json['102'] == null)
          ? null
          : RegisteredResidenceInfo.fromJson(
              json['102'] as Map<String, dynamic>),
      (json['136'] == null)
          ? null
          : BusinessInfo.fromJson(json['136'] as Map<String, dynamic>),
      (json['138'] == null)
          ? null
          : OnlineLoanBlacklist.fromJson(json['138'] as Map<String, dynamic>),
      (json['182'] == null)
          ? null
          : TechnicalColleges.fromJson(json['182'] as Map<String, dynamic>),
      (json['184'] == null)
          ? null
          : DomesticDegree.fromJson(json['184'] as Map<String, dynamic>),
      (json['194'] == null)
          ? null
          : DriverLicenseInfo.fromJson(json['194'] as Map<String, dynamic>),
      (json['205'] == null)
          ? null
          : BadSocialInfo.fromJson(json['205'] as Map<String, dynamic>),
      (json['261'] == null)
          ? null
          : LimitedLitigationRecord.fromJson(
              json['261'] as Map<String, dynamic>),
      (json['403'] == null)
          ? null
          : DomesticEducationalBackground.fromJson(
              json['403'] as Map<String, dynamic>),
      AccountingQualification.fromJson(
        json['418'] != null
            ? json['418'] as Map<String, dynamic>
            : {
                "queryCost": 20,
                "itemId": "201811140000133416",
                "itemName": "会计专业资格核实",
                "callSuccess": true,
                "itemCode": "418",
                "cateName": "查询类",
                "cateCode": "02",
                "isSuccess": false,
                "risk": "关注"
              },
      ),
      (json['421'] == null)
          ? null
          : MoralHazard.fromJson(json['421'] as Map<String, dynamic>),
      (json['423'] == null)
          ? null
          : BadTaxRecord.fromJson(json['423'] as Map<String, dynamic>),
      (json['425'] == null)
          ? null
          : ProhibitedDrugs.fromJson(json['425'] as Map<String, dynamic>),
      (json['452'] == null)
          ? null
          : PeopleWhoLoseCredit.fromJson(json['452'] as Map<String, dynamic>),
      (json['453'] == null)
          ? null
          : ExecutedPerson.fromJson(json['453'] as Map<String, dynamic>),
      (json['746'] == null)
          ? null
          : OverseasEducationalBackground.fromJson(
              json['746'] as Map<String, dynamic>),
      (json['755'] == null)
          ? null
          : HearingAnnouncement.fromJson(json['755'] as Map<String, dynamic>),
      (json['757'] == null)
          ? null
          : LimitHighConsumption.fromJson(json['757'] as Map<String, dynamic>),
      (json['764'] == null)
          ? null
          : CriminalAdjudicationDocument.fromJson(
              json['764'] as Map<String, dynamic>),
      (json['769'] == null)
          ? null
          : RestrictedEntryAndExit.fromJson(
              json['769'] as Map<String, dynamic>),
      (json['001'] == null)
          ? null
          : IdentityVerification.fromJson(json['001'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      '102': instance.registeredResidenceInfo,
      '136': instance.businessInfo,
      '138': instance.onlineLoanBlacklist,
      '182': instance.technicalColleges,
      '184': instance.domesticDegree,
      '194': instance.driverLicenseInfo,
      '205': instance.badSocialInfo,
      '261': instance.limitedLitigationRecord,
      '403': instance.domesticEducationalBackground,
      '418': instance.accountingQualification,
      '421': instance.moralHazard,
      '423': instance.badTaxRecord,
      '425': instance.prohibitedDrugs,
      '452': instance.peopleWhoLoseCredit,
      '453': instance.executedPerson,
      '746': instance.overseasEducationalBackground,
      '755': instance.hearingAnnouncement,
      '757': instance.limitHighConsumption,
      '764': instance.criminalAdjudicationDocument,
      '769': instance.restrictedEntryAndExit,
      '001': instance.identityVerification,
    };

RegisteredResidenceInfo _$RegisteredResidenceInfoFromJson(
        Map<String, dynamic> json) =>
    RegisteredResidenceInfo(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData102.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$RegisteredResidenceInfoToJson(
        RegisteredResidenceInfo instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData102,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData102 _$ItemData102FromJson(Map<String, dynamic> json) => ItemData102(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'].toString(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData102ToJson(ItemData102 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

BusinessInfo _$BusinessInfoFromJson(Map<String, dynamic> json) => BusinessInfo(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData136.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$BusinessInfoToJson(BusinessInfo instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData136,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData136 _$ItemData136FromJson(Map<String, dynamic> json) => ItemData136(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData136ToJson(ItemData136 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

OnlineLoanBlacklist _$OnlineLoanBlacklistFromJson(Map<String, dynamic> json) =>
    OnlineLoanBlacklist(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData138.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$OnlineLoanBlacklistToJson(
        OnlineLoanBlacklist instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData138,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
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

TechnicalColleges _$TechnicalCollegesFromJson(Map<String, dynamic> json) =>
    TechnicalColleges(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData182.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$TechnicalCollegesToJson(TechnicalColleges instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData182,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData182 _$ItemData182FromJson(Map<String, dynamic> json) => ItemData182(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as String,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData182ToJson(ItemData182 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

DomesticDegree _$DomesticDegreeFromJson(Map<String, dynamic> json) =>
    DomesticDegree(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData184.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$DomesticDegreeToJson(DomesticDegree instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData184,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData184 _$ItemData184FromJson(Map<String, dynamic> json) => ItemData184(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData184ToJson(ItemData184 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

DriverLicenseInfo _$DriverLicenseInfoFromJson(Map<String, dynamic> json) =>
    DriverLicenseInfo(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData194.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['itemCode'] as String,
    );

Map<String, dynamic> _$DriverLicenseInfoToJson(DriverLicenseInfo instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData194,
      'itemCode': instance.itemCode,
    };

ItemData194 _$ItemData194FromJson(Map<String, dynamic> json) => ItemData194(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as String,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData194ToJson(ItemData194 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

BadSocialInfo _$BadSocialInfoFromJson(Map<String, dynamic> json) =>
    BadSocialInfo(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData205.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$BadSocialInfoToJson(BadSocialInfo instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData205,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData205 _$ItemData205FromJson(Map<String, dynamic> json) => ItemData205(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as String,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData205ToJson(ItemData205 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

LimitedLitigationRecord _$LimitedLitigationRecordFromJson(
        Map<String, dynamic> json) =>
    LimitedLitigationRecord(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData261.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$LimitedLitigationRecordToJson(
        LimitedLitigationRecord instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData261,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData261 _$ItemData261FromJson(Map<String, dynamic> json) => ItemData261(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData261ToJson(ItemData261 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

DomesticEducationalBackground _$DomesticEducationalBackgroundFromJson(
        Map<String, dynamic> json) =>
    DomesticEducationalBackground(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData403.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$DomesticEducationalBackgroundToJson(
        DomesticEducationalBackground instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData403,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData403 _$ItemData403FromJson(Map<String, dynamic> json) => ItemData403(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData403ToJson(ItemData403 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

AccountingQualification _$AccountingQualificationFromJson(
        Map<String, dynamic> json) =>
    AccountingQualification(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData418.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$AccountingQualificationToJson(
        AccountingQualification instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData418,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData418 _$ItemData418FromJson(Map<String, dynamic> json) => ItemData418(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as String,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData418ToJson(ItemData418 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

MoralHazard _$MoralHazardFromJson(Map<String, dynamic> json) => MoralHazard(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData421.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$MoralHazardToJson(MoralHazard instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData421,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData421 _$ItemData421FromJson(Map<String, dynamic> json) => ItemData421(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as int,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData421ToJson(ItemData421 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

BadTaxRecord _$BadTaxRecordFromJson(Map<String, dynamic> json) => BadTaxRecord(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData423.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['isOffline'] as int,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$BadTaxRecordToJson(BadTaxRecord instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData423,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'isOffline': instance.isOffline,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData423 _$ItemData423FromJson(Map<String, dynamic> json) => ItemData423(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'].toString(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData423ToJson(ItemData423 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

ProhibitedDrugs _$ProhibitedDrugsFromJson(Map<String, dynamic> json) =>
    ProhibitedDrugs(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData425.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$ProhibitedDrugsToJson(ProhibitedDrugs instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData425,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData425 _$ItemData425FromJson(Map<String, dynamic> json) => ItemData425(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as int,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData425ToJson(ItemData425 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

PeopleWhoLoseCredit _$PeopleWhoLoseCreditFromJson(Map<String, dynamic> json) =>
    PeopleWhoLoseCredit(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData452.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$PeopleWhoLoseCreditToJson(
        PeopleWhoLoseCredit instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData452,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData452 _$ItemData452FromJson(Map<String, dynamic> json) => ItemData452(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData452ToJson(ItemData452 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

ExecutedPerson _$ExecutedPersonFromJson(Map<String, dynamic> json) =>
    ExecutedPerson(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData453.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$ExecutedPersonToJson(ExecutedPerson instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData453,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData453 _$ItemData453FromJson(Map<String, dynamic> json) => ItemData453(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData453ToJson(ItemData453 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

OverseasEducationalBackground _$OverseasEducationalBackgroundFromJson(
        Map<String, dynamic> json) =>
    OverseasEducationalBackground(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData746.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$OverseasEducationalBackgroundToJson(
        OverseasEducationalBackground instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData746,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData746 _$ItemData746FromJson(Map<String, dynamic> json) => ItemData746(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as String,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData746ToJson(ItemData746 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

HearingAnnouncement _$HearingAnnouncementFromJson(Map<String, dynamic> json) =>
    HearingAnnouncement(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData755.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$HearingAnnouncementToJson(
        HearingAnnouncement instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData755,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData755 _$ItemData755FromJson(Map<String, dynamic> json) => ItemData755(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData755ToJson(ItemData755 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

LimitHighConsumption _$LimitHighConsumptionFromJson(
        Map<String, dynamic> json) =>
    LimitHighConsumption(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData757.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$LimitHighConsumptionToJson(
        LimitHighConsumption instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData757,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData757 _$ItemData757FromJson(Map<String, dynamic> json) => ItemData757(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData757ToJson(ItemData757 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

CriminalAdjudicationDocument _$CriminalAdjudicationDocumentFromJson(
        Map<String, dynamic> json) =>
    CriminalAdjudicationDocument(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData764.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$CriminalAdjudicationDocumentToJson(
        CriminalAdjudicationDocument instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData764,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData764 _$ItemData764FromJson(Map<String, dynamic> json) => ItemData764(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData764ToJson(ItemData764 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

RestrictedEntryAndExit _$RestrictedEntryAndExitFromJson(
        Map<String, dynamic> json) =>
    RestrictedEntryAndExit(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData769.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
    );

Map<String, dynamic> _$RestrictedEntryAndExitToJson(
        RestrictedEntryAndExit instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData769,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
    };

ItemData769 _$ItemData769FromJson(Map<String, dynamic> json) => ItemData769(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      (json['itemPropValue'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => ItemPropValueBean.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData769ToJson(ItemData769 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

IdentityVerification _$IdentityVerificationFromJson(
        Map<String, dynamic> json) =>
    IdentityVerification(
      json['itemId'] as String,
      json['itemName'] as String,
      (json['itemData'] != null ? json['itemData'] as List<dynamic> : [])
          .map((e) => ItemData001.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['callSuccess'] as bool,
      json['itemCode'] as String,
      json['cateName'] as String,
      json['cateCode'] as String,
      json['isSuccess'] as bool,
      json['risk'] as String,
    );

Map<String, dynamic> _$IdentityVerificationToJson(
        IdentityVerification instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemData': instance.itemData001,
      'callSuccess': instance.callSuccess,
      'itemCode': instance.itemCode,
      'cateName': instance.cateName,
      'cateCode': instance.cateCode,
      'isSuccess': instance.isSuccess,
      'risk': instance.risk,
    };

ItemData001 _$ItemData001FromJson(Map<String, dynamic> json) => ItemData001(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'] as String,
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemData001ToJson(ItemData001 instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };

InputMap _$InputMapFromJson(Map<String, dynamic> json) => InputMap(
      json['birthday'] ?? "",
      json['report_notify_url'] as String,
      json['isSendSignSms'] as String,
      json['sex'] ?? "",
      json['name'] as String,
      json['mobile'] as String,
      json['tplId'] as String,
      json['idNo'] as String,
      json['certificationRequire'] as String,
      json['age'] ?? 0,
      json['certificateNumber'] as String,
      json['diplomaNumber'] as String,
      json['examinationLevel'] ?? "",
      json['examinationYear'] ?? "",
      json['examinationProvince'] ?? "",
      json['internationalEduNumber'] ?? "",
    );

Map<String, dynamic> _$InputMapToJson(InputMap instance) => <String, dynamic>{
      'birthday': instance.birthday,
      'report_notify_url': instance.reportNotifyUrl,
      'isSendSignSms': instance.isSendSignSms,
      'sex': instance.sex,
      'name': instance.name,
      'mobile': instance.mobile,
      'tplId': instance.tplId,
      'idNo': instance.idNo,
      'certificationRequire': instance.certificationRequire,
      'age': instance.age,
      'certificateNumber': instance.certificateNumber,
      'diplomaNumber': instance.diplomaNumber,
      'examinationLevel': instance.examinationLevel,
      'examinationYear': instance.examinationYear,
      'examinationProvince': instance.examinationProvince,
      'internationalEduNumber': instance.internationalEduNumber,
    };

ItemPropValueBean _$ItemPropValueBeanFromJson(Map<String, dynamic> json) =>
    ItemPropValueBean(
      json['itemPropLabel'] as String,
      json['itemPropName'] as String,
      json['itemPropValue'].toString(),
      json['set'] as bool,
    );

Map<String, dynamic> _$ItemPropValueBeanToJson(ItemPropValueBean instance) =>
    <String, dynamic>{
      'itemPropLabel': instance.itemPropLabel,
      'itemPropName': instance.itemPropName,
      'itemPropValue': instance.itemPropValue,
      'set': instance.set,
    };
