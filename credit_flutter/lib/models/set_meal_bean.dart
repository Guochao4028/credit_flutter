import 'package:json_annotation/json_annotation.dart';

part 'set_meal_bean.g.dart';

List<SetMealBean> getSetMealBeanList(List<dynamic> list) {
  List<SetMealBean> result = [];
  list.forEach((item) {
    result.add(SetMealBean.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class SetMealBean extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'originalPrice')
  double originalPrice;

  @JsonKey(name: 'price')
  double price;

  @JsonKey(name: 'recommend')
  int recommend;

  @JsonKey(name: 'subTitle')
  String subTitle;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'isSelect')
  bool isSelect = false;

  SetMealBean(
    this.id,
    this.originalPrice,
    this.price,
    this.recommend,
    this.subTitle,
    this.title,
    this.type,
  );

  factory SetMealBean.fromJson(Map<String, dynamic> srcJson) =>
      _$SetMealBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetMealBeanToJson(this);
}
