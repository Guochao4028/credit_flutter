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
import 'package:credit_flutter/models/comment_bean.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/network/dio_client.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:dio/dio.dart';

class BackCheckCompanyManager {
  /// *
  /// -  @description: 背调公司列表
  /// -  @Date: 2022-06-17 14:19
  /// -  @parm:
  /// -  @return {*}
  ///
  static list(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.backCheckCompanyList, queryParameters: param);
    callBack(BackCheckCompanyListModel.fromJson(response.data));
  }

  /// *
  /// -  @description: 背调公司详情
  /// -  @Date: 2022-06-17 14:26
  /// -  @parm: id 公司id
  /// -  @return {*}
  ///
  static info(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.backCheckCompanyInfo, queryParameters: param);

    callBack(BackCheckCompanyInfoModel.fromJson(response.data));
  }

  /// *
  /// -  @description: 评论列表
  /// -  @Date: 2022-06-17 14:26
  /// -  @parm: id 公司id
  /// -  @return {*}
  ///
  static commentList(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.backCheckCompanyComment, queryParameters: param);
    callBack(CommentBean.fromJson(response.data));
  }

  /// *
  /// -  @description: 评论列表
  /// -  @Date: 2022-06-17 14:26
  /// -  @parm: id 公司id
  /// -  @return {*}
  ///
  static commentLike(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.backCheckCompanyCommentLike,
        queryParameters: param);
    callBack(response.data);
  }

  /// *
  /// -  @description: 评论
  /// -  @Date: 2022-06-17 14:26
  /// -  @parm: id 公司id
  /// -  @return {*}
  ///
  static putComment(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.backCheckCompanyComment, queryParameters: param);
    Log.i(response.toString());
    callBack(response.data);
  }
}
