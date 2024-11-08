/// *
/// -  @Date: 2022-08-08 13:37
/// -  @LastEditTime: 2022-08-08 13:37
/// -  @Description: 订单详情
///
import 'dart:io';

import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/models/news_list_model.dart';
import 'package:credit_flutter/models/order_invoice_model.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/network/dio_client.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/flutter_native_utils.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class OrderManager {
  /// *
  /// -  @description: 订单详情
  /// -  @Date: 2022-08-08 13:42
  /// -  @parm: orderId 订单id
  /// -  @return {*}
  ///
  static orderInfo(
      Map<String, dynamic> param, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.getOrderInfo, queryParameters: param);

    Map<String, dynamic> map = response.data;

    Map<String, dynamic> temp = {"status": map["status"], "type": map["type"]};
    callBack(temp);
  }

  static getOrderInfo(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.getOrderInfo, queryParameters: param);

    Map<String, dynamic> map = response.data;
    callBack(OrderDetailsModel.fromJson(map));
  }

  /// *
  /// -  @description: [企业端]订单列表
  /// -  @Date: 2022-08-31 14:51
  /// -  @parm: pageNum, pageSize
  /// -  @return {*}
  ///
  static orderList(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.getOrderList, queryParameters: param);
    Map<String, dynamic> map = response.data;

    callBack(OrderListModel.fromJson(map));
  }

  static orderPersonList(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.getOrderPersonList, queryParameters: param);
    Map<String, dynamic> map = response.data;

    callBack(OrderListModel.fromJson(map));
  }

  static orderInvoice(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postOrderInvoice, queryParameters: param);
    callBack(1);
  }

  static getOrderInvoice(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.getOrderInvoice, queryParameters: param);

    callBack(OrderInvoiceModel.fromJson(response.data));
  }

  static deleteOrder(List param, NetworkObjectCallBack callBack) async {
    String token = Golbal.token;
    final url = Uri.parse(FinalKeys.baseServer() + NetworkingUrls.deleteOrder);
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == HttpStatus.ok) {
        EasyLoading.dismiss();
        print('请求成功');
        print(response.headers); //打印头部信息
        print("post------${response.body}");

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

  /// *
  /// -  @description:补充手机号
  /// -  @Date: 2023-09-13 18:43
  /// -  @parm: orderId
  ///            phone
  /// -  @return {*}
  ///
  static orderSupplementPhone(
      Map<String, dynamic> param, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.psotOrderSupplement, queryParameters: param);

    callBack({});
  }
}
