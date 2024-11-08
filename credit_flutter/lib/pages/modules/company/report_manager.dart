import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/network/dio_client.dart';
import 'package:dio/dio.dart';

/// *
/// @Date: 2022-06-14 10:47
/// @LastEditTime: 2022-06-15 04:45
/// @Description: 企业认证
class ReportManager {
  /// *
  /// @description: 判断手机号是否注册过
  /// @Date: 2022-06-14 10:49
  /// @parm: 手机号
  /// @return {*}
  static uploadFile(String file, NetworkStringCallBack callBack) async {
    FormData formData = FormData();
    formData.files.add(MapEntry("file", await MultipartFile.fromFile(file)));
    Response<dynamic> response = await DioClient().uploadFile(formData);
    callBack(response.data);
  }

  static commonTip(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doGet(NetworkingUrls.commonTip, queryParameters: param);
    callBack(response.data);
  }

  static demandCenterReport(
      Map<String, dynamic> param, NetworkObjectCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.demandCenterReport, queryParameters: param);
    callBack(response.data);
  }
}
