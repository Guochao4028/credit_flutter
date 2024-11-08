import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/home/home_page.dart';
import 'package:credit_flutter/pages/modules/mine/enterprise_info/enterprise_info_page.dart';
import 'package:credit_flutter/pages/modules/mine/mine_home/mine_home_new_page.dart';
import 'package:credit_flutter/pages/modules/report/report_home_page.dart';
import 'package:credit_flutter/pages/modules/scan_code/scan_code_query_page.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:fluwx/fluwx.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../tools/screen_tool.dart';
import '../../tools/widget_tool.dart';

/// @Date: 2022-06-16 14:47
/// @LastEditTime: 2022-06-16 15:01
/// @Description: 所有页面根页面
class RootPage extends StatefulWidget {
  int pageNumber = 0;

  bool isCertigier;

  RootPage({
    this.pageNumber = 0,
    this.isCertigier = false,
    Key? key,
  }) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // List<Widget> pages = [
  //   // const TestPage(),
  //   // const HomePage(),
  //   const IndexSynthsisPage(),
  //   const ReportHomePage(),
  //   // const BackToneCompanyPage(),
  //   const MineHomeNewPage(),
  // ];

  List<Widget> pages = [];

  int currentIndex = 0;

  bool isOther = false;

  @override
  void initState() {
    super.initState();

    // if (Golbal.token.isNotEmpty) {
    //   pages.add(const HomePage());
    // } else {
    //   pages.add(const IndexSynthsisPage());
    // }

    pages.add(const HomePage());
    pages.add(const ReportHomePage());
    pages.add(const MineHomeNewPage());

    bus.on("switch_bottom_page", (arg) {
      currentIndex = arg;
      setState(() {});
    });

    currentIndex = widget.pageNumber;

    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    // 写入数据
    prefs.then((sp) {
      bool firstOpen = sp.getBool(FinalKeys.FIRST_OPEN) ?? false;
      ifAgent(Golbal.loginType);
      if (firstOpen) {
        _getInfo();
        initWxPay();
        initIMSDK();
        _initUmengSDK();
      }
    });

    if (PlatformUtils.isWeb) {
      ///检查是否有微信支付信息
      ///有微信支付信息，跳转到支付中间页。
      ///没有微信信息。 检查账号。
      if (Golbal.isWX) {
        MineHomeManager.userUpdateUserInfo((message) {
          Golbal.checkWechatPayInfo((success, orderNumber) {
            if (success && orderNumber.isNotEmpty) {
              Navigator.of(context).pushNamed('/payResults', arguments: {
                'out_trade_no': orderNumber,
              });
            } else {
              Golbal.checkAccount((success, userModel) {
                // ToastUtils.showMessage("MineHomeManager.userGetUserInfo");
                if (userModel != null) {
                  UserInfo userInfo = userModel.userInfo;
                  if (success == true) {
                  } else {
                    Navigator.pushNamed(context, "/childAccountInfo",
                        arguments: {"childStatus": userInfo.childStatus});
                  }
                }
                setState(() {});
              });
            }
          });
        });
      } else {
        Golbal.checkWechatPayInfo((success, orderNumber) {
          if (success && orderNumber.isNotEmpty) {
            Navigator.of(context).pushNamed('/payResults', arguments: {
              'out_trade_no': orderNumber,
            });
          } else {
            Golbal.checkAccount((success, userModel) {
              if (userModel != null) {
                UserInfo userInfo = userModel.userInfo;
                if (success == true) {
                } else {
                  Navigator.pushNamed(context, "/childAccountInfo",
                      arguments: {"childStatus": userInfo.childStatus});
                }
              }
              setState(() {});
            });
          }
        });
      }
    } else {
      Golbal.checkAccount((success, userModel) {
        if (userModel != null) {
          UserInfo userInfo = userModel.userInfo;
          if (!success) {
            Navigator.pushNamed(context, "/childAccountInfo",
                arguments: {"childStatus": userInfo.childStatus});
          }
        }
        setState(() {});
      });
    }

    setState(() {});

    UmengCommonSdk.onPageStart("root_page");

    // Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    // prefs0.then((sp) {
    //   bool s = sp.getBool(FinalKeys.IS_POP) ?? false;
    //   if (s == true) {
    //     /// 触发弹窗
    //     WidgetTools().showComment(context);

    //     /// 取消弹窗
    //     sp.setBool(FinalKeys.IS_POP, false);
    //   }
    // });
  }

