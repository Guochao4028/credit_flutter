import 'package:json_annotation/json_annotation.dart';

part 'order_list_model.g.dart';

@JsonSerializable()
class OrderListModel extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<OrderDetailsModel> detailsList;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  OrderListModel(
    this.total,
    this.detailsList,
    this.pageSize,
    this.currentPage,
  );

  factory OrderListModel.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderListModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderListModelToJson(this);
}

@JsonSerializable()
class OrderDetailsModel extends Object {
  @JsonKey(name: 'amount')
  double amount;

  @JsonKey(name: 'createTimeTs')
  int createTimeTs;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'companyId')
  int companyId;

  @JsonKey(name: 'invoiceId')
  int invoiceId;

  @JsonKey(name: 'invoiceStatus')
  int invoiceStatus;

  @JsonKey(name: 'invoiceValid')
  int invoiceValid;

  @JsonKey(name: 'payTimeTs')
  int payTimeTs;

  @JsonKey(name: 'payType')
  int payType;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'quantity')
  int quantity;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'reportAuthId')
  int reportAuthId;

  @JsonKey(name: 'reportIdCard')
  String reportIdCard;

  @JsonKey(name: 'reportType')
  int reportType;

  @JsonKey(name: 'reportUserName')
  String reportUserName;

  @JsonKey(name: 'reportUserType')
  int reportUserType;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'unit')
  int unit;

  @JsonKey(name: 'updateTimeTs')
  int updateTimeTs;

  @JsonKey(name: 'userId')
  int userId;

  OrderDetailsModel(
    this.amount,
    this.companyId,
    this.createTimeTs,
    this.id,
    this.invoiceId,
    this.invoiceStatus,
    this.invoiceValid,
    this.payTimeTs,
    this.payType,
    this.phone,
    this.quantity,
    this.remark,
    this.reportAuthId,
    this.reportIdCard,
    this.reportType,
    this.reportUserName,
    this.reportUserType,
    this.status,
    this.type,
    this.unit,
    this.updateTimeTs,
    this.userId,
  );

  bool isOpenInvoice() {
    return invoiceValid == 1;
  }

  String getPayType() {
    String type = "";
// 1.微信 2.支付宝 3.苹果支付 4.慧眼币支付
    switch (payType) {
      case 1:
        type = "微信";
        break;
      case 2:
        type = "支付宝";
        break;
      case 3:
        type = "苹果支付";
        break;
      case 4:
        type = "慧眼币支付";
        break;
      case 5:
        type = "抖音支付";
        break;
      default:
    }
    return type;
  }

  String getPayTime() {
    DateTime dateTime = DateTime.now();

    ///如果是十三位时间戳返回这个
    if (payTimeTs.toString().length == 13) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(payTimeTs);
    } else if (payTimeTs.toString().length == 16) {
      ///如果是十六位时间戳
      dateTime = DateTime.fromMicrosecondsSinceEpoch(payTimeTs);
    }
    String time = dateTime.toString();
    time = time.substring(0, time.length - 4);
    return time;
  }

  factory OrderDetailsModel.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderDetailsModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderDetailsModelToJson(this);
}
