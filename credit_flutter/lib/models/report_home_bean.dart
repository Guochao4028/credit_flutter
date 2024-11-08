/// *
/// -  @Date: 2022-07-08 14:14
/// -  @LastEditTime: 2022-07-08 14:52
/// -  @Description:
///
import 'package:json_annotation/json_annotation.dart';

part 'report_home_bean.g.dart';

@JsonSerializable()
class ReportHomeBean extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<ReportHomeDataBean> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  ReportHomeBean(
    this.total,
    this.data,
    this.pageSize,
    this.currentPage,
  );

  factory ReportHomeBean.fromJson(Map<String, dynamic> srcJson) =>
      _$ReportHomeBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReportHomeBeanToJson(this);
}

@JsonSerializable()
class ReportHomeDataBean extends Object {
  @JsonKey(name: 'authorizationStatus')
  int authorizationStatus;

  @JsonKey(name: 'buyStatus')
  int buyStatus;

  @JsonKey(name: 'checkStatus')
  int checkStatus;

  @JsonKey(name: 'createTimeTs')
  int createTimeTs;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'id')
  String reportId;

  @JsonKey(name: 'idCardNameCode')
  String idCardNameCode;

  @JsonKey(name: 'idCardNumCode')
  String idCardNumCode;

  @JsonKey(name: 'rejectionReason')
  String rejectionReason;

  @JsonKey(name: 'reportType')
  int reportType;

  ReportHomeDataBean(
    this.authorizationStatus,
    this.buyStatus,
    this.checkStatus,
    this.createTimeTs,
    this.id,
    this.idCardNameCode,
    this.idCardNumCode,
    this.rejectionReason,
    this.reportType,
    this.reportId,
  );

  factory ReportHomeDataBean.fromJson(Map<String, dynamic> srcJson) =>
      _$ReportHomeDataBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReportHomeDataBeanToJson(this);
}
