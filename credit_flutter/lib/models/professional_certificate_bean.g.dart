// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_certificate_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalCertificateBean _$ProfessionalCertificateBeanFromJson(
        Map<String, dynamic> json) =>
    ProfessionalCertificateBean(
      json['name'] as String,
      (json['content'] as List<dynamic>)
          .map((e) => ProfessionalCertificateContent.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      json['explain'] as String,
    );

Map<String, dynamic> _$ProfessionalCertificateBeanToJson(
        ProfessionalCertificateBean instance) =>
    <String, dynamic>{
      'name': instance.name,
      'content': instance.content,
      'explain': instance.explain,
    };

ProfessionalCertificateContent _$ProfessionalCertificateContentFromJson(
        Map<String, dynamic> json) =>
    ProfessionalCertificateContent(
      json['title'] as String,
      json['content'] as String,
    );

Map<String, dynamic> _$ProfessionalCertificateContentToJson(
        ProfessionalCertificateContent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };
