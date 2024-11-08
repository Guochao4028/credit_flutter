/// *
/// -  @Date: 2022-07-19 15:42
/// -  @LastEditTime: 2022-07-19 15:42
/// -  @Description: 套餐
///

import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

List<ProductModel> getProductModelList(List<dynamic> list) {
  List<ProductModel> result = [];
  list.forEach((item) {
    result.add(ProductModel.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class ProductModel extends Object {
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

  @JsonKey(name: 'iosProductId')
  String iosProductId;

  bool isSelected = false;

  ProductModel(this.id, this.originalPrice, this.price, this.recommend,
      this.subTitle, this.title, this.type, this.iosProductId);

  factory ProductModel.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
