import 'dart:async';

import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../define/define_colors.dart';
import 'pay_password_successful.dart';
import 'pay_password_view/pay_password_view_page.dart';

//修改支付密码
class ModifyPaymentPasswordPage extends StatefulWidget {
  const ModifyPaymentPasswordPage({Key? key}) : super(key: key);

  @override
  State<ModifyPaymentPasswordPage> createState() =>
      _ModifyPaymentPasswordPageState();
}

class _ModifyPaymentPasswordPageState extends State<ModifyPaymentPasswordPage> {
  UserModel? userModel;

  ///原密码
  final originalPasswordController = TextEditingController();

  ///处理新密码
  final textNewPasswordController = TextEditingController();

  ///处理确认密码
  final textConfirmPasswordController = TextEditingController();

  ///密码错误信息
  String passwordErrorStr = "";

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
              "修改支付密码",
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
                _inputView("原密码", originalPasswordController, "请输入原密码"),
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
                    determineAction();
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

  void reloadView() {
    setState(() {});
  }

  void determineAction() {
    if (_checkData() == false) {
      return;
    }
    String original = originalPasswordController.text.toString();
    String originalPassword = original! + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5originalPassword = StringTools.generateMD5(originalPassword);

    MineManager.checkPayPassword(md5originalPassword, (message) {
      if (message.isSuccess) {
        String password = textNewPasswordController.text.toString();
        String newPassword = password! + FinalKeys.ENCRYPTION_MD5_KEY;
        String md5Str = StringTools.generateMD5(newPassword);

        Map<String, dynamic> temp = {"type": "2", "userPayPassword": md5Str};
        String rsaPassword = StringTools.generateRSA(temp);

        MineManager.updatePayPassword({"rsaEncryption": rsaPassword},
            (message) {
          ToastUtils.showMessage("修改支付密码成功");
          Navigator.of(context).pop();
        });
      }
    });
  }

  bool _checkData() {
    String originalPassword = originalPasswordController.text.toString();
    String password = textNewPasswordController.text.toString();
    String confirmPassword = textConfirmPasswordController.text.toString();
    bool flag = true;
    if (StringTools.isEmpty(originalPassword)) {
      passwordErrorStr = "请输入原密码";
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
