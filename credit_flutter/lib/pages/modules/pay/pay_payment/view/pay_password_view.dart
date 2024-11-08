/// *
/// -  @Date: 2022-07-18 09:56
/// -  @LastEditTime: 2022-07-18 10:08
/// -  @Description:  密码弹框功能
///

import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
// import 'package:hb_password_input_textfield/hb_password_input_textfield.dart';

import 'package:pin_code_text_field/pin_code_text_field.dart';

abstract class InputPasswordClickListener {
  ///关闭
  void closeInput();

  ///忘记密码
  void forgotPassword();

  /// 输入结束
  /// 验证密码是否输入正确或者锁定
  void finishInputPassword(
      String password, String orderNumber, CheckAccountCallBack callBack);
}

class PayInputPasswordWindowDialog extends StatefulWidget {
  ///支付方式标题
  final String title;

  ///价格
  final String? content;

  ///提示
  final String prompt;

  final String orderNumber;

  ///是否可输入
  final bool isInput;

  final InputPasswordClickListener? clickListener;

  PayInputPasswordWindowDialog(
      {
      // this.cancelColor = Colors.white,
      // this.confirmColor = CustomColors.lightBlue,
      this.title = '慧眼币支付',
      this.content = '',
      this.prompt = '',
      this.clickListener,
      this.orderNumber = '',
      this.isInput = true,
      Key? key})
      : super(key: key);

  @override
  State<PayInputPasswordWindowDialog> createState() =>
      _PayInputPasswordWindowDialogState();
}

class _PayInputPasswordWindowDialogState
    extends State<PayInputPasswordWindowDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _node = FocusNode();

  ///支付方式标题
  String? _title;

  ///价格
  String? _content;

  ///提示
  String? _prompt;

  String? _orderNumber;

  ///是否可输入
  bool? _isInput;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _content = widget.content;
    _prompt = widget.prompt;
    _orderNumber = widget.orderNumber;
    _isInput = widget.isInput;
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = CustomColors.lightGrey;
    if (_isInput == false) {
      borderColor = CustomColors.bgRedColor;
    } else {
      _getFocusFunction(context);
    }

    double passwordWidth = (ScreenTool.screenWidth - 60 - 38 - 38) / 6;
    return InkWell(
      onTap: () => {
        // Navigator.of(context).pop(),
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(116, 0, 0, 0),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(38),
              constraints: const BoxConstraints(
                maxHeight: 242,
              ),
              width: double.infinity,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///关闭按钮
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () {
                          widget.clickListener?.closeInput();
                          _node.unfocus();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: CustomColors.lightGrey,
                        ),
                      ),
                    ],
                  ),

                  ///标题
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: const Text(
                      "请输入支付密码",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: CustomColors.greyBlack),
                    ),
                  ),

                  ///支付方式标题
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      _title ?? "",
                      style: const TextStyle(
                          fontSize: 15, color: CustomColors.greyBlack),
                    ),
                  ),

                  ///价格
                  Container(
                    margin: const EdgeInsets.only(bottom: 13),
                    child: Text(
                      StringTools.numberFormat(_content!, true),
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ///密码输入框
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: PinCodeTextField(
                      controller: _controller,
                      pinBoxOuterPadding:
                          const EdgeInsets.symmetric(horizontal: 0.0),

                      ///输入框尺寸
                      pinBoxHeight: 38,
                      pinBoxWidth: passwordWidth,
                      isCupertino: true,
                      maxLength: 6,

                      ///是否隐藏输入的字符,当为true时和maskCharacter配合使用可以显示占位符
                      hideCharacter: true,
                      maskCharacter: "●",

                      ///输入文本样式
                      // pinTextStyle: TextStyle(fontSize: 20, color: Colors.deepPurple),

                      ///已经输入过的输入显示的颜色
                      hasTextBorderColor: borderColor,

                      focusNode: _node,

                      ///输入结束时获取输入的内容
                      onDone: (text) {
                        if (_isInput == true) {
                          if (text.isNotEmpty && text.length == 6) {
                            widget.clickListener?.finishInputPassword(
                              text,
                              _orderNumber!,
                              (success, uModel) {
                                if (success == false) {
                                  ToastUtils.showMessage("支付密码错误");
                                  bool isLock =
                                      uModel?.userInfo.getPayPasswordLock() ??
                                          false;
                                  if (isLock == true) {
                                    _isInput = !isLock;
                                    _prompt = "三次错误自动锁定，请重新设置";
                                  }
                                  setState(() {});
                                }
                              },
                            );
                            // _node.unfocus();
                            // Navigator.of(context).pop();
                            _controller.text = "";
                          }
                        } else {
                          _controller.clear();
                          setState(() {});
                        }
                      },

                      ///监听输入了中的文本
                      onTextChanged: (text) {
                        if (_isInput == false) {
                          _controller.text = "";
                        }
                      },
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

                      defaultBorderColor: borderColor,

                      ///输入框已经输入背景色
                      highlightPinBoxColor: Colors.white,
                    ),
                  ),

                  ///提示语，忘记密码
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 30, left: 30, right: 30),
                    child: Row(
                      children: [
                        Text(
                          _prompt!,
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        const Expanded(child: SizedBox()),

                        ///忘记密码
                        _pCreateTextButton(
                            "忘记密码?", CustomColors.lightBlue, 11, null, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //获取焦点
  void _getFocusFunction(BuildContext context) {
    if (!PlatformUtils.isWeb) {
      FocusScope.of(context).requestFocus(_node);
    }
  }

  ///
  /// @description: 创建一个带文字的按钮
  ///@return InkWell
  ///@parm:  title 标题， color字体颜色 fontSize字号 tapType 点击类型 bgColor 背景颜色
  ///
  InkWell _pCreateTextButton(String title, Color color, double? fontSize,
      Color? bgColor, BuildContext context) {
    if (fontSize == 0) {
      fontSize = 15;
    }
    bgColor ??= Colors.white;

    return InkWell(
      child: Container(
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
        _node.unfocus();
        Navigator.of(context).pop();
        widget.clickListener?.forgotPassword();
      },
    );
  }
}
