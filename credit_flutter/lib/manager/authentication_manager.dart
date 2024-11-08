/// *
/// -  @Date: 2022-09-07 14:49
/// -  @LastEditTime: 2022-09-07 14:49
/// -  @Description: 公司
///
import 'package:dio/dio.dart';

import '../define/define_block.dart';
import '../define/define_url.dart';
import '../network/dio_client.dart';

class AuthenticationManager {
  static appVerify(
      Map<String, dynamic> param, NetworkMapCallBack callBack) async {
    Response<dynamic> response = await DioClient()
        .doPost(NetworkingUrls.appVerify, queryParameters: param);
    callBack(response.data);
  }
}
