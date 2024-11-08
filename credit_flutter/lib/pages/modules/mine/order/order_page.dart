/// *
/// -  @Date: 2022-08-30 14:27
/// -  @LastEditTime: 2022-08-30 14:27
/// -  @Description: 订单列表
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/certification_process_page.dart';
import 'package:credit_flutter/pages/modules/mine/order/order_detail_page.dart';
import 'package:credit_flutter/pages/modules/mine/order/order_invoice_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_status/pay_success_input_phone_page.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    implements OrderListItemViewClickListener, ClickListener {
  List<OrderDetailsModel> modelList = [];
  final EasyRefreshController controller = EasyRefreshController();

  //当前页
  int currentPage = 1;

  //每页多少条
  int pageSize = 10;

  int deleteModelId = 0;

  bool _orderListEmpty = false;

  bool verifiedStatus = true;

  String loginType = "";

  @override
  void initState() {
    super.initState();
    UmengCommonSdk.onPageStart("order_page");
    _initUI();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("login_page");
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
              "我的订单",
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

  void _initUI() {
    UserModel.getInfo((model) {
      if (model != null) {
        verifiedStatus = model.userInfo.getUserVerifiedStatus();
        setState(() {});
      }
    });
  }

  void _initData() {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 取出数据
    _prefs.then((sp) {
      ///获取用户登录状态
      ///1，企业。2，用户
      loginType = sp.getString(FinalKeys.LOGIN_TYPE) ?? "1";

      if (loginType == "1") {
        OrderManager.orderList({"pageNum": 1, "pageSize": 10}, (object) {
          currentPage++;
          OrderListModel listModel = object as OrderListModel;
          listModel.detailsList;
          setState(() {
            modelList = listModel.detailsList;
          });
        });
      } else {
        OrderManager.orderPersonList({"pageNum": 1, "pageSize": 10}, (object) {
          currentPage++;
          OrderListModel listModel = object as OrderListModel;
          listModel.detailsList;
          setState(() {
            modelList = listModel.detailsList;
          });
        });
      }
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
              listener: this,
              orderListEmpty: _orderListEmpty,
              verifiedStatus: verifiedStatus,
            );
          },
          itemCount: orderList.length,
        ),
      ),
    );
  }

  Future _onRefresh() async {
    currentPage = 1;

    if (loginType == "1") {
      OrderManager.orderList({"pageNum": currentPage, "pageSize": pageSize},
          (object) {
        currentPage++;
        controller.finishRefresh(success: true);
        controller.finishLoad(success: true, noMore: false);
        OrderListModel listModel = object as OrderListModel;
        listModel.detailsList;
        setState(() {
          modelList = listModel.detailsList;
        });
      });
    } else {
      OrderManager.orderPersonList(
          {"pageNum": currentPage, "pageSize": pageSize}, (object) {
        currentPage++;
        controller.finishRefresh(success: true);
        controller.finishLoad(success: true, noMore: false);
        OrderListModel listModel = object as OrderListModel;
        listModel.detailsList;
        setState(() {
          modelList = listModel.detailsList;
        });
      });
    }

    return "";
  }

  Future _onLoad() async {
    if (loginType == "1") {
      OrderManager.orderList({"pageNum": currentPage, "pageSize": pageSize},
          (object) {
        currentPage++;
        controller.finishLoad(success: true, noMore: false);
        OrderListModel listModel = object as OrderListModel;
        listModel.detailsList;
        setState(() {
          modelList.addAll(listModel.detailsList);
        });
      });
    } else {
      OrderManager.orderPersonList(
          {"pageNum": currentPage, "pageSize": pageSize}, (object) {
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
    }

    return "";
  }

  @override
  deleteOrderListItem(OrderDetailsModel model) {
    deleteModelId = model.id;
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            confirm: "确定",
            cancel: "取消",
            content: "确定要删除这一条订单信息吗",
            showCancel: true,
            clickListener: this,
          );
        });
  }

  @override
  operationInvoice(OrderDetailsModel model) {
    int invoiceValid = model.invoiceValid;

    if (invoiceValid == 2) {
      ToastUtils.showMessage("未达到开票条件");
    } else {
      var push = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderInvoicePage(
            model: model,
          ),
        ),
      );

      push.then((value) {
        if (value != null) {
          _onRefresh();
        }
      });
    }
  }

  @override
  tapOrderListItem(OrderDetailsModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailPage(model: model)),
    );
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    String title = confirmMap["title"];
    // String identity = map["identity"];
    Log.i(deleteModelId);
    if (title == "确定") {
      OrderManager.deleteOrder([deleteModelId], (object) {
        // ToastUtils.showMessage("已成功删除订单");
        ToastUtils.showImageMessage(
            context, "已成功删除订单", "assets/images/svg/ok.svg");

        setState(() {
          modelList.removeWhere((element) => element.id == deleteModelId);
        });
      });
    }
  }

  @override
  realNameAuthentication(OrderDetailsModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const CertificationProcessPage();
        },
      ),
    ).then(
      (value) {
        if (value != null) {
          var certifyId = value["certifyId"];
          var result = value["result"];
          if (result) {
            LoginManager.authCheck(
              {"certifyId": certifyId},
              (message) {
                MineHomeManager.userUpdateUserInfo((message) {
                  verifiedStatus = true;
                  _initData();
                  ToastUtils.showMessage("认证成功");
                });
              },
            );
          }
        }
      },
    );
  }

  @override
  inputPhoneNumber(OrderDetailsModel model) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => PaySuccessInputPhonePage(
                  orderNo: model.id.toString(),
                )),
        (route) => route == null);
  }
}