  void ifAgent(String loginType) {
    Future.delayed(const Duration(microseconds: 500), () {
      if (Golbal.generalAgent.isNotEmpty) {
        if (loginType == "1") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EnterpriseInfoPage(),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                var code = Golbal.generalAgent.toString();
                Golbal.generalAgent = "";
                return ScanCodeQueryPage(
                  authorizationCode: code,
                );
              },
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("root_page");
    bus.off("switch_bottom_page");
  }

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  _addItem(int item, String check, String unchecked, String label) {
    return InkWell(
      onTap: () {
        _statistics(item);
        closeKeyboard(context);
        if (Golbal.isWX) {
          currentIndex = item;
          setState(() {});
        } else {
          String jsonStr = Golbal.token;
          if (jsonStr.isEmpty) {
            if (Golbal.bottomReport ? item == 2 : item != 0) {
              WidgetTools().showNotLoggedIn(context);
            } else {
              currentIndex = item;
              setState(() {});
            }
          } else {
            Golbal.checkAccount((success, userModel) {
              if (userModel != null) {
                UserInfo userInfo = userModel.userInfo;
                if (success == true) {
                  currentIndex = item;
                } else {
                  Navigator.pushNamed(context, "/childAccountInfo",
                      arguments: {"childStatus": userInfo.childStatus});
                }
              }
              setState(() {});
            });
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: 22,
            height: 22,
            image: AssetImage(
                "assets/images/${item == currentIndex ? check : unchecked}"),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            label,
            style: TextStyle(
              color: item == currentIndex
                  ? CustomColors.connectColor
                  : CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void closeKeyboard(BuildContext context) {
    // FocusScopeNode currentFocus = FocusScope.of(context);
    // /// 键盘是否是弹起状态
    // if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
    // }
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
      });

      NativeUtils.toolsMethodChannelMethodWithParams("getClientId", params: {
        "context": "getClientId",
      }).then((value) {
        Golbal.clientId = value["clientId"];
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
      Log.e("fingerprint=${androidInfo.fingerprint}");
      Golbal.modelId = StringTools.generateMD5(androidInfo.fingerprint);
      Log.e("modelId=${Golbal.modelId}");

      // //底层板的名称，如“金鱼”。-camellia
      // Log.e("board=${androidInfo.board}");
      // //系统引导加载程序版本号。-unknown
      // Log.e("bootloader=${androidInfo.bootloader}");
      // //与产品/硬件相关联的消费者可见品牌（如果有）-Redmi
      // Log.e("brand=${androidInfo.brand}");
      // //设备信息数据警告：返回的Map可能无法进行JSON编码。
      // Log.e("data=${androidInfo.data}");
      // //工业品外观设计的名称。-camellia
      // Log.e("device=${androidInfo.device}");
      // //用于向用户显示的构建 ID 字符串-TP1A.220624.014
      // Log.e("display=${androidInfo.display}");
      // //有关当前 Android 显示的信息。
      // Log.e("displayMetrics=${androidInfo.displayMetrics.toString()}");
      // //唯一标识此构建的字符串。-Redmi/camellia/camellia:13/TP1A.220624.014/V14.0.6.0.TKSMIXM:user/release-keys
      // Log.e("fingerprint=${androidInfo.fingerprint}");
      // //硬件的名称（来自内核命令行或/proc）。-mt6833
      // Log.e("hardware=${androidInfo.hardware}");
      // //该对象的哈希码。-604799273
      // Log.e("hashCode=${androidInfo.hashCode}");
      // //主机名-pangu-build-component-system-170428-cddvh-bb0sq-g478g
      // Log.e("host=${androidInfo.host}");
      // //可以是变更列表编号，也可以是“M4-rc20”之类的标签。-TP1A.220624.014
      // Log.e("id=${androidInfo.id}");
      // //如果应用程序在模拟器中运行，则为 false，否则为 true。
      // Log.e("isPhysicalDevice=${androidInfo.isPhysicalDevice}");
      // //产品/硬件的制造商。-Xiaomi
      // Log.e("manufacturer=${androidInfo.manufacturer}");
      // //最终产品的最终用户可见的名称。-M2103K19C
      // Log.e("model=${androidInfo.model}");
      // //整体产品的名称。-camellia
      // Log.e("product=${androidInfo.product}");
      // //对象的运行时类型的表示。-AndroidDeviceInfo
      // Log.e("runtimeType=${androidInfo.runtimeType}");
      // //设备的硬件序列号（如果有）-unknown
      // Log.e("serialNumber=${androidInfo.serialNumber}");
      // //该设备支持的 32 位 ABI 的有序列表。 仅适用于 Android L (API 21) 及更高版本
      // Log.e("supported32BitAbis=${androidInfo.supported32BitAbis}");
      // //该设备支持的 64 位 ABI 的有序列表。 仅适用于 Android L (API 21) 及更高版本
      // Log.e("supported64BitAbis=${androidInfo.supported64BitAbis}");
      // //该设备支持的 ABI 的有序列表。 仅适用于 Android L (API 21) 及更高版本
      // Log.e("supportedAbis=${androidInfo.supportedAbis}");
      // //描述当前设备上可用的功能。
      // Log.e("systemFeatures=${androidInfo.systemFeatures}");
      // //描述构建的逗号分隔标签，例如“unsigned,debug”。-release-keys
      // Log.e("tags=${androidInfo.tags}");

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
        // appKey: "1402230919068395#kefuchannelapp107810",
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
    } on EMError catch (e) {
      Log.e(e);
    }
  }

  void _statistics(int item) {
    if (Golbal.token.isEmpty) {
      if (item == 1) {
        UmengCommonSdk.onEvent("click_bottom_report", {"type": "count"});
      } else if (item == 2) {
        UmengCommonSdk.onEvent("click_bottom_mine", {"type": "count"});
      }
    }
  }

  Widget _body(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.bottom;
    ScreenTool.int(context);
    if (isOther == false) {
      return Scaffold(
        body: LazyIndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: CustomColors.color1C0000,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          width: double.infinity,
          height: 55 + statusBarHeight,
          padding: EdgeInsets.only(bottom: statusBarHeight),
          child: Row(
            children: [
              Expanded(
                child: _addItem(0, "icon_home_yes.png", "icon_home.png", "首页"),
              ),
              Expanded(
                child:
                    _addItem(1, "icon_report_yes.png", "icon_report.png", "报告"),
              ),
              // Expanded(
              //   child: _addItem(
              //       2, "icon_back_tone_yes.png", "icon_back_tone.png", "背调"),
              // ),
              Expanded(
                child: _addItem(2, "icon_mine_yes.png", "icon_mine.png", "我的"),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Text("isOther == true"),
      );
    }
  }

// void _initRefresh() {
//   EasyRefresh.defaultHeaderBuilder = () => ClassicHeader(
//         dragText: 'Pull to refresh',
//         armedText: 'Release ready',
//         readyText: 'Refreshing...',
//         processingText: 'Refreshing...',
//         processedText: 'Succeeded',
//         noMoreText: 'No more',
//         failedText: 'Failed',
//         messageText: 'Last updated at %T',
//       );
//   EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
//         dragText: 'Pull to load',
//         armedText: 'Release ready',
//         readyText: 'Loading...',
//         processingText: 'Loading...',
//         processedText: 'Succeeded',
//         noMoreText: 'No more',
//         failedText: 'Failed',
//         messageText: 'Last updated at %T',
//       );
// }
}
