import 'package:json_annotation/json_annotation.dart'; 
  
part 'project_switch_model.g.dart';


@JsonSerializable()
  class ProjectSwitchModel extends Object {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'pages')
  int pages;

  @JsonKey(name: 'data')
  List<Data> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  ProjectSwitchModel(this.total,this.pages,this.data,this.pageSize,this.currentPage,);

  factory ProjectSwitchModel.fromJson(Map<String, dynamic> srcJson) => _$ProjectSwitchModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProjectSwitchModelToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'jsonParam')
  String jsonParam;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'updateTime')
  int updateTime;

  Data(this.createTime,this.description,this.id,this.jsonParam,this.status,this.updateTime,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
