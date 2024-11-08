/// *
/// -  @Date: 2022-07-11 14:35
/// -  @LastEditTime: 2022-07-11 14:36
/// -  @Description:
///
/// *
/// -  @Date: 2022-07-11 14:35
/// -  @LastEditTime: 2022-07-11 14:35
/// -  @Description: 设置支付密码
///
import 'dart:async';

import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';

import '../../../../define/define_colors.dart';
import 'pay_password_successful.dart';
import 'pay_password_view/pay_password_view_page.dart';

class PaySetupPasswordPage extends StatefulWidget {
  const PaySetupPasswordPage({Key? key}) : super(key: key);

  @override
  State<PaySetupPasswordPage> createState() => _PaySetupPasswordPageState();
}

class _PaySetupPasswordPageState extends State<PaySetupPasswordPage>
    implements PaySetupPasswordPageViewClickListener {
  PaySetupPasswordPageView? view;
  UserModel? userModel;
  String phoneNumberStr = "";

  //定义变量
  Timer? _timer;

  //倒计时数值
  var countdownTime = 0;

  @override
  void initState() {
    UserModel.getInfo((model) {
      if (model != null) {
        setState(() {
          userModel = model;
          phoneNumberStr = model.userInfo.telPhone;
          view = PaySetupPasswordPageView(
            phoneNumberStr: model.userInfo.telPhone,
            clickListener: this,
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.color1B7CF6,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "设置支付密码",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: BaseBody(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: view?.paySetupPasswordView(),
          ),
        ),
      ),
    );
  }

  /***
   * @description: 倒计时逻辑 先toast 在倒计时
   * @Date: 2022-06-15 01:40
   * @parm:
   * @return {*}
   */
  void countdownLogic() {
    ToastUtils.showMessage(FinalKeys.VERIFICATION_CODE_SEND_SUCCESSFUL);
    //开始读秒
    startCountdown();
  }

  //倒计时方法
  startCountdown() {
    countdownTime = 60;
    final call = (timer) {
      setState(() {
        if (countdownTime < 1) {
          _timer?.cancel();
        } else {
          countdownTime -= 1;
        }
        view!.countdownTime = countdownTime;
        handleCodeText();
      });
    };

    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  void handleCodeText() {
    if (countdownTime > 0) {
      view!.timeText = "${countdownTime}s";
    } else {
      view!.timeText = "获取验证码";
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  @override
  void reloadView() {
    setState(() {});
  }

  @override
  void statrTime() {
    LoginManager.sendPhoneVerifyCode({
      "phoneNumber": phoneNumberStr,
      "codeType": "3",
    }, (message) {
      countdownLogic();
    });
  }

  @override
  void determineAction(Map<String, String> map) {
    if (_checkData(map) == false) {
      return;
    }

    String? code = map["code"];
    String? password = map["newPassword"];
    String? confirmPassword = map["confirmPassword"];

    String newPassword = password! + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5Str = StringTools.generateMD5(newPassword);

    Map<String, dynamic> temp = {
      "type": "1",
      "phone": phoneNumberStr,
      "codeType": "3",
      "code": code,
      "userPayPassword": md5Str
    };
    String rsaPassword = StringTools.generateRSA(temp);

    MineManager.updatePayPassword({"rsaEncryption": rsaPassword}, (message) {
      UserModel.getInfo((model) {
        if (model != null) {
          model.userInfo.ifSet = 1;
          UserModel.saveUserInfo(model.toJson());
        }
      });

      Golbal.changeNotifier.sendMessage({"": ""});

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PayPasswordSuccessful(
            title: "恭喜您设置支付密码成功",
            popNumebr: 2,
          ),
        ),
      );
    });
  }

  bool _checkData(Map<String, String> map) {
    String? code = map["code"];
    String? password = map["newPassword"];
    String? confirmPassword = map["confirmPassword"];
    bool flag = true;
    if (StringTools.isEmpty(code)) {
      view!.passwordErrorStr = "请输入验证码";
      flag = false;
      setState(() {});
      return flag;
    }
    if (StringTools.isEmpty(password)) {
      view!.passwordErrorStr = "请输入新密码";
      flag = false;
      setState(() {});
      return flag;
    }
    if (StringTools.isEmpty(confirmPassword)) {
      view!.passwordErrorStr = "请再次输入密码";
      flag = false;
      setState(() {});
      return flag;
    }
    if (password != confirmPassword) {
      view!.passwordErrorStr = "密码不一致";
      flag = false;
      setState(() {});
      return flag;
    }

    setState(() {});
    return flag;
  }
}
