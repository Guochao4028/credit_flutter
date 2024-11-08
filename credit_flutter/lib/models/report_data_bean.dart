import 'package:json_annotation/json_annotation.dart';

part 'report_data_bean.g.dart';

@JsonSerializable()
class ReportDataBean extends Object {
  @JsonKey(name: 'creditReportDigest')
  CreditReportDigest creditReportDigest;

  ///报告总结
  @JsonKey(name: 'summary', defaultValue: '')
  String summary;

  @JsonKey(name: 'digestMap', defaultValue: Map<String, dynamic>)
  DigestMap digestMap;

  ///报告声明
  @JsonKey(name: 'reportDeclare', defaultValue: '')
  String reportDeclare;

  ///报告基础信息
  @JsonKey(name: 'reportInfo', defaultValue: Map<String, dynamic>)
  ReportInfo reportInfo;

  @JsonKey(name: 'detail', defaultValue: Map<String, dynamic>)
  Detail detail;

  @JsonKey(name: 'inputMap', defaultValue: Map<String, dynamic>)
  InputMap inputMap;

  ReportDataBean(
    this.creditReportDigest,
    this.summary,
    this.digestMap,
    this.reportDeclare,
    this.reportInfo,
    this.detail,
    this.inputMap,
  );

  factory ReportDataBean.fromJson(Map<String, dynamic> srcJson) =>
      _$ReportDataBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReportDataBeanToJson(this);
}

@JsonSerializable()
class CreditReportDigest extends Object {
  ///报告 Id
  @JsonKey(name: 'reportId', defaultValue: '')
  String reportId;

  ///姓名
  @JsonKey(name: 'name', defaultValue: '')
  String name;

  ///身份证号
  @JsonKey(name: 'idNo', defaultValue: '')
  String idNo;

  ///手机号
  @JsonKey(name: 'mobile', defaultValue: '')
  String mobile;

  ///性别
  @JsonKey(name: 'sex', defaultValue: '')
  String sex;

  ///户籍所在地
  @JsonKey(name: 'householdAddr', defaultValue: '')
  String householdAddr;

  ///出生日期（yyyyMMdd格式）
  @JsonKey(name: 'birthday', defaultValue: 0)
  int birthday;

  ///风险等级
  //1 int 核实中
  // 2 int 待复核
  // 3 int 风险
  // 4 int 一般风险
  // 5 int 轻微风险
  // 6 int 关注
  // 7 int 无风险
  @JsonKey(name: 'riskLevel', defaultValue: '7')
  String riskLevel;

  ///创建时间
  @JsonKey(name: 'createTime', defaultValue: 0)
  int createTime;

  CreditReportDigest(
    this.reportId,
    this.name,
    this.idNo,
    this.mobile,
    this.sex,
    this.householdAddr,
    this.birthday,
    this.riskLevel,
    this.createTime,
  );

  factory CreditReportDigest.fromJson(Map<String, dynamic> srcJson) =>
      _$CreditReportDigestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CreditReportDigestToJson(this);
}

@JsonSerializable()
class DigestMap extends Object {
  @JsonKey(name: 'digestListInfo', defaultValue: [])
  List<DigestListInfo> digestListInfo;

  DigestMap(
    this.digestListInfo,
  );

  factory DigestMap.fromJson(Map<String, dynamic> srcJson) =>
      _$DigestMapFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DigestMapToJson(this);
}

@JsonSerializable()
class DigestListInfo extends Object {
  @JsonKey(name: 'result', defaultValue: '')
  String result;

  @JsonKey(name: 'level', defaultValue: '')
  String level;

  ///摘要名称
  @JsonKey(name: 'name', defaultValue: '')
  String name;

  ///风险说明(核实中，待复核，风险，一般风险，关注，无风险)
  @JsonKey(name: 'risk', defaultValue: '')
  String risk;

  @JsonKey(name: 'remark', defaultValue: '')
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
  ///生日
  @JsonKey(name: 'birthday', defaultValue: '')
  String birthday;

  ///公司名称
  @JsonKey(name: 'orgName', defaultValue: '')
  String orgName;

