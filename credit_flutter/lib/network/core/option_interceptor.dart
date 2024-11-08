///* @Date: 2022-06-07 13:19
///* @LastEditTime: 2022-06-16 09:54
///* @Description: 拦截器
///*/
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

//Option拦截器可以用来统一处理Option信息 可以在这里添加
class OptionInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = FinalKeys.baseServer();
    String clientDeviceStr = "";
    if (PlatformUtils.isWeb) {
      clientDeviceStr = "3";
    } else if (PlatformUtils.isIOS) {
      clientDeviceStr = "4";
    } else if (PlatformUtils.isAndroid) {
      clientDeviceStr = "5";
    }

    options.headers["model_id"] = Golbal.modelId;

    options.headers["model"] = Golbal.model;
    options.headers["manufacturer"] = Golbal.manufacturer;
    options.headers["brand"] = Golbal.brand;
    options.headers["systemName"] = Golbal.systemName;
    options.headers["equipmentModel"] = Golbal.equipmentModel;
    options.headers["systemVersion"] = Golbal.systemVersion;

    //app版本
    options.headers["appVersion"] = Golbal.appVersion;

    options.headers["clientDevice"] = clientDeviceStr;
    if (Golbal.clientId.isNotEmpty){
      options.headers["cid"] = Golbal.clientId;
    }
    if (Golbal.token.isEmpty) {
      if (Golbal.golbalToken.isNotEmpty) {
        options.headers["token"] = Golbal.golbalToken;
      } else {
        UserModel.getInfo((model) {
          if (model != null) {
            options.headers["token"] = model.accessToken;
          }
        });
      }
    } else {
      options.headers["token"] = Golbal.token;
    }

    options.headers["Content-Type"] = "application/json";
    debugPrint("options..headers:----> ${options.headers}");

    debugPrint(
        "request:---->${options.method}\t url-->${options.baseUrl}${options.path}?${options.queryParameters}");

    if (options.queryParameters["hideLoading"] != true) {
      EasyLoading.show();
    }

    return handler.next(options);
  }
}
