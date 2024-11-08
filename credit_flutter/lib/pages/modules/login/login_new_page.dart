/// *
/// -  @Date: 2023-08-15 13:23
/// -  @LastEditTime: 2023-08-15 13:26
/// -  @Description: 新的登录页 登录和注册合并
///

import 'dart:async';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/define/define_url.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/login/forgot_password_page.dart';
import 'package:credit_flutter/pages/modules/login/registered_account.dart';
import 'package:credit_flutter/pages/modules/web/web_page.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class LoginNewPage extends StatefulWidget {
  /// 登录类型
  final LoginType type;

  ///
  final bool isHiddenBack;

  const LoginNewPage({
    required this.type,
    this.isHiddenBack = false,
    super.key,
  });

  @override
  State<LoginNewPage> createState() => _LoginNewPageState();
}

class _LoginNewPageState extends State<LoginNewPage> {
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

  //定义变量
  Timer? _timer;

  //倒计时数值
  var countdownTime = 0;

  //验证码
  String verificationCodeStr = "";

  /// 切换验证码
  bool toggleVerificationCode = true;

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
    textController.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
    UmengCommonSdk.onPageEnd("login_page");
  }

  @override
  Widget build(BuildContext context) {
    ScreenTool.int(context);
    //输入框总体宽度
    double wholeWidth = ScreenTool.screenWidth - 32 - 23;
    //输入框总体高度
    double wholeHeight = 56;
    double iconMarginTop = widget.isHiddenBack == false ? 0 : 100;
    return WillPopScope(
        onWillPop: () {
          _exit();
          return Future.value(false);
        },
        child: Scaffold(
          //导航
          appBar: _appBar(widget.isHiddenBack),
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
                  Container(
                    height: 108,
                    width: 108,
                    margin: EdgeInsets.only(top: iconMarginTop, bottom: 10),
                    child: const Image(
                      image: AssetImage("assets/images/aboutIcon.png"),
                      width: 108,
                      height: 108,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const Text(
                    "国家信用体系建设重点服务平台",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.darkGreyE6,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 25), //挤位置
                  _inputView(wholeWidth, wholeHeight),
                  const SizedBox(
                    height: 12,
                  ),
                  //协议
                  Row(
                    children: [
                      _agreement(),
                      const Expanded(child: SizedBox()), //挤位置
                    ],
                  ),
                  //挤间隔
                  const SizedBox(
                    height: 25,
                  ),
                  //登录按钮
                  _pCreateMaterialButton(ScreenTool.screenWidth - 60),
                  const SizedBox(
                    height: 10,
                  ),
                  _loginFunButton(),
                ],
              ),
            ),
          ),
        ));
  }

  /// *
  /// -  @description: 《用户协议》及《隐私权政策》的布局
  /// -  @Date: 2023-08-15 13:56
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _agreement() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              isReading = !isReading;
            });
          },
          icon: Image(
            image: isReading == false
                ? const AssetImage("assets/images/radioNormal.png")
                : const AssetImage("assets/images/radioSelectBlue.png"),
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
                        color: CustomColors.lightGrey, fontSize: 12.0)),
                TextSpan(
                  text: "《隐私权政策》",
                  style: const TextStyle(
                      color: CustomColors.lightBlue, fontSize: 12.0),
                  recognizer: privacyRecognizer,
                ),
              ],
              text: "同意",
              style: const TextStyle(
                  color: CustomColors.greyBlack, fontSize: 12.0)),
        ),
      ],
    );
  }

  /// *
  /// -  @description: appbar 布局
  /// -  @Date: 2023-08-15 13:56
  /// -  @parm: 是否隐藏appbar
  /// -  @return {*}
  ///
  PreferredSizeWidget _appBar(bool isHiddend) {
    if (isHiddend == true) {
      return PreferredSize(
        preferredSize: Size.fromHeight(ScreenTool.topSafeHeight),
        child: SizedBox(
          height: ScreenTool.topSafeHeight,
        ),
      );
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.black,
        onPressed: () {
          _exit();
        },
      ),
    );
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
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: ((context) =>
        //         VerificationCodeLoginPage(type: widget.type)),
        //   ),
        // );

        setState(() {
          toggleVerificationCode = true;
        });
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
        setState(() {
          toggleVerificationCode = false;
        });
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
      color: CustomColors.greyBlack,
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
      color: CustomColors.greyBlack,
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
  Widget _pCreateMaterialButton(double buttonWidth) {
    String buttonTitle = "登录 / 注册";
    if (toggleVerificationCode == false) {
      buttonTitle = "登录";
    }
    return WidgetTools().createCustomButton(
      buttonWidth,
      buttonTitle,
      () => _loginMethod(),
      fontWeight: FontWeight.bold,
      bgColor: CustomColors.greyBlack,
      textColor: Colors.white,
      radius: 8,
      height: 50,
      shadow: const BoxShadow(),
    );
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
  /// @description: 提交数据验证
  /// @Date: 2022-06-14 20:18
  /// @parm: {"flag": bool, "errorStr": errorStr}
  /// @return {*}
  Map<String, dynamic> dataVerificationCodeValidation() {
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

  /// *
  /// @description: 登录函数
  /// @Date: 2022-05-27 11:11
  /// @parm:
  /// @return {*}
  void _loginMethod() {
    if (toggleVerificationCode == true) {
      Map map = dataVerificationCodeValidation();
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
        UserModel.getTempUserInfo((model) {
          if (model != null) {
            LoginManager.userGuestDataMerge({"userId": model.userInfo.id},
                (message) {
              var box = Hive.box(HiveBoxs.dataBox);
              String orderId = box.get(FinalKeys.Quick_BUY_Order_ID) ?? "";
              String userJson =
                  box.get(FinalKeys.BOX_TEMPORARILY_USER_LOGIN_KEY) ?? "";

              int quickStanding = box.get(FinalKeys.Quick_STANDING) ?? 0;

              if (orderId.isNotEmpty) {
                box.put(FinalKeys.Quick_BUY_Order_ID, "");

                box.delete(FinalKeys.Quick_BUY_Order_ID);
                box.delete(FinalKeys.Quick_STANDING);
              }
              if (userJson.isNotEmpty) {
                box.put(FinalKeys.BOX_TEMPORARILY_USER_LOGIN_KEY, "");
                box.delete(FinalKeys.BOX_TEMPORARILY_USER_LOGIN_KEY);
              }

              if (quickStanding != 0) {
                box.put(FinalKeys.Quick_STANDING, 0);
                box.delete(FinalKeys.Quick_STANDING);
              }
              Golbal.isStorage = false;
              LoginTools.loginCompleted(widget.type, context, 2);
            });
          } else {
            LoginTools.loginCompleted(widget.type, context, 1);
          }
        });
      });
    } else {
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
      });
    }
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

  Widget _inputView(double width, double height) {
    if (toggleVerificationCode == true) {
      return _verificationCodeView(width, height);
    } else {
      return _passwordView(width, height);
    }
  }

  Widget _passwordView(double width, double height) {
    return SizedBox(
      //输入最外层的容器
      height: 132,
      child: Column(
        //输入手机号和密码
        children: [
          _pCreatesTextFileld(18, "assets/images/phone.png", "请输入手机号",
              TextInputType.phone, width, height, "", false, 0),
          if (isPhoneNumber) addErrorPrompt('手机号错误'),
          _pCreatesPasswordTextFileld(
              18,
              "assets/images/password.png",
              "请输入密码",
              TextInputType.visiblePassword,
              width,
              height,
              "assets/images/nosee.png",
              isPasswordEncryption,
              1),
          if (isPassCorrect) addErrorPrompt('密码必须8-12位 数字字母大小写'),
        ],
      ),
    );
  }

  Widget _verificationCodeView(double width, double height) {
    return SizedBox(
      //输入最外层的容器
      height: 132,
      child: Column(
        //输入手机号和密码
        children: [
          _pCreatesVCTextFileld(
            18,
            "assets/images/phone.png",
            "请输入手机号",
            TextInputType.phone,
            width,
            height,
          ),
          if (isPhoneNumber) addErrorPrompt('手机号错误'),
          _pCreatesVerificationCodeTextFileld(
            18,
            "assets/images/loginCode.svg",
            "请输入验证码",
            TextInputType.number,
            width,
            height,
          ),
        ],
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
    SizedBox iconImage = SizedBox(
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
        onChanged: ((text) {
          verificationCodeStr = text;
        }),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: placeholder,
          hintText: placeholder,
          focusedBorder: focusedBorder,
          icon: iconImage,
          suffixIcon: SizedBox(
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
                    // LoginManager.phoneCheck(
                    //     {"telPhone": phoneNumberStr},
                    //     (message) => {
                    //           if (message.isSuccess)
                    //             {ToastUtils.showMessage("用户不存在")}
                    //           else
                    //             {

                    // }
                    // });

                    /// 发送验证码

                    LoginManager.sendPhoneVerifyCode(
                        {
                          "codeType": FinalKeys.PHONE_CODE_TYPE_LOGIN,
                          "phoneNumber": phoneNumberStr
                        },
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
  SizedBox _pCreatesVCTextFileld(
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

  String handleCodeText() {
    if (countdownTime > 0) {
      return "${countdownTime}s";
    } else {
      return "获取验证码";
    }
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

  /// *
  /// @description: 倒计时逻辑 先toast 在倒计时
  /// @Date: 2022-06-15 01:40
  /// @parm:
  /// @return {*}
  void countdownLogic() {
    ToastUtils.showMessage(FinalKeys.VERIFICATION_CODE_SEND_SUCCESSFUL);
    //开始读秒
    startCountdown();
  }

  //倒计时方法
  startCountdown() {
    countdownTime = 60;
    call(timer) {
      setState(() {
        print(countdownTime);
        if (countdownTime < 1) {
          _timer?.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    }

    _timer = Timer.periodic(const Duration(seconds: 1), call);
  }

  Widget _loginFunButton() {
    InkWellTapType tapType = InkWellTapType.verificationCode;
    String titleStr = "验证码登录";

    Widget fv, rv, fgv, rgv;
    if (toggleVerificationCode == true) {
      tapType = InkWellTapType.toggle;
      titleStr = "密码登录";
      fv = const SizedBox();
      rv = const SizedBox();
      fgv = const SizedBox();
      rgv = const SizedBox();
    } else {
      countdownTime = 0;
      _timer?.cancel();
      titleStr = "验证码登录";
      tapType = InkWellTapType.verificationCode;

      //忘记密码
      fv = _pCreateTextButton("忘记密码", CustomColors.greyBlack, 13,
          InkWellTapType.forgotPassword, null);
      rv = _pCreateTextButton("注册账号", CustomColors.greyBlack, 13,
          InkWellTapType.registeredAccount, null);

      fgv = SizedBox(
        width: 2,
        height: 10,
        child: Container(
          color: CustomColors.lightGrey,
        ),
      );
      rgv = SizedBox(
        width: 2,
        height: 10,
        child: Container(
          color: CustomColors.lightGrey,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      //交叉轴的布局方式，对于column来说就是水平方向的布局方式
      crossAxisAlignment: CrossAxisAlignment.center,
      //就是字child的垂直布局方向，向上还是向下
      verticalDirection: VerticalDirection.down,
      children: [
        fv,
        fgv,
        WidgetTools().createCustomButton(
          130,
          titleStr,
          () => _pTapAction(tapType),
          textColor: CustomColors.greyBlack,
          height: 50,
          shadow: const BoxShadow(),
        ),
        rgv,
        rv,
      ],
    );
  }
}
