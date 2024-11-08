import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:dio/dio.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

/// *
/// @Date: 2022-06-14 10:47
/// @LastEditTime: 2022-06-15 04:45
/// @Description: 企业认证
class EnterpriseInfoManager {
  static uploadFile(String file, NetworkStringCallBack callBack) async {
    FormData formData = FormData();
    formData.files.add(MapEntry("file", await MultipartFile.fromFile(file)));
    Response<dynamic> response = await DioClient().uploadFile(formData);
    callBack(response.data);
  }

  static editInfo(
      Map<String, dynamic> param, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient().doPost(
        NetworkingUrls.companyUpdateCompanyInfo,
        queryParameters: param);
    callBack(response.data);
  }

  static addCompany(
      Map<String, dynamic> param, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.companyAddCompany, queryParameters: param);
    callBack(response.data);
  }

  static newShow(NetworkMessageCallBack callBack) async {
    Response<dynamic> response =
        await DioClient().doGet(NetworkingUrls.newShow);

    ///是否隐藏
    bool isHidden = true;
    String reason = "";
    if (response.data == "0") {
      isHidden = true;
    } else {
      isHidden = false;
    }

    callBack(Message(isHidden, reason));
  }

  static getAgencyName(
      String agencyCode, NetworkStringCallBack callBack) async {
    Response<dynamic> response = await DioClient().doGet(
        NetworkingUrls.getAgencyName,
        queryParameters: {"agencyCode": agencyCode});
    callBack(response.data);
  }
}