  ///风险登记
  @JsonKey(name: 'riskLevel', defaultValue: '')
  String riskLevel;

  ///授权完成时间（时间戳）
  @JsonKey(name: 'completeTime', defaultValue: 0)
  int completeTime;

  @JsonKey(name: 'userId', defaultValue: '')
  String userId;

  ///报告是否有效（1：有效，0：无效）
  @JsonKey(name: 'isEffective', defaultValue: 0)
  int isEffective;

  ///更新时间（时间戳）
  @JsonKey(name: 'modifyTime', defaultValue: 0)
  int modifyTime;

  ///套餐名称
  @JsonKey(name: 'tplName', defaultValue: '')
  String tplName;

  ///创建时间（时间戳）
  @JsonKey(name: 'createTime', defaultValue: 0)
  int createTime;

  ///客观项状态
  @JsonKey(name: 'objectiveStatus', defaultValue: 0)
  int objectiveStatus;

  ///报告 id
  @JsonKey(name: 'id', defaultValue: '')
  String id;

  ///套餐 id
  @JsonKey(name: 'tplId', defaultValue: '')
  String tplId;

  ///报告状态
  //字典值 数据类型 字典描述
  // 1 int 授权中
  // 2 int 已催
  // 3 int 已取消
  // 4 int 已完成
  // 5 int 已删除
  // 7 int 生成中
  // 8 int 读卡成功，待扫码授权
  // 9 int 待补充信息
  // 11 int 待复核
  // 12 int 阶段版
  // 13 int 进行中
  // 14 int 暂停
  // 15 int 终止
  // 16 int 已完成已通知
  // 17 int 已查看授权
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
    this.status,
  );

  factory ReportInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$ReportInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReportInfoToJson(this);
}

@JsonSerializable()
class Detail extends Object {
  ///户籍信息核实
  @JsonKey(name: '102', defaultValue: Map<String, dynamic>)
  RegisteredResidenceInfo? registeredResidenceInfo;

  @JsonKey(name: '136', defaultValue: Map<String, dynamic>)
  BusinessInfo? businessInfo;

  @JsonKey(name: '138', defaultValue: Map<String, dynamic>)
  OnlineLoanBlacklist? onlineLoanBlacklist;

  @JsonKey(name: '182', defaultValue: Map<String, dynamic>)
  TechnicalColleges? technicalColleges;

  @JsonKey(name: '184', defaultValue: Map<String, dynamic>)
  DomesticDegree? domesticDegree;

  @JsonKey(name: '194', defaultValue: Map<String, dynamic>)
  DriverLicenseInfo? driverLicenseInfo;

  @JsonKey(name: '205', defaultValue: Map<String, dynamic>)
  BadSocialInfo? badSocialInfo;

  @JsonKey(name: '261', defaultValue: Map<String, dynamic>)
  LimitedLitigationRecord? limitedLitigationRecord;

  @JsonKey(name: '403', defaultValue: Map<String, dynamic>)
  DomesticEducationalBackground? domesticEducationalBackground;

  @JsonKey(name: '418', defaultValue: Map<String, dynamic>)
  AccountingQualification accountingQualification;

  @JsonKey(name: '421', defaultValue: Map<String, dynamic>)
  MoralHazard? moralHazard;

  @JsonKey(name: '423', defaultValue: Map<String, dynamic>)
  BadTaxRecord? badTaxRecord;

  @JsonKey(name: '425', defaultValue: Map<String, dynamic>)
  ProhibitedDrugs? prohibitedDrugs;

  @JsonKey(name: '452', defaultValue: Map<String, dynamic>)
  PeopleWhoLoseCredit? peopleWhoLoseCredit;

  @JsonKey(name: '453', defaultValue: Map<String, dynamic>)
  ExecutedPerson? executedPerson;

  @JsonKey(name: '746', defaultValue: Map<String, dynamic>)
  OverseasEducationalBackground? overseasEducationalBackground;

  @JsonKey(name: '755', defaultValue: Map<String, dynamic>)
  HearingAnnouncement? hearingAnnouncement;

