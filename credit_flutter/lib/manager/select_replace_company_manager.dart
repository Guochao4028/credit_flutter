import 'dart:collection';

import 'package:credit_flutter/models/select_replace_company_bean.dart';
import 'package:dio/dio.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

class SelectReplaceCompanyManager {
  static companyLeaveCompany(NetworkStringCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doGet(NetworkingUrls.companyLeaveCompany);

    callBack(response.data.toString());
  }

  static getCompanyList(String name, NetworkListCallBack callBack) async {
    Map<String, dynamic> param = HashMap();
    param["name"] = name;
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.getCompanyList, queryParameters: param);

    callBack(getSelectReplaceCompanyBeanList(response.data));
  }

  static changeCompany(String companyId, NetworkStringCallBack callBack) async {
    Map<String, dynamic> param = HashMap();
    param["companyId"] = companyId;
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.changeCompany, queryParameters: param);
    callBack(response.data.toString());
  }
}
