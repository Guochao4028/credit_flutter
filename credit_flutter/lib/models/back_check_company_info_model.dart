import 'package:json_annotation/json_annotation.dart';

part 'back_check_company_info_model.g.dart';

@JsonSerializable()
class BackCheckCompanyInfoModel extends Object {
  ///关于我们
  @JsonKey(name: 'aboutUs')
  String aboutUs;

  ///公司地址
  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'id')
  int id;

  ///简介
  @JsonKey(name: 'introduction')
  String introduction;

  ///logo
  @JsonKey(name: 'logo')
  String logo;

  ///联系邮箱
  @JsonKey(name: 'mail')
  String mail;

  ///公司名称
  @JsonKey(name: 'name')
  String name;

  ///联系电话
  @JsonKey(name: 'phone')
  String phone;

  ///产品名称
  @JsonKey(name: 'productName')
  String productName;

  ///官网
  @JsonKey(name: 'website')
  String website;

  ///评分
  @JsonKey(name: 'score')
  double score;

  BackCheckCompanyInfoModel(
    this.aboutUs,
    this.address,
    this.id,
    this.introduction,
    this.logo,
    this.mail,
    this.name,
    this.phone,
    this.productName,
    this.website,
    this.score,
  );

  factory BackCheckCompanyInfoModel.fromJson(Map<String, dynamic> srcJson) =>
      _$BackCheckCompanyInfoModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BackCheckCompanyInfoModelToJson(this);
}
