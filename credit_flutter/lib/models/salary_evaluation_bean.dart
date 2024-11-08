import 'package:json_annotation/json_annotation.dart';

part 'salary_evaluation_bean.g.dart';

List<SalaryEvaluationBean> getSalaryEvaluationBeanList(List<dynamic> list) {
  List<SalaryEvaluationBean> result = [];
  list.forEach((item) {
    result.add(SalaryEvaluationBean.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class SalaryEvaluationBean extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'label1')
  String label1;

  @JsonKey(name: 'label2')
  String label2;

  @JsonKey(name: 'name')
  String name;

  bool isSelect = false;

  SalaryEvaluationBean(
    this.id,
    this.label1,
    this.label2,
    this.name,
  );

  factory SalaryEvaluationBean.fromJson(Map<String, dynamic> srcJson) =>
      _$SalaryEvaluationBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SalaryEvaluationBeanToJson(this);
}
