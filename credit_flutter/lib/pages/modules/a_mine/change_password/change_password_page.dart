/// *
/// -  @Date: 2022-07-04 10:49
/// -  @LastEditTime: 2022-07-04 10:57
/// -  @Description:
///
/// *
/// -  @Date: 2022-07-04 10:49
/// -  @LastEditTime: 2022-07-04 10:55
/// -  @Description: 修改密码
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/pages/modules/login/forgot_password_page.dart';
import 'package:credit_flutter/pages/modules/mine/change_password/setup_new_password_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ///处理密码
  final textController = TextEditingController();

  ///密码错误信息
  String passwordErrorStr = "";

  ///密码信息
  String passwordStr = "";

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
                "1、验证身份",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.textDarkColor,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                "原密码",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.lightGrey,
                ),
              ),
              TextField(
                controller: textController,
                onChanged: (str) {
                  passwordErrorStr = "";
                  setState(() {});

                  passwordStr = str;
                },
                cursorColor: Colors.black,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "请输入原密码",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z,a-z,0-9]')),
                ],
              ),
              Container(
                height: 1,
                color: CustomColors.lineColor,
              ),
              Row(
                children: [
                  addErrorPrompt(passwordErrorStr),
                  const Expanded(child: SizedBox()),
                  _pCreateTextButton(
                      "忘记原密码", CustomColors.lightGrey, null, null),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              WidgetTools().createCustomButton(
                ScreenTool.screenWidth - 60,
                "下一步",
                () => {_next()},
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

  InkWell _pCreateTextButton(
      String title, Color color, double? fontSize, Color? bgColor) {
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
        _pTapAction();
      },
    );
  }

  void _pTapAction() {
    //忘记密码
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => const ForgotPasswordPage(
              type: PageType.password,
            )),
      ),
    );
  }

  ///下一步
  void _next() {
    if (StringTools.isEmpty(passwordStr)) {
      passwordErrorStr = "请输入原密码";
      setState(() {});
      return;
    }
    String newPassword = passwordStr + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5Str = StringTools.generateMD5(newPassword);

    MineManager.checkPassword(md5Str, (message) {
      if (message.isSuccess) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => SetupNewPasswordPage(
                  type: PageType.password,
                )),
          ),
        );
      }
    });
  }
}
