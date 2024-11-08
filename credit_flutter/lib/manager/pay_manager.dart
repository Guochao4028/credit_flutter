/// *
/// -  @Date: 2022-07-12 16:23
/// -  @LastEditTime: 2022-07-12 16:23
/// -  @Description: 支付相关
///
import 'dart:convert';

import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/models/product_model.dart';
import 'package:credit_flutter/network/dio_client.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:dio/dio.dart';

class PayManager {
  /// *
  /// -  @description: 公司资产
  /// -  @Date: 2022-07-12 16:24
  /// -  @parm:
  /// -  @return {*}

  static Future getAssets(Map<String, dynamic> param) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.virtualGetAssets, queryParameters: param);
    return null;
  }

  /// *
  /// -  @description: 公司买个人报告（生成订单）
  /// -  @Date: 2022-07-15 11:12
  /// -  @parm:
  ///     idCard	身份证
  ///     idCardName	姓名
  ///     phone	手机号
  ///     reportType	报告类型  1.99基础版 2.198普通 3.999高级
  /// -  @return {*}
  ///
  static Future<dynamic> createCompanyOrder(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.postOrderCompanyBuyReport,
        queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 公司买人数
  /// -  @Date: 2022-09-05 17:35
  /// -  @parm:
  /// -  @return {*}
  ///
  static Future<dynamic> createCompanyBuyPeopleOrder(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.postOrderCompanyBuyPeople,
        queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 公司买会员
  /// -  @Date: 2022-09-05 17:35
  /// -  @parm:
  /// -  @return {*}
  ///
  static Future<dynamic> createCompanyBuyVipOrder(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postOrderCompanyBuyVip, queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 公司买会员
  /// -  @Date: 2022-09-05 17:35
  /// -  @parm:
  /// -  @return {*}
  ///
  static Future<dynamic> createCompanyBuySVipOrder(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postOrderCompanyBuySVip, queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 公司买个人报告 去购买
  /// -  @Date: 2022-07-27 15:54
  /// -  @parm: id 授权id
  ///           reportType 报告类型
  /// -  @return {*}
  ///
  static Future<dynamic> createOrderCompanyGotoBuyReport(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.postOrderCompanyGotoBuyReport,
        queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 公司购买个人报告升级
  /// -  @Date: 2022-07-27 15:59
  /// -  @parm: reportAuthId 授权id
  ///           reportType 报告类型
  /// -  @return {*}
  ///
  static Future<dynamic> createOrderCompanyReportUpGrade(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.postOrderCompanyReportUpGrade,
        queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 公司买慧眼币
  /// -  @Date: 2022-07-20 10:26
  /// -  @parm:  productId  套餐id
  /// -  @return {*}
  ///
  static Future<dynamic> createCompanyBuyCoinOrder(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postOrderCompanyBuyCoin, queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 个人买慧眼币
  /// -  @Date: 2022-09-27 14:31
  /// -  @parm:
  /// -  @return {*}
  ///
  static Future<dynamic> createPersonBuyCoinOrder(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postOrderPersonBuyCoin, queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 余额支付
  /// -  @Date: 2022-07-20 10:25
  /// -  @parm:
  /// -  @return {*}
  ///
  static Future payBalance(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postPayBalance, queryParameters: param);

    bool flag = true;
    String reason = "";
    if (response.statusCode == 10106) {
      flag = false;
      reason = "支付密码错误";
    }

    callBack(Message(flag, reason));

    return null;
  }

  /// *
  /// -  @description: 支付宝app支付
  /// -  @Date: 2022-07-15 13:38
  /// -  @parm: orderId 订单号
  /// -  @return {*}
  ///
  static Future payAlipay(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postPayAlipay, queryParameters: param);
    callBack(response.data.toString());
    return null;
  }

  /// *
  /// -  @description: 微信app支付
  /// -  @Date: 2022-07-26 18:27
  /// -  @parm:
  /// -  @return {*}
  ///
  static Future payWechatPay(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postPayWechatpay, queryParameters: param);

    callBack(json.encode(response.data));
    return null;
  }

  /// *
  /// -  @description: 微信H5支付
  /// -  @Date: 2022-08-02 14:39
  /// -  @parm:
  /// -  @return {*}
  ///
  static Future payWechatH5Pay(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postPayWechatH5, queryParameters: param);

    callBack(response.data["h5_url"]);
    return null;
  }

  /// *
  /// -  @description: 微信小程序支付
  /// -  @Date: 2022-11-22 15:02
  /// -  @parm:
  /// -  @return {*}
  ///
  static Future payWechatProgramPay(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.postPayWechatMiniProgramH5,
        queryParameters: param);
    Map<String, dynamic> map = response.data;

    callBack(StringTools.map2Json(map));
    return null;
  }

  /// *
  /// -  @description: 支付宝 H5支付
  /// -  @Date: 2022-07-21 10:21
  /// -  @parm: orderId 订单号，returnUrl 返回url
  /// -  @return {*}
  ///
  static Future payAlipayH5(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postPayAlipayH5, queryParameters: param);
    callBack(response.data.toString());
    return null;
  }

  /// *
  /// -  @description:获取购买报告的价格
  /// -  @return {*}
  ///
  static Future getReportPrice(
      int reoirtType, NetworkStringCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doGet(NetworkingUrls.getReportPrice);

    String reportPrice = "";
    List priceList = response.data;
    for (Map map in priceList) {
      if (map["type"] == reoirtType) {
        reportPrice = map["price"].toString();
        break;
      }
    }

    callBack(reportPrice);

    return null;
  }

  /// *
  /// -  @description: 套餐列表
  /// -  @Date: 2022-07-19 15:34
  /// -  @parm: type : 1.vip 2.svip 3.慧眼币 4.企业增加人数 5.个人端慧眼币
  /// -  @return {*}
  ///
  static Future getProductList(
      Map<String, dynamic> param, NetworkListCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.getProductList, queryParameters: param);

    List pList = getProductModelList(response.data);
    ProductModel model = pList.first;
    model.isSelected = true;

    callBack(pList);

    return null;
  }

  /// *
  /// -  @description: 个人买报告
  /// -  @Date: 2022-07-19 15:34
  /// -  @parm: type : 1.vip 2.svip 3.慧眼币 4.企业增加人数 5.个人端慧眼币
  /// -  @return {*}
  ///
  static Future personBuyReport(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.personBuyReport, queryParameters: param);

    callBack(response.data.toString());
    return null;
  }

  /// *
  /// -  @description: 苹果内购
  /// -  @Date: 2022-07-19 15:34
  /// -  @parm: receipt 苹果凭证
  /// -  @return {*}
  ///
  static Future payApple(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postPayApple, queryParameters: param);

    callBack(response.data.toString());
    return null;
  }

  /// *
  /// -  @description: 公司买个人报告（生成订单）
  /// -  @Date: 2022-07-15 11:12
  /// -  @parm:
  ///     idCard	身份证
  ///     idCardName	姓名
  ///     phone	手机号
  ///     reportType	报告类型  1.99基础版 2.198普通 3.999高级
  /// -  @return {*}
  ///
  static Future<dynamic> createPersonBuyPersonReport(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.postOrderPersonBuyPersonReport,
        queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }

  /// *
  /// -  @description: 公司买个人报告,个人付款
  /// -  @Date: 2022-07-15 11:12
  /// -  @parm:
  ///     idCard	身份证
  ///     idCardName	姓名
  ///     phone	手机号
  ///     reportType	报告类型  1.99基础版 2.198普通 3.999高级
  /// -  @return {*}
  ///
  static Future<dynamic> companyBuyPersonReportPersonPay(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.companyBuyPersonReportPersonPay,
        queryParameters: param);
    callBack(response.data.toString());
    return response.data;
  }
}
