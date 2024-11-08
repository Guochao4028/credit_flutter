import 'package:json_annotation/json_annotation.dart'; 
  
part 'my_needs_bean.g.dart';


@JsonSerializable()
  class MyNeedsBean extends Object {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<MyNeedsData> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  MyNeedsBean(this.total,this.data,this.pageSize,this.currentPage,);

  factory MyNeedsBean.fromJson(Map<String, dynamic> srcJson) => _$MyNeedsBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MyNeedsBeanToJson(this);

}

  
@JsonSerializable()
  class MyNeedsData extends Object {

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

  MyNeedsData(this.budget,this.createTime,this.days,this.description,this.id,this.phone,this.reportDetail,this.status,this.title,this.userId,this.validTime,);

  factory MyNeedsData.fromJson(Map<String, dynamic> srcJson) => _$MyNeedsDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MyNeedsDataToJson(this);

}

  
