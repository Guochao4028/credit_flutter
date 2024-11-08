/// *
/// -  @Date: 2022-08-04 15:00
/// -  @LastEditTime: 2022-08-04 15:00
/// -  @Description: 支付跳转的中间页
///
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pay_payment/view/pay_middle_view.dart';

class PayMiddleResultsPage extends StatefulWidget {
  final Map arguments;

  const PayMiddleResultsPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  State<PayMiddleResultsPage> createState() => _PayMiddleResultsPageState();
}

class _PayMiddleResultsPageState extends State<PayMiddleResultsPage>
    implements PayMiddleViewClickListener {
  String orderId = "";
  String payInfo = "";
  String payment = "";

  String status = "";
  String type = "";
  bool isFirst = true;
  bool? isSuccessful;
  bool isRefresh = true;

  PayMiddleView? payMiddleView;

  @override
  void initState() {
    super.initState();
    // ToastUtils.showMessage("initState");
    payMiddleView = PayMiddleView();
    payMiddleView!.clickListener = this;

    orderId = widget.arguments["out_trade_no"] ?? "";
    payInfo = widget.arguments["payInfo"] ?? "";
    payment = widget.arguments["payment"] ?? "";

    MineHomeManager.userGetUserInfo((message) {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      if (orderId.isNotEmpty) {
        OrderManager.orderInfo({"orderId": orderId}, (map) {
          // 取出数据
          _prefs.then((sp) {
            // IS_WECHAT_PAY_INFO

            bool isWechatPayInfo =
                sp.getBool(FinalKeys.IS_WECHAT_PAY_INFO) ?? false;
            if (isWechatPayInfo == true) {
              sp.remove(FinalKeys.IS_WECHAT_PAY_INFO);
              sp.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
            }

            status = map["status"].toString();
            if (map["status"] == 4) {
              isSuccessful = true;
            } else {
              isSuccessful = false;
            }
            type = map["type"].toString();
            // ToastUtils.showMessage("setState");
            setState(() {});
          });
        });
      } else {
        // 取出数据
        _prefs.then((sp) {
          // IS_WECHAT_PAY_INFO
          sp.remove(FinalKeys.IS_WECHAT_PAY_INFO);
          sp.remove(FinalKeys.SHARED_PREFERENCES_ORDER_ID);
        });
      }
    });

    // } else {
    //   Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    //   prefs.then((value) {
    //     String json =
    //         value.getString(FinalKeys.SHARED_PREFERENCES_ORDER_ID) ?? "";

    //     if (json.isNotEmpty) {
    //       Map map = StringTools.json2Map(json);
    //       if (orderId.isEmpty) {
    //         orderId = map["orderId"];
    //       }
    //       isFirst = map["isFirst"] == "1";
    //       if (orderId.isNotEmpty) {
    //         OrderManager.orderInfo({"orderId": orderId}, (map) {
    //           ToastUtils.showMessage("1");
    //           status = map["status"].toString();
    //           if (map["status"] == 4) {
    //             isSuccessful = true;
    //           } else {
    //             isSuccessful = false;
    //           }
    //           type = map["type"].toString();
    //           setState(() {});
    //         });
    //       }
    //     }
    //   });
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _buildView(),
      ),
    );
  }

  Widget _buildView() {
    if (payment.isNotEmpty && isFirst == true) {
      return payMiddleView?.loadingContentView() ?? const SizedBox();
    } else {
      if (isSuccessful != null && isSuccessful == true) {
        return payMiddleView?.successfulContentView() ?? const SizedBox();
      } else {
        return payMiddleView?.failureContentView() ?? const SizedBox();
      }
    }
  }

  @override
  tapClick() {
    ///1.vip
    ///2.svip
    ///3.公司购买慧眼币 6.个人购买慧眼币
    ///4.企业增加人数
    /// 5.公司购买个人报告
    /// 7.会员升级
    /// 8.个人购买报告
    ///  9.公司报告升级
    /// 10.去购买

    switch (type) {
      case "5":
        Golbal.currentIndex = 2;

        ///首页
        Navigator.of(context)
          ..pushNamedAndRemoveUntil("/", (route) => route == null)
          ..pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        pageNumber: 1,
                      )),
              (route) => route == null);

        // ///首页
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (context) => RootPage(
        //               pageNumber: 1,
        //               isCertigier: true,
        //             )),
        //     (route) => route == null);

        break;
      case "9":
      case "10":
        Golbal.currentIndex = 1;

        ///首页
        Navigator.of(context)
          ..pushNamedAndRemoveUntil("/", (route) => route == null)
          ..pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        pageNumber: 1,
                      )),
              (route) => route == null);
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (context) => RootPage(
        //               pageNumber: 1,
        //             )),
        //     (route) => route == null);

        ;

        break;
      case "8":
        Golbal.currentIndex = 1;

        ///首页
        Navigator.of(context)
          ..pushNamedAndRemoveUntil("/", (route) => route == null)
          ..pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        pageNumber: 0,
                      )),
              (route) => route == null);

        // ///首页
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (context) => RootPage(
        //               pageNumber: 0,
        //             )),
        //     (route) => route == null);

        break;
      case "3":
      case "6":
        MineHomeManager.userGetUserInfo((message) => {
              // Navigator.of(context)
              //   ..pushAndRemoveUntil(
              //       MaterialPageRoute(
              //           builder: (context) => RootPage(
              //                 pageNumber: 2,
              //               )),
              //       (route) => route == null)
              //   ..pushNamed("/assetManagement")

              ///首页
              Navigator.of(context)
                ..pushNamedAndRemoveUntil("/", (route) => route == null)
                ..pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => RootPage(
                              pageNumber: 2,
                            )),
                    (route) => route == null)
            });
        break;
      case "2":
        MineHomeManager.userGetUserInfo((message) => {
              // Navigator.of(context)
              //   ..pushAndRemoveUntil(
              //       MaterialPageRoute(
              //           builder: (context) => RootPage(
              //                 pageNumber: 2,
              //               )),
              //       (route) => route == null)
              Navigator.of(context)
                ..pushNamedAndRemoveUntil("/", (route) => route == null)
                ..pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => RootPage(
                              pageNumber: 2,
                            )),
                    (route) => route == null)
            });
        break;
      default:
        MineHomeManager.userGetUserInfo((message) => {
              // Navigator.of(context)
              //   ..pushAndRemoveUntil(
              //       MaterialPageRoute(
              //           builder: (context) => RootPage(
              //                 pageNumber: 2,
              //               )),
              //       (route) => route == null)
              Navigator.of(context)
                ..pushNamedAndRemoveUntil("/", (route) => route == null)
                ..pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => RootPage(
                              pageNumber: 2,
                            )),
                    (route) => route == null)
            });
    }
  }
}
