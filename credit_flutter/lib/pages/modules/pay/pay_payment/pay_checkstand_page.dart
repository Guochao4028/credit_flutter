/// *
/// -  @Date: 2022-07-12 10:55
/// -  @LastEditTime: 2022-07-12 10:55
/// -  @Description: 收银台
///
import 'dart:convert';

import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/manager/vip_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/certification_process_page.dart';
import 'package:credit_flutter/pages/modules/login/forgot_password_page.dart';
import 'package:credit_flutter/pages/modules/mine/vip/vip_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_password/pay_setup_password_view.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/view/pay_checkstand_view.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/view/pay_password_view.dart';
import 'package:credit_flutter/pages/modules/pay/pay_status/pay_success_input_phone_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_status/pay_success_page.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/notification.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/common_utils.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class PayCheakstandPage extends StatefulWidget {
  PaymentListDisplayType displayType;
  PaymentFromType fromType;

  ///价格
  final String price;

  ///主要放 身份证 姓名 手机号
  Map<String, dynamic> packet = {};

  ///套餐id
  String productId = "";

  ///报告类型
  int? reportType;

  ///授权id
  String reportAuthId = "";

  ///价格
  final String yearPrice;

  PayCheakstandPage(
      {required this.fromType,
      required this.displayType,
      required this.price,
      this.reportType,
      this.reportAuthId = "",
      this.yearPrice = "0",
      Key? key})
      : super(key: key);

  @override
  State<PayCheakstandPage> createState() => _PayCheakstandPageState();
}

