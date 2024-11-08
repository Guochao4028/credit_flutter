/// *
/// -  @Date: 2022-09-19 14:24
/// -  @LastEditTime: 2022-09-19 14:24
/// -  @Description: 个人页首页
///
import 'package:aliyun_face_plugin/aliyun_face_plugin.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/manager/report_home_manager.dart';
import 'package:credit_flutter/models/company_report_home_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/empower/notification_statement_page.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/certification_home_page.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/person_views/person_index_certification_view.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/person_views/person_index_check_view.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/person_views/person_index_verified_view.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_page.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_sample_page.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/pop_option_widget.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'person_views/person_index_view.dart';

class PersonIndexPage extends StatefulWidget {
  const PersonIndexPage({Key? key}) : super(key: key);

  @override
  State<PersonIndexPage> createState() => _PersonIndexPageState();
}

class _PersonIndexPageState extends State<PersonIndexPage>
    implements
        PersonIndexViewClickListener,
        PopOptionWidgetClickListener,
        ClickListener {
  bool userVerifiedStatus = false;

  String titleStr = "慧眼查";

  PersonIndexView? personView;

  bool isShowAppBar = true;

  bool isInputUM = false;

  static const _channel = MethodChannel(FinalKeys.NATIVE_CHANNEL_PAY);

  void _backRealNameCuation(Map map) {
    Log.i("---$map");
    String resultStatus = map["resultStatus"];
    if (resultStatus == "1") {
      // LoginManager.authCheck({"bizId": _bizId}, (message) {
      //   MineHomeManager.userGetUserInfo((message) => {_refreshUI()});
      // });
    } else if (resultStatus == "2") {
      ToastUtils.showMessage("认证失败");
    } else if (resultStatus == "-1") {
      ToastUtils.showMessage("未认证，请重新认证");
    }
  }

  void _refreshUI() {
    MineHomeManager.userUpdateUserInfo((message) {
      UserModel.getInfo((model) {
        if (model != null) {
          userVerifiedStatus = model.userInfo.getUserVerifiedStatus();

          if (userVerifiedStatus) {
            if (Golbal.loginType == "2") {
              isShowAppBar = true;
              ReportHomeManager.getPersonList({
                "userType": 2,
                "pageNum": 1,
                "pageSize": 999,
              }, (object) {
                CompanyReportHomeBean bean = object as CompanyReportHomeBean;
                if (bean.data.isEmpty) {
                  model.userInfo.reportBuyStatus = 0;
                } else {
                  model.userInfo.reportBuyStatus = 1;
                  Iterable<CompanyReportHomeData> tempList = bean.data
                      .where((element) => element.authorizationStatus == 2);

                  if (tempList.isNotEmpty) {
                    CompanyReportHomeData homeData = tempList.last;
                    model.userInfo.reportId = homeData.reportId.toString();
                    model.reportAuthId = homeData.reportAuthId;
                  } else {
                    Iterable<CompanyReportHomeData> tempList = bean.data
                        .where((element) => element.authorizationStatus == 1);
                    CompanyReportHomeData homeData = tempList.first;
                    model.userInfo.reportId = homeData.reportId.toString();
                    model.reportAuthId = homeData.reportAuthId;
                  }

                  personView = PersonIndexCertiticationView(
                    clickListener: this,
                    userModel: model,
                    isInputUM: isInputUM,
                  );

                  setState(() {});
                }

                personView = PersonIndexCertiticationView(
                  clickListener: this,
                  userModel: model,
                  isInputUM: isInputUM,
                );
                setState(() {});
              });

              personView = PersonIndexCertiticationView(
                clickListener: this,
                userModel: model,
                isInputUM: isInputUM,
              );
              setState(() {});
            } else {
              isShowAppBar = false;
              personView = PersonIndexCheckView(
                clickListener: this,
                userModel: model,
                isInputUM: isInputUM,
              );
            }
          } else {
            // titleStr = "查询报告";
            isShowAppBar = true;
            personView = PersonIndexVerifiedView(
              clickListener: this,
              userModel: model,
              isInputUM: isInputUM,
            );
          }
        }
        setState(() {});
      });
    });
  }

  final _aliyunFacePlugin = AliyunFacePlugin();

  @override
  void initState() {
    var box = Hive.box(HiveBoxs.dataBox);
    isInputUM = box.get(FinalKeys.FIRST_OPEN_REPORT_SAMPLE) ?? false;
    super.initState();

    _aliyunFacePlugin.init();

    ///微信支付通道，用于处理微信支付结果
    _channel.setMethodCallHandler((call) async {
      Log.i("---setMethodCallHandler---");
      setState(() {
        // _nativeData = call.arguments['count'];
        _backRealNameCuation(call.arguments);
      });
    });

    ///获取个人报告列表
    ///判断的列表
    ///列表为空，去购买
    ///列表数量一个 判断授权还是查看
    ///列表两个或以上，查看按钮去列表倒数第二个报告
    ///如果一直不授权  1小时 按钮变去购买

    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      ///获取用户登录状态
      String? loginType = sp.getString(FinalKeys.LOGIN_TYPE);

      UserModel.getInfo((model) {
        if (model != null) {
          userVerifiedStatus = model.userInfo.getUserVerifiedStatus();

          if (userVerifiedStatus) {
            if (loginType == "2") {
              isShowAppBar = true;
              ReportHomeManager.getPersonList({
                "userType": 2,
                "pageNum": 1,
                "pageSize": 999,
              }, (object) {
                CompanyReportHomeBean bean = object as CompanyReportHomeBean;
                if (bean.data.isEmpty) {
                  model.userInfo.reportBuyStatus = 0;
                } else {
                  model.userInfo.reportBuyStatus = 1;

                  var first = bean.data.first;
                  Log.e('---${first.authorizationStatus}');
                  if (first.authorizationStatus == 4) {
                    //TODO 等ui逻辑
                  }

                  Iterable<CompanyReportHomeData> tempList = bean.data
                      .where((element) => element.authorizationStatus == 2);

                  if (tempList.isNotEmpty) {
                    CompanyReportHomeData homeData = tempList.last;
                    model.userInfo.reportId = homeData.reportId.toString();
                    model.reportAuthId = homeData.reportAuthId;
                  } else {
                    Iterable<CompanyReportHomeData> tempList = bean.data
                        .where((element) => element.authorizationStatus == 1);
                    CompanyReportHomeData homeData = tempList.first;
                    model.userInfo.reportId = homeData.reportId.toString();
                    model.reportAuthId = homeData.reportAuthId;
                  }

                  personView = PersonIndexCertiticationView(
                    clickListener: this,
                    userModel: model,
                    isInputUM: isInputUM,
                  );

                  setState(() {});
                }

                personView = PersonIndexCertiticationView(
                  clickListener: this,
                  userModel: model,
                  isInputUM: isInputUM,
                );
                setState(() {});
              });

              personView = PersonIndexCertiticationView(
                clickListener: this,
                userModel: model,
                isInputUM: isInputUM,
              );
              setState(() {});
            } else {
              isShowAppBar = false;
              personView = PersonIndexCheckView(
                clickListener: this,
                userModel: model,
                isInputUM: isInputUM,
              );
            }
          } else {
            // titleStr = "查询报告";
            isShowAppBar = true;
            personView = PersonIndexVerifiedView(
              clickListener: this,
              userModel: model,
              isInputUM: isInputUM,
            );
          }
        }
        setState(() {});
      });
    });
    UmengCommonSdk.onPageStart("personal_home_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("personal_home_page");
  }

  @override
  Widget build(BuildContext context) {
    if (isShowAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: personView?.appBar(titleStr),
          elevation: 0,
          backgroundColor: CustomColors.lightBlue,
        ),
        body: personView?.contentView(context),
      );
    } else {
      return Scaffold(
        body: personView?.contentView(context),
      );
    }
  }

  @override
  tapBuy() {
    PayManager.getReportPrice(1, (price) {
      if (Golbal.isWX == true) {
        PayWXMiniProgramClass.price = price;
        PayWXMiniProgramClass.reportType = 1;
        PayWXMiniProgramClass.toPay(PaymentFromType.paymentFromPersonType);
      } else {
        PayCheakstandPage page = PayCheakstandPage(
          displayType: PaymentListDisplayType.paymentListAllDisplay,
          fromType: PaymentFromType.paymentFromPersonType,
          price: price,
          reportType: 1,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      }
    });
  }

  @override
  tapCheck(UserModel model) {
    ///查看

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewReportDetailsPage(
          reportId: model.userInfo.reportId,
          authId: model.reportAuthId.toString(),
        ),
      ),
    );
  }

  @override
  tapDownload(UserModel model) {
    bool isHaveReport = model.userInfo.reportId.isNotEmpty;

    if (isHaveReport == true) {
      ///下载
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, on) {
              return PopOptionWidget(
                titleStr: "下载员工背调报告",
                imagePath: "assets/images/ed.png",
                hintText: "请输入您的邮箱号",
                instructions: "您的员工背调报告会发送到指定邮箱，方便您进行打印",
                textIconPath: "assets/images/icon_Mailbox.png",
                identify: "download",
                pClickListener: this,
              );
            });
          });
    } else {
      /// 未购买报告
      showDialog(
          context: context,
          builder: (context) {
            return const PopupWindowDialog(
              title: "提示",
              confirm: "知道了",
              content: "您还没有购买个人报告，请购买后才可以下载",
              contentAlign: TextAlign.center,
              contentEdgeInsets: EdgeInsets.only(left: 39, right: 39),
              contentStyle: TextStyle(fontSize: 15),
              showCancel: false,
            );
          });
    }
  }

  @override
  tapGoCertification() {
    if (PlatformUtils.isWeb) {
      ///去认证
      LoginManager.smsCheck((message) {
        ToastUtils.showMessage("短信已发送，请前往短信进行验证");
      });
    } else {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => const CertificationHomePage(),
        ),
      )
          .then((value) {
        if (value != null) {
          //{"certifyId": certifyId, "result": value}
          var certifyId = value["certifyId"];
          var result = value["result"];
          if (result) {
            LoginManager.authCheck({"certifyId": certifyId}, (message) {
              MineHomeManager.userGetUserInfo((message) => {_refreshUI()});
            });
          }
        }
      });

      // LoginManager.getVerifyToken((message) {
      //   Log.i("---getVerifyToken---");
      //
      //   Map<String, dynamic> map = message.extensionDic ?? {};
      //   _bizId = map["bizId"];
      //   String verifyToken = map["verifyToken"];
      //   NativeUtils.toolsMethodChannelMethodWithParams("Certification",
      //       params: {
      //         "context": "certification",
      //         "bizId": _bizId,
      //         "verifyToken": verifyToken
      //       }).then((value) {
      //     _backRealNameCuation(value);
      //
      //     Log.i("---then---");
      //   });
      // });
    }
  }

  @override
  tapShare() {
    ///分享
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, on) {
            return PopOptionWidget(
              titleStr: "分享员工背调报告",
              imagePath: "assets/images/rs.png",
              hintText: "请输入授权码",
              instructions: "填写授权码后进行授权，可以授权给对应企业查看您员工背调报告",
              textIconPath: "assets/images/shouquan.png",
              identify: "share",
              pClickListener: this,
            );
          });
        });
  }

  @override
  void onAffirm(Map<String, dynamic> confirmMap) {
    print(confirmMap);
    String id = confirmMap["id"];
    String contentStr = confirmMap["contentStr"];
    if (id == "share") {
      MineHomeManager.shareReport({"code": contentStr}, (message) {
        ToastUtils.showMessage(message.reason);
      });
    }

    if (id == "download") {
      MineHomeManager.downloadReport({"mail": contentStr}, (message) {
        ToastUtils.showMessage(message.reason);
      });
    }
  }

  @override
  example() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewReportDetailsSamplePage(),
      ),
    );
  }

  String reportAuthId = "";

  @override
  tapResend(UserModel userModel) {
    reportAuthId = userModel.reportAuthId.toString();
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            identity: "99",
            confirm: "发送短信",
            cancel: "取消",
            content: "需要进行短信授权才可查看个人报告",
            contentAlign: TextAlign.center,
            contentEdgeInsets: EdgeInsets.only(left: 39, right: 39),
            contentStyle: TextStyle(fontSize: 15),
            showCancel: true,
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> map) {
    String title = map["title"];
    String identity = map["identity"];
    if (identity == "99") {
      ReportHomeManager.getCompanyNameForMessage({"id": reportAuthId}, (str) {
        var companyName = str["companyName"];
        var idCard = str["idCard"];
        var name = str["name"];
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => NotificationStatementPage(
              type: 1,
              companyName: companyName.toString(),
              idCard: idCard.toString(),
              name: name.toString(),
              reportAuthId: reportAuthId,
            ),
          ),
        )
            .then((value) {
          if (value != null) {
            _refreshUI();
          }
        });
      });
    }

    if (identity == "999") {
      PayManager.getReportPrice(1, (price) {
        if (Golbal.isWX == true) {
          PayWXMiniProgramClass.price = price;
          PayWXMiniProgramClass.reportType = 1;
          PayWXMiniProgramClass.toPay(PaymentFromType.paymentFromPersonType);
        } else {
          PayCheakstandPage page = PayCheakstandPage(
            displayType: PaymentListDisplayType.paymentListAllDisplay,
            fromType: PaymentFromType.paymentFromPersonType,
            price: price,
            reportType: 1,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        }
      });
    }
  }

  @override
  tapUpdate(UserModel model) {
    // NativeJSUtlis.openEmpower("http://localhost:55902/empowerPage?authId=测试值");
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            title: "提示",
            identity: "999",
            confirm: "更新",
            cancel: "取消",
            content: "报告可能有更新记录，需要更新重新购买报告，覆盖之前报告",
            contentAlign: TextAlign.center,
            contentEdgeInsets: const EdgeInsets.only(left: 39, right: 39),
            contentStyle: const TextStyle(fontSize: 15),
            showCancel: true,
            clickListener: this,
          );
        });
  }

  @override
  tapPurchaseReport(Map<String, dynamic> map) {
    String idStr = map["idCard"];
    String nameStr = map["idCardName"];
    String phoneStr = map["phone"];

    if (StringTools.isEmpty(nameStr)) {
      ToastUtils.showMessage("姓名不能为空");
      return;
    }
    if (StringTools.checkSpace(nameStr)) {
      ToastUtils.showMessage("姓名中不能有空格或特殊符号");
      return;
    }
    if (StringTools.checkABC(nameStr)) {
      ToastUtils.showMessage("姓名中不能有英文字母");
      return;
    }

    Map idMap = StringTools.verifyCardId(idStr);
    if (idMap["state"] == false) {
      ToastUtils.showMessage(idMap["message"]);
      return;
    }

    if (StringTools.isEmpty(phoneStr)) {
      ToastUtils.showMessage("手机号不能为空");
      return;
    }
    if (!RegexUtils.verifyPhoneNumber(phoneStr)) {
      ToastUtils.showMessage("请输入正确手机号");
      return;
    }

    _payment(map);
  }

  _payment(Map<String, dynamic> map) {
    if (isInputUM == true) {
      UmengCommonSdk.onEvent(
          "SeeReportSamplePurchaseLaterBuy", {"type": "count"});
    }

    ///获取报告价格
    PayManager.getReportPrice(1, (price) {
      if (Golbal.isWX == true) {
        PayWXMiniProgramClass.price = price;
        PayWXMiniProgramClass.reportType = 1;
        PayWXMiniProgramClass.toPay(
            PaymentFromType.paymentFromPersonBuyPersonReport);
      } else {
        PayCheakstandPage page = PayCheakstandPage(
          displayType: PaymentListDisplayType.paymentListAllDisplay,
          fromType: PaymentFromType.paymentFromPersonBuyPersonReport,
          price: price,
          reportType: 1,
        );
        page.packet = map;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      }
    });
  }
}
