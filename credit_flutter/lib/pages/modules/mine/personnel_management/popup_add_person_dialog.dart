/// *
/// -  @Date: 2022-06-22 15:40
/// -  @LastEditTime: 2022-06-22 15:49
/// -  @Description: 添加管理人员 弹窗
///

import 'package:credit_flutter/define/define_block.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AddPersonClickListener {
  void onAffirm(Map<String, dynamic> confirmMap);

  void validation(String phoneNumber, NetworkObjectCallBack callBack);
}

class PopupAddPersonDialog extends StatefulWidget {
  final AddPersonClickListener? clickListener;

  ///剩余可添加人数
  String personNumber;

  PopupAddPersonDialog({
    Key? key,
    this.clickListener,
    this.personNumber = "0",
  }) : super(key: key);

  @override
  State<PopupAddPersonDialog> createState() => _PopupAddPersonDialogState();
}

class _PopupAddPersonDialogState extends State<PopupAddPersonDialog> {
  ///处理手机号
  final _textPhoneController = TextEditingController();

  ///处理姓名
  final _textNameController = TextEditingController();

  ///处理名称
  final _textIdController = TextEditingController();

  ///标题
  final String _title = "添加管理人员";

  ///确认文案
  final String _confirm = "添加";

  ///剩余可添加人数
  bool isRegistered = true;

  ///错误信息
  String phoneErrorStr = "";
  String nameErrorStr = "";
  String idErrorStr = "";

