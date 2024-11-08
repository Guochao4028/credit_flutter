import 'package:json_annotation/json_annotation.dart';

part 'report_details_bean.g.dart';

@JsonSerializable()
class ReportDetailsBean extends Object {
  @JsonKey(name: 'birthDay')
  int birthDay;

  @JsonKey(name: 'companyRegistrationInfos')
  List<CompanyRegistrationInfos> companyRegistrationInfos;

  @JsonKey(name: 'currentAddress')
  String currentAddress;

  @JsonKey(name: 'educations')
  List<Educations> educations;

  @JsonKey(name: 'gender')
  String gender;

  @JsonKey(name: 'hometown')
  String hometown;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'idCard')
  String idCard;

  @JsonKey(name: 'idCardName')
  String idCardName;

  @JsonKey(name: 'industryBan')
  IndustryBan industryBan;

  @JsonKey(name: 'loanInfos')
  List<LoanInfos> loanInfos;

  @JsonKey(name: 'marital')
  String marital;

  @JsonKey(name: 'nationality')
  String nationality;

  @JsonKey(name: 'pastExperience')
  List<PastExperience> pastExperience;

  @JsonKey(name: 'personalRiskInfos')
  List<PersonalRiskInfos> personalRiskInfos;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'politicalStatus')
  String politicalStatus;

  @JsonKey(name: 'publicInformation')
  List<PublicInformation> publicInformation;

  @JsonKey(name: 'reportType')
  int reportType;

  @JsonKey(name: 'riskWarning')
  List<RiskWarning> riskWarning;

  @JsonKey(name: 'skillsCertificates')
  List<SkillsCertificates> skillsCertificates;

  @JsonKey(name: 'workExperience')
  List<WorkExperience> workExperience;

  ReportDetailsBean(
    this.birthDay,
    this.companyRegistrationInfos,
    this.currentAddress,
    this.educations,
    this.gender,
    this.hometown,
    this.id,
    this.idCard,
    this.idCardName,
    this.industryBan,
    this.loanInfos,
    this.marital,
    this.nationality,
    this.pastExperience,
    this.personalRiskInfos,
    this.phone,
    this.politicalStatus,
    this.publicInformation,
    this.reportType,
    this.riskWarning,
    this.skillsCertificates,
    this.workExperience,
  );

  factory ReportDetailsBean.fromJson(Map<String, dynamic> srcJson) =>
      _$ReportDetailsBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReportDetailsBeanToJson(this);
}

@JsonSerializable()
class CompanyRegistrationInfos extends Object {
  @JsonKey(name: 'capital')
  String capital;

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'operateStatus')
  String operateStatus;

  @JsonKey(name: 'position')
  String position;

  @JsonKey(name: 'province')
  String province;

  CompanyRegistrationInfos(
    this.capital,
    this.createTime,
    this.name,
    this.operateStatus,
    this.position,
    this.province,
  );

  factory CompanyRegistrationInfos.fromJson(Map<String, dynamic> srcJson) =>
      _$CompanyRegistrationInfosFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CompanyRegistrationInfosToJson(this);
}

@JsonSerializable()
class Educations extends Object {
  @JsonKey(name: 'beginTime')
  int beginTime;

  @JsonKey(name: 'diploma')
  String diploma;

  @JsonKey(name: 'educationalBackground')
  String educationalBackground;

  @JsonKey(name: 'endTime')
  int endTime;

  @JsonKey(name: 'name')
  String name;

  Educations(
    this.beginTime,
    this.diploma,
    this.educationalBackground,
    this.endTime,
    this.name,
  );

  factory Educations.fromJson(Map<String, dynamic> srcJson) =>
      _$EducationsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EducationsToJson(this);
}

@JsonSerializable()
class IndustryBan extends Object {
  @JsonKey(name: 'banIndustry')
  String banIndustry;

  @JsonKey(name: 'proposedBanIndustry')
  String proposedBanIndustry;

  @JsonKey(name: 'thing')
  String thing;

  IndustryBan(
    this.banIndustry,
    this.proposedBanIndustry,
    this.thing,
  );

  factory IndustryBan.fromJson(Map<String, dynamic> srcJson) =>
      _$IndustryBanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$IndustryBanToJson(this);
}