  @JsonKey(name: '757', defaultValue: Map<String, dynamic>)
  LimitHighConsumption? limitHighConsumption;

  @JsonKey(name: '764', defaultValue: Map<String, dynamic>)
  CriminalAdjudicationDocument? criminalAdjudicationDocument;

  @JsonKey(name: '769', defaultValue: Map<String, dynamic>)
  RestrictedEntryAndExit? restrictedEntryAndExit;

  @JsonKey(name: '001', defaultValue: Map<String, dynamic>)
  IdentityVerification? identityVerification;

  Detail(
    this.registeredResidenceInfo,
    this.businessInfo,
    this.onlineLoanBlacklist,
    this.technicalColleges,
    this.domesticDegree,
    this.driverLicenseInfo,
    this.badSocialInfo,
    this.limitedLitigationRecord,
    this.domesticEducationalBackground,
    this.accountingQualification,
    this.moralHazard,
    this.badTaxRecord,
    this.prohibitedDrugs,
    this.peopleWhoLoseCredit,
    this.executedPerson,
    this.overseasEducationalBackground,
    this.hearingAnnouncement,
    this.limitHighConsumption,
    this.criminalAdjudicationDocument,
    this.restrictedEntryAndExit,
    this.identityVerification,
  );

  factory Detail.fromJson(Map<String, dynamic> srcJson) =>
      _$DetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DetailToJson(this);
}

@JsonSerializable()
class RegisteredResidenceInfo extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData102> itemData102;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  RegisteredResidenceInfo(
    this.itemId,
    this.itemName,
    this.itemData102,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory RegisteredResidenceInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$RegisteredResidenceInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RegisteredResidenceInfoToJson(this);
}

@JsonSerializable()
class ItemData102 extends Object {
  /// string 属性说明
  @JsonKey(name: 'itemPropLabel', defaultValue: '')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName', defaultValue: '')
  String itemPropName;

  @JsonKey(name: 'itemPropValue', defaultValue: '')
  String itemPropValue;

  ///是否集合数据
  @JsonKey(name: 'set', defaultValue: false)
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
class BusinessInfo extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData136> itemData136;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  BusinessInfo(
    this.itemId,
    this.itemName,
    this.itemData136,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory BusinessInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$BusinessInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BusinessInfoToJson(this);
}

@JsonSerializable()
class ItemData136 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData136(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData136.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData136FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData136ToJson(this);
}

@JsonSerializable()
class OnlineLoanBlacklist extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData138> itemData138;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  OnlineLoanBlacklist(
    this.itemId,
    this.itemName,
    this.itemData138,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory OnlineLoanBlacklist.fromJson(Map<String, dynamic> srcJson) =>
      _$OnlineLoanBlacklistFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OnlineLoanBlacklistToJson(this);
}

@JsonSerializable()
class ItemData138 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData138(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData138.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData138FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData138ToJson(this);
}

@JsonSerializable()
class TechnicalColleges extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData182> itemData182;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  TechnicalColleges(
    this.itemId,
    this.itemName,
    this.itemData182,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory TechnicalColleges.fromJson(Map<String, dynamic> srcJson) =>
      _$TechnicalCollegesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TechnicalCollegesToJson(this);
}

@JsonSerializable()
class ItemData182 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData182(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData182.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData182FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData182ToJson(this);
}

@JsonSerializable()
class DomesticDegree extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData184> itemData184;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ///风险等级
  @JsonKey(name: 'risk', defaultValue: '')
  String risk;

  DomesticDegree(
    this.itemId,
    this.itemName,
    this.itemData184,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
    this.risk,
  );

  factory DomesticDegree.fromJson(Map<String, dynamic> srcJson) =>
      _$DomesticDegreeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DomesticDegreeToJson(this);
}

@JsonSerializable()
class ItemData184 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData184(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData184.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData184FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData184ToJson(this);
}

@JsonSerializable()
class DriverLicenseInfo extends Object {
  @JsonKey(name: 'itemId', defaultValue: "")
  String itemId;

  @JsonKey(name: 'itemName', defaultValue: "")
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData194> itemData194;