  String phoneStr = "";
  String nameStr = "";
  String idStr = "";

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> nameInputFormatterList = [
      FilteringTextInputFormatter.allow(RegExp(r'[\u4e00-\u9fa5, A-Z,a-z,.]')),
      FilteringTextInputFormatter.deny(
        RegExp(
            "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
      ),
      LengthLimitingTextInputFormatter(10),
    ];
    List<TextInputFormatter> phoneInputFormatterList = [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      LengthLimitingTextInputFormatter(11),
    ];

    List<TextInputFormatter> idInputFormatterList = [
      LengthLimitingTextInputFormatter(10),
    ];

    return InkWell(
        onTap: () => {
              // Navigator.of(context).pop(),
            },
        child: Scaffold(
          backgroundColor: Color.fromARGB(116, 0, 0, 0),
          body: SingleChildScrollView(
            child: BaseBody(
              child: Container(
                width: double.infinity,
                height: 472,
                margin: const EdgeInsets.all(38),
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///关闭按钮
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        alignment: Alignment.centerRight,
                        icon: const Icon(Icons.close_outlined),
                        iconSize: 15,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),

                    ///标题
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        _title,
                        style: const TextStyle(
                            fontSize: 17, color: CustomColors.greyBlack),
                      ),
                    ),

                    ///*剩余可添加人数 1
                    _remainingNumberView(),

                    _inputItemView(
                      "手机号",
                      "(将作为账号使用)",
                      "请输入手机号",
                      _textPhoneController,
                      context,
                      TextInputType.phone,
                      phoneInputFormatterList,
                    ),
                    _inputItemView(
                      "姓名",
                      "",
                      "请输入姓名",
                      _textNameController,
                      context,
                      TextInputType.text,
                      nameInputFormatterList,
                    ),

                    _inputItemView(
                      "添加人员名称",
                      "",
                      "例如：HR人事或主管",
                      _textIdController,
                      context,
                      TextInputType.text,
                      idInputFormatterList,
                    ),

                    _getBottomWidget(context),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _getBottomWidget(context) {
    return InkWell(
      child: Container(
        height: 35,
        width: 145,
        margin: const EdgeInsets.only(bottom: 22),
        decoration: const ShapeDecoration(
          color: CustomColors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _confirm,
          style: const TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () => {
        if (determineLegal())
          {
            widget.clickListener?.onAffirm({
              "title": _confirm,
              "name": nameStr,
              "phone": phoneStr,
              "id": idStr,
            }),
            Navigator.of(context).pop(),
          }
      },
    );
  }

  /// *
  /// -  @description: 剩余可添加人数
  /// -  @Date: 2022-09-06 17:37
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _remainingNumberView() {
    String numberStr = widget.personNumber;
    TextStyle textStyle =
        const TextStyle(fontSize: 13, color: CustomColors.redColor61B);
    return Container(
      padding: const EdgeInsets.only(right: 16),
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Text(
            "*剩余可添加人数 ",
            style: textStyle,
          ),
          Text(
            numberStr,
            style: textStyle,
          ),
        ],
      ),
    );
  }

  /// *
  /// -  @description: 标题 + 输入框
  /// -  @Date: 2022-09-06 17:37
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _inputItemView(
      String titleStr,
      String instructionsStr,
      String hintText,
      TextEditingController textEditingController,
      BuildContext context,
      TextInputType inputType,
      List<TextInputFormatter> inputFormatters) {
    TextStyle textStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    TextStyle textStyle1 =
        const TextStyle(fontSize: 13, color: CustomColors.lightGrey);

    Widget errorView = const SizedBox(height: 1);
    if (textEditingController == _textPhoneController) {
      errorView = addErrorPrompt(phoneErrorStr);
    } else if (textEditingController == _textNameController) {
      errorView = addErrorPrompt(nameErrorStr);
    } else if (textEditingController == _textIdController) {
      errorView = addErrorPrompt(idErrorStr);
    }

    return SizedBox(
      width: double.infinity,
      // height: 8,
      child: Column(
        children: [
          ///title
          Row(
            children: [
              Text(
                titleStr,
                style: textStyle,
              ),
              Text(
                instructionsStr,
                style: textStyle1,
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          ///输入框
          inputTextFiled(
            hintText,
            textEditingController,
            inputType,
            context,
            inputFormatters,
          ),
          errorView,
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget inputTextFiled(
    String hintText,
    TextEditingController textEditingController,
    TextInputType inputType,
    BuildContext context,
    List<TextInputFormatter> inputFormatters,
  ) {
    InputDecoration decoration = InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      focusedBorder: _inputBorder(),
      disabledBorder: _inputBorder(),
      errorBorder: _inputBorder(),
      focusedErrorBorder: _inputBorder(),
      enabledBorder: _inputBorder(),
      border: _inputBorder(),
      contentPadding: const EdgeInsets.all(0),
    );

    TextField textField = TextField(
      controller: textEditingController,
      onChanged: (str) {
        if (textEditingController == _textPhoneController) {
          if (str.length == 11) {
            phoneStr = str;
            if (verifyPhone()) {
              phoneErrorStr = "";
              widget.clickListener?.validation(phoneStr, (object) {
                isRegistered = object == 1 ? false : true;

                if (isRegistered == false) {
                  phoneErrorStr = "该账号不存在，请通知用户进行注册";
                }
                setState(() {});
              });
            } else {
              setState(() {});
            }
          }
        } else if (textEditingController == _textNameController) {
          nameStr = str;
        } else if (textEditingController == _textIdController) {
          idStr = str;
        }
      },
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: inputFormatters,
      keyboardType: inputType,
      decoration: decoration,
      maxLines: 1,
    );

    return SizedBox(
      height: 35,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.lightGrey,
            width: 0.5,
          ),
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        padding: const EdgeInsets.only(left: 16),
        child: textField,
      ),
    );
  }

  Widget addErrorPrompt(String title) {
    return Offstage(
      offstage: StringTools.isEmpty(title),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.warningColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool verifyPhone() {
    nameErrorStr = "";
    idErrorStr = "";
    bool flag = true;
    if (StringTools.isEmpty(phoneStr)) {
      phoneErrorStr = "手机号不能为空";
      flag = false;
    }
    if (!RegexUtils.verifyPhoneNumber(phoneStr)) {
      phoneErrorStr = "请输入正确手机号";
      flag = false;
    }
    return flag;
  }

  bool verifyName() {
    phoneErrorStr = "";
    idErrorStr = "";
    bool flag = true;
    if (StringTools.isEmpty(nameStr)) {
      nameErrorStr = "姓名不能为空";
      flag = false;
      return flag;
    }

    if (StringTools.checkSpace(nameStr)) {
      nameErrorStr = "姓名中不能有空格或特殊符号";
      flag = false;
      return flag;
    }

    if (StringTools.checkABC(nameStr)) {
      nameErrorStr = "姓名中不能有英文字母";
      flag = false;
      return flag;
    }

    return flag;
  }

  bool verifyId() {
    phoneErrorStr = "";
    nameErrorStr = "";
    bool flag = true;

    if (StringTools.isEmpty(idStr)) {
      idErrorStr = "人员名称不能为空";
      flag = false;
      return flag;
    }
    return flag;
  }

  bool determineLegal() {
    bool flag = true;

    if (!verifyPhone()) {
      flag = false;
    } else if (!verifyName()) {
      flag = false;
    } else if (!verifyId()) {
      flag = false;
    }

    setState(() {});
    return flag;
  }

  InputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 0, color: Colors.transparent),
    );
  }
}
