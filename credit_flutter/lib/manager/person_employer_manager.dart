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
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

///个人购买别人报告
class PersonEmployerManager {
  ///获取未认证，已支付的报告,返回授权报告id集合
  static getNotCertifiedReport(NetworkListCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doGet(NetworkingUrls.getNotCertifiedReport);

    List list = json.decode(response.data.toString());

    callBack(list);
  }
}
