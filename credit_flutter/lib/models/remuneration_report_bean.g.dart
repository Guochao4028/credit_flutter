// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remuneration_report_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemunerationReportBean _$RemunerationReportBeanFromJson(
        Map<String, dynamic> json) =>
    RemunerationReportBean(
      json['dataSource'] as String,
      json['description'] as String,
      json['id'] as int,
      json['incomeRange'] as String,
      (json['incomeRangeJSONArray'] as List<dynamic>)
          .map((e) => IncomeRangeJSONArray.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['label1'] as String,
      json['label2'] as String,
      json['labelId'] as int,
      json['name'] as String,
      json['salaryAvg'] as String,
    );

Map<String, dynamic> _$RemunerationReportBeanToJson(
        RemunerationReportBean instance) =>
    <String, dynamic>{
      'dataSource': instance.dataSource,
      'description': instance.description,
      'id': instance.id,
      'incomeRange': instance.incomeRange,
      'incomeRangeJSONArray': instance.incomeRangeJSONArray,
      'label1': instance.label1,
      'label2': instance.label2,
      'labelId': instance.labelId,
      'name': instance.name,
      'salaryAvg': instance.salaryAvg,
    };

IncomeRangeJSONArray _$IncomeRangeJSONArrayFromJson(
        Map<String, dynamic> json) =>
    IncomeRangeJSONArray(
      json['content'] as String,
      json['rank'] as String,
      json['rate'] as String,
    );

Map<String, dynamic> _$IncomeRangeJSONArrayToJson(
        IncomeRangeJSONArray instance) =>
    <String, dynamic>{
      'content': instance.content,
      'rank': instance.rank,
      'rate': instance.rate,
    };
