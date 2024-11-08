/// *
/// -  @Date: 2022-07-04 14:57
/// -  @LastEditTime: 2022-07-04 14:57
/// -  @Description: 设置新密码
///
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/login/login_new_page.dart';
import 'package:credit_flutter/pages/modules/login/login_page.dart';

import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class SetupNewPasswordPage extends StatefulWidget {
  const SetupNewPasswordPage({Key? key}) : super(key: key);

  @override
  State<SetupNewPasswordPage> createState() => _SetupNewPasswordPageState();
}

class _SetupNewPasswordPageState extends State<SetupNewPasswordPage> {
  ///处理密码
  final textNewPasswordController = TextEditingController();

  ///处理密码
  final textConfirmPasswordController = TextEditingController();

  ///密码错误信息
  String passwordErrorStr = "";

  ///新密码
  String newPasswordStr = "";

  ///确认密码
  String confirmPasswordStr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "修改密码",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "2、输入新的密码",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.textDarkColor,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              _inputView("新密码", textNewPasswordController),
              const SizedBox(
                height: 20,
              ),
              _inputView("确认密码", textConfirmPasswordController),
              addErrorPrompt(passwordErrorStr),
              const SizedBox(
                height: 60,
              ),
              WidgetTools().createCustomButton(
                ScreenTool.screenWidth - 60,
                "确定",
                () => {_finish()},
                fontSize: 15,
                fontWeight: FontWeight.bold,
                radius: 23,
                borderColor: CustomColors.colorFFEBEBEB,
                borderWidth: 1,
                bgColor: CustomColors.lightBlue,
                textColor: CustomColors.whiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputView(
    String title,
    TextEditingController controller,
  ) {
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
        setState(() {});

        if (controller == textNewPasswordController) {
          newPasswordStr = str;
        } else {
          confirmPasswordStr = str;
        }
      },
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "请输入新密码",
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(12),
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z,a-z,0-9]')),
      ],
    );
    Container line = Container(
      height: 1,
      color: CustomColors.lineColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
  Widget addErrorPrompt(String title) {
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

  bool _checkData() {
    bool flag = true;
    if (StringTools.isEmpty(newPasswordStr)) {
      passwordErrorStr = "请输入新密码";
      flag = false;
    } else if (StringTools.isEmpty(confirmPasswordStr)) {
      passwordErrorStr = "请再次输入密码";
      flag = false;
    }
    if (newPasswordStr != confirmPasswordStr) {
      passwordErrorStr = "密码不一致";
      flag = false;
    }

    bool newPasswordFlag = RegexUtils.checkPassword(newPasswordStr);
    bool confirmPasswordFlag = RegexUtils.checkPassword(confirmPasswordStr);

    if (!confirmPasswordFlag || !newPasswordFlag) {
      passwordErrorStr = '密码必须为8位以上数字字母大小写';
      flag = false;
    }
    setState(() {});

    return flag;
  }

  ///确定
  void _finish() {
    ///校验密码
    if (_checkData() == false) {
      return;
    }

    ///调接口 修改密码
    String newPassword = newPasswordStr + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5Str = StringTools.generateMD5(newPassword);
    MineManager.updatePassword(md5Str, (message) {
      if (message.isSuccess) {
        UserModel.removeUserInfo();
        Future<SharedPreferences> prefs = SharedPreferences.getInstance();
        prefs.then((value) {
          String? loginType = value.getString(FinalKeys.LOGIN_TYPE);
          if (loginType != null) {
            LoginType type =
                loginType == "1" ? LoginType.company : LoginType.personal;
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
}
