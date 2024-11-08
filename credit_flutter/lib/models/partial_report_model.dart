import 'package:json_annotation/json_annotation.dart';

part 'partial_report_model.g.dart';

@JsonSerializable()
class PartialReportModel extends Object {
  @JsonKey(name: 'creditReportDigest')
  CreditReportDigest creditReportDigest;

  @JsonKey(name: 'summary')
  String summary;

  @JsonKey(name: 'outline')
  Outline outline;

  @JsonKey(name: 'digestMap')
  DigestMap digestMap;

  @JsonKey(name: 'reportDeclare')
  String reportDeclare;

  @JsonKey(name: 'reportInfo')
  ReportInfo reportInfo;

  @JsonKey(name: 'detail')
  Detail detail;

  @JsonKey(name: 'inputMap')
  InputMap inputMap;

  PartialReportModel(
    this.creditReportDigest,
    this.summary,
    this.outline,
    this.digestMap,
    this.reportDeclare,
    this.reportInfo,
    this.detail,
    this.inputMap,
  );

  factory PartialReportModel.fromJson(Map<String, dynamic> srcJson) =>
      _$PartialReportModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PartialReportModelToJson(this);
}

@JsonSerializable()
class CreditReportDigest extends Object {
  @JsonKey(name: 'reportId')
  String reportId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'idNo')
  String idNo;

  @JsonKey(name: 'mobile')
  String mobile;

  @JsonKey(name: 'sex')
  String sex;

  @JsonKey(name: 'householdAddr')
  String householdAddr;

  @JsonKey(name: 'birthday')
  int birthday;

  @JsonKey(name: 'reviewStatus')
  int reviewStatus;

  @JsonKey(name: 'identityRiskLevel')
  String identityRiskLevel;

  @JsonKey(name: 'riskScore')
  int riskScore;

  @JsonKey(name: 'failNum')
  int failNum;

  @JsonKey(name: 'failItemNum')
  int failItemNum;

  @JsonKey(name: 'riskLevel')
  String riskLevel;

  @JsonKey(name: 'createTime')
  int createTime;

  CreditReportDigest(
    this.reportId,
    this.name,
    this.idNo,
    this.mobile,
    this.sex,
    this.householdAddr,
    this.birthday,
    this.reviewStatus,
    this.identityRiskLevel,
    this.riskScore,
    this.failNum,
    this.failItemNum,
    this.riskLevel,
    this.createTime,
  );

  factory CreditReportDigest.fromJson(Map<String, dynamic> srcJson) =>
      _$CreditReportDigestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CreditReportDigestToJson(this);
}

@JsonSerializable()
class Outline extends Object {
  Outline();

  factory Outline.fromJson(Map<String, dynamic> srcJson) =>
      _$OutlineFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OutlineToJson(this);
}

@JsonSerializable()
class DigestMap extends Object {
  @JsonKey(name: 'digestMapInfo')
  DigestMapInfo digestMapInfo;

  @JsonKey(name: 'digestListInfo')
  List<DigestListInfo> digestListInfo;

  DigestMap(
    this.digestMapInfo,
    this.digestListInfo,
  );

  factory DigestMap.fromJson(Map<String, dynamic> srcJson) =>
      _$DigestMapFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DigestMapToJson(this);
}

@JsonSerializable()
class DigestMapInfo extends Object {
  @JsonKey(name: 'realNamCheck')
  bool realNamCheck;

  DigestMapInfo(
    this.realNamCheck,
  );

  factory DigestMapInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$DigestMapInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DigestMapInfoToJson(this);
}

@JsonSerializable()
class DigestListInfo extends Object {
  @JsonKey(name: 'result')
  String result;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'risk')
  String risk;

  @JsonKey(name: 'remark')
  String remark;

  DigestListInfo(
    this.result,
    this.level,
    this.name,
    this.risk,
    this.remark,
  );

  factory DigestListInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$DigestListInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DigestListInfoToJson(this);
}

