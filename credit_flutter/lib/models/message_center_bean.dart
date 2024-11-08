import 'package:json_annotation/json_annotation.dart'; 
  
part 'message_center_bean.g.dart';


@JsonSerializable()
  class MessageCenterBean extends Object {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<Data> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  MessageCenterBean(this.total,this.data,this.pageSize,this.currentPage,);

  factory MessageCenterBean.fromJson(Map<String, dynamic> srcJson) => _$MessageCenterBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MessageCenterBeanToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'businessId')
  int businessId;

  @JsonKey(name: 'companyId')
  int companyId;

  @JsonKey(name: 'createTimeTs')
  int createTimeTs;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'readStatus')
  int readStatus;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'updateTimeTs')
  int updateTimeTs;

  @JsonKey(name: 'userId')
  int userId;

  Data(this.businessId,this.companyId,this.createTimeTs,this.id,this.readStatus,this.title,this.type,this.updateTimeTs,this.userId,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