  @JsonKey(name: 'itemCode', defaultValue: "")
  String itemCode;

  DriverLicenseInfo(
    this.itemId,
    this.itemName,
    this.itemData194,
    this.itemCode,
  );

  factory DriverLicenseInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$DriverLicenseInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DriverLicenseInfoToJson(this);
}

@JsonSerializable()
class ItemData194 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData194(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData194.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData194FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData194ToJson(this);
}

@JsonSerializable()
class BadSocialInfo extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData205> itemData205;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ///风险等级
  @JsonKey(name: 'risk', defaultValue: '')
  String risk;

  BadSocialInfo(
    this.itemId,
    this.itemName,
    this.itemData205,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
    this.risk,
  );

  factory BadSocialInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$BadSocialInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BadSocialInfoToJson(this);
}

@JsonSerializable()
class ItemData205 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData205(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData205.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData205FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData205ToJson(this);
}

@JsonSerializable()
class LimitedLitigationRecord extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData261> itemData261;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ///风险等级
  @JsonKey(name: 'risk', defaultValue: '')
  String risk;

  LimitedLitigationRecord(
    this.itemId,
    this.itemName,
    this.itemData261,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
    this.risk,
  );

  factory LimitedLitigationRecord.fromJson(Map<String, dynamic> srcJson) =>
      _$LimitedLitigationRecordFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LimitedLitigationRecordToJson(this);
}

@JsonSerializable()
class ItemData261 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData261(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData261.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData261FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData261ToJson(this);
}

@JsonSerializable()
class DomesticEducationalBackground extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData403> itemData403;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ///风险等级
  @JsonKey(name: 'risk', defaultValue: '')
  String risk;

  DomesticEducationalBackground(
    this.itemId,
    this.itemName,
    this.itemData403,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
    this.risk,
  );

  factory DomesticEducationalBackground.fromJson(
          Map<String, dynamic> srcJson) =>
      _$DomesticEducationalBackgroundFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DomesticEducationalBackgroundToJson(this);
}

@JsonSerializable()
class ItemData403 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData403(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData403.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData403FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData403ToJson(this);
}

@JsonSerializable()
class AccountingQualification extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData418> itemData418;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  AccountingQualification(
    this.itemId,
    this.itemName,
    this.itemData418,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory AccountingQualification.fromJson(Map<String, dynamic> srcJson) =>
      _$AccountingQualificationFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccountingQualificationToJson(this);
}

@JsonSerializable()
class ItemData418 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData418(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData418.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData418FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData418ToJson(this);
}

@JsonSerializable()
class MoralHazard extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData421> itemData421;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  MoralHazard(
    this.itemId,
    this.itemName,
    this.itemData421,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory MoralHazard.fromJson(Map<String, dynamic> srcJson) =>
      _$MoralHazardFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MoralHazardToJson(this);
}

@JsonSerializable()
class ItemData421 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  int itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData421(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData421.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData421FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData421ToJson(this);
}

@JsonSerializable()
class BadTaxRecord extends Object {
  @JsonKey(name: 'itemId')
  String itemId;

  @JsonKey(name: 'itemName')
  String itemName;

  @JsonKey(name: 'itemData')
  List<ItemData423> itemData423;

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

