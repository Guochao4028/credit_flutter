/// *
/// -  @Date: 2022-07-11 13:47
/// -  @LastEditTime: 2022-07-11 13:47
/// -  @Description: 处理所有支付密码页面view
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// *
/// -  @description: 支付密码
/// -  @Date: 2022-07-11 15:09
/// -  @parm:
/// -  @return {*}
///
class PayPasswordPageView {
  final PayPasswordPageViewClickListener? clickListener;

  PayPasswordPageView({this.clickListener, Key? key});

  Widget payPasswordListView(List<Map<String, dynamic>> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        Map itmeModel = list[index];
        return InkWell(
          onTap: () {
            clickListener?.tapPayPasswordListItem(index);
          },
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            width: double.infinity,
            height: 55,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          itmeModel["name"],
                          style: const TextStyle(
                            fontSize: 15,
                            color: CustomColors.darkGrey,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 26,
                        color: Color(0xFFC8C9CD),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: CustomColors.colorF1F4F9,
                ),
              ],
            ),
          ),
        );

        // return ListTile(
        //   title: Text(
        //     itmeModel["name"],
        //     style: const TextStyle(
        //         fontSize: 15, color: CustomColors.textDarkColor),
        //   ),
        //   trailing: const Icon(Icons.keyboard_arrow_right),
        //   onTap: () {
        //     clickListener?.tapPayPasswordListItem(index);
        //   },
        // );
      },
    );
  }
}

abstract class PayPasswordPageViewClickListener {
  ///点击支付密码入口
  tapPayPasswordListItem(int index);
}

/// *
/// -  @description: 设置支付密码
/// -  @Date: 2022-07-11 15:09
/// -  @parm:
/// -  @return {*}
///
class PaySetupPasswordPageView {
  final PaySetupPasswordPageViewClickListener? clickListener;

  //倒计时数值
  var countdownTime = 0;

  ///新密码
  String newPasswordStr = "";

  ///确认密码
  String confirmPasswordStr = "";

  String codeStr = "";

  ///处理新密码
  final textNewPasswordController = TextEditingController();

  ///处理确认密码
  final textConfirmPasswordController = TextEditingController();

  ///验证码
  final textCodeController = TextEditingController();

  ///倒计时文案
  String timeText = "获取验证码";

  ///密码错误信息
  String passwordErrorStr = "";

  String phoneNumberStr = "";

  PaySetupPasswordPageView(
      {this.clickListener, required this.phoneNumberStr, Key? key});

  Widget paySetupPasswordView() {
    if (phoneNumberStr.isNotEmpty) {
      return Column(
        children: [
          _phoneNumberView(),
          _verificationCode(),
          _inputView("支付密码", textNewPasswordController, "请输入6位的数字支付密码"),
          _inputView("确认支付密码", textConfirmPasswordController, "请再次输入6位的数字支付密码"),
          _addErrorPrompt(passwordErrorStr),
          const SizedBox(
            height: 50,
          ),
          WidgetTools().createCustomButton(
            ScreenTool.screenWidth - 60,
            "确定",
            () {
              clickListener?.determineAction({
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
      );
    } else {
      return const SizedBox();
    }
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
              clickListener?.reloadView();
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
                      clickListener?.statrTime();
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
        clickListener?.reloadView();

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
}

abstract class PaySetupPasswordPageViewClickListener {
  ///刷新页面
  void reloadView();

  ///倒计时
  void statrTime();

  ///确定
  void determineAction(Map<String, String> map);
}
