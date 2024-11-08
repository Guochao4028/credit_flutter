/*** 
 * @Date: 2022-06-07 13:54
 * @LastEditTime: 2022-06-08 10:32
 * @Description: 异常
 */
class ResponseException implements Exception {
  int? errCode;
  String? errMsg;

  ResponseException({this.errCode});

  int? get errorCode => errCode;

//statusCode==200时候返回的data中存在的respCode
  String? get errorMessage {
    String msg = errMsg ?? "";
    switch (errCode) {
      case 403:
        msg = "非法访问!";
        break;
      default:
    }
    return msg;
  }

  @override
  String toString() {
    return 'RequestException{errorCode: $errorCode, errorMessage: $errorMessage}';
  }
}

class UnauthorizedError implements Exception {
  int? errCode;
  String errorMessage = "身份信息获取失败,请重新登录";

  UnauthorizedError({this.errCode});

  int? get errorCode => errCode;

  @override
  String toString() {
    return 'UnauthorizedError{errorCode: $errorCode, errorMessage: $errorMessage}';
  }
}