  BadTaxRecord(
    this.itemId,
    this.itemName,
    this.itemData423,
    this.callSuccess,
    this.itemCode,
    this.isOffline,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory BadTaxRecord.fromJson(Map<String, dynamic> srcJson) =>
      _$BadTaxRecordFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BadTaxRecordToJson(this);
}

@JsonSerializable()
class ItemData423 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData423(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData423.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData423FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData423ToJson(this);
}

@JsonSerializable()
class ProhibitedDrugs extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData425> itemData425;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ProhibitedDrugs(
    this.itemId,
    this.itemName,
    this.itemData425,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory ProhibitedDrugs.fromJson(Map<String, dynamic> srcJson) =>
      _$ProhibitedDrugsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProhibitedDrugsToJson(this);
}

@JsonSerializable()
class ItemData425 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  int itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData425(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData425.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData425FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData425ToJson(this);
}

@JsonSerializable()
class PeopleWhoLoseCredit extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData452> itemData452;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  PeopleWhoLoseCredit(
    this.itemId,
    this.itemName,
    this.itemData452,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory PeopleWhoLoseCredit.fromJson(Map<String, dynamic> srcJson) =>
      _$PeopleWhoLoseCreditFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PeopleWhoLoseCreditToJson(this);
}

@JsonSerializable()
class ItemData452 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData452(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData452.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData452FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData452ToJson(this);
}

@JsonSerializable()
class ExecutedPerson extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData453> itemData453;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ExecutedPerson(
    this.itemId,
    this.itemName,
    this.itemData453,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory ExecutedPerson.fromJson(Map<String, dynamic> srcJson) =>
      _$ExecutedPersonFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ExecutedPersonToJson(this);
}

@JsonSerializable()
class ItemData453 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData453(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData453.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData453FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData453ToJson(this);
}

@JsonSerializable()
class OverseasEducationalBackground extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData746> itemData746;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  OverseasEducationalBackground(
    this.itemId,
    this.itemName,
    this.itemData746,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory OverseasEducationalBackground.fromJson(
          Map<String, dynamic> srcJson) =>
      _$OverseasEducationalBackgroundFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OverseasEducationalBackgroundToJson(this);
}

@JsonSerializable()
class ItemData746 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData746(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData746.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData746FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData746ToJson(this);
}

@JsonSerializable()
class HearingAnnouncement extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData755> itemData755;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ///风险等级
  @JsonKey(name: 'risk', defaultValue: '')
  String risk;

  HearingAnnouncement(
    this.itemId,
    this.itemName,
    this.itemData755,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
    this.risk,
  );

  factory HearingAnnouncement.fromJson(Map<String, dynamic> srcJson) =>
      _$HearingAnnouncementFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HearingAnnouncementToJson(this);
}

@JsonSerializable()
class ItemData755 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData755(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData755.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData755FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData755ToJson(this);
}

@JsonSerializable()
class LimitHighConsumption extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData757> itemData757;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  LimitHighConsumption(
    this.itemId,
    this.itemName,
    this.itemData757,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory LimitHighConsumption.fromJson(Map<String, dynamic> srcJson) =>
      _$LimitHighConsumptionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LimitHighConsumptionToJson(this);
}

@JsonSerializable()
class ItemData757 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData757(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData757.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData757FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData757ToJson(this);
}

@JsonSerializable()
class CriminalAdjudicationDocument extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData764> itemData764;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ///风险等级
  @JsonKey(name: 'risk', defaultValue: '')
  String risk;

  CriminalAdjudicationDocument(
    this.itemId,
    this.itemName,
    this.itemData764,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
    this.risk,
  );

  factory CriminalAdjudicationDocument.fromJson(Map<String, dynamic> srcJson) =>
      _$CriminalAdjudicationDocumentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CriminalAdjudicationDocumentToJson(this);
}

@JsonSerializable()
class ItemData764 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData764(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData764.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData764FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData764ToJson(this);
}

@JsonSerializable()
class RestrictedEntryAndExit extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData769> itemData769;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  RestrictedEntryAndExit(
    this.itemId,
    this.itemName,
    this.itemData769,
    this.callSuccess,
    this.itemCode,
    this.cateName,
    this.cateCode,
    this.isSuccess,
  );

  factory RestrictedEntryAndExit.fromJson(Map<String, dynamic> srcJson) =>
      _$RestrictedEntryAndExitFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RestrictedEntryAndExitToJson(this);
}

@JsonSerializable()
class ItemData769 extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  List<List<ItemPropValueBean>> itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemData769(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemData769.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemData769FromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemData769ToJson(this);
}

@JsonSerializable()
class IdentityVerification extends Object {
  ///查询项 id
  @JsonKey(name: 'itemId', defaultValue: '')
  String itemId;