@JsonSerializable()
class LoanInfos extends Object {
  @JsonKey(name: 'amount')
  String amount;

  @JsonKey(name: 'bankName')
  String bankName;

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'overdueStatus')
  int overdueStatus;

  LoanInfos(
    this.amount,
    this.bankName,
    this.createTime,
    this.overdueStatus,
  );

  factory LoanInfos.fromJson(Map<String, dynamic> srcJson) =>
      _$LoanInfosFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoanInfosToJson(this);
}

@JsonSerializable()
class PastExperience extends Object {
  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'title')
  String title;

  PastExperience(
    this.createTime,
    this.title,
  );

  factory PastExperience.fromJson(Map<String, dynamic> srcJson) =>
      _$PastExperienceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PastExperienceToJson(this);
}

@JsonSerializable()
class PersonalRiskInfos extends Object {
  @JsonKey(name: 'administrative')
  int administrative;

  @JsonKey(name: 'court')
  int court;

  @JsonKey(name: 'courtAnnouncement')
  int courtAnnouncement;

  @JsonKey(name: 'courtService')
  int courtService;

  @JsonKey(name: 'executed')
  int executed;

  @JsonKey(name: 'failure')
  int failure;

  @JsonKey(name: 'filing')
  int filing;

  @JsonKey(name: 'finalCase')
  int finalCase;

  @JsonKey(name: 'judgment')
  int judgment;

  @JsonKey(name: 'judicial')
  int judicial;

  @JsonKey(name: 'marketSurveillance')
  int marketSurveillance;

  @JsonKey(name: 'taxViolation')
  int taxViolation;

  PersonalRiskInfos(
    this.administrative,
    this.court,
    this.courtAnnouncement,
    this.courtService,
    this.executed,
    this.failure,
    this.filing,
    this.finalCase,
    this.judgment,
    this.judicial,
    this.marketSurveillance,
    this.taxViolation,
  );

  factory PersonalRiskInfos.fromJson(Map<String, dynamic> srcJson) =>
      _$PersonalRiskInfosFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PersonalRiskInfosToJson(this);
}

@JsonSerializable()
class PublicInformation extends Object {
  @JsonKey(name: 'link')
  String link;

  @JsonKey(name: 'publicCase')
  String publicCase;

  @JsonKey(name: 'punish')
  String punish;

  @JsonKey(name: 'type')
  int type;

  PublicInformation(
    this.link,
    this.publicCase,
    this.punish,
    this.type,
  );

  factory PublicInformation.fromJson(Map<String, dynamic> srcJson) =>
      _$PublicInformationFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PublicInformationToJson(this);
}

@JsonSerializable()
class RiskWarning extends Object {
  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'title')
  String title;

  RiskWarning(
    this.createTime,
    this.title,
  );

  factory RiskWarning.fromJson(Map<String, dynamic> srcJson) =>
      _$RiskWarningFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RiskWarningToJson(this);
}

@JsonSerializable()
class SkillsCertificates extends Object {
  @JsonKey(name: 'code')
  String code;

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'name')
  String name;

  SkillsCertificates(
    this.code,
    this.createTime,
    this.name,
  );

  factory SkillsCertificates.fromJson(Map<String, dynamic> srcJson) =>
      _$SkillsCertificatesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SkillsCertificatesToJson(this);
}

@JsonSerializable()
class WorkExperience extends Object {
  @JsonKey(name: 'beginTime')
  int beginTime;

  @JsonKey(name: 'endTime')
  int endTime;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'position')
  String position;

  @JsonKey(name: 'socialSecurityBeginTime')
  int socialSecurityBeginTime;

  @JsonKey(name: 'socialSecurityEndTime')
  int socialSecurityEndTime;

  @JsonKey(name: 'time')
  String time;

  WorkExperience(
    this.beginTime,
    this.endTime,
    this.name,
    this.position,
    this.socialSecurityBeginTime,
    this.socialSecurityEndTime,
    this.time,
  );

  factory WorkExperience.fromJson(Map<String, dynamic> srcJson) =>
      _$WorkExperienceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$WorkExperienceToJson(this);
}
