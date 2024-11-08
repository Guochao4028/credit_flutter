/// *
/// -  @Date: 2022-08-19 11:22
/// -  @LastEditTime: 2022-09-06 16:07
/// -  @Description:
///
import 'package:json_annotation/json_annotation.dart';

part 'comment_bean.g.dart';

@JsonSerializable()
class CommentBean extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<CommentDataBean> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  CommentBean(
    this.total,
    this.data,
    this.pageSize,
    this.currentPage,
  );

  factory CommentBean.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentBeanToJson(this);
}

@JsonSerializable()
class CommentDataBean extends Object {
  @JsonKey(name: 'backCompanyId')
  int backCompanyId;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'createTime')
  int createTime;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'likeCount')
  int likeCount;

  @JsonKey(name: 'selfLike')
  int selfLike;

  CommentDataBean(
    this.backCompanyId,
    this.content,
    this.createTime,
    this.id,
    this.likeCount,
    this.selfLike,
  );

  factory CommentDataBean.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentDataBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentDataBeanToJson(this);
}
