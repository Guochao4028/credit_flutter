/// *
/// -  @Date: 2022-09-16 13:43
/// -  @LastEditTime: 2022-09-16 14:33
/// -  @Description:
///
import 'dart:collection';

import 'package:credit_flutter/models/set_meal_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:dio/dio.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

class VIPManager {
  static getUserInfo(NetworkObjectCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doGet(NetworkingUrls.getUserInfo);
    callBack(UserInfo.fromJson(response.data));
  }

  static getProductList(int type, NetworkListCallBack callBack) async {
    Map<String, dynamic> param = HashMap();
    param["type"] = type;
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.productList, queryParameters: param);

    callBack(getSetMealBeanList(response.data));
  }

  static orderCompanyVipUpGrade(NetworkStringCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doPost(NetworkingUrls.orderCompanyVipUpGrade);
    callBack(response.data.toString());
  }

  static productVipUpGrade(NetworkStringCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doGet(NetworkingUrls.productVipUpGrade);
    callBack(response.data.toString());
  }
}