class _PayCheakstandPageState extends State<PayCheakstandPage>
    implements
        PayCheakstandViewClickListener,
        InputPasswordClickListener,
        ClickListener {
  PayCheakstandView? cheakstandView;

  HYCPayType payType = HYCPayType.none;

  ReportBuyType buyType = ReportBuyType.none;

  PaymentListDisplayType? displayType;

  ///支付密码是否锁定 默认不锁
  bool payPasswordLock = false;

  ///是否设置过支付密码
  bool ifSet = true;

  ///报告价格
  String reportPrice = "";

  ///慧眼币余额
  String balance = "0";

  ///是否是vip
  bool isVip = false;

  ///是否显示vip
  bool isViewVip = false;

  ///是否显示充值按钮
  bool isRechange = true;

  ///报告原价
  String reportOriginalPrice = "";

  UserModel? _userModel;

  List<Map<String, dynamic>> paymentMethods = [];

  /// 购买报告类型
  List<Map<String, dynamic>> reportBuyTypes = [];

  static const _channel = MethodChannel(FinalKeys.NATIVE_CHANNEL_PAY);

  ///登录类型
  String? loginType;

  ///是否支付成功
  bool _isPaySuccessful = true;

  String price = "";

  ///报告订阅价格
  String yearPice = "";

  /// 只有购买个人报告
  String orderId = "";

  /// 停留时间
  DateTime? startTime;

  @override
  void initState() {
    super.initState();

    ///获取报告价格

    reportPrice = widget.price;
    yearPice = widget.yearPrice;

    ///报告原价
    if (widget.reportType != null) {
      reportOriginalPrice = widget.reportType == 2 ? "198" : "999";
    }

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 取出数据
    _prefs.then((sp) {
      ///获取用户登录状态
      ///1，企业。2，用户
      loginType = sp.getString(FinalKeys.LOGIN_TYPE);
      _initReprtBuyTypeData(price: reportPrice);

      _refreshData();
    });

    ///更新个人信息
    MineHomeManager.userGetUserInfo((message) => {_refreshData()});

    ///微信支付通道，用于处理微信支付结果
    _channel.setMethodCallHandler((call) async {
      setState(() {
        // _nativeData = call.arguments['count'];

        _backWxPay(call.arguments);
      });
    });
    startTime = DateTime.now();
    UmengCommonSdk.onPageStart("pay_checkstand_page");
    UmengCommonSdk.onEvent(
        "PayCheckstand", {"state": "start", "time": "${DateTime.now()}"});
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("pay_checkstand_page");
    UmengCommonSdk.onEvent("PayCheckstand", {
      "state": "end",
      "time": "${DateTime.now()}",
      "continueTime": "${startTime} - ${DateTime.now()}",
    });

    String loginType = "";
    if (Golbal.loginType == "1") {
      loginType = "企业雇主";
    } else if (Golbal.loginType == "2") {
      loginType = "个人自查";
    } else if (Golbal.loginType == "3") {
      loginType = "个人雇主";
    }
    UmengCommonSdk.onEvent("pay_checkstand_page_stay", {
      "data":
          "time:${differenceTime(startTime!, DateTime.now())}、identity:$loginType"
    });
  }

  @override
  void didUpdateWidget(covariant PayCheakstandPage oldWidget) {
    Golbal.checkWechatPayInfo((success, orderNumber) {
      if (success) {
        Navigator.of(context).pushNamed('/payResults', arguments: {
          'out_trade_no': orderNumber,
        });
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "支付",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: CustomColors.colorEDF6F6,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.infinity,
          child: cheakstandView?.cheakstabContentView(isVip,
              reportOriginalPrice, isViewVip, isRechange, widget.fromType),
        ),
      ),
    );
  }

  @override
  tapListItem(int index) {
    Map temp = paymentMethods[index];
    payType = temp["payType"];
    setState(() {
      for (Map<String, dynamic> item in paymentMethods) {
        item["isSelected"] = "0";
      }
      Map a = temp;
      a["isSelected"] = "1";
    });
  }

  @override
  tapOpenVip() {
    print("tapOpenVip");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VipPageWidget(),
      ),
    );
  }

  ///支付
  @override
  tapPay() {
    if (CommonUtils.checkClick()) {
      Map<String, dynamic> map = Map.from(widget.packet);

      int orderNumber = map["orderNumber"] ?? 0;

      /// 如果数据包里有订单号，那么直接支付，没有订单号 生成订单
      if (orderNumber == 0) {
        /// 生成订单
        _patternToPay();
      } else {
        /// 直接支付

        String str = orderNumber.toString();

        /// 因为现在只有个人雇主有的待支付
        orderId = str;

        var box = Hive.box(HiveBoxs.dataBox);
        bool firstOpen = box.get(FinalKeys.FIRST_OPEN_REPORT_SAMPLE) ?? false;
        if (firstOpen == false) {
          /// 用户未查看报告样例购买报告数量
          UmengCommonSdk.onEvent(
              "NoSeeReportSamplePurchase", {"type": "count"});
        } else {
          /// 用户查看报告样例后购买报告数量
          UmengCommonSdk.onEvent("SeeReportSamplePurchase", {"type": "count"});
        }

        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, false);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          case HYCPayType.payBalance:
            _balancePay(str);
            break;
          default:
        }
      }
    }
  }

  /// *
  /// -  @description: 根据调用方，配置不同订单号
  /// -  @Date: 2023-10-26 14:59
  ///
  void _patternToPay() {
    var box = Hive.box(HiveBoxs.dataBox);
    bool firstOpen = box.get(FinalKeys.FIRST_OPEN_REPORT_SAMPLE) ?? false;
    if (firstOpen == false) {
      /// 用户未查看报告样例购买报告数量
      UmengCommonSdk.onEvent("NoSeeReportSamplePurchase", {"type": "count"});
    } else {
      /// 用户查看报告样例后购买报告数量
      UmengCommonSdk.onEvent("SeeReportSamplePurchase", {"type": "count"});
    }

    if (widget.fromType == PaymentFromType.paymentFromSeachType) {
      ///公司购买个人报告
      _createCompanyOrder();
    } else if (widget.fromType == PaymentFromType.paymentFromRechargeType) {
      ///
      _createCompanyBuyCoinOrder();
    } else if (widget.fromType == PaymentFromType.paymentFromReportListType) {
      ///公司买个人报告,去购买
      _createCompanyGoBuyOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFromReportDetailsType) {
      ///公司购买个人报告升级
      _createCompanyReportUpGrade();
    } else if (widget.fromType == PaymentFromType.paymentFromReportVIPType) {
      ///会员充值
      _creatVipBuyOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFromReportUpgradeType) {
      ///会员升级
      _creatVipUpgradeOrder();
    } else if (widget.fromType == PaymentFromType.paymentFromPersonType) {
      ///购买个人报告
      _creatPersonBuyReportOrder();
    } else if (widget.fromType == PaymentFromType.paymentFromQuickBuyType) {
      ///购买前置
      _creatPersonBuyPersonReportOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFromQuickBuyPersonType) {
      ///购买前置
      _creatPersonBuyReportOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFromCheckYourselfForFiveYuan) {
      ///个人自查5五元报告
      _creatPersonBuyReportOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFrom5yuanReportUpgradeType) {
      ///个人自查5五元报告
      _creatPersonBuyReportOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFromPersonRechargeType) {
      ///个人充值慧眼币
      _createPersonBuyCoinOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFromPersonReportUpgradeType) {
      ///个人充值慧眼币
      _creatPersonBuyReportOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFromPersonBuyPersonReport) {
      _creatPersonBuyPersonReportOrder();
    } else if (widget.fromType ==
        PaymentFromType.paymentFromPersonalPaymentForCompanyPurchase) {
      //公司买个人报告,个人付款
      _personalPaymentForCompanyPurchaseOrder();
    }
  }

  ///充值
  @override
  tapRecharge() {
    Navigator.pushNamed(context, "/assetManagement").then((value) {
      MineHomeManager.userGetUserInfo((message) => _refreshData());
    });
  }

  /// *
  /// -  @description: 刷新用户数据
  /// -  @Date: 2022-07-20 10:30
  /// -  @parm:
  /// -  @return {*}
  ///
  void _refreshData() {
    Log.i("_refreshData");

    if (buyType == ReportBuyType.none || buyType == ReportBuyType.once) {
      price = reportPrice;
    } else if (buyType == ReportBuyType.year) {
      price = yearPice;
    }

//data
    UserModel.getInfo((model) {
      ifSet = model?.userInfo.getIfSet() ?? false;
      _userModel = model;

      if (widget.fromType == PaymentFromType.paymentFromPersonType ||
          widget.fromType ==
              PaymentFromType.paymentFromPersonReportUpgradeType ||
          loginType == "2" ||
          loginType == "3") {
        balance = model?.userInfo.balance.toString() ?? "0";
        isVip = false;
        isViewVip = false;
      } else {
        balance = model?.userInfo.companyInfo.balance.toString() ?? "0";
        int vipType = model?.userInfo.companyInfo.vipType ?? 0;
        isRechange = model?.userInfo.owner == 1 ? true : false;

        isVip = vipType == 0 ? false : true;
        isViewVip = true;
      }

      payPasswordLock = model?.userInfo.getPayPasswordLock() ?? false;

      if (mounted) {
        setState(() {
          //view
          displayType = widget.displayType;
          _initListData();

          bool isViewBuyType = false;
          if (widget.fromType == PaymentFromType.paymentFromSeachType ||
              widget.fromType == PaymentFromType.paymentFromReportListType ||
              widget.fromType == PaymentFromType.paymentFromReportDetailsType) {
            isViewBuyType = true;
          }

          cheakstandView = PayCheakstandView(
            price: price,
            paymentMethods: paymentMethods,
            balanceStr: balance,
            reportBuyTypes: reportBuyTypes,
            isViewBuyType: isViewBuyType,
          );
          cheakstandView?.clickListener = this;
        });
      }
    });
  }

  /// *
  /// -  @description: 初始化购买报告类型数据
  /// -  @Date: 2023-02-23 19:30
  /// -  @parm:
  /// -  @return {*}
  ///
  _initReprtBuyTypeData({String price = ""}) {
    reportBuyTypes.clear();
    Map<String, dynamic> onceMap = {
      "titleStr": "单次报告",
      "description": "一次报告购买",
      "originalPrice": reportOriginalPrice,
      "price": price,
      "left": 22.0,
      "right": 22.0,
      "buyType": ReportBuyType.once,
      "isSelected": "1",
      "problem": "0",
    };

    Map<String, dynamic> yearMap = {
      "titleStr": "年付报告",
      "description": "12个月每月定期发送报告",
      "originalPrice": "2376",
      "price": yearPice,
      "left": 16.0,
      "right": 16.0,
      "buyType": ReportBuyType.year,
      "isSelected": "0",
      "problem": "1",
    };
    reportBuyTypes.add(onceMap);
    reportBuyTypes.add(yearMap);
  }

  /// *
  /// -  @description: 初始化列表数据
  /// -  @Date: 2022-07-15 10:50
  /// -  @parm:
  /// -  @return {*}
  ///
  void _initListData() {
    paymentMethods.clear();
    Map<String, dynamic> aliMap = {
      "normal": "assets/images/radioNormal.png",
      "selected": "assets/images/radioSelectBlue.png",
      "icon": "assets/images/svg/alipay.svg",
      "name": "支付宝支付",
      "isSelected": "0",
      "payType": HYCPayType.payAli,
    };
    Map<String, dynamic> wechatMap = {
      "normal": "assets/images/radioNormal.png",
      "selected": "assets/images/radioSelectBlue.png",
      "icon": "assets/images/svg/vwpay.svg",
      "name": "微信支付",
      "isSelected": "1",
      "payType": HYCPayType.payWechat,
    };

    Map<String, dynamic> balanceMap = {
      "normal": "assets/images/radioNormal.png",
      "selected": "assets/images/radioSelectBlue.png",
      "icon": "assets/images/svg/hui.svg",
      "name": "慧眼币",
      "isSelected": "0",
      "payType": HYCPayType.payBalance,
    };

    switch (displayType) {
      case PaymentListDisplayType.paymentListOnlyOtherDisplay:
        paymentMethods.add(wechatMap);
        paymentMethods.add(aliMap);

        break;
      case PaymentListDisplayType.paymentListOnlyBalanceDisplay:
        paymentMethods.add(balanceMap);
        break;
      default:
        paymentMethods.add(wechatMap);
        paymentMethods.add(aliMap);
        paymentMethods.add(balanceMap);
    }
    for (Map<String, dynamic> item in paymentMethods) {
      if (item["isSelected"] == "1") {
        payType = item["payType"];
      }
    }
  }

  _creatVipUpgradeOrder() {
    /// 1,生成订单号
    VIPManager.orderCompanyVipUpGrade((str) {
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, false);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          case HYCPayType.payBalance:
            _balancePay(str);
            break;
          default:
        }
      }
    });
  }

  _creatPersonBuyReportOrder() {
    /// 1,生成订单号
    PayManager.personBuyReport({"reportType": widget.reportType}, (str) {
      orderId = str;
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, false);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          case HYCPayType.payBalance:
            _balancePay(str);
            break;
          default:
        }
      }
    });
  }

  _creatPersonBuyPersonReportOrder() {
    Map<String, dynamic> map = Map.from(widget.packet);

    if (buyType == ReportBuyType.none || buyType == ReportBuyType.once) {
      map["reportType"] = widget.reportType;
    } else if (buyType == ReportBuyType.year) {
      map["reportType"] = 4;
    }

    /// 1,生成订单号
    PayManager.createPersonBuyPersonReport(map, (str) {
      orderId = str;

      /// 2,支付逻辑
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, false);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          case HYCPayType.payBalance:
            _balancePay(str);
            break;
          default:
        }
      }
    });
  }

  _creatVipBuyOrder() {
    int type = widget.packet["type"];

    switch (type) {
      case 0:

        ///人数
        /// 1,生成订单号
        Map<String, dynamic> map = Map.from(widget.packet);
        PayManager.createCompanyBuyPeopleOrder(map, (str) {
          /// 2,支付逻辑
          if (str.isNotEmpty) {
            switch (payType) {
              case HYCPayType.payAli:
                _aliPay(str, false);
                break;
              case HYCPayType.payWechat:
                _wechatPay(str);
                break;
              case HYCPayType.payBalance:
                _balancePay(str);
                break;
              default:
            }
          }
          return str;
        });

        break;
      case 1:

        ///会员

        ////// 1,生成订单号
        Map<String, dynamic> map = Map.from(widget.packet);
        PayManager.createCompanyBuyVipOrder(map, (str) {
          /// 2,支付逻辑
          if (str.isNotEmpty) {
            switch (payType) {
              case HYCPayType.payAli:
                _aliPay(str, false);
                break;
              case HYCPayType.payWechat:
                _wechatPay(str);
                break;
              case HYCPayType.payBalance:
                _balancePay(str);
                break;
              default:
            }
          }
          return str;
        });

        break;
      case 2:

        ///svip
        /// 1,生成订单号
        Map<String, dynamic> map = Map.from(widget.packet);
        PayManager.createCompanyBuySVipOrder(map, (str) {
          /// 2,支付逻辑
          if (str.isNotEmpty) {
            switch (payType) {
              case HYCPayType.payAli:
                _aliPay(str, false);
                break;
              case HYCPayType.payWechat:
                _wechatPay(str);
                break;
              case HYCPayType.payBalance:
                _balancePay(str);
                break;
              default:
            }
          }
          return str;
        });
        break;
      default:
    }
  }

  /// *
  /// -  @description: 支付宝支付
  /// -  @Date: 2022-07-15 10:51
  /// -  @parm:
  /// -  @return {*}
  ///
  void _aliPay(String orderNumber, bool isBuyCoin) {
    /// 判断平台
    if (PlatformUtils.isWeb) {
      String returnUrl = "";
      if (isBuyCoin == true) {
        returnUrl = FinalKeys.alipayReturnBuycoin();
      } else {
        returnUrl = FinalKeys.alipayReturn();
      }

      ///h5
      PayManager.payAlipayH5({"orderId": orderNumber, "returnUrl": returnUrl},
          (str) {
        if (str.isNotEmpty) {
          // Future<SharedPreferences> prefs = SharedPreferences.getInstance();

          // prefs.then((value) {
          // value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);

          // value.setString(
          //   FinalKeys.SHARED_PREFERENCES_ORDER_ID,
          //   StringTools.map2Json({
          //     "orderId": orderNumber,
          //   }),
          // );
          _callAlipay(str);

          //   Navigator.pushNamed(
          //     context,
          //     '/payResults',
          //     arguments: {
          //       'out_trade_no': orderNumber,
          //       "payInfo": str,
          //       "payment": "ali"
          //     },
          //   );
          // });

          // Navigator.of(context).pushNamed('/payResults', arguments: {
          //   'out_trade_no': orderNumber,
          //   "payInfo": str,
          //   "payment": "ali"
          // });
        }
      });
    } else {
      ///移动
      ///请求 支付宝app支付
      PayManager.payAlipay({"orderId": orderNumber}, (str) {
        if (str.isNotEmpty) {
          _callAlipay(str);
        }
      });
    }
  }

  /// *
  /// -  @description: 通知各端处理支付宝支付逻辑
  /// -  @Date: 2022-07-18 10:14
  /// -  @parm:
  /// -  @return {*}
  ///
  void _callAlipay(String payInfo) async {
    if (PlatformUtils.isWeb) {
      NativeJSUtlis.aliPayH5(payInfo);
    } else {
      // _popView();
      // return;
      NativeUtils.toolsMethodChannelMethodWithParams("AliPay",
          params: {"context": payInfo}).then((value) {
        String resultStatus = value["resultStatus"];
        if (resultStatus == "9000") {
          ToastUtils.showMessage("支付成功");
          if (Golbal.token.isEmpty) {
            _popView();
          } else {
            MineHomeManager.userGetUserInfo((message) => {_popView()});
          }
        } else if (resultStatus == "8000") {
          ToastUtils.showMessage("正在处理中");
        } else if (resultStatus == "4000") {
          ToastUtils.showMessage("订单支付失败");
          NotificationCener.instance
              .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
        } else if (resultStatus == "6001") {
          ToastUtils.showMessage("您已取消支付");
        } else if (resultStatus == "6002") {
          ToastUtils.showMessage("网络连接出错");
        } else {
          ToastUtils.showMessage("支付失败");
          NotificationCener.instance
              .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
        }
      });
    }
  }

  /// *
  /// -  @description: 微信支付
  /// -  @Date: 2022-07-26 18:23
  /// -  @parm:
  /// -  @return {*}
  ///
  void _wechatPay(String orderNumber) {
    /// 判断平台
    if (PlatformUtils.isWeb) {
      ///判断是否是微信小程序
      if (Golbal.isWX == true) {
        ///小程序
        PayManager.payWechatProgramPay({"orderId": orderNumber}, (str) {
          if (str.isNotEmpty) {
            // if (str.isNotEmpty) {
            // Future<SharedPreferences> prefs = SharedPreferences.getInstance();

            // prefs.then((value) {
            //   value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
            //   value.remove(FinalKeys.IS_WECHAT_PAY_INFO);

            //   value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
            //   value.setString(
            //     FinalKeys.SHARED_PREFERENCES_ORDER_ID,
            //     StringTools.map2Json({
            //       "orderId": orderNumber,
            //     }),
            //   );

            _callWechatPay(orderNumber);

            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       return PopupWindowDialog(
            //         title: "提示",
            //         confirm: "支付成功",
            //         cancel: "取消",
            //         content: "是否支付成功",
            //         showCancel: true,
            //         clickListener: this,
            //         identity: "989",
            //       );
            //     });
            // });
            // }
          }
        });
      } else {
        ///h5
        PayManager.payWechatH5Pay({"orderId": orderNumber}, (str) {
          if (str.isNotEmpty) {
            if (str.isNotEmpty) {
              Future<SharedPreferences> prefs = SharedPreferences.getInstance();

              prefs.then((value) {
                value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
                value.remove(FinalKeys.IS_WECHAT_PAY_INFO);

                value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
                value.setString(
                  FinalKeys.SHARED_PREFERENCES_ORDER_ID,
                  StringTools.map2Json({
                    "orderId": orderNumber,
                  }),
                );

                _callWechatPay(str);

                showDialog(
                    context: context,
                    builder: (context) {
                      return PopupWindowDialog(
                        title: "提示",
                        confirm: "支付成功",
                        cancel: "取消",
                        content: "是否支付成功",
                        showCancel: true,
                        clickListener: this,
                        identity: "989",
                      );
                    });
              });
            }

            // Future<SharedPreferences> prefs = SharedPreferences.getInstance();

            // prefs.then((value) {
            //   value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
            //   value.setString(
            //       FinalKeys.SHARED_PREFERENCES_ORDER_ID,
            //       StringTools.map2Json({
            //         "orderId": orderNumber,
            //         "isFirst": "1",
            //       }));
            //   Navigator.of(context).pushNamed('/payResults', arguments: {
            //     'out_trade_no': orderNumber,
            //     "payInfo": str,
            //     "payment": "wechat"
            //   });
            // });

            // Navigator.of(context).pushNamed('/payResults', arguments: {
            //   'out_trade_no': orderNumber,
            //   "payInfo": str,
            //   "payment": "wechat"
            // });
          }
        });
      }

// postPayWechatH5
    } else {
      ///移动
      ///请求 微信支付
      PayManager.payWechatPay({"orderId": orderNumber}, (str) {
        if (str.isNotEmpty) {
          _callWechatPay(str);
        }
      });
    }
  }

  /// *
  /// -  @description: 通知各端处理微信支付逻辑
  /// -  @Date: 2022-07-26 18:24
  /// -  @parm:
  /// -  @return {*}
  ///
  void _callWechatPay(String payInfo) async {
    if (PlatformUtils.isWeb) {
      if (Golbal.isWX == true) {
        NativeJSUtlis.wxMiniPayHandle(payInfo);
      } else {
        NativeJSUtlis.wxpay(payInfo);
      }
    } else {
      _toWxPay(payInfo);
    }
  }

  /// *
  /// -  @description: 余额支付
  /// -  @Date: 2022-07-20 10:31
  /// -  @parm: orderNumber 订单号
  /// -  @return {*}
  ///
  void _balancePay(String orderNumber) {
    /// 1.判断余额是否可以购买
    double balanceInt = double.parse(balance);
    double reportPriceInt = double.parse(reportPrice);
    if (balanceInt - reportPriceInt >= 0) {
      ///2.去支付
      _balanceGotoPay(orderNumber);
    } else {
      ///1，判断账号是否是主账号
      ///主账号
      int owner = _userModel?.userInfo.owner ?? 1;
      if (owner == 1) {
        ///去充值
        showDialog(
            context: context,
            builder: (context) {
              return PopupWindowDialog(
                title: "提示",
                confirm: "去充值",
                cancel: "取消",
                content: "您的余额不足，请前往充值",
                showCancel: true,
                clickListener: this,
                identity: "1",
              );
            });
      } else {
        ToastUtils.showMessage("您的余额不足，请通知主账号进行充值");
      }
    }
  }

  /// *
  /// -  @description: 有余额时处理支付逻辑
  /// -  @Date: 2022-07-29 10:31
  /// -  @parm:
  /// -  @return {*}
  ///
  void _balanceGotoPay(String orederNumber) {
    ///1， 判断是否设置过支付密码
    if (ifSet == false) {
      /// 2,判断密码错误次数
      String prompt = "请输入六位数支付密码";
      bool isInput = true;

      if (payPasswordLock == true) {
        prompt = "三次错误自动锁定，请重新设置";
        isInput = false;
      }
      String itemPrice = "";

      if (buyType == ReportBuyType.none || buyType == ReportBuyType.once) {
        itemPrice = reportPrice;
      } else if (buyType == ReportBuyType.year) {
        itemPrice = yearPice;
      }

      ///弹出密码输入框
      showDialog(
          context: context,
          builder: (context) {
            return PayInputPasswordWindowDialog(
              clickListener: this,
              isInput: isInput,
              content: itemPrice,
              orderNumber: orederNumber,
              prompt: prompt,
            );
          });
    } else {
      ///去设置支付密码
      showDialog(
          context: context,
          builder: (context) {
            return PopupWindowDialog(
              title: "提示",
              confirm: "去设置",
              cancel: "取消",
              content: "您还没有支付密码，请前往设置",
              showCancel: true,
              clickListener: this,
              identity: "0",
            );
          });
    }
  }

  /// *
  /// -  @description: 企业购买个人报告 生成订单
  /// -  @Date: 2022-07-15 11:28
  /// -  @parm:
  /// -  @return 订单id
  ///
  String _createCompanyOrder() {
    Map<String, dynamic> map = Map.from(widget.packet);

    if (buyType == ReportBuyType.none || buyType == ReportBuyType.once) {
      map["reportType"] = widget.reportType;
    } else if (buyType == ReportBuyType.year) {
      map["reportType"] = 4;
    }

    /// 1,生成订单号
    PayManager.createCompanyOrder(map, (str) {
      /// 2,支付逻辑
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, false);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          case HYCPayType.payBalance:
            _balancePay(str);
            break;
          default:
        }
      }
      return str;
    });
    return "";
    //
  }

  /// *
  /// -  @description: 公司买个人报告,去购买
  /// -  @Date: 2022-07-27 15:48
  /// -  @parm:
  /// -  @return {*}
  ///
  String _createCompanyGoBuyOrder() {
    Map<String, dynamic> map = {
      "reportType": widget.reportType,
      "id": widget.reportAuthId
    };

    /// 1,生成订单号
    PayManager.createOrderCompanyGotoBuyReport(map, (str) {
      /// 2,支付逻辑
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, false);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          case HYCPayType.payBalance:
            _balancePay(str);
            break;
          default:
        }
      }
      return str;
    });
    return "";
    //
  }

  String _createCompanyReportUpGrade() {
    Map<String, dynamic> map = {
      "reportType": widget.reportType,
      "reportAuthId": widget.reportAuthId
    };

    /// 1,生成订单号
    PayManager.createOrderCompanyReportUpGrade(map, (str) {
      /// 2,支付逻辑
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, false);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          case HYCPayType.payBalance:
            _balancePay(str);
            break;
          default:
        }
      }
      return str;
    });
    return "";
    //
  }

  /// *
  /// -  @description: 企业充值慧眼币 生成订单
  /// -  @Date: 2022-07-15 11:28
  /// -  @parm:
  /// -  @return 订单id
  ///
  String _createCompanyBuyCoinOrder() {
    /// 1,生成订单号
    PayManager.createCompanyBuyCoinOrder({"productId": widget.productId},
        (str) {
      /// 2,支付逻辑
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, true);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          default:
        }
      }
      return str;
    });
    return "";
    //
  }

  /// *
  /// -  @description: 个人充值慧眼币 生成订单
  /// -  @Date: 2022-09-27 14:30
  /// -  @parm:
  /// -  @return {*}
  ///
  String _createPersonBuyCoinOrder() {
    /// 1,生成订单号
    PayManager.createPersonBuyCoinOrder({"productId": widget.productId}, (str) {
      /// 2,支付逻辑
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, true);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          default:
        }
      }
      return str;
    });
    return "";
    //
  }

  /// *
  /// -  @description: 忘记支付密码
  /// -  @Date: 2022-07-20 10:32
  /// -  @parm:
  /// -  @return {*}
  ///
  @override
  void forgotPassword() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ForgotPasswordPage(
        type: PageType.payPassword,
      ),
    ));
  }

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    String identity = confirmMap["identity"];
    if (identity == "0") {
      ///设置支付密码
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) => const PaySetupPasswordPage(),
      ))
          .then((_) {
        MineHomeManager.userGetUserInfo((message) => {_refreshData()});
      });
    } else if (identity == "989") {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();

      prefs.then((value) {
        // value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
        String json =
            value.getString(FinalKeys.SHARED_PREFERENCES_ORDER_ID) ?? "";
        Map map = StringTools.json2Map(json);

        OrderManager.orderInfo({"orderId": map["orderId"]}, (map) {
          value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);

          if (map["status"] == 4) {
            _isPaySuccessful = true;
          } else {
            _isPaySuccessful = false;
          }

          // ToastUtils.showMessage("setState");
          MineHomeManager.userGetUserInfo((message) => _popView());
        });
      });
    } else {
      Navigator.pushNamed(context, "/assetManagement").then((value) {
        MineHomeManager.userGetUserInfo((message) => _refreshData());
      });
    }
  }

  @override
  void onCancel() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
      MineHomeManager.userGetUserInfo((message) => _refreshData());
    });
  }

  @override
  void closeInput() {
    // MineHomeManager.userGetUserInfo((message) => {_refreshData()});
  }

  ///输入支付密码结束
  @override
  void finishInputPassword(
      String password, String orderNumber, CheckAccountCallBack callBack) {
    String newPassword = password + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5Password = StringTools.generateMD5(newPassword);

    PayManager.payBalance({"orderId": orderNumber, "payPassword": md5Password},
        (model) {
      if (model.isSuccess == false) {
        MineHomeManager.userGetUserInfo((message) => {
              UserModel.getInfo((model) {
                callBack(false, model);
              })
            });
      } else {
        //收键盘
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }

        //支付成功
        payPasswordLock = false;
        if (Golbal.token.isEmpty) {
          _popView();
        } else {
          MineHomeManager.userGetUserInfo((message) => {_popView()});
        }
      }
    });
  }

  /// *
  /// -  @description: 支付成功 页面返回
  /// -  @Date: 2022-07-27 16:17
  /// -  @parm:
  /// -  @return {*}
  ///
  void _popView() {
    switch (widget.fromType) {
      case PaymentFromType.paymentFromSeachType:
        Golbal.currentIndex = 2;

        ///首页
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => RootPage(
                      pageNumber: 1,
                      isCertigier: true,
                    )),
            (route) => route == null);

        break;
      case PaymentFromType.paymentFromReportDetailsType:
      case PaymentFromType.paymentFromReportListType:
        Golbal.currentIndex = 1;

        ///首页
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => RootPage(
                      pageNumber: 1,
                    )),
            (route) => route == null);

        break;
      case PaymentFromType.paymentFromRechargeType:
      case PaymentFromType.paymentFromPersonRechargeType:
        Navigator.of(context)
          ..pop()
          ..pop()
          ..pushNamed("/assetManagement");
        break;
      case PaymentFromType.paymentFromReportVIPType:

        ///首页
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => RootPage(
                      pageNumber: 2,
                    )),
            (route) => route == null);
        break;
      case PaymentFromType.paymentFromReportUpgradeType:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => RootPage(
                pageNumber: 2,
              ),
            ),
            (route) => route == null);

        break;

      case PaymentFromType.paymentFromPersonType:
      case PaymentFromType.paymentFromCheckYourselfForFiveYuan:
      case PaymentFromType.paymentFrom5yuanReportUpgradeType:
        if (_isPaySuccessful == true) {
          ToastUtils.showMessage("购买成功");
        } else {
          ToastUtils.showMessage("购买失败，请重新购买");
          NotificationCener.instance
              .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
        }
        UserModel.getInfo((model) {
          if (model != null) {
            if (model.userInfo.getUserVerifiedStatus()) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => RootPage(
                      pageNumber: 0,
                    ),
                  ),
                  (route) => route == null);
            } else {
              _realNameAuthentication();
            }
          }
        });

        break;
      case PaymentFromType.paymentFromPersonBuyPersonReport:
        if (_isPaySuccessful == true) {
          ToastUtils.showMessage("购买成功");
        } else {
          ToastUtils.showMessage("购买失败，请重新购买");
          NotificationCener.instance
              .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
        }
        // UserModel.getInfo((model) {
        //   if (model != null) {
        //     if (model.userInfo.getUserVerifiedStatus()) {
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(
        //             builder: (context) => RootPage(
        //               pageNumber: 0,
        //             ),
        //           ),
        //           (route) => route == null);
        //     } else {
        //       _realNameAuthentication();
        //     }
        //   }
        // });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => PaySuccessInputPhonePage(
                      orderNo: orderId,
                    )),
            (route) => route == null);

        break;
      case PaymentFromType.paymentFromQuickBuyPersonType:
        var box = Hive.box(HiveBoxs.dataBox);
        box.put(FinalKeys.Quick_BUY_Order_ID, orderId);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => PaySuccessPage(
                orderNo: orderId,
              ),
            ),
            (route) => route == null);
        break;
      case PaymentFromType.paymentFromQuickBuyType:
        if (Golbal.token.isEmpty) {
          var box = Hive.box(HiveBoxs.dataBox);
          box.put(FinalKeys.Quick_BUY_Order_ID, orderId);
          box.put(FinalKeys.BUY_PHONE, "");
          box.delete(FinalKeys.BUY_PHONE);
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => PaySuccessInputPhonePage(
                      orderNo: orderId,
                    )),
            (route) => route == null);

        break;
      case PaymentFromType.paymentFromPersonReportUpgradeType:
        // ToastUtils.showMessage("购买成功");
        if (_isPaySuccessful == true) {
          ToastUtils.showMessage("购买成功");
        } else {
          ToastUtils.showMessage("购买失败，请重新购买");
          NotificationCener.instance
              .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => RootPage(
                pageNumber: 0,
              ),
            ),
            (route) => route == null);
        break;
      case PaymentFromType.paymentFromPersonalPaymentForCompanyPurchase:
        Navigator.of(context)
          ..pop()
          ..pop("clean_up");
        break;
      default:
    }
  }

  void _toWxPay(String payInfo) async {
    Map? map = json.decode(payInfo);
    int timeStamp = int.parse(map?["timestamp"] ?? 0);
    // payWithWeChat(
    //   appId: map?['appId'] ?? "",
    //   partnerId: map?['partnerId'] ?? "",
    //   prepayId: map?['prepayId'] ?? "",
    //   packageValue: map?['package'] ?? "",
    //   nonceStr: map?['nonceStr'] ?? "",
    //   timeStamp: timeStamp,
    //   sign: map?['sign'] ?? "",
    // );

    Fluwx fluwx = Fluwx();
    fluwx.pay(
        which: Payment(
      appId: map?['appId'] ?? "",
      partnerId: map?['partnerId'] ?? "",
      prepayId: map?['prepayId'] ?? "",
      packageValue: map?['package'] ?? "",
      nonceStr: map?['nonceStr'] ?? "",
      timestamp: timeStamp,
      sign: map?['sign'] ?? "",
    ));

    fluwx.addSubscriber((response) {
      if (response.errCode == 0) {
        ToastUtils.showMessage("支付成功");
        if (Golbal.token.isEmpty) {
          _popView();
        } else {
          MineHomeManager.userGetUserInfo((message) => {_popView()});
        }
      } else {
        ToastUtils.showMessage("支付失败");
        NotificationCener.instance
            .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
      }
    });

    // weChatResponseEventHandler.listen((event) async {
    //   if (event.errCode == 0) {
    //     ToastUtils.showMessage("支付成功");
    //     // _popView();
    //     if (Golbal.token.isEmpty) {
    //       _popView();
    //     } else {
    //       MineHomeManager.userGetUserInfo((message) => {_popView()});
    //     }
    //   } else {
    //     ToastUtils.showMessage("支付失败");
    //   }
    // });
  }

  void _backWxPay(Map map) {
    String resultStatus = map["resultStatus"];
    if (resultStatus == "9000") {
      ToastUtils.showMessage("支付成功");
      // _popView();
      if (Golbal.token.isEmpty) {
        _popView();
      } else {
        MineHomeManager.userGetUserInfo((message) => {_popView()});
      }
    } else {
      ToastUtils.showMessage("支付失败");
      NotificationCener.instance
          .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
    }
  }

  @override
  tapBuyReportListItem(int index) {
    Map temp = reportBuyTypes[index];
    buyType = temp["buyType"];
    setState(() {
      for (Map<String, dynamic> item in reportBuyTypes) {
        item["isSelected"] = "0";
      }
      Map a = temp;
      a["isSelected"] = "1";
      _refreshData();
    });
  }

  /// *
  /// -  @description: 年付说明弹窗
  /// -  @Date: 2023-02-25 10:36
  /// -  @parm:
  /// -  @return {*}
  ///
  @override
  tapProblemItem() {
    showDialog(
        context: context,
        builder: (context) {
          return const DescriptionWindowDialog();
        });
  }

  void _realNameAuthentication() {
    if (payType == HYCPayType.payBalance) {
      Navigator.of(context).pop();
    }
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
                  ToastUtils.showMessage("认证成功");
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => RootPage(
                          pageNumber: 0,
                        ),
                      ), (route) {
                    return route == null;
                  });
                });
              },
            );
          }
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  void _personalPaymentForCompanyPurchaseOrder() {
    Map<String, dynamic> map = Map.from(widget.packet);

    if (buyType == ReportBuyType.none || buyType == ReportBuyType.once) {
      map["reportType"] = widget.reportType;
    } else if (buyType == ReportBuyType.year) {
      map["reportType"] = 4;
    }

    /// 1,生成订单号
    PayManager.companyBuyPersonReportPersonPay(map, (str) {
      /// 2,支付逻辑
      if (str.isNotEmpty) {
        switch (payType) {
          case HYCPayType.payAli:
            _aliPay(str, false);
            break;
          case HYCPayType.payWechat:
            _wechatPay(str);
            break;
          case HYCPayType.payBalance:
            _balancePay(str);
            break;
          default:
        }
      }
    });
  }

  int differenceTime(DateTime stsrt, DateTime end) {
    return end.difference(stsrt).inSeconds;
  }
}

