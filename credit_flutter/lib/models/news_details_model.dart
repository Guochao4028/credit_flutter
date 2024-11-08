/// *
/// -  @Date: 2022-06-08 10:19
/// -  @LastEditTime: 2022-06-23 17:06
/// -  @Description:
///
/***
 * @Date: 2022-06-08 10:19
 * @LastEditTime: 2022-06-08 14:19
 * @Description: 新闻详情 模型
 */
import 'package:json_annotation/json_annotation.dart';

part 'news_details_model.g.dart';

@JsonSerializable()
class NewsDetailsModel extends Object {
  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'coverImage')
  String? coverImage;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'from')
  String from;

  @JsonKey(name: 'keyword')
  String keyword;

  @JsonKey(name: 'newsId')
  int newsId;

  @JsonKey(name: 'releaseTime')
  String releaseTime;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'top')
  int top;

  @JsonKey(name: 'type')
  int type;

  NewsDetailsModel(
    this.content,
    this.coverImage,
    this.createTime,
    this.description,
    this.from,
    this.keyword,
    this.newsId,
    this.releaseTime,
    this.title,
    this.top,
    this.type,
  );

  factory NewsDetailsModel.fromJson(Map<String, dynamic> srcJson) =>
      _$NewsDetailsModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NewsDetailsModelToJson(this);
}