class OrderListItemView extends StatefulWidget {
  OrderDetailsModel detailsModel;
  OrderListItemViewClickListener? listener;
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
  OrderListItemViewClickListener? _listener;
  double start = 0;
  bool isOpen = false;
  double maxMove = 62;
  bool isTapDelete = false;
  OrderDetailsModel? detailsModel;
  late final AnimationController controller = AnimationController(
      lowerBound: 0,
      upperBound: maxMove,
      duration: const Duration(milliseconds: 300),
      vsync: this)
    ..addListener(() {
      start = controller.value;
      setState(() {});
    });

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
        child: GestureDetector(
          child: Stack(
            children: [
              Positioned(
                right: 0,
                child: deleteOperationView(),
              ),

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
          onHorizontalDragDown: (DragDownDetails details) {
            _close();
            return widget.onStart();
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              start -= details.delta.dx;
              if (start <= 0) {
                start = 0;
              }
              if (start >= maxMove) {
                start = maxMove;
              }
            });
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            controller.value = start;
            if (start == maxMove) {
              isOpen = true;
            } else if (start > maxMove / 2) {
              controller.animateTo(maxMove);
              isOpen = true;
            } else if (start < maxMove / 2) {
              _close();
            }
          },
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
    String status = "";
    var reportType = widget.detailsModel?.reportType ?? 1;
    switch (widget.detailsModel?.status) {
      case 0:
        status = "待付款";
        break;
      case 4:
        status = "已完成";
        break;
      case 5:
        status = "退款";
        break;
    }

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
      case 5:
      case 8:
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
                  color: CustomColors.warningColor,
                  fontSize: 15,
                ),
              ),
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
    double amount = widget.detailsModel?.amount ?? 0.0;
    String price = StringTools.numberFormat(amount.toString(), true);

    String status = "支付金额";
    if (widget.detailsModel?.status == 5) {
      status = "退款金额";
    }

    Widget buttonView = const SizedBox(
      height: 1,
      width: 1,
    );

    int type = widget.detailsModel?.type ?? 0;
    if (widget.detailsModel?.status == 4) {
      //已完成
      if (widget.detailsModel.phone.isEmpty) {
        String buttonTitle = "填写授权号码";

        buttonView = WidgetTools().createCustomInkWellButton(buttonTitle, () {
          _listener?.inputPhoneNumber(widget.detailsModel!);
        },
            bgColor: CustomColors.connectColor,
            textColor: Colors.white,
            radius: 15,
            fontSize: 15,
            height: 30,
            shadow: const BoxShadow(),
            buttonWidth: 110);
      } else {
        if (widget.detailsModel?.isOpenInvoice() ?? false) {
          switch (widget.detailsModel?.invoiceStatus) {
            case 0:
              {
                String buttonTitle = "开发票";

                buttonView = WidgetTools()
                    .createCustomInkWellButton(buttonTitle, () {
                  _listener?.operationInvoice(widget.detailsModel!);
                },
                        bgColor: CustomColors.connectColor,
                        textColor: Colors.white,
                        radius: 15,
                        fontSize: 15,
                        height: 30,
                        shadow: const BoxShadow(),
                        buttonWidth: 82);
              }
              break;
            case 1:
              {
                String buttonTitle = "开票中";

                buttonView = WidgetTools().createCustomInkWellButton(
                    buttonTitle, () {},
                    bgColor: CustomColors.lightGrey,
                    textColor: Colors.white,
                    radius: 15,
                    fontSize: 15,
                    height: 30,
                    shadow: const BoxShadow(),
                    buttonWidth: 82);
              }
              break;
            case 2:
              {
                String buttonTitle = "查看发票";

                buttonView = WidgetTools()
                    .createCustomInkWellButton(buttonTitle, () {
                  _listener?.operationInvoice(widget.detailsModel!);
                },
                        bgColor: CustomColors.connectColor,
                        textColor: Colors.white,
                        radius: 15,
                        fontSize: 15,
                        height: 30,
                        shadow: const BoxShadow(),
                        buttonWidth: 82);
              }
              break;
            default:
          }
        }
      }
    }
    if (type == 12 || type == 8) {
      if (!widget.verifiedStatus) {
        String buttonTitle = "去认证";

        buttonView = WidgetTools().createCustomInkWellButton(buttonTitle, () {
          _listener?.realNameAuthentication(widget.detailsModel!);
        },
            bgColor: CustomColors.connectColor,
            textColor: Colors.white,
            radius: 15,
            fontSize: 15,
            height: 30,
            shadow: const BoxShadow(),
            buttonWidth: 82);
      }
    }

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

  /// *
  /// -  @description: 删除面板
  /// -  @Date: 2022-08-31 10:25
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget deleteOperationView() {
    SizedBox icon = SizedBox(
      width: 30,
      height: 30,
      child: SvgPicture.asset(
        "assets/images/svg/deleteButton.svg",
        fit: BoxFit.fill,
      ),
    );

    // Color bgColor =
    //     isTapDelete == true ? CustomColors.warningColor : Colors.transparent;

    // Color textColor =
    //     isTapDelete == true ? Colors.white : CustomColors.greyBlack;

    Color bgColor = Colors.transparent;

    Color textColor = CustomColors.greyBlack;
    return GestureDetector(
      onTap: () {
        setState(() {
          // isTapDelete = !isTapDelete;
          _listener?.deleteOrderListItem(widget.detailsModel!);
        });
      },
      child: Container(
        height: 170,
        alignment: Alignment.center,
        color: bgColor,
        width: maxMove,
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            icon,
            Text(
              "删除",
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  void _close() {
    controller.animateTo(0);
    isOpen = false;
  }
}

abstract class OrderListItemViewClickListener {
  ///点击list item
  tapOrderListItem(OrderDetailsModel model);

  ///删除List Item
  deleteOrderListItem(OrderDetailsModel model);

  ///发票操作
  operationInvoice(OrderDetailsModel model);

  ///填写授权手机号码操作
  inputPhoneNumber(OrderDetailsModel model);

  ///发票操作
  realNameAuthentication(OrderDetailsModel model);
}