class PayWXMiniProgramClass {
  static String productId = "";
  static String price = "";
  static int reportType = 0;
  static String reportAuthId = "";
  static Map<String, dynamic>? packet;
  static int type = -1;
  static String quantity = "";

  static toPay(PaymentFromType fromType) {
    switch (fromType) {
      case PaymentFromType.paymentFromSeachType:

        ///公司购买个人报告
        _createCompanyOrder();
        break;
      case PaymentFromType.paymentFromRechargeType:

        ///
        _createCompanyBuyCoinOrder();
        break;
      case PaymentFromType.paymentFromReportListType:

        ///公司买个人报告,去购买
        _createCompanyGoBuyOrder();
        break;
      case PaymentFromType.paymentFromReportDetailsType:

        ///公司购买个人报告升级
        _createCompanyReportUpGrade();
        break;
      case PaymentFromType.paymentFromReportVIPType:

        ///会员充值
        _creatVipBuyOrder();
        break;
      case PaymentFromType.paymentFromReportUpgradeType:

        ///会员升级
        _creatVipUpgradeOrder();
        break;
      case PaymentFromType.paymentFromPersonType:

        ///购买个人报告
        _creatPersonBuyReportOrder();
        break;
      case PaymentFromType.paymentFromPersonRechargeType:

        ///个人充值慧眼币
        _createPersonBuyCoinOrder();
        break;
      case PaymentFromType.paymentFromPersonReportUpgradeType:

        ///个人升级报告
        _creatPersonBuyReportOrder();
        break;
      default:
    }
  }

