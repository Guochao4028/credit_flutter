/// *
/// @Date: 2022-05-24 11:05
/// @LastEditTime: 2022-05-27 17:03
/// @Description:  选择登录类型页面
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/pages/modules/login/login_new_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../root/root_page.dart';
import 'login_page.dart';

class LoginTypePage extends StatefulWidget {
  const LoginTypePage({Key? key}) : super(key: key);

  @override
  State<LoginTypePage> createState() => _LoginTypePageState();
}

class _LoginTypePageState extends State<LoginTypePage> {
  @override
  void initState() {
    super.initState();
    UmengCommonSdk.onPageStart("login_type_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("login_type_page");
  }

  @override
  Widget build(BuildContext context) {
    ScreenTool.int(context);
    double buttonWidth = ScreenTool.screenWidth - 60;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => RootPage()),
                (Route<dynamic> route) => false,
              );
            }),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 122), //icon 挤位置
            Image(
              image: const AssetImage("assets/images/logo.png"),
              width: ScreenTool.screenWidth - (67.5 * 2),
              fit: BoxFit.fitWidth,
            ),

            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 30, top: 60, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: CustomColors.connectColor,
              ),
              child: InkWell(
                onTap: () {
                  _pOnPressed(LoginType.personal);
                },
                child: const Center(
                  child: Text(
                    "个人背调自查",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 30, top: 20, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: CustomColors.connectColor,
                ),
              ),
              child: InkWell(
                onTap: () {
                  _pOnPressed(LoginType.employer);
                },
                child: const Center(
                  child: Text(
                    "个人雇主背调登录",
                    style: TextStyle(
                      color: CustomColors.connectColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 30, top: 20, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: CustomColors.connectColor,
                ),
              ),
              child: InkWell(
                onTap: () {
                  _pOnPressed(LoginType.company);
                },
                child: const Center(
                  child: Text(
                    "企业雇主背调登录",
                    style: TextStyle(
                      color: CustomColors.connectColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            // const SizedBox(height: 112), //icon 挤位置
            // _pCreateMaterialButton(LoginType.company, buttonWidth, "企业"),
            // const SizedBox(height: 20), //icon 挤位置
            // _pCreateMaterialButton(LoginType.personal, buttonWidth, "个人"),
          ],
        ),
      ),
    );
  }

  void _pOnPressed(LoginType type) {
    String loginType = "1";

    if (type == LoginType.company) {
      loginType = "1";
    } else if (type == LoginType.personal) {
      loginType = "2";
    } else if (type == LoginType.employer) {
      loginType = "3";
    }

    if (Golbal.isWX) {
      ///跳转到微信
      NativeJSUtlis.wxLogin(loginType);
    } else {
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: ((context) => LoginPage(type: type))),
      // );

      Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => LoginNewPage(type: type))),
      );
    }

    // NativeJSUtlis.mlgmmp("mmmp");
  }

  ///生成 企业/个人 按钮
  MaterialButton _pCreateMaterialButton(
      LoginType type, double buttonWidth, String title) {
    //背景颜色
    Color bgColor = type == LoginType.company ? Colors.blue : Colors.white;
    // 字体颜色
    Color textColor = type == LoginType.company ? Colors.white : Colors.blue;

    return WidgetTools().createMaterialButton(
      buttonWidth,
      title,
      bgColor,
      textColor,
      1,
      () => _pOnPressed(type),
    );
  }
}
