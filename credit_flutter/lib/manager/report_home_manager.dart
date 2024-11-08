// ignore_for_file: unused_import

/// *
/// -  @Date: 2022-06-17 14:14
/// -  @LastEditTime: 2022-06-17 14:17
/// -  @Description: 背调公司
///
import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/models/back_check_company_info_model.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/models/company_report_home_bean.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/models/report_home_bean.dart';
import 'package:credit_flutter/network/dio_client.dart';
import 'package:dio/dio.dart';

class ReportHomeManager {
  /// -  @description: 企业授权列表
  static getAuthorizeList(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.reportAuthCompanyList, queryParameters: param);
    callBack(ReportHomeBean.fromJson(response.data));
  }

  /// -  @description: 个人授权列表
  static getPersonList(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.reportAuthPersonList, queryParameters: param);
    callBack(CompanyReportHomeBean.fromJson(response.data));
  }

  /// 个人同意授权
  static reportAuthPersonAgreeAuth(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.reportAuthPersonAgreeAuth,
        queryParameters: param);
    callBack(response.data.toString());
  }

  /// 个人拒绝授权
  static reportAuthPersonRefuseAuth(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.reportAuthPersonRefuseAuth,
        queryParameters: param);
    callBack(response.data.toString());
  }

  /// 重复发送短信
  static reportAuthMessageAgain(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.reportAuthMessageAgain, queryParameters: param);
    callBack(response.data.toString());
  }

  /// 通过报告授权id，获取授权信息
  static getCompanyNameForMessage(
      Map<String, dynamic> param, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.companyNameForMessage, queryParameters: param);
    callBack(response.data);
  }

  /// 通过报告授权id，获取授权信息
  static companyNameForMessage(
      Map<String, dynamic> param, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.companyNameForMessage, queryParameters: param);

    callBack(response.data);
  }

  /// 舆情申报添加
  static reportPublicOpinion(
      Map<String, dynamic> param, NetworkMessageCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.reportPublicOpinion, queryParameters: param);

    bool flag = true;
    String reason = "";
    if (response.statusCode != 200) {
      flag = false;
    }

    callBack(Message(flag, reason));
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
}
