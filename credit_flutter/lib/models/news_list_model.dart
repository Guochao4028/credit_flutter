/*** 
 * @Date: 2022-06-16 16:43
 * @LastEditTime: 2022-06-16 17:21
 * @Description: 新闻列表model
 */
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_list_model.g.dart';

@JsonSerializable()
class NewsListModel extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<NewsDetailsModel> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  NewsListModel(
    this.total,
    this.data,
    this.pageSize,
    this.currentPage,
  );

  factory NewsListModel.fromJson(Map<String, dynamic> srcJson) =>
      _$NewsListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NewsListModelToJson(this);
}