@JsonSerializable()
class ReportInfo extends Object {
  @JsonKey(name: 'birthday')
  String birthday;

  @JsonKey(name: 'orgName')
  String orgName;

  @JsonKey(name: 'riskLevel')
  String riskLevel;

  @JsonKey(name: 'completeTime')
  int completeTime;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'isEffective')
  int isEffective;

  @JsonKey(name: 'modifyTime')
  int modifyTime;

  @JsonKey(name: 'tplName')
  String tplName;

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'objectiveStatus')
  int objectiveStatus;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'tplId')
  String tplId;

  @JsonKey(name: 'isContainOffline')
  int isContainOffline;

  @JsonKey(name: 'status')
  int status;

  ReportInfo(
    this.birthday,
    this.orgName,
    this.riskLevel,
    this.completeTime,
    this.userId,
    this.isEffective,
    this.modifyTime,
    this.tplName,
    this.createTime,
    this.objectiveStatus,
    this.id,
    this.tplId,
    this.isContainOffline,
    this.status,
  );

  factory ReportInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$ReportInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReportInfoToJson(this);
}

@JsonSerializable()
class Detail extends Object {
  @JsonKey(name: '102')
  RegisteredResidenceInfo registeredResidenceInfo;

  @JsonKey(name: '120')
  OperatorHours operatorHours;

  @JsonKey(name: '001')
  IdentityVerification identityVerification;

  Detail(
    this.registeredResidenceInfo,
    this.operatorHours,
    this.identityVerification,
  );

  factory Detail.fromJson(Map<String, dynamic> srcJson) =>
      _$DetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DetailToJson(this);
}

@JsonSerializable()
class RegisteredResidenceInfo extends Object {
  @JsonKey(name: 'queryCost')
  double queryCost;

  @JsonKey(name: 'itemId')
  String itemId;

  @JsonKey(name: 'itemName')
  String itemName;

  @JsonKey(name: 'itemData')
  List<ItemData102> itemData102;

  @JsonKey(name: 'callSuccess')
  bool callSuccess;

  @JsonKey(name: 'itemCode')
  String itemCode;

  @JsonKey(name: 'isOffline')
  int isOffline;

  @JsonKey(name: 'cateName')
  String cateName;

  @JsonKey(name: 'cateCode')
  String cateCode;

  @JsonKey(name: 'isSuccess')
  bool isSuccess;

  @JsonKey(name: 'risk')
  String risk;

  RegisteredResidenceInfo(
    this.queryCost,
    this.itemId,
    this.itemName,
    this.itemData102,
    this.callSuccess,
    this.itemCode,
    this.isOffline,
    this.cateName,
    this.cateCode,
    this.isSuccess,
    this.risk,
  );

  factory RegisteredResidenceInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$RegisteredResidenceInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RegisteredResidenceInfoToJson(this);
}

@JsonSerializable()
class ItemData102 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData102(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData102.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData102FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData102ToJson(this);
}

@JsonSerializable()
class OperatorHours extends Object {
  @JsonKey(name: 'queryCost')
  double queryCost;

  @JsonKey(name: 'itemId')
  String itemId;

  @JsonKey(name: 'itemName')
  String itemName;

  @JsonKey(name: 'itemData')
  List<ItemData120> itemData120;

  @JsonKey(name: 'callSuccess')
  bool callSuccess;

  @JsonKey(name: 'itemCode')
  String itemCode;

  @JsonKey(name: 'isOffline')
  int isOffline;

  @JsonKey(name: 'cateName')
  String cateName;

  @JsonKey(name: 'cateCode')
  String cateCode;

  @JsonKey(name: 'isSuccess')
  bool isSuccess;