  ///查询项名称
  @JsonKey(name: 'itemName', defaultValue: '')
  String itemName;

  @JsonKey(name: 'itemData', defaultValue: [])
  List<ItemData001> itemData001;

  ///调用是否成功
  @JsonKey(name: 'callSuccess', defaultValue: false)
  bool callSuccess;

  ///查询项 code
  @JsonKey(name: 'itemCode', defaultValue: '')
  String itemCode;

  ///所属分类名称
  @JsonKey(name: 'cateName', defaultValue: '')
  String cateName;

  ///所属分类 code
  @JsonKey(name: 'cateCode', defaultValue: '')
  String cateCode;

  ///是否成功
  @JsonKey(name: 'isSuccess', defaultValue: false)
  bool isSuccess;

  ///风险等级
  @JsonKey(name: 'risk', defaultValue: '')
  String risk;

  IdentityVerification(
    this.itemId,
    this.itemName,
    this.itemData001,
    this.callSuccess,
    this.itemCode,
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
  ///出生日期（yyyyMMdd格式）
  @JsonKey(name: 'birthday', defaultValue: '')
  String birthday;

  ///报告回调通知地址
  @JsonKey(name: 'report_notify_url', defaultValue: '')
  String reportNotifyUrl;

  ///是否发送授权短信(1.发送,0.不发送)
  @JsonKey(name: 'isSendSignSms', defaultValue: '')
  String isSendSignSms;

  ///性别
  @JsonKey(name: 'sex', defaultValue: '')
  String sex;

  ///姓名
  @JsonKey(name: 'name', defaultValue: '')
  String name;

  ///手机号
  @JsonKey(name: 'mobile', defaultValue: '')
  String mobile;

  ///套餐 id
  @JsonKey(name: 'tplId', defaultValue: '')
  String tplId;

  ///身份证号（候选人填写为0 时必填）
  @JsonKey(name: 'idNo', defaultValue: '')
  String idNo;

  ///证明人要求
  @JsonKey(name: 'certificationRequire', defaultValue: '')
  String certificationRequire;

  ///年龄
  @JsonKey(name: 'age', defaultValue: 0)
  int age;

  ///学位证书编号
  @JsonKey(name: 'certificateNumber', defaultValue: '')
  String certificateNumber;

  ///毕业证书编号
  @JsonKey(name: 'diplomaNumber', defaultValue: '')
  String diplomaNumber;

  ///会计-报考级别
  @JsonKey(name: 'examinationLevel', defaultValue: '')
  String examinationLevel;

  ///会计-报考年份
  @JsonKey(name: 'examinationYear', defaultValue: '')
  String examinationYear;

  ///会计-报考省份
  @JsonKey(name: 'examinationProvince', defaultValue: '')
  String examinationProvince;

  ///国际学历证书编号
  @JsonKey(name: 'internationalEduNumber', defaultValue: '')
  String internationalEduNumber;

  InputMap(
    this.birthday,
    this.reportNotifyUrl,
    this.isSendSignSms,
    this.sex,
    this.name,
    this.mobile,
    this.tplId,
    this.idNo,
    this.certificationRequire,
    this.age,
    this.certificateNumber,
    this.diplomaNumber,
    this.examinationLevel,
    this.examinationYear,
    this.examinationProvince,
    this.internationalEduNumber,
  );

  factory InputMap.fromJson(Map<String, dynamic> srcJson) =>
      _$InputMapFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InputMapToJson(this);
}

@JsonSerializable()
class ItemPropValueBean extends Object {
  @JsonKey(name: 'itemPropLabel')
  String itemPropLabel;

  @JsonKey(name: 'itemPropName')
  String itemPropName;

  @JsonKey(name: 'itemPropValue')
  String itemPropValue;

  @JsonKey(name: 'set')
  bool set;

  ItemPropValueBean(
    this.itemPropLabel,
    this.itemPropName,
    this.itemPropValue,
    this.set,
  );

  factory ItemPropValueBean.fromJson(Map<String, dynamic> srcJson) =>
      _$ItemPropValueBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ItemPropValueBeanToJson(this);
}
