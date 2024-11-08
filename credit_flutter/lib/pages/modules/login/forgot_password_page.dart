/***
 * @Date: 2022-05-26 10:26
 * @LastEditTime: 2022-05-27 17:03
 * @Description: 忘记密码
 */

import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/login/set_new_password_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class ForgotPasswordPage extends StatefulWidget {
  final PageType type;

  const ForgotPasswordPage({required this.type, Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //定义变量
  Timer? _timer;

  //倒计时数值
  var countdownTime = 0;

  //获取、处理 手机号格式
  final textController = TextEditingController();
  int _inputLength = 0;

  //验证码
  String verificationCodeStr = "";

  //手机号
  String phoneNumberStr = "";
  bool isPhoneNumber = false;
  bool isPhoneCorrect = false;

  @override
  void initState() {
    super.initState();
    UserModel.getInfo((model) {
      if (model != null) {
        phoneNumberStr = model.userInfo.telPhone;
        textController.text = phoneNumberStr;
        setState(() {});
      }
    });
    UmengCommonSdk.onPageStart("forgot_password_page");
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
    UmengCommonSdk.onPageEnd("forgot_password_page");
  }

  @override
  Widget build(BuildContext context) {
    //输入框总体宽度
    double wholeWidth = ScreenTool.screenWidth - 32 - 23;
    //输入框总体高度
    double wholeHeight = 56;

    return Container(
      child: Scaffold(
        //导航
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            //列布局
            children: [
              //标题
              _pCreatePageTitle("账号验证", "输入手机号及验证码备份"),
              //占位置
              const SizedBox(
                height: 50,
              ),
              _pCreatesTextFileld(
                18,
                "assets/images/phone.png",
                "请输入手机号",
                TextInputType.phone,
                wholeWidth,
                wholeHeight,
              ),
              if (isPhoneNumber) addErrorPrompt('手机号错误'),
              _pCreatesVerificationCodeTextFileld(
                18,
                "assets/images/loginCode.svg",
                "请输入验证码",
                TextInputType.number,
                wholeWidth,
                wholeHeight,
              ),
              //占位置
              const SizedBox(
                height: 60,
              ),
              //下一步按钮
              _pCreateMaterialButton(
                ScreenTool.screenWidth - 32,
                "下一步",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /***
   * @description: 创建一个容器，容器放着标题，子标题
   * @Date: 2022-05-26 11:21
   * @parm: title 主标题， subtitle 子标题
   * @return 容器放着标题，子标题
   */
  Container _pCreatePageTitle(String title, String subtitle) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: CustomColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  /***
   * @description: 生成按钮  主要是下一步按钮
   * @Date: 2022-05-26 11:51
   * @parm:  buttonWidth 按钮宽，title 按钮上的文字
   * @return 按钮
   */
  MaterialButton _pCreateMaterialButton(double buttonWidth, String title) {
    //背景颜色CustomColors.greyBlack
    // Color bgColor = Colors.blue;
    Color bgColor = CustomColors.greyBlack;
    // 字体颜色
    Color textColor = Colors.white;
    return WidgetTools().createMaterialButton(
      buttonWidth,
      title,
      bgColor,
      textColor,
      0,
      () => next(),
    );
  }

  /***
   * @description: 提交数据验证
   * @Date: 2022-06-14 20:18
   * @parm: {"flag": bool, "errorStr": errorStr}
   * @return {*}
   */
  Map<String, dynamic> dataValidation() {
    bool flag = false;
    String error = "";

    if (phoneNumberStr.length == 0) {
      return {
        "flag": flag,
        "errorStr": FinalKeys.PHONE_NUMBER_ERROR,
      };
    }

    if (verificationCodeStr.length == 0) {
      return {
        "flag": flag,
        "errorStr": FinalKeys.VERIFICATION_CODE_ERROR,
      };
    }
    if (verificationCodeStr.length > 6) {
      return {
        "flag": flag,
        "errorStr": FinalKeys.VERIFICATION_CODE_LENGTH_ERROR
      };
    }

    flag = true;

    return {
      "flag": flag,
      "errorStr": "",
    };
  }

  void next() {
    Map map = dataValidation();

    bool flag = map["flag"];
    String errorStr = map["errorStr"];
    if (flag == false) {
      ToastUtils.showMessage(errorStr);
      return;
    }

    String codeType = "4";
    if (widget.type == PageType.payPassword) {
      codeType = FinalKeys.PHONE_CODE_TYPE_FORGET_PAY;
    } else {
      codeType = FinalKeys.PHONE_CODE_TYPE_FORGET_PASSWORD;
    }

    // /调校验接口 验证手机号 验证码
    LoginManager.codeCheck({
      "phoneNumber": phoneNumberStr,
      "code": verificationCodeStr,
      "codeType": codeType
    }, (message) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SetNewPasswordPage(
            phoneNumber: phoneNumberStr,
            phoneCode: verificationCodeStr,
            type: widget.type,
          ),
        ),
      );
    });
  }

  /**
   * @description: 自定义输入框
   * @return SizedBox 带有大小的盒子
   * @parm:
   *
   * iconSize 左图标的宽高
   * imageAssetPath 左图标的资源地址
   * placeholder 提示文字
   * keyboardType 键盘的显示类型
   * wholeWidth  SizedBox的宽度
   * wholeHeight  SizedBox的高度
   */
  SizedBox _pCreatesTextFileld(
    double iconSize,
    String imageAssetPath,
    String placeholder,
    TextInputType keyboardType,
    double wholeWidth,
    double wholeHeight,
  ) {
    Image iconImage = Image(
      image: AssetImage(imageAssetPath),
      width: iconSize,
      height: iconSize,
    );
    UnderlineInputBorder focusedBorder = const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black12,
      ),
    );

    return SizedBox(
      width: wholeWidth,
      height: wholeHeight,
      child: TextField(
        // enabled: phoneNumberStr.isEmpty ? true : false,
        controller: textController,
        onChanged: (text) {
          _inputLength = StringTools()
              .splitPhoneNumber(text, textController, _inputLength);
          setState(() {
            if (_inputLength == 13) {
              text = text.substring(0, _inputLength);
              var phone = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
              var hasMatch = RegexUtils.verifyPhoneNumber(phone);
              isPhoneCorrect = hasMatch;
              isPhoneNumber = !hasMatch;
              if (isPhoneCorrect == true) {
                phoneNumberStr = phone;
              }
            } else {
              isPhoneCorrect = false;
              isPhoneNumber = false;
            }
          });
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: placeholder,
          hintText: placeholder,
          focusedBorder: focusedBorder,
          icon: iconImage,
        ),
      ),
    );
  }

  //验证码
  SizedBox _pCreatesVerificationCodeTextFileld(
    double iconSize,
    String imageAssetPath,
    String placeholder,
    TextInputType keyboardType,
    double wholeWidth,
    double wholeHeight,
  ) {
    Container iconImage = Container(
      width: iconSize,
      height: iconSize,
      child: SvgPicture.asset(
        imageAssetPath,
      ),
    );
    UnderlineInputBorder focusedBorder = const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black12,
      ),
    );

    Text suffixText = Text(
      handleCodeText(),
      style: const TextStyle(
        fontSize: 13,
        color: CustomColors.lightBlue,
      ),
    );

    return SizedBox(
      width: wholeWidth,
      height: wholeHeight,
      child: TextField(
        onChanged: (text) {
          verificationCodeStr = text;
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: placeholder,
          hintText: placeholder,
          focusedBorder: focusedBorder,
          icon: iconImage,
          suffixIcon: Container(
            height: 56,
            child: GestureDetector(
              onTap: () {
                //收键盘
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
                //是否还在读秒，没有读秒 验证码逻辑
                if (countdownTime == 0) {
                  //判断手机号格式
                  if (phoneNumberStr.length > 0) {
                    String codeType = FinalKeys.PHONE_CODE_TYPE_FORGET_PASSWORD;
                    if (widget.type == PageType.payPassword) {
                      codeType = FinalKeys.PHONE_CODE_TYPE_FORGET_PAY;
                    } else {
                      codeType = FinalKeys.PHONE_CODE_TYPE_FORGET_PASSWORD;
                    }

                    //发送验证码
                    LoginManager.sendPhoneVerifyCode(
                        {"codeType": codeType, "phoneNumber": phoneNumberStr},
                        (message) => {
                              if (message.isSuccess)
                                {countdownLogic()}
                              else
                                {ToastUtils.showMessage(message.reason)}
                            });
                  } else {
                    ToastUtils.showMessage(FinalKeys.PHONE_NUMBER_ERROR);
                  }
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
        print(countdownTime);
        if (countdownTime < 1) {
          _timer?.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(Duration(seconds: 1), call);
  }

  String handleCodeText() {
    if (countdownTime > 0) {
      return "${countdownTime}s";
    } else
      return "获取验证码";
  }

  Container addErrorPrompt(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 34),
      margin: const EdgeInsets.only(left: 10),
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
    );
  }
}
