/// *
/// @Date: 2022-05-24 10:27
/// @LastEditTime: 2022-06-16 14:44
/// @Description:
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/route/route.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'models/user_model.dart';
import 'tools/global.dart';

void main() {
  /// 初始化数据库
  setUpLocator().then((value) {
// HttpOverrides.global = GlobalHttpOverrides();
    //WidgetFlutterBinding用于与 Flutter 引擎进行交互。
    // Firebase.initializeApp()需要调用本机代码来初始化 Firebase，
    // 并且由于插件需要使用平台通道来调用本机代码，这是异步完成的，
    // 因此您必须调用ensureInitialized()以确保您拥有WidgetsBinding.
    WidgetsFlutterBinding.ensureInitialized();

    //设置状态栏颜色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    //Flutter 特定页面切换屏幕方向/iOS强制横屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      setPathUrlStrategy();
      Golbal.getInstance();

      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      // 写入数据
      prefs.then((sp) {
        UserModel.getTempUserInfo((model) => null);
        var loginType = sp.getString(FinalKeys.LOGIN_TYPE).toString();
        Golbal.loginType = loginType;

        String? jsonStr = sp.getString(FinalKeys.SHARED_PREFERENCES_LOGIN_KEY);
        if (jsonStr != null) {
          Map<String, dynamic> map = StringTools.json2Map(jsonStr);
          UserModel model = UserModel.fromJson(map);
          Golbal.token = model.accessToken;
        }
        runApp(const MyApp());
      });
    });
  });
}

Future setUpLocator() async {
  /// 初始化数据库
  await Hive.initFlutter();
  var box = await Hive.openBox(HiveBoxs.dataBox);
  print("box.toString()");
  print(box.toString());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenTool.int(context);
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    prefs0.then((sp) {
      ///  /// 用户下载产品后，三天内打开次数超过2次，（并且没有触发过内部评分弹窗）在第3次打开时弹出评分。每月仅触发一次。

      /// 进入时间
      String inTiming = sp.getString(FinalKeys.IN_TIMING) ?? "";

      /// 进入次数
      int inCount = sp.getInt(FinalKeys.IN_COUNT) ?? 0;
      inCount += 1;
      sp.setInt(FinalKeys.IN_COUNT, inCount);

      /// 获取上次触发弹窗时间
      String popuoTiming = sp.getString(FinalKeys.TRIGGER_POPUP_TIMING) ?? "";

      /// 是否能触发 1，触发。 0 不触发
      int month = StringTools.getTimeDifference(popuoTiming, timeType: "month");
      if (month == 1) {
        /// 触发时效内
        /// 计算想个上次进入的天数
        int dayNumber = StringTools.getTimeDifference(inTiming);

        /// 三天内打开次数超过2次
        if (dayNumber < 3) {
          if (inCount > 2) {
            /// 触发弹窗
            sp.setBool(FinalKeys.IS_POP, true);

            /// 记录触发弹窗时间
            sp.setString(
                FinalKeys.TRIGGER_POPUP_TIMING, StringTools.getNowTime());

            /// 重置打开次数，重置为1
            sp.setInt(FinalKeys.IN_COUNT, 1);
          }
        } else {
          ///三天外
          /// 重置打开次数，重置为1
          sp.setInt(FinalKeys.IN_COUNT, 1);
        }
      }

      /// 记录进入时间
      sp.setString(FinalKeys.IN_TIMING, StringTools.getNowTime());
    });

    EasyLoading.instance
      ..userInteractions = false
      ..dismissOnTap = false;

    return MaterialApp(
      title: "慧眼查——查信用 查背调 最全面的社会信用数据服务",
      navigatorKey: navigatorKey,
      //主题
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: EasyLoading.init(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: onGenerateRoute,
      initialRoute: initialRoute(),
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
    );
  }
}
