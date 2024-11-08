/// *
/// -  @Date: 2022-08-19 11:22
/// -  @LastEditTime: 2022-09-07 15:20
/// -  @Description:
///
//
///* @Date: 2022-06-07 13:41
///* @LastEditTime: 2022-06-16 17:12
///* @Description: 拦截器 数据初步处理
///*/
import 'dart:convert';

import 'package:credit_flutter/main.dart';
import 'package:credit_flutter/network/core/resp_data_model.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'resp_error_model.dart';
import 'response_exception.dart';

class RequestInterceptor extends InterceptorsWrapper {
  var skip = {
    "10081": "验证原支付密码错误",
    "10106": "未知",
    "10116": "已认证",
    "10118": "认证失败",
  };

  //请求后 成功走这里
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    EasyLoading.dismiss();
    Log.i("-------onResponse STATR----------");

    Log.i(response);

    Log.i("--------onResponse END---------");

    if (response.statusCode == 200) {
      //访问正确有返回值的情况
      if (response.data is Map) {
        //将数据脱壳需要返回自己的数据
        ResponseData responseData = ResponseData.fromJson(response.data);
        if (responseData.success) {
          if (ifCode(responseData.respCode.toString())) {
            return;
          }
          response.statusCode = responseData.respCode;
          response.data = responseData.data;
          response.statusMessage = responseData.respDesc;
          return handler.resolve(response);
        }
        return handler.resolve(response);
      } else if (response.data is String) {
        //字符串转map
        Map<String, dynamic> jsonMap = jsonDecode(response.data);
        if (ifCode(jsonMap["code"].toString())) {
          return;
        }
        if (jsonMap["code"].toString() == "200" ||
            skip[jsonMap["code"]] != null) {
          ResponseData responseData = ResponseData.fromJson(jsonMap);
          response.statusCode = responseData.respCode;
          response.data = responseData.data;
          response.statusMessage = responseData.respDesc;
          return handler.resolve(response);
        } else {
          ResponseError model =
              ResponseError.fromJson(jsonDecode(response.data));
          if (ifCode(model.respCode.toString())) {
            return;
          }
          response.statusCode = model.respCode;
          if (model.respCode == 403 || model.respCode == 402) {
            //做些什么
            throwUnauthorizedError(response);
          } else {
            ToastUtils.showMessage(jsonMap["msg"].toString());
            // throwError(response);
          }
        }
      } else {
        throwError(response);
      }
    } else {
      throwError(response);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    EasyLoading.dismiss();
    throw DioError(
        requestOptions: err.requestOptions,
        type: err.type,
        error: err,
        response: err.response);
  }

  ////抛出异常 留给baseModel去统一处理
  void throwError(Response<dynamic> response) {
    throw DioError(
        requestOptions: response.requestOptions,
        error: ResponseException(errCode: response.statusCode));
  }

  ///鉴权错误
  void throwUnauthorizedError(Response<dynamic> response) {
    throw DioError(
        requestOptions: response.requestOptions,
        error: UnauthorizedError(errCode: response.statusCode));
  }

  bool ifCode(String code) {
    if (code == "10018") {
      ToastUtils.showMessage("token过期");
      try {
        LoginTools.loginOut(navigatorKey.currentState!.overlay!.context);
      } catch (_) {}
      return true;
    }
    return false;
  }

// void _loginOut() {
//   var context = navigatorKey.currentState?.overlay?.context;
//   if (context != null) {
//     ///清空用户数据
//     UserModel.removeUserInfo();
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => const LoginTypePage()),
//         (route) => route == null);
//   }
// }
}
