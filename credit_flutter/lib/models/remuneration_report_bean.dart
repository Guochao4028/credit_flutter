import 'package:json_annotation/json_annotation.dart'; 
  
part 'remuneration_report_bean.g.dart';


@JsonSerializable()
  class RemunerationReportBean extends Object {

  @JsonKey(name: 'dataSource')
  String dataSource;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'incomeRange')
  String incomeRange;

  @JsonKey(name: 'incomeRangeJSONArray')
  List<IncomeRangeJSONArray> incomeRangeJSONArray;

  @JsonKey(name: 'label1')
  String label1;

  @JsonKey(name: 'label2')
  String label2;

  @JsonKey(name: 'labelId')
  int labelId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'salaryAvg')
  String salaryAvg;

  RemunerationReportBean(this.dataSource,this.description,this.id,this.incomeRange,this.incomeRangeJSONArray,this.label1,this.label2,this.labelId,this.name,this.salaryAvg,);

  factory RemunerationReportBean.fromJson(Map<String, dynamic> srcJson) => _$RemunerationReportBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RemunerationReportBeanToJson(this);

}

  
@JsonSerializable()
  class IncomeRangeJSONArray extends Object {

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'rank')
  String rank;

  @JsonKey(name: 'rate')
  String rate;

  IncomeRangeJSONArray(this.content,this.rank,this.rate,);

  factory IncomeRangeJSONArray.fromJson(Map<String, dynamic> srcJson) => _$IncomeRangeJSONArrayFromJson(srcJson);

  Map<String, dynamic> toJson() => _$IncomeRangeJSONArrayToJson(this);

}

  
