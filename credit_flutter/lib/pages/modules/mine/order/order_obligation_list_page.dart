/// *
/// -  @Date: 2023-10-25 16:57
/// -  @LastEditTime: 2023-10-25 16:59
/// -  @Description: 待付款列表（从倒计时进来的 ）
///

import 'dart:async';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/pages/modules/report/report_preview_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/notification.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderObligaionListPage extends StatefulWidget {
  const OrderObligaionListPage({super.key});

  @override
  State<OrderObligaionListPage> createState() => _OrderObligaionListPageState();
}

class _OrderObligaionListPageState extends State<OrderObligaionListPage>
    implements OrderObligationListClickListener {
  List<OrderDetailsModel> modelList = [];
  final EasyRefreshController controller = EasyRefreshController();

  //当前页
  int currentPage = 1;

  //每页多少条
  int pageSize = 10;
  bool _orderListEmpty = false;

  bool verifiedStatus = true;

  @override
  void initState() {
    super.initState();

    NotificationCener.instance.addNotification(FinalKeys.NOTIFICATION_COUNTDOWN,
        ({object}) {
      _initData();
    });
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "待支付订单",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: CustomColors.colorF1F4F9,
      body: contentView(modelList),
    );
  }

  void _initData() {
    Map<String, dynamic> map = {
      "pageNum": 1,
      "pageSize": 10,
      "minute": 60,
      "orderStatus": 1
    };
    if (Golbal.loginType.isNotEmpty && Golbal.token.isNotEmpty) {
      if (Golbal.loginType == "2") {
        map["orderType"] = 8;
      } else {
        map["orderType"] = 12;
      }
    }

    OrderManager.orderPersonList(map, (object) {
      currentPage++;
      OrderListModel listModel = object as OrderListModel;
      listModel.detailsList;
      setState(() {
        modelList = listModel.detailsList;
      });
    });
  }

  Widget contentView(List<OrderDetailsModel> orderList) {
    if (orderList.isEmpty) {
      _orderListEmpty = true;
      orderList = [
        OrderDetailsModel(0, 0, 0, 0, 0, 0, 0, 0, 0, "0", 0, "0", 0, "0", 0,
            "0", 0, 0, 0, 0, 0, 0)
      ];
    } else {
      _orderListEmpty = false;
    }
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: EasyRefresh(
        header: WidgetTools().getClassicalHeader(),
        footer: WidgetTools().getClassicalFooter(),
        controller: controller,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        child: ListView.builder(
          itemBuilder: (context, index) {
            OrderDetailsModel model = orderList[index];
            return OrderListItemView(
              onStart: (() {}),
              detailsModel: model,
              orderListEmpty: _orderListEmpty,
              verifiedStatus: verifiedStatus,
              listener: this,
            );
          },
          itemCount: orderList.length,
        ),
      ),
    );
  }

  Future _onRefresh() async {
    currentPage = 1;

    Map<String, dynamic> map = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "minute": 60,
      "orderStatus": 1
    };
    if (Golbal.loginType.isNotEmpty && Golbal.token.isNotEmpty) {
      if (Golbal.loginType == "2") {
        map["orderType"] = 8;
      } else {
        map["orderType"] = 12;
      }
    }

    OrderManager.orderPersonList(map, (object) {
      currentPage++;
      controller.finishRefresh(success: true);
      controller.finishLoad(success: true, noMore: false);
      OrderListModel listModel = object as OrderListModel;
      listModel.detailsList;
      setState(() {
        modelList = listModel.detailsList;
      });
    });

    return "";
  }

  Future _onLoad() async {
    OrderManager.orderPersonList({
      "pageNum": currentPage,
      "pageSize": pageSize,
      "minute": 60,
      "orderStatus": 1,
    }, (object) {
      currentPage++;

      OrderListModel listModel = object as OrderListModel;
      List<OrderDetailsModel> list = listModel.detailsList;
      if (list.isNotEmpty) {
        modelList.addAll(list);

        controller.finishLoad(success: true, noMore: false);
      } else {
        controller.finishLoad(success: true, noMore: true);
      }

      setState(() {});
    });

    return "";
  }

  @override
  tapOrderListItem(OrderDetailsModel model) {
    String token = Golbal.token;
    Map<String, dynamic> dataMap = {
      "idCardName": model.reportUserName,
      "idCard": model.reportIdCard,
      "orderNumber": model.id
    };
    // reportUserType	1.企业购买报告 2.个人自查 3.个人雇主
    if (model.reportUserType == 2) {
      bool flag = model.reportType == 1 ? true : false;
      if (token.isEmpty) {
        _goBuy(model.reportType, flag, dataMap,
            PaymentFromType.paymentFromQuickBuyPersonType);
      } else {
        if (flag == false) {
          _goBuy(model.reportType, flag, dataMap,
              PaymentFromType.paymentFrom5yuanReportUpgradeType);
        } else {
          _goBuy(model.reportType, flag, dataMap,
              PaymentFromType.paymentFromPersonType);
        }
      }
    } else if (model.reportUserType == 3) {
      if (token.isEmpty) {
        PayManager.getReportPrice(1, (price) {
          ///获取报告订阅价格
          PayManager.getReportPrice(4, (yearPrice) {
            ReportPreviewPage page = ReportPreviewPage(
              displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
              fromType: PaymentFromType.paymentFromQuickBuyType,
              price: price,
              reportType: 1,
              yearPrice: yearPrice,
            );
            page.packet = dataMap;

            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => page,
              ),
            )
                .then((value) {
              _initData();
              NotificationCener.instance
                  .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
            });
          });
        });
      } else {
        PayManager.getReportPrice(1, (price) {
          ReportPreviewPage page = ReportPreviewPage(
            displayType: PaymentListDisplayType.paymentListAllDisplay,
            fromType: PaymentFromType.paymentFromPersonBuyPersonReport,
            price: price,
            reportType: 1,
          );
          page.packet = dataMap;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return page;
              },
            ),
          ).then((value) {
            NotificationCener.instance
                .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
          });
        });
      }
    }
  }

  /// 个人自查报告 去支付 分 19.9和全部
  void _goBuy(int type, bool bool, Map<String, dynamic> dataMap,
      PaymentFromType fromType) {
    PayManager.getReportPrice(type, (price) {
      PayCheakstandPage page = PayCheakstandPage(
        displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
        fromType: fromType,
        price: price,
        reportType: type,
      );
      page.packet = dataMap;
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      )
          .then((value) {
        NotificationCener.instance
            .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
      });
    });
  }

  @override
  tapOrderGotoPay(OrderDetailsModel model) {
    String token = Golbal.token;
    Map<String, dynamic> dataMap = {
      "idCardName": model.reportUserName,
      "idCard": model.reportIdCard,
      "orderNumber": model.id
    };

    if (model.reportUserType == 2) {
      bool flag = model.reportType == 1 ? true : false;
      if (token.isEmpty) {
        _goBuy(model.reportType, flag, dataMap,
            PaymentFromType.paymentFromQuickBuyPersonType);
      } else {
        if (flag == false) {
          _goBuy(model.reportType, flag, dataMap,
              PaymentFromType.paymentFrom5yuanReportUpgradeType);
        } else {
          _goBuy(model.reportType, flag, dataMap,
              PaymentFromType.paymentFromPersonType);
        }
      }
    } else if (model.reportUserType == 3) {
      if (token.isEmpty) {
        PayManager.getReportPrice(1, (price) {
          ///获取报告订阅价格
          PayManager.getReportPrice(4, (yearPrice) {
            ReportPreviewPage page = ReportPreviewPage(
              displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
              fromType: PaymentFromType.paymentFromQuickBuyType,
              price: price,
              reportType: 1,
              yearPrice: yearPrice,
            );
            page.packet = dataMap;

            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => page,
              ),
            )
                .then((value) {
              NotificationCener.instance
                  .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
            });
          });
        });
      } else {
        PayManager.getReportPrice(1, (price) {
          ReportPreviewPage page = ReportPreviewPage(
            displayType: PaymentListDisplayType.paymentListAllDisplay,
            fromType: PaymentFromType.paymentFromPersonBuyPersonReport,
            price: price,
            reportType: 1,
          );
          page.packet = dataMap;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return page;
              },
            ),
          ).then((value) {
            NotificationCener.instance
                .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
          });
        });
      }
    }
  }
}