  static void _createCompanyOrder() {
    Map<String, dynamic> map = Map.from(packet ?? <String, dynamic>{});
    map["reportType"] = reportType;

    /// 1,生成订单号
    PayManager.createCompanyOrder(map, (orderNumber) {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((value) {
        value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
        value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
        value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
        value.setString(
            FinalKeys.SHARED_PREFERENCES_ORDER_ID,
            StringTools.map2Json({
              "orderId": orderNumber,
            }));
      });

      String webUrl = '/pages/pay/pay?orderId=$orderNumber&reportType=1';
      NativeJSUtlis.wxMiniPayHandle(webUrl);
    });
  }

  static void _createCompanyBuyCoinOrder() {
    PayManager.createCompanyBuyCoinOrder({"productId": productId},
        (orderNumber) {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((value) {
        value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
        value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
        value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
        value.setString(
            FinalKeys.SHARED_PREFERENCES_ORDER_ID,
            StringTools.map2Json({
              "orderId": orderNumber,
            }));
      });
      String webUrl = "/pages/pay/pay?orderId=$orderNumber&money=$price";

      /// 2,支付逻辑
      NativeJSUtlis.wxMiniPayHandle(webUrl);
    });
  }

  static void _createCompanyGoBuyOrder() {
    Map<String, dynamic> map = {"reportType": reportType, "id": reportAuthId};

    /// 1,生成订单号
    PayManager.createOrderCompanyGotoBuyReport(map, (str) {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((value) {
        value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
        value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
        value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
        value.setString(
            FinalKeys.SHARED_PREFERENCES_ORDER_ID,
            StringTools.map2Json({
              "orderId": str,
            }));
      });
      String webUrl =
          '/pages/pay/pay?reportId=$reportAuthId&reportType=1&orderId=$str';

      /// 2,支付逻辑
      NativeJSUtlis.wxMiniPayHandle(webUrl);
    });
  }

