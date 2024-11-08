/// *
/// -  @Date: 2022-06-16 14:24
/// -  @LastEditTime: 2022-09-19 14:02
/// -  @Description:首页
///
import 'dart:async';

import 'package:credit_flutter/chat/chat_page.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/pages/modules/home/pages/company_page/temporary_company_index_page.dart';
import 'package:credit_flutter/pages/modules/home/pages/index_synthesis/index_synthesis_page.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_employer/person_employer_page.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/revision_person_index_page.dart';
import 'package:credit_flutter/pages/modules/mine/order/order_obligation_list_page.dart';
import 'package:credit_flutter/pages/test_page.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/notification.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/update_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:fluwx/fluwx.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../define/define_colors.dart';
import '../../../define/define_url.dart';
import '../../../tools/global.dart';
import '../../../utils/platform_utils.dart';
import '../web/web_page.dart';
import 'views/countdown_payout_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 会话
  EMConversation? _conv;
  bool _nohasMessage = true;

  OrderListModel? listModel;

  late Timer timer;

  bool isView = false;
  List<String> titleCStr = [
    "现在有优惠活动吗？",
    "可以介绍产品吗？",
    "背调流程是怎样的？",
  ];

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    NotificationCener.instance.addNotification(FinalKeys.NOTIFICATION_COUNTDOWN,
        ({object}) {
      Log.e("-------------------NotificationCener");

      if (Golbal.token.isEmpty && Golbal.golbalToken.isEmpty) {
        setState(() {});
      } else {
        Map<String, dynamic> map = {"minute": 60, "orderStatus": 1};

        if (Golbal.loginType.isNotEmpty && Golbal.token.isNotEmpty) {
          if (Golbal.loginType == "2") {
            map["orderType"] = 8;
          } else {
            map["orderType"] = 12;
          }
        }
        OrderManager.orderPersonList(map, (object) {
          listModel = object as OrderListModel;
          setState(() {});
        });
      }
    });

    super.initState();
    if (PlatformUtils.isIOS || PlatformUtils.isAndroid) {
      timer = Timer(const Duration(milliseconds: 50), () {
        try {
          Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
          // 写入数据
          prefs0.then((sp) {
            bool firstOpen = sp.getBool(FinalKeys.FIRST_OPEN) ?? false;
            bool leaflets = sp.getBool(FinalKeys.LEAFLETS) ?? false;
            if (!firstOpen) {
              showAgreement();
            } else {
              ifAppUpdate();
              if (!leaflets) {
                sp.setBool(FinalKeys.LEAFLETS, true);
              }
              _pullHXData();
              // OrderManager.orderPersonList({"minute": 60, "orderStatus": 1},
              //     (object) {
              //   listModel = object as OrderListModel;
              //   setState(() {});
              // });
            }
          });
        } catch (_) {}
      });
      UmengCommonSdk.onEvent("OpenAppNumber", {"type": "count"});
    }
    Future.delayed(const Duration(seconds: 5), () {
      isView = true;
      setState(() {});
    });
  }

  ifAppUpdate() {
    Future.delayed(const Duration(seconds: 5), () {
      PackageInfo.fromPlatform().then((value) {
        UpdateUtils()
            .appUpdate(context, int.parse(value.buildNumber), value.version, 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double top = ScreenTool.screenHeight -
        (96 + 10 + 30 - 10) -
        ScreenTool.bottomSafeHeight;

    double orderObligationTop = top - 10;
    if (Golbal.loginType.isNotEmpty && Golbal.token.isNotEmpty) {
      if (Golbal.loginType == "2") {
        orderObligationTop -= 50;
      }
    }

    return Stack(
      children: [
        _currentContentView(),
        Positioned(
          left: 0,
          right: 0,
          top: top + 45,
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
            color: Colors.white,
            width: ScreenTool.screenWidth,
            height: 25,
            child: GestureDetector(
              onTap: () {
                Log.d("GestureDetector >>> 1");
                launchUrl(
                    Uri.parse("https://beian.miit.gov.cn/#/Integrated/index"));
              },
              child: const Text(
                "备案号：京ICP备2022008367号-2A",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: top - 10,
          child: Column(
            children: [
              Offstage(
                offstage: !isView,
                child: Container(
                  width: 96,
                  height: 20,
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 4,
                  ),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: CustomColors.color81,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {},
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        //每次循环遍历时，将i赋值给index
                        return Text(
                          titleCStr[index],
                          style:
                              const TextStyle(color: Colors.white, fontSize: 9),
                          textAlign: TextAlign.center,
                        );
                      },
                      loop: true,
                      autoplay: true,
                      // curve: Curves.bounceIn,
                      scrollDirection: Axis.vertical,
                      itemCount: titleCStr.length,
                      autoplayDelay: 5000,
                      onTap: (index) {},
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                padding: EdgeInsets.only(left: 10),
                child: Stack(
                  children: [
                    WidgetTools().createCustomInkWellButton(
                      "在线客服",
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ChatPage(),
                            // builder: (context) => const OnlineServisePage(),
                          ),
                        );
                      },
                      bgColor: CustomColors.whiteBlueColor,
                      textColor: Colors.white,
                      buttonWidth: 80,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      height: 30,
                      radius: 8,
                      leftImage: Image.asset(
                        "assets/images/zai1.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 75,
                      child: Offstage(
                        offstage: _nohasMessage,
                        child: ClipOval(
                          child: Container(
                            width: 10,
                            height: 10,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 16,
          top: orderObligationTop,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OrderObligaionListPage(),
                ),
              );
            },
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 70,
                  child: CountDownPayoutView(
                    listModel: listModel,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // _currentContentView();
  }

  Widget _currentContentView() {
    StatefulWidget statefulWidget;
    String? jsonStr = Golbal.token;

    if (jsonStr.isEmpty) {
      // statefulWidget = const TemporaryCompanyIndexPage();
      statefulWidget = const IndexSynthsisPage();
    } else {
      switch (Golbal.loginType) {
        case "1":
          //企业雇主
          statefulWidget = const TemporaryCompanyIndexPage();
          break;
        case "2":
          //个人自查
          statefulWidget = const RevisionPersonIndexPage();
          // statefulWidget = const PersonIndexPage();
          break;
        case "3":
          //个人雇主
          statefulWidget = const PersonEmployerPage();
          break;
        default:
          statefulWidget = const TestPage();
          break;
      }
    }

    return statefulWidget;
  }

  void showAgreement() {
    TapGestureRecognizer userRecognizer = TapGestureRecognizer();
    TapGestureRecognizer privacyRecognizer = TapGestureRecognizer();
    userRecognizer.onTap = () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              const WebViewPage("用户协议", NetworkingUrls.h5AllRegisterUrl),
        ),
      );
    };
    privacyRecognizer.onTap = () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              const WebViewPage("隐私协议", NetworkingUrls.h5AllPrivacyPolicyUrl),
        ),
      );
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return UnconstrainedBox(
          constrainedAxis: Axis.horizontal,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 38, right: 38),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "隐私协议",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                      children: [
                        const TextSpan(
                            text: "并完成注册后方可继续操作,请您充分阅读并接受全部内容后点击同意。",
                            style: TextStyle(
                                color: CustomColors.greyBlack, fontSize: 18.0)),
                        TextSpan(
                          text: "《用户协议》",
                          style: const TextStyle(
                              color: CustomColors.lightBlue, fontSize: 18.0),
                          recognizer: userRecognizer,
                        ),
                        const TextSpan(
                            text: "及",
                            style: TextStyle(
                                color: CustomColors.greyBlack, fontSize: 18.0)),
                        TextSpan(
                          text: "《隐私权政策》",
                          style: const TextStyle(
                              color: CustomColors.lightBlue, fontSize: 18.0),
                          recognizer: privacyRecognizer,
                        ),
                      ],
                      text: "您需要同意",
                      style: const TextStyle(
                          color: CustomColors.greyBlack, fontSize: 18.0)),
                ),
                const SizedBox(height: 8),
                const Text(
                  "1、为向您提供交易、服务等相关功能或服务,我们会收集、使用您的必要信息;\n2、摄像头、相册等敏感权限均不会默认开启,只有经过您明示授权的前提下才会为实现某项功能或服务时使用;\n3、未经您的同意,我们不会从第三方获取、共享或对外提供您的个人信息;\n4、您可以查询、更正、删除您的个人信息、我们提供账号注销途径。",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Container(
                          width: double.infinity,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: const ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(22),
                              ),
                              side: BorderSide(
                                width: 1,
                                color: CustomColors.lightGrey,
                              ),
                            ),
                          ),
                          child: const Text(
                            "不同意",
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.lightGrey,
                            ),
                          ),
                        ),
                        onTap: () => {SystemNavigator.pop()},
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          width: double.infinity,
                          height: 44,
                          decoration: const ShapeDecoration(
                            color: CustomColors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(22),
                              ),
                              side: BorderSide(
                                width: 0,
                                color: CustomColors.lightGrey,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "同意",
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.whiteColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          initWxPay();
                          initIMSDK();
                          _getInfo();
                          _initUmengSDK();

                          /// 统计：用户首次打开首页次数
                          UmengCommonSdk.onEvent(
                              "FirstOpenAppNumber", {"type": "count"});

                          ifAppUpdate();

                          Future<SharedPreferences> prefs =
                              SharedPreferences.getInstance();
                          // 写入数据
                          prefs.then((sp) {
                            /// 保存 是否第一次进入
                            sp.setBool(FinalKeys.FIRST_IN, true);

                            sp.setBool(FinalKeys.FIRST_OPEN, true);
                            Navigator.pop(ctx, true);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _initUmengSDK() {
    UmengCommonSdk.initCommon(FinalKeys.umengAndroidAppkey(),
        FinalKeys.umengIosAppkey(), FinalKeys.umengChannel);

    UmengCommonSdk.setPageCollectionModeManual();
  }

  void _getInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (PlatformUtils.isIOS) {
      NativeUtils.toolsMethodChannelMethodWithParams("getUUID", params: {
        "context": "getUUID",
      }).then((value) {
        Golbal.modelId = StringTools.generateMD5(value["UUID"].toString());
        LoginManager.userRegisterSummary(Golbal.modelId, (object) {});
      });

      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Golbal.model = iosInfo.model;
      Golbal.manufacturer = "Apple";
      Golbal.brand = "iOS";
      Golbal.systemName = iosInfo.systemName;
      Golbal.equipmentModel = iosInfo.utsname.machine;
      Golbal.systemVersion = iosInfo.systemVersion;
    } else if (PlatformUtils.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      //唯一标识此构建的字符串。-Redmi/camellia/camellia:13/TP1A.220624.014/V14.0.6.0.TKSMIXM:user/release-keys
      Golbal.modelId = StringTools.generateMD5(androidInfo.fingerprint);
      LoginManager.userRegisterSummary(Golbal.modelId, (object) {});

      Golbal.model = "Android";
      Golbal.manufacturer = androidInfo.manufacturer;
      Golbal.brand = androidInfo.brand;
      Golbal.systemName = "Android";
      Golbal.equipmentModel = androidInfo.model;
      Golbal.systemVersion = androidInfo.version.sdkInt.toString();
    } else if (PlatformUtils.isWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      Golbal.model = webBrowserInfo.userAgent.toString();
      Golbal.manufacturer = webBrowserInfo.platform.toString();
      Golbal.brand = webBrowserInfo.vendor.toString();
      Golbal.systemName = webBrowserInfo.browserName.toString();
      Golbal.equipmentModel = webBrowserInfo.appName.toString();
      Golbal.systemVersion = "H5";
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Golbal.appVersion = packageInfo.version;
  }

  //先注册
  void initWxPay() async {
    if (!PlatformUtils.isWeb) {
      //出实话微信
      Fluwx fluwx = Fluwx();
      fluwx.registerApi(
          appId: "wxf0bb015426aa0b8c",
          universalLink: "https://api.nowcheck.cn/app");
    }
  }

  //先注册
  void initIMSDK() async {
    if (!PlatformUtils.isWeb) {
      EMOptions options = EMOptions(
        //appKey: "1402230919068395#kefuchannelapp107810",

        appKey: "1161230919209751#huiyancha",
        autoLogin: false,
        debugMode: true,
      );
      await EMClient.getInstance.init(options);
      // 通知sdk ui已经准备好，执行后才会收到`EMChatRoomEventHandler`, `EMContactEventHandler`, `EMGroupEventHandler` 回调。
      await EMClient.getInstance.startCallback();
//暂时不用，从逻辑上来说这个应该是个低频操作，不需要每个打开APP的人都去注册环信用户
      //只需要当用户需要反馈时能正常发送消息就可以了
      ////1.进入到客服页
      ////2.判断是否有环信用户，有正常登录 拉取聊天记录。没有就去注册
      //用户发送完消息，需要清退，时间为三天
      // _signUp();
    }
  }

  void _signUp() async {
    var box = Hive.box(HiveBoxs.dataBox);
    String password = box.get(FinalKeys.BOX_HUANXIN_PASSWORD) ?? "";
    String user = box.get(FinalKeys.BOX_HUANXIN_USER) ?? "";
    if (password.isEmpty || user.isEmpty) {
      String uname = "${DateTime.now().millisecondsSinceEpoch}";
      String pws = "q1234567890";
      try {
        await EMClient.getInstance.createAccount(uname, pws);
        box.put(FinalKeys.BOX_HUANXIN_USER, uname);
        box.put(FinalKeys.BOX_HUANXIN_PASSWORD, pws);
      } on EMError catch (e) {
        Log.e(e);
      }
    } else {
      _signIn();
    }
  }

  void _signIn() async {
    var box = Hive.box(HiveBoxs.dataBox);
    String password = box.get(FinalKeys.BOX_HUANXIN_PASSWORD) ?? "";
    String user = box.get(FinalKeys.BOX_HUANXIN_USER) ?? "";
    try {
      await EMClient.getInstance.login(user, password);
    } on EMError catch (e) {}
  }

  void _pullHXData() async {
    bool isConnected = await EMClient.getInstance.isConnected();
    if (isConnected == true) {
      try {
        _conv = await EMClient.getInstance.chatManager
            .getConversation("kefuchannelimid_563522");
        int unreadCont = await _conv?.unreadCount() ?? 0;
        if (unreadCont > 0) {
          _nohasMessage = false;
        }
        Log.d(unreadCont);
      } on EMError catch (e) {
        Log.e('操作失败，原因是: $e');
      }
    }
  }
}
