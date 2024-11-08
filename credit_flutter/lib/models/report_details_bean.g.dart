// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_details_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDetailsBean _$ReportDetailsBeanFromJson(Map<String, dynamic> json) =>
    ReportDetailsBean(
      json['birthDay'] as int,
      ((json['companyRegistrationInfos'] ?? []) as List<dynamic>)
          .map((e) =>
              CompanyRegistrationInfos.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['currentAddress'] as String,
      (json['educations'] as List<dynamic>)
          .map((e) => Educations.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['gender'] as String,
      json['hometown'] as String,
      json['id'] as String,
      json['idCard'] as String,
      json['idCardName'] as String,
      IndustryBan.fromJson(json['industryBan'] ?? <String, dynamic>{}),
      ((json['loanInfos'] ?? []) as List<dynamic>)
          .map((e) => LoanInfos.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['marital'] as String,
      json['nationality'] as String,
      (json['pastExperience'] as List<dynamic>)
          .map((e) => PastExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['personalRiskInfos'] as List<dynamic>)
          .map((e) => PersonalRiskInfos.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['phone'] as String,
      json['politicalStatus'] as String,
      (json['publicInformation'] as List<dynamic>)
          .map((e) => PublicInformation.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['reportType'] as int,
      (json['riskWarning'] as List<dynamic>)
          .map((e) => RiskWarning.fromJson(e as Map<String, dynamic>))
          .toList(),
      ((json['skillsCertificates'] ?? []) as List<dynamic>)
          .map((e) => SkillsCertificates.fromJson(e as Map<String, dynamic>))
          .toList(),
      ((json['workExperience'] ?? []) as List<dynamic>)
          .map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportDetailsBeanToJson(ReportDetailsBean instance) =>
    <String, dynamic>{
      'birthDay': instance.birthDay,
      'companyRegistrationInfos': instance.companyRegistrationInfos,
      'currentAddress': instance.currentAddress,
      'educations': instance.educations,
      'gender': instance.gender,
      'hometown': instance.hometown,
      'id': instance.id,
      'idCard': instance.idCard,
      'idCardName': instance.idCardName,
      'industryBan': instance.industryBan,
      'loanInfos': instance.loanInfos,
      'marital': instance.marital,
      'nationality': instance.nationality,
      'pastExperience': instance.pastExperience,
      'personalRiskInfos': instance.personalRiskInfos,
      'phone': instance.phone,
      'politicalStatus': instance.politicalStatus,
      'publicInformation': instance.publicInformation,
      'reportType': instance.reportType,
      'riskWarning': instance.riskWarning,
      'skillsCertificates': instance.skillsCertificates,
      'workExperience': instance.workExperience,
    };

CompanyRegistrationInfos _$CompanyRegistrationInfosFromJson(
        Map<String, dynamic> json) =>
    CompanyRegistrationInfos(
      json['capital'] as String,
      json['createTime'] as int,
      json['name'] as String,
      json['operateStatus'] as String,
      json['position'] as String,
      json['province'] as String,
    );

Map<String, dynamic> _$CompanyRegistrationInfosToJson(
        CompanyRegistrationInfos instance) =>
    <String, dynamic>{
      'capital': instance.capital,
      'createTime': instance.createTime,
      'name': instance.name,
      'operateStatus': instance.operateStatus,
      'position': instance.position,
      'province': instance.province,
    };

Educations _$EducationsFromJson(Map<String, dynamic> json) => Educations(
      json['beginTime'] as int,
      json['diploma'] as String,
      json['educationalBackground'] as String,
      json['endTime'] as int,
      json['name'] as String,
    );

Map<String, dynamic> _$EducationsToJson(Educations instance) =>
    <String, dynamic>{
      'beginTime': instance.beginTime,
      'diploma': instance.diploma,
      'educationalBackground': instance.educationalBackground,
      'endTime': instance.endTime,
      'name': instance.name,
    };

IndustryBan _$IndustryBanFromJson(Map<String, dynamic> json) => IndustryBan(
      json['banIndustry'] ?? "",
      json['proposedBanIndustry'] ?? "",
      json['thing'] ?? "",
    );

Map<String, dynamic> _$IndustryBanToJson(IndustryBan instance) =>
    <String, dynamic>{
      'banIndustry': instance.banIndustry,
      'proposedBanIndustry': instance.proposedBanIndustry,
      'thing': instance.thing,
    };

LoanInfos _$LoanInfosFromJson(Map<String, dynamic> json) => LoanInfos(
      json['amount'] as String,
      json['bankName'] as String,
      json['createTime'] as int,
      json['overdueStatus'] as int,
    );

Map<String, dynamic> _$LoanInfosToJson(LoanInfos instance) => <String, dynamic>{
      'amount': instance.amount,
      'bankName': instance.bankName,
      'createTime': instance.createTime,
      'overdueStatus': instance.overdueStatus,
    };

PastExperience _$PastExperienceFromJson(Map<String, dynamic> json) =>
    PastExperience(
      json['createTime'] as int,
      json['title'] as String,
    );

Map<String, dynamic> _$PastExperienceToJson(PastExperience instance) =>
    <String, dynamic>{
      'createTime': instance.createTime,
      'title': instance.title,
    };

PersonalRiskInfos _$PersonalRiskInfosFromJson(Map<String, dynamic> json) =>
    PersonalRiskInfos(
      json['administrative'] as int,
      json['court'] as int,
      json['courtAnnouncement'] as int,
      json['courtService'] as int,
      json['executed'] as int,
      json['failure'] as int,
      json['filing'] as int,
      json['finalCase'] as int,
      json['judgment'] as int,
      json['judicial'] as int,
      json['marketSurveillance'] as int,
      json['taxViolation'] as int,
    );

Map<String, dynamic> _$PersonalRiskInfosToJson(PersonalRiskInfos instance) =>
    <String, dynamic>{
      'administrative': instance.administrative,
      'court': instance.court,
      'courtAnnouncement': instance.courtAnnouncement,
      'courtService': instance.courtService,
      'executed': instance.executed,
      'failure': instance.failure,
      'filing': instance.filing,
      'finalCase': instance.finalCase,
      'judgment': instance.judgment,
      'judicial': instance.judicial,
      'marketSurveillance': instance.marketSurveillance,
      'taxViolation': instance.taxViolation,
    };

PublicInformation _$PublicInformationFromJson(Map<String, dynamic> json) =>
    PublicInformation(
      json['link'] as String,
      json['publicCase'] as String,
      json['punish'] as String,
      json['type'] as int,
    );

Map<String, dynamic> _$PublicInformationToJson(PublicInformation instance) =>
    <String, dynamic>{
      'link': instance.link,
      'publicCase': instance.publicCase,
      'punish': instance.punish,
      'type': instance.type,
    };

RiskWarning _$RiskWarningFromJson(Map<String, dynamic> json) => RiskWarning(
      json['createTime'] as int,
      json['title'] as String,
    );

Map<String, dynamic> _$RiskWarningToJson(RiskWarning instance) =>
    <String, dynamic>{
      'createTime': instance.createTime,
      'title': instance.title,
    };

SkillsCertificates _$SkillsCertificatesFromJson(Map<String, dynamic> json) =>
    SkillsCertificates(
      json['code'] as String,
      json['createTime'] as int,
      json['name'] as String,
    );

Map<String, dynamic> _$SkillsCertificatesToJson(SkillsCertificates instance) =>
    <String, dynamic>{
      'code': instance.code,
      'createTime': instance.createTime,
      'name': instance.name,
    };

WorkExperience _$WorkExperienceFromJson(Map<String, dynamic> json) =>
    WorkExperience(
      json['beginTime'] as int,
      json['endTime'] as int,
      json['name'] as String,
      json['position'] as String,
      json['socialSecurityBeginTime'] as int,
      json['socialSecurityEndTime'] as int,
      json['time'] as String,
    );

Map<String, dynamic> _$WorkExperienceToJson(WorkExperience instance) =>
    <String, dynamic>{
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'name': instance.name,
      'position': instance.position,
      'socialSecurityBeginTime': instance.socialSecurityBeginTime,
      'socialSecurityEndTime': instance.socialSecurityEndTime,
      'time': instance.time,
    };
