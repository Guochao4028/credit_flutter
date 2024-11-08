/*** 
 * @Date: 2022-06-07 13:16
 * @LastEditTime: 2022-06-07 13:17
 * @Description: 分发数据
 */
abstract class BaseResponseData {
  int? respCode;
  String? respDesc;
  dynamic attribute;
  dynamic data;
  bool get success;

  BaseResponseData({this.respCode, this.respDesc, this.attribute, this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $respCode, message: $respDesc, data: $attribute}';
  }
}
