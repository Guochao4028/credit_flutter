import 'package:json_annotation/json_annotation.dart';

part 'demand_center_bean.g.dart';

@JsonSerializable()
class DemandCenterBean extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<DemandCenterData> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  DemandCenterBean(
    this.total,
    this.data,
    this.pageSize,
    this.currentPage,
  );

  factory DemandCenterBean.fromJson(Map<String, dynamic> srcJson) =>
      _$DemandCenterBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DemandCenterBeanToJson(this);
}

@JsonSerializable()
class DemandCenterData extends Object {
  @JsonKey(name: 'budget')
  double budget;

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'days')
  int days;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'reportDetail')
  String reportDetail;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'userId')
  int userId;

  @JsonKey(name: 'validTime')
  int validTime;

  DemandCenterData(
    this.budget,
    this.createTime,
    this.days,
    this.description,
    this.id,
    this.phone,
    this.reportDetail,
    this.status,
    this.title,
    this.userId,
    this.validTime,
  );

  factory DemandCenterData.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
