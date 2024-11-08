/// *
/// -  @Date: 2023-09-01 17:12
/// -  @LastEditTime: 2023-09-01 17:13
/// -  @Description:
///
/// *
/// -  @Date: 2022-09-14 17:45
/// -  @LastEditTime: 2022-10-21 16:25
/// -  @Description:
///
import 'dart:convert';
import 'dart:io';

import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/message_center_bean.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

class MessageCenterManager {
  static getMessage(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.getMessage, queryParameters: param);
    callBack(MessageCenterBean.fromJson(response.data));
  }

  static messageRead(String id, NetworkStringCallBack callBack) async {
    Map<String, dynamic> param = {"id": id};
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.messageRead, queryParameters: param);
    callBack(response.data.toString());
  }

  static messageReadAll(NetworkStringCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doPost(NetworkingUrls.messageReadAll);
    callBack(response.data.toString());
  }

  static deleteOrder(List param, NetworkObjectCallBack callBack) async {
    String token = Golbal.token;
    final url = Uri.parse(FinalKeys.baseServer() + NetworkingUrls.getMessage);

    EasyLoading.show();

    if (!PlatformUtils.isWeb) {
      HttpClient httpClient = HttpClient();

      HttpClientRequest request = await httpClient.deleteUrl(url);

      request.headers.set('content-type', 'application/json');
      request.headers.set("token", token);

      /// 添加请求体
      request.add(utf8.encode(json.encode(param)));

      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();
      if (response.statusCode == HttpStatus.ok) {
        EasyLoading.dismiss();
        print('请求成功');
        print(response.headers); //打印头部信息
        print("post------${responseBody}");

        Map<String, dynamic> jsonMap = jsonDecode(responseBody);

        String code = jsonMap["code"];
        if (jsonMap["code"] == "200" || jsonMap["code"] == "10106") {
          callBack(1);
        } else {
          ToastUtils.showMessage(jsonMap["msg"]);
        }
      }
    } else {
      var response = await http
          .delete(url, body: utf8.encode(json.encode(param)), headers: {
        'content-type': 'application/json',
        'token': token,
      });

      if (response.statusCode == HttpStatus.ok) {
        EasyLoading.dismiss();

        Map<String, dynamic> jsonMap = jsonDecode(response.body);

        String code = jsonMap["code"];
        if (code == "200" || code == "10106") {
          callBack(1);
        } else {
          ToastUtils.showMessage(jsonMap["msg"]);
        }
      }
    }
  }
}
