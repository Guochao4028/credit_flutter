/*** 
 * @Date: 2022-06-07 13:44
 * @LastEditTime: 2022-06-16 17:14
 * @Description: 分发 基础数据模型
 */
import 'base_resp_data.dart';

class ResponseData extends BaseResponseData {
  @override
  bool get success => respCode != null || data != null;

  ResponseData.fromJson(Map<String, dynamic> json) {
    if (json['code'] != null && json['code'] is String) {
      json['code'] = int.parse(json['code']);
    }
    print(json["code"]);
    respCode = json['code'];
    respDesc = json['msg'];
    attribute = json["data"];
    if (attribute != null) {
      // if (attribute is Map && attribute.containsKey("data")) {
      //   data = attribute['data'];
      // } else {
      data = attribute;
      // }
    } else {
      data = json;
    }
  }
}