  static void _createCompanyReportUpGrade() {
    Map<String, dynamic> map = {
      "reportType": reportType,
      "reportAuthId": reportAuthId
    };

    /// 1,生成订单号
    PayManager.createOrderCompanyReportUpGrade(map, (str) {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((value) {
        value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
        value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
        value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
        value.setString(
            FinalKeys.SHARED_PREFERENCES_ORDER_ID,
            StringTools.map2Json({
              "orderId": str,
            }));
      });
      String webUrl = '/pages/pay/pay?reportId=' +
          reportAuthId +
          '&reportType=1&orderId=' +
          str;

      /// 2,支付逻辑
      NativeJSUtlis.wxMiniPayHandle(webUrl);
    });
  }

  static void _creatVipBuyOrder() {
    Map<String, dynamic> map = {
      "productId": productId,
      "quantity": quantity,
      "type": type
    };
    switch (type) {
      case 0:

        ///人数
        PayManager.createCompanyBuyPeopleOrder(map, (str) {
          if (str.isNotEmpty) {
            Future<SharedPreferences> prefs = SharedPreferences.getInstance();
            prefs.then((value) {
              value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
              value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
              value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
              value.setString(
                  FinalKeys.SHARED_PREFERENCES_ORDER_ID,
                  StringTools.map2Json({
                    "orderId": str,
                  }));
            });
            String webUrl = '/pages/pay/pay?orderId=$str&money=$price';

            /// 2,支付逻辑
            NativeJSUtlis.wxMiniPayHandle(webUrl);
          }
        });

        break;
      case 1:

        ///会员
        PayManager.createCompanyBuyVipOrder(map, (str) {
          if (str.isNotEmpty) {
            Future<SharedPreferences> prefs = SharedPreferences.getInstance();
            prefs.then((value) {
              value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
              value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
              value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
              value.setString(
                  FinalKeys.SHARED_PREFERENCES_ORDER_ID,
                  StringTools.map2Json({
                    "orderId": str,
                  }));
            });
            String webUrl = '/pages/pay/pay?orderId=' + str + '&money=' + price;

            /// 2,支付逻辑
            NativeJSUtlis.wxMiniPayHandle(webUrl);
          }
          return str;
        });

        break;
      case 2:

        ///svip
        PayManager.createCompanyBuySVipOrder(map, (str) {
          if (str.isNotEmpty) {
            Future<SharedPreferences> prefs = SharedPreferences.getInstance();
            prefs.then((value) {
              value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
              value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
              value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
              value.setString(
                  FinalKeys.SHARED_PREFERENCES_ORDER_ID,
                  StringTools.map2Json({
                    "orderId": str,
                  }));
            });
            String webUrl = '/pages/pay/pay?orderId=$str&money=$price';

            /// 2,支付逻辑
            NativeJSUtlis.wxMiniPayHandle(webUrl);
          }
          return str;
        });
        break;
      default:
    }
  }

