/// *
/// -  @Date: 2022-09-06 15:51
/// -  @LastEditTime: 2022-09-06 16:06
/// -  @Description:
///
/// *
/// -  @Date: 2022-09-06 15:51
/// -  @LastEditTime: 2022-09-06 16:02
/// -  @Description:
///
import 'package:json_annotation/json_annotation.dart';

part 'order_invoice_model.g.dart';

@JsonSerializable()
class OrderInvoiceModel extends Object {
  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'createTimeTs')
  int createTimeTs;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'invoiceClass')
  int invoiceClass;

  @JsonKey(name: 'mail')
  String mail;

  @JsonKey(name: 'orderId')
  int orderId;

  @JsonKey(name: 'tax')
  String tax;

  @JsonKey(name: 'titleName')
  String titleName;

  @JsonKey(name: 'titleType')
  int titleType;

  @JsonKey(name: 'type')
  int type;

  OrderInvoiceModel(
    this.content,
    this.createTimeTs,
    this.id,
    this.invoiceClass,
    this.mail,
    this.orderId,
    this.tax,
    this.titleName,
    this.titleType,
    this.type,
  );

  factory OrderInvoiceModel.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderInvoiceModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderInvoiceModelToJson(this);
}
