/// *
/// -  @Date: 2023-09-04 13:55
/// -  @LastEditTime: 2023-09-04 13:55
/// -  @Description: 未登录首页 综合企业和个人
///

import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/home/pages/index_synthesis/views/index_synthesis_company_view.dart';
import 'package:credit_flutter/pages/modules/mine/about/contact_us_page.dart';
import 'package:credit_flutter/pages/modules/mine/enterprise_info/enterprise_info_page.dart';
import 'package:credit_flutter/pages/modules/news/news_details.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/pages/modules/report/fix_report.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_sample_page.dart';
import 'package:credit_flutter/pages/modules/report/report_preview_page.dart';
import 'package:credit_flutter/pages/modules/scan_code/scan_code_page.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/notification.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/platform_utils.dart';
import 'views/index_synthesis_heard_view.dart';
import 'views/index_synthesis_person_view.dart';

class IndexSynthsisPage extends StatefulWidget {
  const IndexSynthsisPage({super.key});

  @override
  State<IndexSynthsisPage> createState() => _IndexSynthsisPageState();
}

class _IndexSynthsisPageState extends State<IndexSynthsisPage>
    implements
        IndexSynthesisHeardClickListener,
        IndexSynthesisPersonViewListener,
        IndexSynthesisCompanyViewListener,
        ClickListener {
  late IndexSynthesisHeardView heardView;
  int _index = 0;
  bool isInputUM = false;

  /// 接受从个人页面传过来的购买类型
  int _type = 0;

  @override
  void initState() {
    heardView = IndexSynthesisHeardView(clickListener: this);
    var box = Hive.box(HiveBoxs.dataBox);
    isInputUM = box.get(FinalKeys.FIRST_OPEN_REPORT_SAMPLE) ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: heardView.getAppBar(),
      backgroundColor: Colors.white24,
      body: BaseBody(
        child: Stack(
          children: [
            SizedBox(
              height: 150,
              child: heardView.heardBackdropView(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 96,
              ),
              child: _contentView(),
            ),
          ],
        ),
      ),
    );
  }

  /// ---- method

  /// -  @description: 切换内容页面
  Widget _contentView() {
    Widget statefulWidget;
    if (_index == 0) {
      statefulWidget = IndexSynthesisCompanyView(
        listener: this,
      );
    } else {
      statefulWidget = IndexSynthesisPersonView(listener: this);
    }
    return statefulWidget;
  }

  void _goBuy(int type, bool bool) {
    PayManager.getReportPrice(type, (price) {
      PayCheakstandPage page = PayCheakstandPage(
        displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
        fromType: PaymentFromType.paymentFromQuickBuyPersonType,
        price: price,
        reportType: type,
      );
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

  _payment(
    Map<String, dynamic> dataMap, {
    PaymentFromType fromType = PaymentFromType.paymentFromSeachType,
    PaymentListDisplayType displayType =
        PaymentListDisplayType.paymentListAllDisplay,
  }) {
    if (isInputUM == true) {
      UmengCommonSdk.onEvent(
          "SeeReportSamplePurchaseLaterBuy", {"type": "count"});
    }

    ///获取报告价格
    PayManager.getReportPrice(1, (price) {
      ///获取报告订阅价格
      PayManager.getReportPrice(4, (yearPrice) {
        ReportPreviewPage page = ReportPreviewPage(
          displayType: displayType,
          fromType: fromType,
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
  }

  /// -  @description: 未登录支付逻辑
  ///
  void _loginOutPayment(Map<String, dynamic> map) {
    /// 1. 先判断是否存在临时身份
    /// 有临时身份沿用临时身份的token
    /// 没有临时身份分配临时身份
    UserModel.getTempUserInfo((model) {
      if (model != null) {
        /// 判断个人 还是 雇主
        if (_index == 0) {
          /// 雇主
          _payment(
            map,
            fromType: PaymentFromType.paymentFromQuickBuyType,
            displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
          );
        } else {
          // bool flag = _type == 1 ? false : true;
          bool flag = true;
          _goBuy(_type, flag);
        }
      } else {
        LoginManager.userGuestLogin((message) {
          /// 判断个人 还是 雇主
          if (_index == 0) {
            /// 雇主
            _payment(
              map,
              fromType: PaymentFromType.paymentFromQuickBuyType,
              displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
            );
          } else {
            // bool flag = _type == 1 ? false : true;
            bool flag = true;
            _goBuy(_type, flag);
          }
        });
      }
    });
  }

  /// ----  heardView 点击 方法

  @override
  void tapScan()  {
    // judgmentAuthority();
    jumpScanPage();
  }

  /// 判断相机权限
  judgmentAuthority() async {
    // 检查权限状态
    PermissionStatus permissionStatus = await checkPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // 权限已授予
      jumpScanPage();
    } else {
      /// 除了相机授权成功的都是拒绝授权
      // 权限被拒绝
      // 尝试请求权限
      permissionStatus = await requestPermission();
      if (permissionStatus == PermissionStatus.granted) {
        // 权限被授予
        jumpScanPage();
      // } else if (permissionStatus == PermissionStatus.denied) {
      } else {
        // 用户永久拒绝了权限请求
        ToastUtils.showMessage("尊敬的用户，请前往app设置，授权使用相机，否则，您将无法使用扫一扫功能");
        // openAppSettings();
      }
    }
  }
  /// 跳转到扫码页面
  jumpScanPage(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const ScanCodePage();
        },
      ),
    );
  }

  // 检查权限状态
  Future<PermissionStatus> checkPermission() async {
    PermissionStatus permissionStatus = await Permission.camera.status;
    return permissionStatus;
  }

// 请求权限
  Future<PermissionStatus> requestPermission() async {
    PermissionStatus permissionStatus = await Permission.camera.request();
    return permissionStatus;
  }

  @override
  void tapRiskRemediation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => const ContactUsPage(),
        builder: (context) => const FixReport(),
      ),
    );
  }

  @override
  void tapToggle(int indx) {
    if (indx == 0) {
      UmengCommonSdk.onEvent("ClickSwitchPersonal", {"type": "count"});
    } else {
      UmengCommonSdk.onEvent("ClickSwitchEmployer", {"type": "count"});
    }

    _index = indx;
    setState(() {});
  }

  /// ----  person View 点击 方法
  @override
  void purchaseIndividualReports(int type) {
    var box = Hive.box(HiveBoxs.dataBox);
    box.put(FinalKeys.Quick_STANDING, 1);
    _type = type;
    if (type == 1) {
      UmengCommonSdk.onEvent(
          'CheckPersonalPurchase', {"tapType": "未登录点击查看全部报告"});
    } else {
      UmengCommonSdk.onEvent(
          'CheckPersonalPurchase', {"tapType": "未登录点击19.9报告"});
    }

    String jsonStr = Golbal.token;
    if (jsonStr.isEmpty) {
      /// 调用未登录支付
      _loginOutPayment({});
    }
  }

  /// ---- company View 点击 方法
  @override
  void purchasingEmployerReport(Map<String, dynamic> map) {
    var box = Hive.box(HiveBoxs.dataBox);
    box.put(FinalKeys.Quick_STANDING, 2);
    String jsonStr = Golbal.token;
    if (jsonStr.isEmpty) {
      /// 调用未登录支付
      _loginOutPayment(map);
    }
  }

  @override
  void sampleReport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NewReportDetailsSamplePage();
        },
      ),
    );
  }

  @override
  void tapNews(NewsDetailsModel newsModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewsDetailsPage(
          newsId: newsModel.newsId,
          type: newsModel.type,
          coverImage: newsModel.coverImage,
        ),
      ),
    );
  }

  /// ---- pop View 点击 方法

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    String identity = confirmMap["identity"];
    String title = confirmMap["title"];
    if (title == "去认证") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const EnterpriseInfoPage(),
        ),
      );
    }
  }

}
