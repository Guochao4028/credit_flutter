/// *
/// -  @Date: 2022-07-25 10:42
/// -  @LastEditTime: 2022-07-25 14:19
/// -  @Description: 设置路由跳转衔接模块
///
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/empower/new_trailer_page.dart';
import 'package:credit_flutter/pages/modules/login/child_account_info_page.dart';
import 'package:credit_flutter/pages/modules/login/login_type_page.dart';
import 'package:credit_flutter/pages/modules/mine/asset/asset_management_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_status/pay_middle_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_status/pay_success_input_phone_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_status/pay_success_page.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final routes = {
  // "/": (context) => TestPage(),
  "/": (context) => RootPage(),
  // "/": (context) => NewRootPage(),
  "/login": (context) => const LoginTypePage(),
  "/assetManagement": (context) => const AssetManagementPage(),
  "/payResults": (context, {arguments}) =>
      PayMiddleResultsPage(arguments: arguments),
  "/childAccountInfo": (context, {arguments}) =>
      ChildAccountInfoPage(arguments: arguments),
  "/empowerPage": (context, {arguments}) => NewTrailerPage(
        authId: '',
      ),
  "/paySuccessPage": (context, {arguments}) => const PaySuccessPage(
        orderNo: '',
      ),
  "/paySuccessInputPage": (context, {arguments}) =>
      const PaySuccessInputPhonePage(
        orderNo: '',
      ),
};

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('404!'),
      ),
    );
  }
}

RouteFactory onGenerateRoute = (RouteSettings settings) {
  String name = routeBeforeHook(settings);

  // final String settingName = settings.name ?? "";
  final String settingName = name;

  if (routes[name] != null) {
    final Function pageBuilder = routes[name]!;
    // ToastUtils.showMessage("empowerPage");

    if (settings.arguments != null) {
      // 如果透传了参数
      return MaterialPageRoute(
        builder: (context) =>
            pageBuilder(context, arguments: settings.arguments),
        settings: settings,
      );
    } else {
      if (name == "/payResults") {
        String pathName = settings.name ?? "/";

        ///支付宝回调时会把参数拼在URL上回调
        ///只适用于支付宝支付
        return MaterialPageRoute(
          builder: (context) => pageBuilder(context,
              arguments: _dealAliPayUrlArguments(settings)),
          settings: settings,
        );
      }
      if (settingName.contains("/wxProgram")) {
        Golbal.isWX = true;
        Map dataPacker = _dealAliPayUrlArguments(settings);
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        _prefs.then((sp) {
          sp.setString(FinalKeys.LOGIN_TYPE, dataPacker["loginType"]);
        });
        if (dataPacker["accessToken"] != null) {
          String accessToken = dataPacker["accessToken"];
          if (accessToken.isNotEmpty) {
            Golbal.token = dataPacker["accessToken"];
            return MaterialPageRoute(
              builder: (context) => RootPage(),
              settings: settings,
            );
          } else {
            UserModel.getInfo((model) {
              if (model != null) {
                return MaterialPageRoute(
                  builder: (context) => RootPage(),
                  settings: settings,
                );
              }
            });
          }
        }
      }

      if (settingName.contains("/empowerPage")) {
        Map<String, dynamic> dataPacker = _dealAliPayUrlArguments(settings);
        if (dataPacker.containsKey("authId")) {
          var authId = dataPacker["authId"];
          return MaterialPageRoute(
            builder: (context) => NewTrailerPage(
              authId: authId,
            ),
            settings: settings,
          );
        }
      }

      if (settingName.contains("/paySuccessPage")) {
        return MaterialPageRoute(
          builder: (context) => const PaySuccessPage(
            orderNo: "",
          ),
          settings: settings,
        );
      }

      if (settingName.contains("/paySuccessInputPage")) {
        return MaterialPageRoute(
          builder: (context) => const PaySuccessInputPhonePage(
            orderNo: "",
          ),
          settings: settings,
        );
      }

      // 没有透传参数
      return MaterialPageRoute(
        builder: (context) => pageBuilder(context),
        settings: settings,
      );
    }
  }

  return MaterialPageRoute(builder: (context) => UnknownScreen());
};

String routeBeforeHook(RouteSettings settings) {
  String? jsonStr = Golbal.token;
  String pathName = settings.name ?? "/";

  if (pathName == "/") {
    if (jsonStr == null || jsonStr.isEmpty) {
      var box = Hive.box(HiveBoxs.dataBox);
      String orderId = box.get(FinalKeys.Quick_BUY_Order_ID) ?? "";
      String phoneNumberStr = box.get(FinalKeys.BUY_PHONE) ?? "";

      /// 登陆类型
      int type = box.get(FinalKeys.Quick_STANDING) ?? 0;
      if (type != 2) {
        if (orderId.isNotEmpty) {
          return "/paySuccessPage";
        }
      } else {
        if (phoneNumberStr.isEmpty && orderId.isNotEmpty) {
          return "/paySuccessInputPage";
        } else {
          if (orderId.isNotEmpty) {
            return "/paySuccessPage";
          }
        }
      }
    }
  }

  if (pathName.contains('?')) {
    List<String> strs = pathName.split("?");
    String name = strs[0];
    if (name == "/index") {
      return "/";
    } else if (name == "/wxProgram") {
      return "/";
    } else if (name == "/empowerPage") {
      return "/empowerPage";
    } else if (name == "/empowerPage") {
      return "/paySuccessPage";
    }
    if (name == "/payResults") {}
    return name;
  } else {
    return settings.name!;
  }
}

String initialRoute() {
  String? jsonStr = Golbal.token;
  // return jsonStr.isEmpty ? "/login" : "/index";
  return "/";
}

Map<String, dynamic> _dealAliPayUrlArguments(RouteSettings settings) {
  String pathName = settings.name ?? "/";
  Map<String, dynamic> argMap = <String, dynamic>{};
  if (pathName.contains('?')) {
    List<String> strs = pathName.split("?");
    String argumentsStr = strs[1];
    List<String> argList = argumentsStr.split("&");

    for (String str in argList) {
      List<String> subStrs = str.split("=");
      argMap[subStrs[0]] = subStrs[1];
    }
  }
  argMap["temp"] = "1";

  return argMap;
}
