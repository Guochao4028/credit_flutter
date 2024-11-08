/// *
/// -  @Date: 2022-07-14 18:57
/// -  @LastEditTime: 2022-08-08 13:36
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-21 18:02
/// -  @LastEditTime: 2022-07-11 17:34
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-21 18:02
/// -  @LastEditTime: 2022-07-04 13:55
/// -  @Description:
///
import 'dart:math';

import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/foundation.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

/// @Date: 2022-06-14 10:47
/// @LastEditTime: 2022-06-15 04:45
/// @Description: 我的
class MineManager {
  /// @description: 判断手机号是否注册过
  /// @Date: 2022-06-14 10:49
  /// @parm: 手机号
  /// @return {*}
  static userLogout(NetworkMessageCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doPost(NetworkingUrls.userLogout);
    callBack(Message(true, response.statusMessage.toString()));
  }

  static checkPassword(String password, NetworkMessageCallBack callBack) async {
    String rsaPassword = StringTools.generateRSA({"password": password});

    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.userCheckPassword,
        queryParameters: {"rsaEncryption": rsaPassword});

    callBack(Message(true, response.statusMessage.toString()));
  }

  static checkPayPassword(
      String password, NetworkMessageCallBack callBack) async {
    String rsaPassword = StringTools.generateRSA({"userPayPassword": password});

    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.userCheckPayPassword,
        queryParameters: {"rsaEncryption": rsaPassword});

    Map<String, dynamic> data = convert.jsonDecode(response.toString());
    if (data["code"] == 200) {
      callBack(Message(true, response.statusMessage.toString()));
    } else {
      callBack(Message(false, response.statusMessage.toString()));
    }
  }

  static updatePassword(
      String password, NetworkMessageCallBack callBack) async {
    String rsaPassword = StringTools.generateRSA({"newPassword": password});

    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.updatePassword,
        queryParameters: {"rsaEncryption": rsaPassword});

    callBack(Message(true, response.statusMessage.toString()));
  }

  static updatePayPassword(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.userUpdatePayPassword, queryParameters: param);
    Log.d(response.toString());
    callBack(Message(true, response.statusMessage.toString()));
  }
}
