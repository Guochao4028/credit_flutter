import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/mine_manager.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../../../define/define_colors.dart';
import 'forgot_payment_password_page.dart';

//修改支付密码
class NewModifyPaymentPasswordPage extends StatefulWidget {
  const NewModifyPaymentPasswordPage({Key? key}) : super(key: key);

  @override
  State<NewModifyPaymentPasswordPage> createState() =>
      _NewModifyPaymentPasswordPageState();
}

class _NewModifyPaymentPasswordPageState
    extends State<NewModifyPaymentPasswordPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _node = FocusNode();

  var step = 1;

  ///处理新密码
  var textNewPassword = "";

  ///处理确认密码
  var textConfirmPassword = "";

//页面销毁
  @override
  void dispose() {
    super.dispose();
    //释放
    _node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double passwordWidth = (ScreenTool.screenWidth - 50 - 50) / 6;

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
                const SizedBox(
                  height: 38,
                ),
                Center(
                  child: Text(
                    getClewTxt(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CustomColors.darkGrey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: PinCodeTextField(
                    controller: _controller,
                    pinBoxOuterPadding:
                        const EdgeInsets.symmetric(horizontal: 0.0),

                    ///输入框尺寸
                    pinBoxHeight: passwordWidth,
                    // pinBoxHeight: 38,
                    pinBoxWidth: passwordWidth,
                    isCupertino: true,
                    maxLength: 6,

                    ///是否隐藏输入的字符,当为true时和maskCharacter配合使用可以显示占位符
                    hideCharacter: true,
                    maskCharacter: "●",

                    ///输入文本样式
                    // pinTextStyle: TextStyle(fontSize: 20, color: Colors.deepPurple),

                    ///已经输入过的输入显示的颜色
                    hasTextBorderColor: CustomColors.lightGrey,
                    // hasTextBorderColor: borderColor,

                    focusNode: _node,

                    ///输入结束时获取输入的内容
                    onDone: (text) {
                      verification();
                    },

                    ///监听输入了中的文本
                    onTextChanged: (text) {},
                    autofocus: true,

                    wrapAlignment: WrapAlignment.start,

                    ///输入方向rtl：从右往左输入；；ltr:从左往右输入
                    textDirection: TextDirection.ltr,

                    ///键盘类型
                    keyboardType: TextInputType.number,

                    ///输入框没有焦点时背景色
                    pinBoxColor: Colors.white,

                    ///输入框边框宽度
                    pinBoxBorderWidth: 0.5,

                    ///输入框边框圆角
                    pinBoxRadius: 0,
                    hideDefaultKeyboard: false,

                    defaultBorderColor: CustomColors.lightGrey,
                    // defaultBorderColor: borderColor,

                    ///输入框已经输入背景色
                    highlightPinBoxColor: Colors.white,
                  ),
                ),
                if (step == 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) =>
                                    const ForgotPaymentPasswordPage()),
                              ),
                            );
                          },
                          child: const Text(
                            "忘记密码？",
                            style: TextStyle(
                              fontSize: 11,
                              color: CustomColors.darkGrey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        )
                      ],
                    ),
                  ),

                // WidgetTools().createCustomButton(
                //   ScreenTool.screenWidth - 60,
                //   "确定",
                //   () {
                //     determineAction();
                //   },
                //   bgColor: CustomColors.lightBlue,
                //   textColor: CustomColors.whiteColor,
                //   radius: 25,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getClewTxt() {
    switch (step) {
      case 1:
        return "输入支付密码，完成身份验证";
      case 2:
        return "设置6位数字支付密码";
      case 3:
        return "请再次填写确认";
      default:
        return "";
    }
  }

  void verification() {
    switch (step) {
      case 1:
        verifyOriginalPassword();
        break;
      case 2:
        textNewPassword = _controller.text.toString();
        step = 3;
        _controller.clear();
        reloadView();
        FocusScope.of(context).requestFocus(_node);
        break;
      case 3:
        if (textNewPassword == _controller.text.toString()) {
          String password = _controller.text.toString();
          String newPassword = password! + FinalKeys.ENCRYPTION_MD5_KEY;
          String md5Str = StringTools.generateMD5(newPassword);

          Map<String, dynamic> temp = {"type": "2", "userPayPassword": md5Str};
          String rsaPassword = StringTools.generateRSA(temp);

          MineManager.updatePayPassword({"rsaEncryption": rsaPassword},
              (message) {
            ToastUtils.showMessage("修改支付密码成功");
            Navigator.of(context).pop();
          });
        } else {
          ToastUtils.showMessage("密码不一致，请从新输入");
          textNewPassword = "";
          step = 2;
          _controller.clear();
          reloadView();
        }
        break;
      default:
        break;
    }
  }

  void verifyOriginalPassword() {
    String original = _controller.text.toString();
    String originalPassword = original! + FinalKeys.ENCRYPTION_MD5_KEY;
    String md5originalPassword = StringTools.generateMD5(originalPassword);

    MineManager.checkPayPassword(md5originalPassword, (message) {
      if (message.isSuccess) {
        //密码正确
        step = 2;
      } else {
        //原密码不正确
        ToastUtils.showMessage("密码不正确，请从新输入");
      }
      _controller.clear();
      reloadView();
      FocusScope.of(context).requestFocus(_node);
    });
  }

  void reloadView() {
    setState(() {});
  }

// void determineAction() {
//   if (_checkData() == false) {
//     return;
//   }
//   String original = originalPasswordController.text.toString();
//   String originalPassword = original! + FinalKeys.ENCRYPTION_MD5_KEY;
//   String md5originalPassword = StringTools.generateMD5(originalPassword);
//
//   MineManager.checkPayPassword(md5originalPassword, (message) {
//     if (message.isSuccess) {

//     }
//   });
// }
//
// bool _checkData() {
//   String originalPassword = originalPasswordController.text.toString();
//   String password = textNewPasswordController.text.toString();
//   String confirmPassword = textConfirmPasswordController.text.toString();
//   bool flag = true;
//   if (StringTools.isEmpty(originalPassword)) {
//     passwordErrorStr = "请输入原密码";
//     flag = false;
//     setState(() {});
//     return flag;
//   }
//   if (StringTools.isEmpty(password)) {
//     passwordErrorStr = "请输入新密码";
//     flag = false;
//     setState(() {});
//     return flag;
//   }
//   if (StringTools.isEmpty(confirmPassword)) {
//     passwordErrorStr = "请再次输入密码";
//     flag = false;
//     setState(() {});
//     return flag;
//   }
//   if (password != confirmPassword) {
//     passwordErrorStr = "密码不一致";
//     flag = false;
//     setState(() {});
//     return flag;
//   }
//
//   setState(() {});
//   return flag;
// }

}
