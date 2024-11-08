/// *
/// @Date: 2022-06-14 13:59
/// @LastEditTime: 2022-06-15 10:01
/// @Description: block， 常用的一些回调
///
import 'package:credit_flutter/models/user_model.dart';

import '../models/networking_message_model.dart';

///网络回调
typedef NetworkMapCallBack = Function(Map<String, dynamic> map);
typedef NetworkListCallBack = Function(List<dynamic> list);
typedef NetworkStringCallBack = Function(String str);
typedef NetworkObjectCallBack = Function(Object object);
typedef NetworkMessageCallBack = Function(Message message);

///用户数据
typedef UserModelCallBack = Function(UserModel? model);

///校验账号合法性数据
typedef CheckAccountCallBack = Function(bool success, UserModel? uModel);

///检查微信支付信息
typedef WechatPayInfoCallBack = Function(bool success, String orderNumber);
