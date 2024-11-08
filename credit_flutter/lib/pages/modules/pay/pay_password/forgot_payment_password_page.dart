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
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../define/define_colors.dart';

//忘记支付密码
class ForgotPaymentPasswordPage extends StatefulWidget {
  const ForgotPaymentPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPaymentPasswordPage> createState() =>
      _ForgotPaymentPasswordPageState();
}

class _ForgotPaymentPasswordPageState extends State<ForgotPaymentPasswordPage> {
  UserModel? userModel;

  ///手机号
  String phoneNumberStr = "";

  ///倒计时变量
  Timer? _timer;

  ///倒计时数值
  var countdownTime = 0;

  ///倒计时文案
  String timeText = "获取验证码";

  ///验证码
  String codeStr = "";

  ///验证码
  final textCodeController = TextEditingController();

  ///新密码
  String newPasswordStr = "";

  ///处理新密码
  final textNewPasswordController = TextEditingController();

  ///确认密码
  String confirmPasswordStr = "";

  ///处理确认密码
  final textConfirmPasswordController = TextEditingController();

  ///密码错误信息
  String passwordErrorStr = "";

  @override
  void initState() {
    UserModel.getInfo((model) {
      if (model != null) {
        setState(() {
          userModel = model;
          phoneNumberStr = model.userInfo.telPhone;
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
              "忘记支付密码",
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
            child: Column(
              children: [
                _phoneNumberView(),
                _verificationCode(),
                _inputView("支付密码", textNewPasswordController, "请输入6位的数字支付密码"),
                _inputView(
                    "确认支付密码", textConfirmPasswordController, "请再次输入6位的数字支付密码"),
                _addErrorPrompt(passwordErrorStr),
                const SizedBox(
                  height: 50,
                ),
                WidgetTools().createCustomButton(
                  ScreenTool.screenWidth - 60,
                  "确定",
                  () {
                    determineAction({
                      "code": codeStr,
                      "newPassword": newPasswordStr,
                      "confirmPassword": confirmPasswordStr
                    });
                  },
                  bgColor: CustomColors.lightBlue,
                  textColor: CustomColors.whiteColor,
                  radius: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///手机号
  Widget _phoneNumberView() {
    return Column(
      children: [
        Container(
          height: 86,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "手机号",
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      StringTools.phoneEncryption(phoneNumberStr),
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: CustomColors.lineColor,
        ),
      ],
    );
  }

  ///验证码
  Widget _verificationCode() {
    Text suffixText = Text(
      timeText,
      style: const TextStyle(
        fontSize: 13,
        color: CustomColors.lightBlue,
      ),
    );
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "验证码",
            style: TextStyle(
              fontSize: 16,
              color: CustomColors.lightGrey,
            ),
          ),
          TextField(
            controller: textCodeController,
            onChanged: (str) {
              codeStr = str;
              reloadView();
            },
            cursorColor: Colors.black,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "请输入验证码",
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              suffixIcon: SizedBox(
                height: 56,
                child: GestureDetector(
                  onTap: () {
                    if (countdownTime == 0) {
                      statrTime();
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      suffixText,
                    ],
                  ),
                ),
              ),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          ),
          Container(
            height: 1,
            color: CustomColors.lineColor,
          ),
        ],
      ),
    );
  }

  Widget _inputView(
      String title, TextEditingController controller, String hintTextStr) {
    Text titleText = Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        color: CustomColors.lightGrey,
      ),
    );

    TextField textField = TextField(
      controller: controller,
      onChanged: (str) {
        passwordErrorStr = "";
        reloadView();

        if (controller == textNewPasswordController) {
          newPasswordStr = str;
        } else {
          confirmPasswordStr = str;
        }
      },
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintTextStr,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
    );
    Container line = Container(
      height: 1,
      color: CustomColors.lineColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        titleText,
        textField,
        line,
      ],
    );
  }

  /// *
  /// -  @description: 错误信息
  /// -  @Date: 2022-07-04 15:16
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _addErrorPrompt(String title) {
    return Offstage(
      offstage: StringTools.isEmpty(title),
      child: SizedBox(
        height: 20,
        child: Row(children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: CustomColors.warningColor,
            ),
          ),
        ]),
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
        countdownTime = countdownTime;
        handleCodeText();
      });
    };

    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  void handleCodeText() {
    if (countdownTime > 0) {
      timeText = "${countdownTime}s";
    } else {
      timeText = "获取验证码";
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  void reloadView() {
    setState(() {});
  }

  void statrTime() {
    LoginManager.sendPhoneVerifyCode({
      "phoneNumber": phoneNumberStr,
      "codeType": "4",
    }, (message) {
      countdownLogic();
    });
  }

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
      "codeType": "4",
      "code": code,
      "userPayPassword": md5Str
    };
    String rsaPassword = StringTools.generateRSA(temp);

    MineManager.updatePayPassword({"rsaEncryption": rsaPassword}, (message) {
      ToastUtils.showMessage("设置密码成功");
      Navigator.of(context).pop();
    });
  }

  bool _checkData(Map<String, String> map) {
    String? code = map["code"];
    String? password = map["newPassword"];
    String? confirmPassword = map["confirmPassword"];
    bool flag = true;
    if (StringTools.isEmpty(code)) {
      passwordErrorStr = "请输入验证码";
      flag = false;
      setState(() {});
      return flag;
    }
    if (StringTools.isEmpty(password)) {
      passwordErrorStr = "请输入新密码";
      flag = false;
      setState(() {});
      return flag;
    }
    if (StringTools.isEmpty(confirmPassword)) {
      passwordErrorStr = "请再次输入密码";
      flag = false;
      setState(() {});
      return flag;
    }
    if (password != confirmPassword) {
      passwordErrorStr = "密码不一致";
      flag = false;
      setState(() {});
      return flag;
    }

    setState(() {});
    return flag;
  }
}
