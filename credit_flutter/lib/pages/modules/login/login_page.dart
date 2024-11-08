import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/pages/modules/login/forgot_password_page.dart';
import 'package:credit_flutter/pages/modules/login/verification_code_login_page.dart';
import 'package:credit_flutter/pages/modules/web/web_page.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../tools/global.dart';
import 'registered_account.dart';

/// *
/// @Date: 2022-05-24 10:53
/// @LastEditTime: 2022-06-07 13:59
/// @Description: 登录页
class LoginPage extends StatefulWidget {
  final LoginType type;

  const LoginPage({Key? key, required this.type}) : super(key: key);

  // const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //密码是否密文展示 默认密文展示
  bool isPasswordEncryption = false;
  bool isPhoneNumber = false;

  bool isPhoneCorrect = false;

  bool isReading = false;

  bool isPassCorrect = false;

  //手机号
  String phoneNumberStr = "";

  //密码
  String passwordStr = "";

  //获取、处理 手机号格式
  final textController = TextEditingController();
  int _inputLength = 0;
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
    UmengCommonSdk.onPageStart("login_page");
    String loginType = "";
    if (widget.type == LoginType.company) {
      loginType = "企业";
    } else if (widget.type == LoginType.personal) {
      loginType = "个人";
    } else if (widget.type == LoginType.employer) {
      loginType = "个人雇主";
    }
    UmengCommonSdk.onEvent("login_page", {"loginType": loginType});
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("login_page");
  }

  @override
  Widget build(BuildContext context) {
    ScreenTool.int(context);

    //输入框总体宽度
    double wholeWidth = ScreenTool.screenWidth - 32 - 23;
    //输入框总体高度
    double wholeHeight = 56;
    return WillPopScope(
        onWillPop: () {
          _exit();
          return Future.value(false);
        },
        child: Scaffold(
          //导航
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                _exit();
              },
            ),
            title: Row(
              children: [
                const Expanded(child: SizedBox()),
                _pCreateTextButton("验证码登录", Colors.black, 16,
                    InkWellTapType.verificationCode, null),
              ],
            ),
          ),

          body: GestureDetector(
            onTap: () {
              //点击空白处回收键盘
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                //列布局
                children: [
                  SizedBox(
                    width: ScreenTool.screenWidth - 32,
                    child: const Text(
                      "账号登录",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60), //挤位置
                  SizedBox(
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
                            "",
                            false,
                            0),
                        if (isPhoneNumber) addErrorPrompt('手机号错误'),
                        _pCreatesPasswordTextFileld(
                            18,
                            "assets/images/password.png",
                            "请输入密码",
                            TextInputType.visiblePassword,
                            wholeWidth,
                            wholeHeight,
                            "assets/images/nosee.png",
                            isPasswordEncryption,
                            1),
                        if (isPassCorrect) addErrorPrompt('密码必须8-12位 数字字母大小写'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //忘记密码 和注册
                  Row(
                    children: [
                      //忘记密码
                      _pCreateTextButton("忘记密码", CustomColors.lightGrey, 13,
                          InkWellTapType.forgotPassword, null),

                      const Expanded(child: SizedBox()), //挤位置
                      //注册账号
                      _pCreateTextButton("注册账号", CustomColors.lightBlue, 13,
                          InkWellTapType.registeredAccount, null),
                    ],
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
                              ? const AssetImage(
                                  "assets/images/radioNormal.png")
                              : const AssetImage(
                                  "assets/images/radioSelectBlue.png"),
                        ),
                        iconSize: 15,
                      ),
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: "《用户协议》",
                                style: const TextStyle(
                                    color: CustomColors.lightBlue,
                                    fontSize: 12.0),
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
                                    color: CustomColors.lightBlue,
                                    fontSize: 12.0),
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
        ));
  }

  /// @description: 创建一个带文字的按钮
  /// @return InkWell
  /// @parm:  title 标题， color字体颜色 fontSize字号 tapType 点击类型 bgColor 背景颜色
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

  /// @description: 通过点击类型 处理点击逻辑
  /// @return {*}
  /// @parm: 点击类型
  void _pTapAction(InkWellTapType tapType) {
    switch (tapType) {
      case InkWellTapType.forgotPassword:
        //忘记密码
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => const ForgotPasswordPage(
                  type: PageType.password,
                )),
          ),
        );

        break;
      case InkWellTapType.verificationCode:
        //验证码登录
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) =>
                VerificationCodeLoginPage(type: widget.type)),
          ),
        );
        break;
      case InkWellTapType.registeredAccount:
        //注册账号
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) =>
                RegisteredAccountPage(loginType: widget.type)),
          ),
        );
        break;
      default:
        break;
    }
  }

  /// @description: 自定义输入框
  /// @return SizedBox 带有大小的盒子
  /// @parm:
  ///
  /// iconSize 左图标的宽高
  /// imageAssetPath 左图标的资源地址
  /// placeholder 提示文字
  /// keyboardType 键盘的显示类型
  /// wholeWidth  SizedBox的宽度
  /// wholeHeight  SizedBox的高度
  /// obscureText 密码密文
  /// type 0 手机号 1 密码
  SizedBox _pCreatesTextFileld(
      double iconSize,
      String imageAssetPath,
      String placeholder,
      TextInputType keyboardType,
      double wholeWidth,
      double wholeHeight,
      String suffixIconAssetPath,
      bool obscureText,
      int type) {
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

    Image? suffixIcon;
    if (suffixIconAssetPath.isNotEmpty) {
      suffixIcon = Image(
        image: AssetImage(suffixIconAssetPath),
        width: 18,
        height: 18,
      );
    }

    return SizedBox(
      width: wholeWidth,
      height: wholeHeight,
      child: TextField(
        controller: textController,
        onChanged: (text) {
          StringTools strTools = StringTools();
          _inputLength =
              strTools.splitPhoneNumber(text, textController, _inputLength);
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
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: placeholder,
          hintText: placeholder,
          focusedBorder: focusedBorder,
          icon: iconImage,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  /// @description: 自定义输入框
  /// @return SizedBox 带有大小的盒子
  /// @parm:
  ///
  /// iconSize 左图标的宽高
  /// imageAssetPath 左图标的资源地址
  /// placeholder 提示文字
  /// keyboardType 键盘的显示类型
  /// wholeWidth  SizedBox的宽度
  /// wholeHeight  SizedBox的高度
  /// obscureText 密码密文
  /// type 0 手机号 1 密码
  SizedBox _pCreatesPasswordTextFileld(
      double iconSize,
      String imageAssetPath,
      String placeholder,
      TextInputType keyboardType,
      double wholeWidth,
      double wholeHeight,
      String suffixIconAssetPath,
      bool obscureText,
      int type) {
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

    String assertPath =
        obscureText ? "assets/images/see.png" : "assets/images/nosee.png";
    SizedBox suffixIcon = SizedBox(
      height: 56,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isPasswordEncryption = !obscureText;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(assertPath),
              width: iconSize,
              height: iconSize,
            ),
          ],
        ),
      ),
    );

    return SizedBox(
      width: wholeWidth,
      height: wholeHeight,
      child: TextField(
        onChanged: (text) {
          passwordStr = text;
          setState(() {
            if (text.length >= 8) {
              var hasMatch = RegexUtils.checkPassword(text);
              isPassCorrect = !hasMatch;
            } else {
              isPassCorrect = false;
            }
          });
        },
        obscureText: !obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: placeholder,
          hintText: placeholder,
          focusedBorder: focusedBorder,
          icon: iconImage,
          suffixIcon: suffixIcon,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z,a-z,0-9]')),
          LengthLimitingTextInputFormatter(12),
        ],
      ),
    );
  }

  /// *
  /// @description: 创建登录按钮
  /// @Date: 2022-05-27 10:38
  /// @parm: 登录按钮的宽度
  /// @return 按钮
  MaterialButton _pCreateMaterialButton(double buttonWidth) {
    return WidgetTools().createMaterialButton(
        buttonWidth, "登录", Colors.blue, Colors.white, 1, () => _loginMethod());
  }

  /// @description: 提交数据验证
  /// @Date: 2022-06-14 20:18
  /// @parm: {"flag": bool, "errorStr": errorStr}
  /// @return {*}
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

    var phone = phoneNumberStr.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    var hasMatch = RegexUtils.verifyPhoneNumber(phone);

    if (!hasMatch) {
      return {
        "flag": flag,
        "errorStr": FinalKeys.PHONE_NUMBER_ERROR,
      };
    }

    if (passwordStr.isEmpty) {
      return {
        "flag": flag,
        "errorStr": FinalKeys.PASSWORD_EMPTY_ERROR,
      };
    }
    if (passwordStr.length > 12 || passwordStr.length < 8) {
      return {
        "flag": flag,
        "errorStr": FinalKeys.PASSWORD_LENGTH_ERROR,
      };
    }

    flag = true;

    return {
      "flag": flag,
      "errorStr": "",
    };
  }

  /// *
  /// @description: 登录函数
  /// @Date: 2022-05-27 11:11
  /// @parm:
  /// @return {*}
  void _loginMethod() {
    Map map = dataValidation();

    bool flag = map["flag"];
    String errorStr = map["errorStr"];
    if (flag == false) {
      ToastUtils.showMessage(errorStr);
      return;
    }

    String loginType = widget.type == LoginType.company ? "1" : "2";

    LoginManager.loginPhonePasswordLogin({
      "phoneNumber": phoneNumberStr,
      "password": passwordStr,
      "loginType": loginType
    }, widget.type, (message) {
      LoginTools.loginCompleted(widget.type, context, 1);
      // if (Golbal.generalAgent.isNotEmpty) {
      //   var pageNumber = 0;
      //   if (widget.type == LoginType.company) {
      //     pageNumber = 2;
      //   }
      //   //进入首页 - 企业认证页面
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) {
      //     return RootPage(
      //       pageNumber: pageNumber,
      //       isCertigier: true,
      //     );
      //   }), (route) => route == null);
      // } else {
      //   if (!Golbal.isStorage) {
      //     Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
      //   } else {
      //     Navigator.of(context)
      //       ..pop()
      //       ..pop();
      //   }
      // }
    });
  }

  Container addErrorPrompt(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 34),
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

  void _exit() {
    if (Golbal.generalAgent.isNotEmpty) {
      Golbal.generalAgent = "";
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }
}
