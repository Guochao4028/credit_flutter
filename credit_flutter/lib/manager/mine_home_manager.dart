/// *
/// -  @Date: 2022-07-05 18:11
/// -  @LastEditTime: 2022-07-11 17:21
/// -  @Description:
///
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:dio/dio.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// *
/// @Date: 2022-06-14 10:47
/// @LastEditTime: 2022-06-15 04:45
/// @Description: 我的页面
class MineHomeManager {
  static userGetUserInfo(NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.userGetUserInfo,
        queryParameters: {"hideLoading": true});
    bool flag = true;
    String reason = "";

    var userInfo = UserInfo.fromJson(response.data);
    UserModel.getInfo((model) {
      if (model != null) {
        model.userInfo = userInfo;
        UserModel.saveUserInfo(model.toJson());
        callBack(Message(flag, reason));
      }
    });
  }

  static userUpdateUserInfo(UserModelCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.userGetUserInfo,
        queryParameters: {"hideLoading": true});
    bool flag = true;
    String reason = "";
    var userInfo = UserInfo.fromJson(response.data);
    UserModel.getInfo((model) {
      if (model != null) {
        model.userInfo = userInfo;
        UserModel.saveUserInfo(model.toJson());
        callBack(model);
      } else {
        UserModel temModel = UserModel(0, userInfo, 0, Golbal.token);
        UserModel.saveUserInfo(temModel.toJson());
        callBack(temModel);
      }
    });
  }

  /// *
  /// -  @description: 分享报告
  /// -  @Date: 2022-09-20 16:50
  /// -  @parm:
  /// -  @return {*}
  static shareReport(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postShareByCode, queryParameters: param);
    bool flag = true;
    String reason = "分享成功";
    callBack(Message(flag, reason));
  }

  /// 消息未读数量
  static getMessageUnreadCount(NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.messageUnreadCount,
        queryParameters: {"hideLoading": true});
    callBack(response.data.toString());
  }

  static downloadReport(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.sendMail, queryParameters: param);
    bool flag = true;
    String reason = "发送成功，请注意查收";
    callBack(Message(flag, reason));
  }
}
