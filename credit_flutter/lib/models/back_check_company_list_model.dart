/// *
/// -  @Date: 2022-06-18 21:59
/// -  @LastEditTime: 2022-06-27 18:58
/// -  @Description:
///
import 'package:json_annotation/json_annotation.dart';

part 'back_check_company_list_model.g.dart';

@JsonSerializable()
class BackCheckCompanyListModel extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<BackCheckCompanyListItemModel> data;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  BackCheckCompanyListModel(
    this.total,
    this.data,
    this.pageSize,
    this.currentPage,
  );

  factory BackCheckCompanyListModel.fromJson(Map<String, dynamic> srcJson) =>
      _$BackCheckCompanyListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BackCheckCompanyListModelToJson(this);
}

@JsonSerializable()
class BackCheckCompanyListItemModel extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'introduction')
  String introduction;

  @JsonKey(name: 'logo')
  String logo;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'productName')
  String productName;

  @JsonKey(name: 'score')
  double score;

  @JsonKey(name: 'commentCount')
  int commentCount;

  BackCheckCompanyListItemModel(this.id, this.introduction, this.logo,
      this.name, this.productName, this.score, this.commentCount);

  factory BackCheckCompanyListItemModel.fromJson(
          Map<String, dynamic> srcJson) =>
      _$BackCheckCompanyListItemModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BackCheckCompanyListItemModelToJson(this);
}
