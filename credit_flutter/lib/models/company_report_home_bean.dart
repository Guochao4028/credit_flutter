/// *
/// -  @Date: 2022-11-01 15:04
/// -  @LastEditTime: 2023-03-06 16:36
/// -  @Description:
///
import 'package:json_annotation/json_annotation.dart';

part 'company_report_home_bean.g.dart';

@JsonSerializable()
class CompanyReportHomeBean extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<CompanyReportHomeData> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  CompanyReportHomeBean(
    this.total,
    this.data,
    this.pageSize,
    this.currentPage,
  );

  factory CompanyReportHomeBean.fromJson(Map<String, dynamic> srcJson) =>
      _$CompanyReportHomeBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CompanyReportHomeBeanToJson(this);
}

@JsonSerializable()
class CompanyReportHomeData extends Object {
  @JsonKey(name: 'authorizationStatus')
  int authorizationStatus;

  @JsonKey(name: 'checkStatus')
  int checkStatus;

  @JsonKey(name: 'companyName')
  String companyName;

  @JsonKey(name: 'createTimeTs')
  int createTimeTs;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'reportId')
  String? reportId;

  @JsonKey(name: 'selectUser')
  String selectUser;

  @JsonKey(name: 'rejectionReason')
  String rejectionReason;

  @JsonKey(name: 'orderId')
  int orderId;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'reportAuthId')
  int reportAuthId;

  @JsonKey(name: 'reportType')
  int reportType;

  CompanyReportHomeData(
      this.authorizationStatus,
      this.checkStatus,
      this.companyName,
      this.createTimeTs,
      this.id,
      this.rejectionReason,
      this.selectUser,
      this.reportId,
      this.reportAuthId,
      this.phone,
      this.orderId,
      this.reportType);

  factory CompanyReportHomeData.fromJson(Map<String, dynamic> srcJson) =>
      _$CompanyReportHomeDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CompanyReportHomeDataToJson(this);
}
