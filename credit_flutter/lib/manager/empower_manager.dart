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

class EmpowerManager {
  /// 短信预授权，并调用e签宝
  static getMessagePrepareSign(
      Map<String, dynamic> param, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.messagePrepareSign, queryParameters: param);
    callBack(response.data);
    //https://smlt.esign.cn/hnpSeXmIctbB
  }
}
