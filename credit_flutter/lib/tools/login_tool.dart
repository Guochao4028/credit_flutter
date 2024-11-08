/// *
/// @Date: 2022-05-26 14:29
/// @LastEditTime: 2022-06-07 13:33
/// @Description: 所有字符串，输入格式校验 等  工具
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/login/login_type_page.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class LoginTools {
  ///保存数据操作
  static void saveUserInfo(Map<String, dynamic> data, LoginType type) {
    String loginType = "1";

    int requestUserType = 0;
    if (type == LoginType.company) {
      loginType = "1";
      requestUserType = 0;
    } else if (type == LoginType.personal) {
      loginType = "2";
      requestUserType = 2;
    } else if (type == LoginType.employer) {
      loginType = "3";
      requestUserType = 1;
    }
    Golbal.loginType = loginType;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 写入数据
    _prefs.then((sp) {
      sp.setString(FinalKeys.LOGIN_TYPE, loginType);
      sp.setInt(FinalKeys.LOGIN_USER_TYPE, requestUserType);
    });

    UserModel.saveUserInfo(data);
    var userModel = UserModel.fromJson(data);
    UmengCommonSdk.onProfileSignIn(userModel.userInfo.uuid);
  }

  ///登录完成操作
  static void loginCompleted(LoginType type, BuildContext context, int source) {
    if (Golbal.generalAgent.isNotEmpty) {
      var pageNumber = 0;
      if (type == LoginType.company) {
        pageNumber = 2;
      }
      //进入首页 - 企业认证页面
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return RootPage(
          pageNumber: pageNumber,
          isCertigier: true,
        );
      }), (route) => route == null);
    } else {
      if (!Golbal.isStorage) {
        Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
      } else {
        if (source == 1) {
          Navigator.of(context)
            ..pop()
            ..pop();
        } else {
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pop();
        }
      }
    }
  }

  ///退出登录操作
  static void loginOut(BuildContext context) {
    //登录成功后的操作标识符
    Golbal.isStorage = false;
    UserModel.removeUserInfo();

    /// 友盟登出用户账号
    UmengCommonSdk.onProfileSignOff();
    //清除token
    Golbal.token = "";
    Golbal.golbalToken = "";

    ///清空用户数据
    /////  Golbal.token = "";
    //     SharedPreferences sp = await SharedPreferences.getInstance();
    //     sp.remove(FinalKeys.SHARED_PREFERENCES_LOGIN_KEY);
    SharedPreferences.getInstance().then((sp) {
      //清除全部数据
      sp.clear();
      //是否第一次登录
      sp.setBool(FinalKeys.FIRST_OPEN, true);
      //宣传页弹框
      sp.setBool(FinalKeys.LEAFLETS, true);
      //跳转页面
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          return const LoginTypePage();
        },
      ), (route) {
        return false;
      });
    });
  }

  /// *
  /// -  @description: 保存临时用户
  /// -  @Date: 2023-08-28 14:34
  /// -  @parm:
  /// -  @return {*}
  ///
  static void saveTemporarilyUserInfo(Map<String, dynamic> data) {
    UserModel.saveTempUserInfo(data);
  }
}
