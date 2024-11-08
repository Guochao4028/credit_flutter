/***
 * @Date: 2022-05-26 15:17
 * @LastEditTime: 2022-05-27 17:03
 * @Description: 设置新密码页
 */
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/login/login_new_page.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class SetNewPasswordPage extends StatefulWidget {
  final String phoneNumber;
  final String phoneCode;
  final PageType type;

  const SetNewPasswordPage(
      {Key? key,
      required this.phoneNumber,
      required this.phoneCode,
      required this.type})
      : super(key: key);

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  //密码是否密文展示 默认密文展示
  bool isPasswordEncryption = false;
  bool isPassCorrect = false;

  //密码
  String passwordStr = "";

  @override
  Widget build(BuildContext context) {
    String titleStr = "";
    if (widget.type == PageType.password) {
      titleStr = "设置新密码";
    } else {
      titleStr = "设置新的支付密码";
    }
    //输入框总体宽度
    double wholeWidth = ScreenTool.screenWidth - 32;
    //输入框总体高度
    double wholeHeight = 56;

    String errorPromptString = "";

    if (widget.type == PageType.password) {
      errorPromptString = '密码必须为8-12位数字字母大小写';
    } else {
      errorPromptString = '支付密码格式有误';
    }

    return Container(
      child: Scaffold(
        //导航
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        body: BaseBody(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              //列布局
              children: [
                //标题
                _pCreatePageTitle(titleStr, "输入新的密码，点击确认"),
                //占位置
                const SizedBox(
                  height: 80,
                ),

                _pCreatesVerificationCodeTextFileld(
                  18,
                  "assets/images/password.png",
                  "请输入新密码",
                  TextInputType.visiblePassword,
                  wholeWidth,
                  wholeHeight,
                  isPasswordEncryption,
                ),
                if (isPassCorrect) addErrorPrompt(errorPromptString),
                //占位置
                const SizedBox(
                  height: 60,
                ),
                //下一步按钮
                _pCreateMaterialButton(
                  ScreenTool.screenWidth - 32,
                  "确定",
                ),
              ],
            ),
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
      () {
        if (widget.type == PageType.password) {
          _submitPassword();
        } else {
          _submitPayPassword();
        }
      },
    );
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
   * obscureText 密码密文
   */
  SizedBox _pCreatesVerificationCodeTextFileld(
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

    UnderlineInputBorder focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black12,
      ),
    );
    String assertPath =
        obscureText ? "assets/images/see.png" : "assets/images/nosee.png";
    Container suffixIcon = Container(
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
              width: 18,
              height: 18,
            ),
          ],
        ),
      ),
    );

    List<TextInputFormatter> inputFormatterList = [];

    String placeholderStr = "";
    if (widget.type == PageType.password) {
      placeholderStr = "(密码8-12位,数字+字母大小写)";
      keyboardType = TextInputType.visiblePassword;
      inputFormatterList = [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z,a-z,0-9]')),
        LengthLimitingTextInputFormatter(12),
      ];
    } else {
      placeholderStr = "(6位数字密码)";
      keyboardType = TextInputType.number;
      inputFormatterList = [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(6),
      ];
    }

    return SizedBox(
      width: wholeWidth,
      height: wholeHeight,
      child: TextField(
        onChanged: (text) {
          passwordStr = text;
          setState(() {
            if (widget.type == PageType.password) {
              if (text.length >= 8) {
                var hasMatch = RegexUtils.checkPassword(text);
                isPassCorrect = !hasMatch;
                if (isPassCorrect == false) {
                  passwordStr = text;
                }
              } else {
                isPassCorrect = false;
              }
            }
          });
        },
        obscureText: !obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatterList,
        decoration: InputDecoration(
          label: Row(
            children: [
              const Text(
                "请输入新密码",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.lightGrey,
                ),
              ),
              Text(
                placeholderStr,
                style: const TextStyle(
                  fontSize: 12,
                  color: CustomColors.lightGrey,
                ),
              ),
            ],
          ),
          hintText: placeholder,
          focusedBorder: focusedBorder,
          icon: iconImage,
          suffixIcon: suffixIcon,
        ),
      ),
    );
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
  /// -  @description: 提交
  /// -  @Date: 2022-07-05 13:55
  /// -  @parm:
  /// -  @return {*}
  ///
  void _submitPassword() {
    if ((passwordStr.isEmpty) ||
        (passwordStr.length > 12 || passwordStr.length < 8)) {
      isPassCorrect = true;
      setState(() {});
      return;
    }

    LoginManager.loginForgetPassword({
      "telPhone": widget.phoneNumber,
      "code": widget.phoneCode,
      "password": passwordStr,
      "codeType": FinalKeys.PHONE_CODE_TYPE_FORGET_PASSWORD
    }, (message) {
      if (message.isSuccess == true) {
        ToastUtils.showMessage("密码修改成功");

        ///清空用户数据
        UserModel.removeUserInfo();
        // 获得实例
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
// 取出数据
        _prefs.then((sp) {
          String? loginType = sp.getString(FinalKeys.LOGIN_TYPE);
          if (loginType != null) {
            LoginType type =
                loginType == "1" ? LoginType.company : LoginType.personal;
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //   builder: (context) => LoginPage(type: type,),
            // ));
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginNewPage(
                type: type,
              ),
            ));
          }
        });
      }
    });
  }

  void _submitPayPassword() {
    if ((passwordStr.isEmpty) || passwordStr.length < 6) {
      isPassCorrect = true;
      setState(() {});
      return;
    }
    String newPassword = passwordStr + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5Str = StringTools.generateMD5(newPassword);

    Map<String, dynamic> temp = {"type": "2", "userPayPassword": md5Str};
    String rsaPassword = StringTools.generateRSA(temp);

    MineManager.updatePayPassword({"rsaEncryption": rsaPassword}, (message) {
      ToastUtils.showMessage("支付密码设置成功");
      Navigator.of(context)
        ..pop()
        ..pop();
    });
  }
}
