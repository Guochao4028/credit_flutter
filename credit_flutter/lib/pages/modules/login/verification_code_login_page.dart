// ignore_for_file: unnecessary_new

/***
 * @Date: 2022-05-26 13:51
 * @LastEditTime: 2022-06-16 16:32
 * @Description: 验证码登录
 */
import 'dart:async';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/pages/modules/login/registered_account.dart';
import 'package:credit_flutter/pages/modules/web/web_page.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'forgot_password_page.dart';

class VerificationCodeLoginPage extends StatefulWidget {
  final LoginType type;

  const VerificationCodeLoginPage({Key? key, required this.type})
      : super(key: key);

  @override
  State<VerificationCodeLoginPage> createState() =>
      _VerificationCodeLoginPageState();
}

class _VerificationCodeLoginPageState extends State<VerificationCodeLoginPage> {
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
  bool isReading = false;
  TapGestureRecognizer userRecognizer = TapGestureRecognizer();
  TapGestureRecognizer privacyRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    userRecognizer.onTap = () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              const WebViewPage("用户协议", NetworkingUrls.h5AllRegisterUrl),
        ),
      );
    };
    privacyRecognizer.onTap = () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              const WebViewPage("隐私协议", NetworkingUrls.h5AllPrivacyPolicyUrl),
        ),
      );
    };
    UmengCommonSdk.onPageStart("verification_code_login_page");
  }

  @override
  Widget build(BuildContext context) {
    //输入框总体宽度
    double wholeWidth = ScreenTool.screenWidth - 32 - 23;
    //输入框总体高度
    double wholeHeight = 56;
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
            // .pushNamedAndRemoveUntil("/login", (route) => route == null);
          },
        ),
        title: Container(
          child: Row(
            children: [
              Expanded(child: SizedBox()),
              _pCreateTextButton("账号登录", Colors.black, 16,
                  InkWellTapType.verificationCode, null),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          //点击空白处回收键盘
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            //列布局
            children: [
              Container(
                child: Text(
                  "验证码登录",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width: ScreenTool.screenWidth - 32,
              ),

              const SizedBox(height: 60), //挤位置
              Container(
                //输入最外层的容器
                height: 132,
                child: Column(
                  //输入手机号和密码
                  children: [
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
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              //忘记密码 和注册
              Container(
                child: Row(
                  children: [
                    //忘记密码
                    _pCreateTextButton("忘记密码", CustomColors.lightGrey, 13,
                        InkWellTapType.forgotPassword, null),

                    Expanded(child: SizedBox()), //挤位置
                    //注册账号
                    _pCreateTextButton("注册账号", CustomColors.lightBlue, 13,
                        InkWellTapType.registeredAccount, null),
                  ],
                ),
              ),
              //挤间隔
              const SizedBox(
                height: 50,
              ),
              //登录按钮
              _pCreateMaterialButton(ScreenTool.screenWidth - 60),
              //我已阅读并同意《用户协议》及《隐私权政策
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isReading = !isReading;
                      });
                    },
                    icon: Image(
                      image: isReading == false
                          ? AssetImage("assets/images/radioNormal.png")
                          : AssetImage("assets/images/radioSelectBlue.png"),
                    ),
                    iconSize: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: "《用户协议》",
                            style: const TextStyle(
                                color: CustomColors.lightBlue, fontSize: 12.0),
                            recognizer: userRecognizer,
                          ),
                          const TextSpan(
                              text: "及",
                              style: TextStyle(
                                  color: CustomColors.lightGrey,
                                  fontSize: 12.0)),
                          TextSpan(
                            text: "《隐私权政策》",
                            style: const TextStyle(
                                color: CustomColors.lightBlue, fontSize: 12.0),
                            recognizer: privacyRecognizer,
                          ),
                        ],
                        text: "我已阅读并同意",
                        style: const TextStyle(
                            color: CustomColors.lightGrey, fontSize: 12.0)),
                  ),
                ],
              ),
              //第三方登录
            ],
          ),
        ),
      ),
    );
  }

  /**
   * @description: 创建一个带文字的按钮
   * @return InkWell
   * @parm:  title 标题， color字体颜色 fontSize字号 tapType 点击类型 bgColor 背景颜色
   */
  InkWell _pCreateTextButton(String title, Color color, double? fontSize,
      InkWellTapType tapType, Color? bgColor) {
    if (fontSize == 0) {
      fontSize = 15;
    }
    bgColor ??= Colors.white;

    return InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        color: bgColor,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontSize: fontSize),
            ),
          ],
        ),
      ),
      onTap: () {
        _pTapAction(tapType);
      },
    );
  }

  /**
   * @description: 通过点击类型 处理点击逻辑
   * @return {*}
   * @parm: 点击类型
   */
  void _pTapAction(InkWellTapType tapType) {
    switch (tapType) {
      case InkWellTapType.forgotPassword:
        //忘记密码
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => new ForgotPasswordPage(
                  type: PageType.password,
                )),
          ),
        );

        break;
      case InkWellTapType.verificationCode:
        //账号登录登录
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: ((context) => new LoginPage(
        //           type: widget.type,
        //         )),
        //   ),
        // );
        Navigator.of(context).pop();

        break;
      case InkWellTapType.registeredAccount:
        //注册账号
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => RegisteredAccountPage(
                  loginType: widget.type,
                )),
          ),
        );
        break;

      default:
        break;
    }
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
    UnderlineInputBorder focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black12,
      ),
    );

    return SizedBox(
      width: wholeWidth,
      height: wholeHeight,
      child: TextField(
        controller: textController,
        onChanged: (text) {
          _inputLength = StringTools()
              .splitPhoneNumber(text, textController, _inputLength);
          phoneNumberStr = text;
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
      child: SvgPicture.asset(
        imageAssetPath,
      ),
      width: iconSize,
      height: iconSize,
    );
    UnderlineInputBorder focusedBorder = UnderlineInputBorder(
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
        onChanged: ((text) {
          verificationCodeStr = text;
        }),
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
                  if (phoneNumberStr.isNotEmpty && checkPhoneNumber()) {
                    LoginManager.phoneCheck(
                        {"telPhone": phoneNumberStr},
                        (message) => {
                              if (message.isSuccess)
                                {ToastUtils.showMessage("用户不存在")}
                              else
                                {
                                  //发送验证码
                                  LoginManager.sendPhoneVerifyCode(
                                      {
                                        "codeType":
                                            FinalKeys.PHONE_CODE_TYPE_LOGIN,
                                        "phoneNumber": phoneNumberStr
                                      },
                                      (message) => {
                                            if (message.isSuccess)
                                              {countdownLogic()}
                                            else
                                              {
                                                ToastUtils.showMessage(
                                                    message.reason)
                                              }
                                          })
                                }
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
    } else {
      return "获取验证码";
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
    UmengCommonSdk.onPageEnd("verification_code_login_page");
  }

  /***
   * @description: 创建登录按钮
   * @Date: 2022-05-27 10:38
   * @parm: 登录按钮的宽度
   * @return 按钮
   */
  MaterialButton _pCreateMaterialButton(double buttonWidth) {
    return WidgetTools().createMaterialButton(
        buttonWidth, "登录", Colors.blue, Colors.white, 1, () => _loginMethod());
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
    if (isReading == false) {
      return {
        "flag": flag,
        "errorStr": FinalKeys.LOGIN_READING_ERROR,
      };
    }
    if (phoneNumberStr.isEmpty) {
      return {
        "flag": flag,
        "errorStr": FinalKeys.PHONE_NUMBER_ERROR,
      };
    }

    if (!checkPhoneNumber()) {
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

  /***
   * @description: 登录函数
   * @Date: 2022-05-27 11:11
   * @parm:
   * @return {*}
   */
  void _loginMethod() {
    Map map = dataValidation();

    bool flag = map["flag"];
    String errorStr = map["errorStr"];
    if (flag == false) {
      ToastUtils.showMessage(errorStr);
      return;
    }

    String loginType = widget.type == LoginType.company ? "1" : "2";

    LoginManager.loginCodeLogin({
      "phoneNumber": phoneNumberStr,
      "phoneCode": verificationCodeStr,
      "loginType": loginType
    }, widget.type, (message) {
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: ((context) {
      //   return RootPage();
      // })), (route) => route == null);

      LoginTools.loginCompleted(widget.type, context, 2);

      // if (Golbal.generalAgent.isNotEmpty) {
      //   var pageNumber = 0;
      //   if (widget.type == LoginType.company) {
      //     pageNumber = 2;
      //   }
      //   //进入首页 - 企业认证页面
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) {
      //         return RootPage(
      //           pageNumber: pageNumber,
      //           isCertigier: true,
      //         );
      //       }), (route) => route == null);
      // } else {
      //   if (!Golbal.isStorage) {
      //     Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
      //   } else {
      //     Navigator.of(context)
      //       ..pop()
      //       ..pop()
      //       ..pop();
      //   }
      // }
    });
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

  /// *
  /// -  @description: 校验手机号
  /// -  @Date: 2022-07-04 18:02
  /// -  @parm:
  /// -  @return {*}
  ///
  bool checkPhoneNumber() {
    var phone = phoneNumberStr.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    phoneNumberStr = phone;
    var hasMatch = RegexUtils.verifyPhoneNumber(phone);
    return hasMatch;
  }
}