  static void _creatVipUpgradeOrder() {
    /// 1,生成订单号
    VIPManager.orderCompanyVipUpGrade((str) {
      if (str.isNotEmpty) {
        Future<SharedPreferences> prefs = SharedPreferences.getInstance();
        prefs.then((value) {
          value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
          value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
          value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
          value.setString(
              FinalKeys.SHARED_PREFERENCES_ORDER_ID,
              StringTools.map2Json({
                "orderId": str,
              }));
        });
        String webUrl = '/pages/pay/pay?orderId=$str&money=$price';

        /// 2,支付逻辑
        NativeJSUtlis.wxMiniPayHandle(webUrl);
      }
    });
  }

  static void _creatPersonBuyReportOrder() {
    int temType = reportType > 0 ? reportType - 1 : 0;
    PayManager.personBuyReport({"reportType": reportType}, (str) {
      if (str.isNotEmpty) {
        Future<SharedPreferences> prefs = SharedPreferences.getInstance();
        prefs.then((value) {
          value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
          value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
          value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
          value.setString(
              FinalKeys.SHARED_PREFERENCES_ORDER_ID,
              StringTools.map2Json({
                "orderId": str,
              }));
        });
        String webUrl =
            '/pages/personalPay/personalPay?orderId=$str&reportType=$reportType';

        /// 2,支付逻辑
        NativeJSUtlis.wxMiniPayHandle(webUrl);
      }
    });
  }

