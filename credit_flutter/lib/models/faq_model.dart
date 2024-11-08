/// *
/// -  @Date: 2023-09-14 13:58
/// -  @LastEditTime: 2023-09-14 13:58
/// -  @Description: 常见问题

import 'package:json_annotation/json_annotation.dart';

part 'faq_model.g.dart';

List<FAQModel> getFAQModelList(List<dynamic> list) {
  List<FAQModel> result = [];
  list.forEach((item) {
    result.add(FAQModel.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class FAQModel extends Object {
  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'updateTime')
  int updateTime;

  bool isSeleced = false;
  FAQModel(
    this.content,
    this.createTime,
    this.id,
    this.title,
    this.updateTime,
  );

  factory FAQModel.fromJson(Map<String, dynamic> srcJson) =>
      _$FAQModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FAQModelToJson(this);
}
