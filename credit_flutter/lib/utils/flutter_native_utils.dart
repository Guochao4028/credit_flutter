// import 'dart:js' as js;

import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/services.dart';

/// *
/// -  @Date: 2022-07-15 17:46
/// -  @LastEditTime: 2022-08-12 19:34
/// -  @Description: 处理Native通信
///
class NativeUtils {
  //channel_name每一个通信通道的唯一标识，在整个项目内唯一！！！
  static const _channel = MethodChannel(FinalKeys.NATIVE_CHANNEL_PAY);

  /*
 * MethodChannel
 * 在方法通道上调用方法invokeMethod
 * methodName 方法名称
 * params 发送给原生的参数，自定义基本数据格式{"code":100,"message":"消息","content":内容}
 * return数据 原生发给Flutter的参数,自定义基本数据格式{"code":100,"message":"消息","content":内容}
 */
  static Future<Map> toolsMethodChannelMethodWithParams(String methodName,
      {Map<String, dynamic>? params}) async {
    var res = {};
    try {
      res = await _channel.invokeMethod(methodName, params);
    } catch (e) {
      Log.e(e);
    }
    return res;
  }
}

class NativeJSUtlis {
  static aliPayH5(String params) {
    //调用Js的方法
    // js.context.callMethod("aliPay", [params]);
  }

  static deleteManngaer(Map params) {
    //调用Js的方法
    // js.context.callMethod("deleteManngaer", [params]);
  }

  static getFile(String params) {
    //调用Js的方法
    // js.context.callMethod("getFile", [params]);
  }

  static selectPicture(String params) {
    //调用Js的方法
    // js.context.callMethod("pictureSelection", [params]);
  }

  static wxpay(String params) {
    //调用Js的方法
    // js.context.callMethod("wxPay", [params]);
  }

  static wechatLogin(String params) {
    //调用Js的方法
    // js.context.callMethod("wechatLogin", [params]);
  }

  static mlgmmp(String params) {
    //调用Js的方法
    // js.context.callMethod("mlgmmp", [params]);
  }

  static reload(String params) {
    //调用Js的方法
    // js.context.callMethod("reload", [params]);
  }

  static wxLogin(String params) {
    //调用Js的方法
    // js.context.callMethod("wxLogin", [params]);
  }

  static wxMiniPayHandle(String params) {
    //调用Js的方法
    // js.context.callMethod("wxMiniProgramPayHandle", [params]);
  }

  static openEmpower(String params) {
    //调用Js的方法
    // js.context.callMethod("openEmpower", [params]);
  }
}
