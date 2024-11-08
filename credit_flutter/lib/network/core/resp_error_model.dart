/*** 
 * @Date: 2022-06-07 13:52
 * @LastEditTime: 2022-06-07 13:53
 * @Description: 基础 错误模型
 */

import 'base_resp_data.dart';

class ResponseError extends BaseResponseData {
  ResponseError.fromJson(Map<String, dynamic> json) {
    respDesc = json["respDesc"];
    respCode = json["respCode"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["respDesc"] = respDesc;
    data["respCode"] = respCode;
    return data;
  }

  @override
  // TODO: implement success
  bool get success => false;
}