  static void _createPersonBuyCoinOrder() {
    PayManager.createPersonBuyCoinOrder({"productId": productId}, (str) {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((value) {
        value.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
        value.remove(FinalKeys.IS_WECHAT_PAY_INFO);
        value.setBool(FinalKeys.IS_WECHAT_PAY_INFO, true);
        value.setString(
            FinalKeys.SHARED_PREFERENCES_ORDER_ID,
            StringTools.map2Json({
              "orderId": str,
            }));
      });
      String webUrl =
          '/pages/personalPay/personalPay?orderId=$str&money=${price}payment=1';

      /// 2,支付逻辑
      NativeJSUtlis.wxMiniPayHandle(webUrl);
      return str;
    });
  }
}

class DescriptionWindowDialog extends Dialog {
  ///标题
  final String title;

  ///确认文案
  final String? confirm;
  final ClickListener? clickListener;

  const DescriptionWindowDialog(
      {this.title = '年付报告说明',
      this.confirm = '知道了',
      this.clickListener,
      Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 280,
        ),
        width: 300,
        decoration: const ShapeDecoration(
          // color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/problemBG.png'),
            fit: BoxFit.fill, // 完全填充
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///标题
            Container(
              margin: const EdgeInsets.only(top: 22, bottom: 14),
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CustomColors.greyBlack),
              ),
            ),

            /// 内容
            Container(
              padding: const EdgeInsets.only(left: 21),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "· ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "一次可购买被查询人一年报告",
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text(
                        "· ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "每个月定时更新报告",
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text(
                        "· ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "每月可通过短信告知企业查看报告",
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text(
                        "· ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "年付报告不享受会员折扣",
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text(
                        "· ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "年付报告单独折扣4折优惠",
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.darkGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),

            _getBottomWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _getBottomWidget(context) {
    return InkWell(
      child: Container(
        height: 35,
        width: 132,
        margin: const EdgeInsets.only(bottom: 22),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            side: BorderSide(
              width: 1,
              color: CustomColors.lightGrey,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          confirm!,
          style: const TextStyle(
              fontSize: 14,
              color: CustomColors.lightGrey,
              fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () => {
        Navigator.of(context).pop(),
      },
    );
  }
}
