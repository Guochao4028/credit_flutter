/// *
/// -  @Date: 2022-09-21 15:05
/// -  @LastEditTime: 2022-09-21 15:05
/// -  @Description: 个人信息页面
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../tools/string_tool.dart';
import '../../../../../../utils/toast_utils.dart';

class ModifyInfoPage extends StatefulWidget {
  //1:姓名、2:地址、3:微信、4:邮箱、5:公司名称、6:职位、7:工作年限
  final int type;
  final String content;

  const ModifyInfoPage({Key? key, required this.type, required this.content})
      : super(key: key);

  @override
  State<ModifyInfoPage> createState() => _ModifyInfoPageState();
}

class _ModifyInfoPageState extends State<ModifyInfoPage> {
  var controller = TextEditingController();
  var isError = false;
  var isEmpty = false;

  TextInputFormatter formatter = FilteringTextInputFormatter.deny(RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"));
  TextInputFormatter textFormatter = FilteringTextInputFormatter.deny(RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"));
  TextInputFormatter phoneNumebrFormatter =
      FilteringTextInputFormatter.allow(RegExp("[0-9]"));

  @override
  void initState() {
    //初始化主页面
    super.initState();
    controller.text = widget.content.toString();
    isEmpty = widget.content.toString().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorF1F4F9,
      appBar: AppBar(
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          getName(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      body: GestureDetector(
        onPanDown: (details) {
          closeKeyboard(context);
        },
        child: Column(
          children: [
            initBody(),
            _submit(),
          ],
        ),
      ),
    );
  }

  Widget _itemEnter(int maxLength, String hintText, TextInputType keyboardType,
      TextInputFormatter formatter) {
    InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 15,
        color: isError ? CustomColors.warningColor : CustomColors.lightGrey,
      ),
    );

    return Container(
      padding: const EdgeInsets.only(left: 16, top: 18, right: 16, bottom: 18),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      onChanged: (text) {
                        isEmpty = text.isNotEmpty;
                        setState(() {});
                      },
                      keyboardType: keyboardType,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(maxLength),
                        formatter
                      ],
                      controller: controller,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: inputDecoration,
                    ),
                  ],
                )),
                if (controller.text.isNotEmpty)
                  InkWell(
                    onTap: () {
                      controller.clear();
                      isEmpty = false;
                      setState(() {});
                    },
                    child: const Image(
                      image: AssetImage("assets/images/icon_circle_closed.png"),
                      width: 16,
                      height: 16,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell _submit() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 49,
        margin: const EdgeInsets.only(left: 30, right: 30, top: 16),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24.5)),
          child: _buttonContainerView(),
        ),
      ),
      onTap: () {
        _commit();
      },
    );
  }

  Widget _buttonContainerView() {
    Color bgColor;
    String titleStr;
    Color titleColor;

    if (isEmpty) {
      bgColor = CustomColors.lightBlue;
    } else {
      bgColor = CustomColors.colorC1C1C1;
    }

    titleStr = "保存";
    titleColor = Colors.white;

    return Container(
      color: bgColor,
      width: double.infinity,
      height: 49,
      alignment: Alignment.center,
      child: Text(
        titleStr,
        style: TextStyle(
          color: titleColor,
          fontSize: 15,
        ),
      ),
    );
  }

  void _commit() {
    if (controller.text.isEmpty) {
      ToastUtils.showMessage("请输入${getName()}");
      return;
    }

    if (widget.type == 4) {
      if (controller.text.isNotEmpty && !StringTools.isEmail(controller.text)) {
        ToastUtils.showMessage("请输入正确的邮箱");
        return;
      }
    }

    Map<String, dynamic> param = {};

    switch (widget.type) {
      case 1:
        param["name"] = controller.text;
        break;
      case 2:
        param["address"] = controller.text;
        break;
      case 3:
        param["wechatId"] = controller.text;
        break;
      case 4:
        param["email"] = controller.text;
        break;
      case 5:
        param["companyName"] = controller.text;
        break;
      case 6:
        param["position"] = controller.text;
        break;
      case 7:
        param["workAge"] = controller.text;
        break;
    }

    LoginManager.modify(param, (message) {
      ToastUtils.showMessage("保存成功");
      Navigator.pop(context, controller.text);
    });
  }

  void closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    /// 键盘是否是弹起状态
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  String getName() {
    var name = "";
    //1:姓名、2:地址、3:微信、4:邮箱、5:公司名称、6:职位、7:工作年限

    switch (widget.type) {
      case 1:
        name = "姓名";
        break;
      case 2:
        name = "地址";
        break;
      case 3:
        name = "微信";
        break;
      case 4:
        name = "邮箱";
        break;
      case 5:
        name = "公司名称";
        break;
      case 6:
        name = "职位";
        break;
      case 7:
        name = "工作年限";
        break;
    }
    return name;
  }

  initBody() {
    switch (widget.type) {
      case 1:
        return _itemEnter(10, "请输入您的姓名", TextInputType.text, formatter);
      case 2:
        return _itemEnter(50, "请输入您的所在地址", TextInputType.text, textFormatter);
      case 3:
        return _itemEnter(
          50,
          "请输入您的微信号",
          TextInputType.text,
          FilteringTextInputFormatter.allow(RegExp("[A-Z,a-z,0-9]|[_]")),
        );
      case 4:
        return _itemEnter(
            50, "请输入您的邮箱号", TextInputType.emailAddress, textFormatter);
      case 5:
        return _itemEnter(50, "请输入您的公司名称", TextInputType.text, formatter);
      case 6:
        return _itemEnter(10, "请输入您的职位名称", TextInputType.text, formatter);
      case 7:
        return _itemEnter(
          2,
          "请输入您的工作年限",
          TextInputType.number,
          phoneNumebrFormatter,
        );
    }
  }
}