  OperatorHours(
    this.queryCost,
    this.itemId,
    this.itemName,
    this.itemData120,
    this.callSuccess,
    this.itemCode,
    this.isOffline,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory OperatorHours.fromJson(Map<String, dynamic> srcJson) =>
      _$OperatorHoursFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OperatorHoursToJson(this);
}

@JsonSerializable()
class ItemData120 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData120(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData120.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData120FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData120ToJson(this);
}

@JsonSerializable()
class IdentityVerification extends Object {
  @JsonKey(name: 'queryCost')
  double queryCost;

  @JsonKey(name: 'itemId')
  String itemId;

  @JsonKey(name: 'itemName')
  String itemName;

  @JsonKey(name: 'itemData')
  List<ItemData001> itemData001;

  @JsonKey(name: 'callSuccess')
  bool callSuccess;

  @JsonKey(name: 'itemCode')
  String itemCode;

  @JsonKey(name: 'isOffline')
  int isOffline;

  @JsonKey(name: 'cateName')
  String cateName;

  @JsonKey(name: 'cateCode')
  String cateCode;

  @JsonKey(name: 'isSuccess')
  bool isSuccess;

  @JsonKey(name: 'risk')
  String risk;

  IdentityVerification(
    this.queryCost,
    this.itemId,
    this.itemName,
    this.itemData001,
    this.callSuccess,
    this.itemCode,
    this.isOffline,
    this.cateName,
    this.cateCode,
    this.isSuccess,
    this.risk,
  );

  factory IdentityVerification.fromJson(Map<String, dynamic> srcJson) =>
      _$IdentityVerificationFromJson(srcJson);

  Map<String, dynamic> toJson() => _$IdentityVerificationToJson(this);
}

@JsonSerializable()
class ItemData001 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData001(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData001.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData001FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData001ToJson(this);
}

@JsonSerializable()
class InputMap extends Object {
  @JsonKey(name: 'certificateNumber2')
  String certificateNumber2;

  @JsonKey(name: 'birthday')
  String birthday;

  @JsonKey(name: 'certificateNumber3')
  String certificateNumber3;

  @JsonKey(name: 'report_notify_url')
  String reportNotifyUrl;

  @JsonKey(name: 'certificateNumber1')
  String certificateNumber1;

  @JsonKey(name: 'internationalEduNumber2')
  String internationalEduNumber2;

  @JsonKey(name: 'internationalEduNumber1')
  String internationalEduNumber1;

  @JsonKey(name: 'sex')
  String sex;

  @JsonKey(name: 'mobile')
  String mobile;

  @JsonKey(name: 'idNo')
  String idNo;

  @JsonKey(name: 'certificationRequire')
  String certificationRequire;

  @JsonKey(name: 'diplomaNumber')
  String diplomaNumber;

  @JsonKey(name: 'isSendSignSms')
  String isSendSignSms;

  @JsonKey(name: 'diplomaNumber3')
  String diplomaNumber3;

  @JsonKey(name: 'internationalEduNumber')
  String internationalEduNumber;

  @JsonKey(name: 'certificateNumber')
  String certificateNumber;

  @JsonKey(name: 'areaType')
  int areaType;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'diplomaNumber1')
  String diplomaNumber1;

  @JsonKey(name: 'diplomaNumber2')
  String diplomaNumber2;

  @JsonKey(name: 'tplId')
  String tplId;

  @JsonKey(name: 'age')
  int age;

  InputMap(
    this.certificateNumber2,
    this.birthday,
    this.certificateNumber3,
    this.reportNotifyUrl,
    this.certificateNumber1,
    this.internationalEduNumber2,
    this.internationalEduNumber1,
    this.sex,
    this.mobile,
    this.idNo,
    this.certificationRequire,
    this.diplomaNumber,
    this.isSendSignSms,
    this.diplomaNumber3,
    this.internationalEduNumber,
    this.certificateNumber,
    this.areaType,
    this.name,
    this.diplomaNumber1,
    this.diplomaNumber2,
    this.tplId,
    this.age,
  );

  factory InputMap.fromJson(Map<String, dynamic> srcJson) =>
      _$InputMapFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InputMapToJson(this);
}
