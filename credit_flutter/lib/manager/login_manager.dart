// ignore_for_file: slash_for_doc_comments

import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:dio/dio.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

/// *
/// @Date: 2022-06-14 10:47
/// @LastEditTime: 2022-06-15 04:45
/// @Description: 登录模块
class LoginManager {
  /// *
  /// @description: 判断手机号是否注册过
  /// @Date: 2022-06-14 10:49
  /// @parm: 手机号
  /// @return {*}
  static phoneCheck(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.loginPhoneCheck, queryParameters: param);
    bool flag = false;
    String reason = "";
    if (response.data is Map) {
      Map<String, dynamic> jsonMap = response.data;
      if (jsonMap["data"] == null) {
        flag = true;
      }
    } else {
      //response.data 如果不是map类型的话，就证明服务器把用户id返回
      flag = false;
    }
    if (flag == false) {
      reason = "账号已存在";
    }
    callBack(Message(flag, reason));
  }

  /***
   * @description: 发送验证码
   * @Date: 2022-06-14 14:54
   * @parm: codeType 注册 1
      phoneNumber 手机号
   * @return {*}
   */
  static sendPhoneVerifyCode(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.commonPhoneVerifyCode, queryParameters: param);
    bool flag = false;
    String reason = "";
    if (response.data is Map) {
      Map<String, dynamic> jsonMap = response.data;
      if (jsonMap["code"] == "200") {
        flag = true;
      }
      reason = jsonMap["msg"];
    } else if (response.data is String) {
      if (response.statusCode == 200) {
        flag = true;
      }
      reason = response.statusMessage != null ? response.statusMessage! : "";
    }
    callBack(Message(flag, reason));
  }

  /// *
  /// @description: 注册
  /// @Date: 2022-06-14 14:54
  /// @parm:
  /// @return {*}
  static loginUserRegister(Map<String, dynamic> param, LoginType type,
      NetworkMessageCallBack callBack) async {
    String password = param["password"];
    String newPassword = password + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5Password = StringTools.generateMD5(newPassword);
    param["password"] = md5Password;

    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.loginUserRegister, queryParameters: param);
    bool flag = false;
    String reason = "";
    if (response.data is Map) {
      Map<String, dynamic> jsonMap = response.data;
      LoginTools.saveUserInfo(response.data, type);

      flag = true;
    } else if (response.data is String) {
      if (response.statusCode == 200) {
        flag = true;
      }
      reason = response.statusMessage != null ? response.statusMessage! : "";
    }
    callBack(Message(flag, reason));
  }

  /***
   * @description: 手机号密码登录
   * @Date: 2022-06-14 22:07
   * @parm: loginType 登录类型（1、企业 2、个人）
      phoneNumber 手机号
      password 密码
   * @return {*}
   */
  static loginPhonePasswordLogin(Map<String, dynamic> param, LoginType type,
      NetworkMessageCallBack callBack) async {
    String password = param["password"];
    String newPassword = password + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5Password = StringTools.generateMD5(newPassword);
    param["password"] = md5Password;

    String rsaEncryption = StringTools.generateRSA(param);
    Map<String, String> pa = {"rsaEncryption": rsaEncryption};

    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.loginPhonePasswordLogin, queryParameters: pa);

    bool flag = true;
    String reason = "";

    LoginTools.saveUserInfo(response.data, type);
    Log.i(response.data);

    callBack(Message(flag, reason));
  }

  /***
   * @description: 验证码登录
   * @Date: 2022-06-14 22:07
   * @parm: loginType 登录类型（1、企业 2、个人）
      phoneNumber 手机号
   * @return {*}
   */
  static loginCodeLogin(Map<String, dynamic> param, LoginType type,
      NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.codeUserLogin, queryParameters: param);
    bool flag = true;
    String reason = "";

    LoginTools.saveUserInfo(response.data, type);

    Log.i(response.data);

    callBack(Message(flag, reason));
  }

  /***
   * @description: 忘记密码
   * @Date: 2022-06-14 22:07
   * @parm: telPhone 手机号
      code 密码
      password
      codeType
   * @return {*}
   */

  static loginForgetPassword(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    String password = param["password"];
    String newPassword = password + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5Password = StringTools.generateMD5(newPassword);
    param["password"] = md5Password;

    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.loginForgetPassword, queryParameters: param);
    bool flag = true;
    String reason = "";

    UserModel.saveUserInfo(response.data);

    callBack(Message(flag, reason));
  }

  /// *
  /// -  @description: 忘记密码 校验手机号和验证码
  /// -  @Date: 2022-07-04 17:11
  /// -  @parm:
  /// -  @return {*}
  ///

  static codeCheck(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.codeCheck, queryParameters: param);

    callBack(Message(true, response.statusMessage.toString()));
  }

  /// *
  /// -  @description: 发送认证短信
  /// -  @Date: 2022-09-21 10:47
  /// -  @parm:
  /// -  @return {*}
  ///
  static smsCheck(NetworkMessageCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doPost(NetworkingUrls.smsCheck);

    callBack(Message(true, response.statusMessage.toString()));
  }

  /// *
  /// -  @description: 修改个人信息
  /// -  @Date: 2022-09-21 10:47
  /// -  @parm:
  /// -  @return {*}
  ///
  static modify(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.userModeify, queryParameters: param);

    callBack(Message(true, response.statusMessage.toString()));
  }

  /// *
  /// -  @description: 个人端认证获取认证token
  /// -  @Date: 2022-11-01 16:42
  /// -  @parm:
  /// -  @return {*}
  ///
  static getVerifyToken(NetworkMessageCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doPost(NetworkingUrls.getVerifyToken);

    callBack(Message(true, "", extensionDic: response.data));
  }

  static authCheck(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.authCheck, queryParameters: param);

    callBack(Message(true, response.statusMessage.toString()));
  }

  static userGetUserInfo(NetworkObjectCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doGet(NetworkingUrls.userGetUserInfo);
    var userInfo = UserInfo.fromJson(response.data);
    callBack(userInfo);
  }

  static userGuestLogin(NetworkMessageCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doPost(NetworkingUrls.loginGuest);

    bool flag = true;
    String reason = "";
    LoginTools.saveTemporarilyUserInfo(response.data);
    Log.i(response.data);

    callBack(Message(flag, reason));
  }

  static userGuestDataMerge(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.userGuestDataMerge, queryParameters: param);
    bool flag = true;
    String reason = "";
    Log.i(response.data);

    callBack(Message(flag, reason));
  }

  // [注册-下载]用户统计
  static userRegisterSummary(
      String modelId, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
      NetworkingUrls.userRegisterSummary,
      queryParameters: {
        "modelId": modelId,
      },
    );

    callBack(response.data);
  }
}
