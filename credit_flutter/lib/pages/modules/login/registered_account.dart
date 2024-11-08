import 'dart:async';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/login_tool.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../tools/db/hive_boxs.dart';
import '../../../tools/global.dart';

///注册账号
class RegisteredAccountPage extends StatefulWidget {
  /// 登录类型
  final LoginType loginType;
  const RegisteredAccountPage({
    Key? key,
    required this.loginType,
  }) : super(key: key);

  @override
  State<RegisteredAccountPage> createState() => _RegisteredAccountPageState();
}

class _RegisteredAccountPageState extends State<RegisteredAccountPage> {
  //密码是否密文展示 默认密文展示
  bool isPasswordEncryption = false;

  //定义变量
  Timer? _timer;

  //倒计时数值
  var countdownTime = 0;

  //获取、处理 手机号格式
  final textController = TextEditingController();
  int _inputLength = 0;

  bool isPhoneNumber = false;

  bool isPhoneCorrect = false;

  bool isPassCorrect = false;

  //手机号
  String phoneNumberStr = "";

  //密码
  String passwordStr = "";

  //验证码
  String verificationCodeStr = "";

  @override
  void initState() {
    super.initState();
    UmengCommonSdk.onPageStart("registered_account");
  }

  @override
  Widget build(BuildContext context) {
    //输入框总体宽度
    double wholeWidth = ScreenTool.screenWidth;
    //输入框总体高度
    double wholeHeight = 56;

    return Scaffold(
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

      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus?.unfocus();
        }),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            //列布局
            children: [
              //标题
              _pCreatePageTitle("注册账号"),
              _pCreatesPhoneFileld(
                18,
                "assets/images/phone.png",
                "请输入手机号",
                TextInputType.phone,
                wholeWidth,
                wholeHeight,
              ),
              if (isPhoneNumber) addErrorPrompt('手机号错误'),

              _pCreatesPasswordFileld(
                18,
                "assets/images/password.png",
                "输入密码8-12位，数字+字母大小写",
                TextInputType.visiblePassword,
                wholeWidth,
                wholeHeight,
                isPasswordEncryption,
              ),
              if (isPassCorrect) addErrorPrompt('密码必须为8-12位 数字字母大小写'),

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
                "注册",
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///选中后的下划线颜色
  UnderlineInputBorder focusedBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: CustomColors.underlineColor,
      width: 1,
    ),
  );

  ///未选中的下划线颜色
  UnderlineInputBorder enabledBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: CustomColors.underlineColor,
      width: 1,
    ),
  );

  ///错误的下划线颜色
  UnderlineInputBorder errorBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      // color: MyColor.underlineColor,
      color: CustomColors.warningColor,
      width: 1,
    ),
  );

  /// @description: 创建一个容器，容器放着标题
  /// @Date: 2022-05-26 11:21
  /// @parm: title 标题
  Container _pCreatePageTitle(String title) {
    // ignore: avoid_unnecessary_containers
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      height: 132.5,
      child: Row(children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    );
  }

  /// @description: 生成按钮  主要是下一步按钮
  /// @Date: 2022-05-26 11:51
  /// @param:  buttonWidth 按钮宽，title 按钮上的文字
  /// @return 按钮
  MaterialButton _pCreateMaterialButton(double buttonWidth, String title) {
    //背景颜色
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
    if (verificationCodeStr.isEmpty) {
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
    LoginManager.loginUserRegister(
      {
        "phoneNumber": phoneNumberStr.replaceAll(RegExp(r"\s+\b|\b\s"), ""),
        "password": passwordStr,
        "phoneCode": verificationCodeStr,
      },
      widget.loginType,
      (message) {
        if (message.isSuccess) {
          UserModel.getTempUserInfo((model) => {
                if (model != null) {_bfoption(model)} else {_afoption()}
              });
        }
      },
    );
  }

  /// 注册成功后操作
  _afoption() {
    ToastUtils.showMessage("注册成功");
    // Navigator.pop(context);
    LoginTools.loginCompleted(widget.loginType, context, 2);
  }

  _bfoption(UserModel model) {
    LoginManager.userGuestDataMerge({"userId": model.userInfo.id}, (message) {
      var box = Hive.box(HiveBoxs.dataBox);
      String orderId = box.get(FinalKeys.Quick_BUY_Order_ID) ?? "";
      String userJson = box.get(FinalKeys.BOX_TEMPORARILY_USER_LOGIN_KEY) ?? "";

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
      _afoption();
    });
  }

  /// @description: 手机号输入框
  /// @return SizedBox 带有大小的盒子
  /// iconSize 左图标的宽高
  /// imageAssetPath 左图标的资源地址
  /// placeholder 提示文字
  /// keyboardType 键盘的显示类型
  /// wholeWidth  SizedBox的宽度
  /// wholeHeight  SizedBox的高度
  SizedBox _pCreatesPhoneFileld(
      double iconSize,
      String imageAssetPath,
      String placeholder,
      TextInputType keyboardType,
      double wholeWidth,
      double wholeHeight) {
    Image iconImage = Image(
      image: AssetImage(imageAssetPath),
      width: iconSize,
      height: iconSize,
    );

    Image yesImage = Image(
      image: const AssetImage("assets/images/icon_yes.png"),
      width: iconSize,
      height: iconSize,
    );

    SizedBox yesSize = SizedBox(
      height: iconSize,
      width: iconSize,
    );

    return SizedBox(
      width: wholeWidth,
      height: wholeHeight,
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(13)
        ],
        controller: textController,
        onChanged: (text) {
          _inputLength = StringTools()
              .splitPhoneNumber(text, textController, _inputLength);
          setState(() {
            phoneNumberStr = text;
            if (_inputLength == 13) {
              text = text.substring(0, _inputLength);
              var phone = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
              var hasMatch = RegexUtils.verifyPhoneNumber(phone);
              isPhoneCorrect = hasMatch;
              isPhoneNumber = !hasMatch;
              if (isPhoneCorrect == true) {}
            } else {
              isPhoneCorrect = false;
              isPhoneNumber = false;
            }
          });
        },
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          isCollapsed: true,
          icon: iconImage,
          suffixIcon: isPhoneCorrect ? yesImage : yesSize,
          focusedBorder: isPhoneNumber ? errorBorder : focusedBorder,
          enabledBorder: isPhoneNumber ? errorBorder : enabledBorder,
          // errorBorder: errorBorder,
          // focusedErrorBorder: errorBorder,
          hintText: placeholder,
          hintStyle:
              const TextStyle(fontSize: 16, color: CustomColors.lightGrey),
          prefixStyle:
              const TextStyle(fontSize: 16, color: CustomColors.textDarkColor),
          // errorText: isPhoneNumber ? '手机号错误' : null,
          // prefixIcon: iconImage,
          // prefixIconConstraints: const BoxConstraints(
          //   minWidth: 28,
          //   //添加内部图标之后，图标和文字会有间距，实现这个方法，不用写任何参数即可解决
          // ),
        ),
      ),
    );
  }

  /// @description: 密码输入框
  /// @return SizedBox 带有大小的盒子
  /// iconSize 左图标的宽高
  /// imageAssetPath 左图标的资源地址
  /// placeholder 提示文字
  /// keyboardType 键盘的显示类型
  /// wholeWidth  SizedBox的宽度
  /// wholeHeight  SizedBox的高度
  /// obscureText 密码密文
  SizedBox _pCreatesPasswordFileld(
    double iconSize,
    String imageAssetPath,
    String placeholder,
    TextInputType keyboardType,
    double wholeWidth,
    double wholeHeight,
    bool obscureText,
  ) {
    Image iconImage = Image(
      image: AssetImage(imageAssetPath),
      width: iconSize,
      height: iconSize,
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
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(12),
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z,a-z,0-9]')),
        ],
        obscureText: !obscureText,
        keyboardType: keyboardType,
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
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          isCollapsed: true,
          hintText: placeholder,
          focusedBorder: isPassCorrect ? errorBorder : focusedBorder,
          enabledBorder: isPassCorrect ? errorBorder : enabledBorder,
          icon: iconImage,
          suffixIcon: suffixIcon,
          hintStyle:
              const TextStyle(fontSize: 16, color: CustomColors.lightGrey),
          prefixStyle:
              const TextStyle(fontSize: 16, color: CustomColors.textDarkColor),
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
    SizedBox iconImage = SizedBox(
      width: iconSize,
      height: iconSize,
      child: SvgPicture.asset(
        imageAssetPath,
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
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (text) {
          verificationCodeStr = text;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          hintText: placeholder,
          focusedBorder: focusedBorder,
          enabledBorder: enabledBorder,
          icon: iconImage,
          hintStyle:
              const TextStyle(fontSize: 16, color: CustomColors.lightGrey),
          prefixStyle:
              const TextStyle(fontSize: 16, color: CustomColors.textDarkColor),
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
                    //判断手机号是否注册过
                    LoginManager.phoneCheck(
                        {"telPhone": phoneNumberStr},
                        (message) => {
                              if (message.isSuccess == true)
                                {
                                  //发送验证码
                                  LoginManager.sendPhoneVerifyCode(
                                      {
                                        "codeType":
                                            FinalKeys.PHONE_CODE_TYPE_REGISTER,
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
        if (countdownTime < 1) {
          _timer?.cancel();
        } else {
          countdownTime -= 1;
        }
      });
    };
    _timer = Timer.periodic(const Duration(seconds: 1), call);
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
    UmengCommonSdk.onPageEnd("registered_account");
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

  /// *
  /// -  @description: 校验手机号
  /// -  @Date: 2022-07-04 18:02
  /// -  @parm:
  /// -  @return {*}
  ///
  bool checkPhoneNumber() {
    var phone = phoneNumberStr.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    var hasMatch = RegexUtils.verifyPhoneNumber(phone);
    phoneNumberStr = phone;
    return hasMatch;
  }
}
