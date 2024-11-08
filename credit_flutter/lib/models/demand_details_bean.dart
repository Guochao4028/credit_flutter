import 'package:json_annotation/json_annotation.dart'; 
  
part 'demand_details_bean.g.dart';


@JsonSerializable()
  class DemandDetailsBean extends Object {

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

  DemandDetailsBean(this.budget,this.createTime,this.days,this.description,this.id,this.phone,this.reportDetail,this.status,this.title,this.userId,this.validTime,);

  factory DemandDetailsBean.fromJson(Map<String, dynamic> srcJson) => _$DemandDetailsBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DemandDetailsBeanToJson(this);

}

  