class OrderListItemView extends StatefulWidget {
  OrderDetailsModel detailsModel;
  OrderObligationListClickListener? listener;
  final VoidCallback onStart;
  bool orderListEmpty;
  bool verifiedStatus;

  OrderListItemView({
    Key? key,
    required this.onStart,
    required this.detailsModel,
    this.listener,
    required this.orderListEmpty,
    required this.verifiedStatus,
  }) : super(key: key);

  @override
  State<OrderListItemView> createState() => _OrderListItemViewState();
}

class _OrderListItemViewState extends State<OrderListItemView>
    with SingleTickerProviderStateMixin {
  OrderObligationListClickListener? _listener;
  double start = 0;
  bool isOpen = false;
  double maxMove = 62;
  bool isTapDelete = false;
  OrderDetailsModel? detailsModel;

  @override
  void initState() {
    // detailsModel = widget.detailsModel;
    _listener = widget.listener;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orderListEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Image.asset(
            "assets/images/emptyIcon1.png",
            width: 247,
            height: 187,
          ),
        ),
      );
    } else {
      return Container(
        height: 170,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10, right: 16, left: 16),
        child: Stack(
          children: [
            ///item view
            Positioned(
              left: -start,
              right: start,
              child: GestureDetector(
                onTap: () {
                  _listener?.tapOrderListItem(widget.detailsModel!);
                },
                child: Column(
                  children: [
                    infoView(),
                    operationView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  /// *
  /// -  @description: List Item 上半部信息
  /// -  @Date: 2022-08-31 10:23
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget infoView() {
    int type = widget.detailsModel?.type ?? 0;
    String contentStr = "";
    String titleStr = "";
    String iconPathStr = "assets/images/svg/SVIP.svg";
    int quantity = widget.detailsModel?.quantity ?? 0;
    int unit = widget.detailsModel?.unit ?? 0;
    String name = widget.detailsModel?.reportUserName ?? "";
    String status = "待付款";
    var reportType = widget.detailsModel?.reportType ?? 1;

    ///1.vip
    ///2.svip
    ///3.公司购买慧眼币
    ///4.企业增加人数
    ///5.公司购买个人报告
    ///6.个人购买慧眼币
    ///7.会员升级
    ///8.个人购买报告
    ///9.公司报告升级
    ///10.去购买
    ///11.订阅
    ///12 个人购买他人报告
    switch (type) {
      case 1:
        {
          titleStr = "VIP会员";
          contentStr = "开通$quantity年VIP会员服务";

          iconPathStr = "assets/images/svg/VIP.svg";
        }
        break;
      case 2:
        {
          titleStr = "SVIP会员";
          contentStr = "开通$quantity年SVIP会员服务";
          iconPathStr = "assets/images/svg/SVIP.svg";
        }
        break;
      case 3:
      case 6:
        {
          titleStr = "慧眼币充值";
          contentStr = "购买$quantity个慧眼币";
          iconPathStr = "assets/images/svg/biIcon.svg";
        }
        break;
      case 4:
        {
          titleStr = "增加企业人数";
          contentStr = "购买$quantity个企业人数";
          iconPathStr = "assets/images/svg/addP.svg";
        }
        break;

      case 8:
        {
          {
            titleStr = "个人背调报告";
            contentStr = "购买个人背调报告";
            iconPathStr = "assets/images/svg/baogao.svg";
          }
          break;
        }
      case 5:
      case 10:
      case 12:
      case 13:
        {
          titleStr = reportType == 5 ? "员工背调报告（基础信息）" : "员工背调报告";
          contentStr = "购买$name的员工背调报告${reportType == 5 ? "（基础信息）" : ""}";
          iconPathStr = "assets/images/svg/baogao.svg";
        }
        break;
      case 9:
        {
          titleStr = "员工背调报告";
          contentStr = "升级$name的员工背调报告";
          iconPathStr = "assets/images/svg/baogao.svg";
        }
        break;
      case 11:
        {
          titleStr = "订阅员工背调报告";
          contentStr = "订阅$name的员工背调报告";
          iconPathStr = "assets/images/svg/baogao.svg";
        }
        break;
      case 7:
        {
          titleStr = "会员升级";
          contentStr = "会员升级";
          iconPathStr = "assets/images/svg/upda.svg";
        }
        break;
      default:
    }

    SizedBox icon = SizedBox(
      width: 18,
      height: 18,
      child: SvgPicture.asset(
        iconPathStr,
        fit: BoxFit.fill,
      ),
    );

    ///箭头
    SizedBox direction = SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        "assets/images/svg/back.svg",
        fit: BoxFit.fill,
        color: CustomColors.darkGreyE6,
      ),
    );
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          padding: const EdgeInsets.only(left: 15, right: 16),
          height: 45,
          child: Row(
            children: [
              icon,
              const SizedBox(width: 2),
              Text(
                titleStr,
                style: const TextStyle(
                  color: CustomColors.textDarkColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Expanded(child: SizedBox()),
              Text(
                status,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.greyBlack,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              CountdownView(detailsModel: widget.detailsModel),
            ],
          ),
        ),
        Container(height: 1, color: CustomColors.color1A000),
        Container(
          height: 59,
          color: Colors.white,
          padding: const EdgeInsets.only(left: 38, right: 16, top: 14),
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Text(
                contentStr,
                style: const TextStyle(
                  color: CustomColors.darkGrey,
                  fontSize: 15,
                ),
              ),
              const Expanded(child: SizedBox()),
              direction
            ],
          ),
        ),
      ],
    );
  }

  /// *
  /// -  @description: List Item 下半部操作
  /// -  @Date: 2022-08-31 10:24
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget operationView() {
    double amount = widget.detailsModel.amount ?? 0.0;
    String price = StringTools.numberFormat(amount.toString(), true);

    String status = "支付金额";

    Widget buttonView = const SizedBox(
      height: 1,
      width: 1,
    );

    String buttonTitle = "去支付";

    buttonView = WidgetTools().createCustomInkWellButton(buttonTitle, () {
      _listener?.tapOrderGotoPay(widget.detailsModel!);
    },
        bgColor: CustomColors.connectColor,
        textColor: Colors.white,
        radius: 15,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        height: 30,
        shadow: const BoxShadow(),
        buttonWidth: 82);

    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: CustomColors.colorFFD9,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16),
      alignment: Alignment.center,
      child: Row(
        children: [
          Text(
            "$status：",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: CustomColors.warningColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Expanded(child: SizedBox()),
          buttonView,
        ],
      ),
    );
  }
}

abstract class OrderObligationListClickListener {
  ///点击list item
  tapOrderListItem(OrderDetailsModel model);

  /// 点击 去支付
  tapOrderGotoPay(OrderDetailsModel model);
}

class CountdownView extends StatefulWidget {
  OrderDetailsModel detailsModel;

  CountdownView({required this.detailsModel, super.key});

  @override
  State<CountdownView> createState() => _CountdownViewState();
}

class _CountdownViewState extends State<CountdownView> {
  Timer? _timer;
  int _timsTs = -1;
  OrderDetailsModel? detailsModel;

  @override
  void initState() {
    detailsModel = widget.detailsModel;
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orderTime = detailsModel?.createTimeTs ?? 0;

    ///当前时间
    var _now = DateTime.now();

    var _diffDate = DateTime.fromMillisecondsSinceEpoch(orderTime * 1);

    /// 计算订单截止时间
    var _cutoffTime = _diffDate.add(const Duration(minutes: 60));

    var _existenceTime = _cutoffTime.difference(_now).inSeconds;

    if (_timsTs < 0) {
      //获取总秒数，2 分钟为 120 秒
      _timsTs = _existenceTime;
      _startTimer();
    }
    String remainingTime = _constructTime(_timsTs);
    return SizedBox(
      width: 80,
      child: Text(
        remainingTime,
        style: const TextStyle(
          color: CustomColors.bgRedColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _startTimer() {
    //设置 1 秒回调一次
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        //秒数减一，因为一秒回调一次
        _timsTs -= 1;
      });
      if (_timsTs == 0) {
        //倒计时秒数为0，取消定时器
        _cancelTimer();
        NotificationCener.instance
            .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
      }
    });
  }

  void _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// *
  /// -  @description: 根据总秒数转换为对应的 mm:ss 格式
  /// -  @Date: 2023-10-25 15:15
  ///
  String _constructTime(int time) {
    int min = (time / 60 % 60).toInt();
    int sec = (time % 60).toInt();

    return "${formatTime(min)} : ${formatTime(sec)}";
  }

  /// *
  /// -  @description:数字格式化，将 0~9 的时间转换为 00~09
  /// -  @Date: 2023-10-25 15:14
  ///
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0$timeNum" : timeNum.toString();
  }
}
