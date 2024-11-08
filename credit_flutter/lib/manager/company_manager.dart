/// *
/// -  @Date: 2022-09-07 14:49
/// -  @LastEditTime: 2022-09-07 14:49
/// -  @Description: 公司
///
import 'dart:io';

import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/person_management_list_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/utils/toast_utils.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

import 'package:credit_flutter/utils/log.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:credit_flutter/network/dio_client.dart';

class CompanyManager {
  /// *
  /// -  @description: 公司人员管理列表
  /// -  @Date: 2022-09-07 14:53
  /// -  @parm:
  /// -  @return {*}
  ///
  static companyPersonManagementList(
      Map<String, dynamic> param, NetworkListCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.companyUser, queryParameters: param);
    response.data["data"];
    callBack(PersonManagementListModel.fromJson(response.data).data);
  }

  /// *
  /// -  @description: 查询公司增加人员剩余名额
  /// -  @Date: 2022-09-07 16:04
  /// -  @parm:
  /// -  @return {*}
  ///
  static companyPersonNumber(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.getPeopleNum, queryParameters: param);
    callBack(response.data.toString());
  }

  /// *
  /// -  @description: 新增公司管理人员
  /// -  @Date: 2022-09-09 14:14
  /// -  @parm:
  /// -  @return {*}
  ///
  static companyAddCompanyUser(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.companyUser, queryParameters: param);
    callBack(response.data.toString());
  }

  /// *
  /// -  @description: 修改公司人员状态
  /// -  @Date: 2022-09-09 16:59
  /// -  @parm: 状态 0.禁用 1.启用
  /// -  @return {*}
  ///
  static companyUserStatus(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.postCompanyUserStatus, queryParameters: param);
    callBack(response.data.toString());
  }

  /// *
  /// -  @description: 删除公司管理人员
  /// -  @Date: 2022-09-09 17:12
  /// -  @parm:
  /// -  @return {*}
  ///
  static companyUserDelete(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doDelete(NetworkingUrls.companyUser, queryParameters: param);
    callBack(response.data.toString());
  }

  /// 根据公司code获取公司信息
  static companyGetInfoByCode(String code, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.companyGetInfoByCode,
        queryParameters: {"code": code});
    callBack(response.data);
  }
}
