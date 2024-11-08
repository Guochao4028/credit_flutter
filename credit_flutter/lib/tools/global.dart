/// *
/// -  @Date: 2022-07-25 17:48
/// -  @LastEditTime: 2022-07-25 17:48
/// -  @Description: 全局
///
import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/notification.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Golbal {
  Golbal._internal();

  //登录成功后的操作
  static bool isStorage = false;

  static const _channel = MethodChannel("NATIVE_CHANNEL");

  static String token = "";

  static String golbalToken = "";

  //指纹 唯一标识此构建的字符串
  static String modelId = "";

  //cid 用于远程推送
  static String clientId = "";

  //（设备的型号。）
  static String model = "";

  // （生产厂商）
  static String manufacturer = "";

  // (品牌)
  static String brand = "";

  //（设备上运行的操作系统的名称。）
  static String systemName = "";

  //（手机型号）
  static String equipmentModel = "";

  //（Android系统版本）
  static String systemVersion = "";

  //（Android系统版本）
  static String appVersion = "";

  //总代理商id
  static String generalAgent = "";

  static CustomChangeNotifier changeNotifier = CustomChangeNotifier();

  //授权列表选中状态
  static int currentIndex = 1;

  //消息选中的报告id
  static String reportId = "";

  static bool isWX = false;

  //用户登录状态
  static String loginType = "";

  static Golbal instance = Golbal._internal();

  ///查看报告样例按钮是否展示
  static bool isSampleReport = true;

  ///底部报告按钮是否开启
  static bool bottomReport = true;

  ///报告详情内部顺序
  static int reportOrder = 1;

  static getInstance() {
    return instance;
  }

  /// *
  /// -  @description: 账号是否可以正常请求
  /// -  @Date: 2022-10-08 18:44
  /// -  @parm: callBack 回调 true =》 正常。 false不正常
  /// -  @return {*}
  ///
  static checkAccount(CheckAccountCallBack callBack) {
    String jsonStr = Golbal.token;
    if (jsonStr.isEmpty) {
      return;
    }
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 取出数据
    _prefs.then((sp) {
      ///获取用户登录状态
      ///1，企业。2，用户
      String loginType = sp.getString(FinalKeys.LOGIN_TYPE) ?? "1";
      if (loginType == "1") {
        MineHomeManager.userUpdateUserInfo((message) {
          UserModel.getInfo((model) {
            if (model != null) {
              UserInfo userInfo = model.userInfo;
              if (userInfo.owner == 1) {
                callBack(true, model);
              } else {
                switch (userInfo.childStatus) {
                  ///子账号状态 0.禁用 1.启用 2.过期 3.删除
                  case 0:
                  case 2:
                  case 3:
                    callBack(false, model);
                    break;
                  case 1:

                    ///启用
                    callBack(true, model);
                    break;
                  default:
                }
              }
            }
          });
        });
      } else {
        ///启用
        UserModel.getInfo((model) {
          if (model != null) {
            callBack(true, model);
          }
        });
      }
    });
  }

  /// *
  /// -  @description: 微信支付信息
  /// -  @Date: 2022-10-08 18:44
  /// -  @parm: callBack 回调 true =》 正常。 false不正常
  /// -  @return {*}
  ///
  static checkWechatPayInfo(WechatPayInfoCallBack callBack) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // 取出数据
    _prefs.then((sp) {
      // IS_WECHAT_PAY_INFO

      bool isWechatPayInfo = sp.getBool(FinalKeys.IS_WECHAT_PAY_INFO) ?? false;

      String orderId =
          sp.getString(FinalKeys.SHARED_PREFERENCES_ORDER_ID) ?? "";

      if (orderId.isNotEmpty) {
        Map map = StringTools.json2Map(orderId);

        callBack(isWechatPayInfo, map["orderId"]);
      } else {
        callBack(isWechatPayInfo, "");
      }
    });
  }

  factory Golbal() => getInstance();
}
