import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/report_home_manager.dart';
import 'package:credit_flutter/models/networking_message_model.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FixReport extends StatefulWidget {
  const FixReport({super.key});

  @override
  State<FixReport> createState() => _FixReportState();
}

class _FixReportState extends State<FixReport> {
  List<TextInputFormatter> nameInputFormatterList = [
    FilteringTextInputFormatter.deny(
      RegExp(
          "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
    ),
    LengthLimitingTextInputFormatter(20),
  ];
  List<TextInputFormatter> phoneInputFormatterList = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    LengthLimitingTextInputFormatter(11),
  ];

  List<TextInputFormatter> idInputFormatterList = [
    FilteringTextInputFormatter.allow(RegExp(r'[X,x,0-9]')),
    LengthLimitingTextInputFormatter(18),
  ];

  ///处理联系电话
  final textPhoneController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();

  ///处理修复信用人员的姓名
  final textNameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  ///处理身份证
  final textIdController = TextEditingController();
  FocusNode idFocusNode = FocusNode();

  ///处理简述
  final textSketchController = TextEditingController();
  FocusNode sketchFocusNode = FocusNode();

  ///名字信息
  String nameStr = "";

  ///手机号信息
  String phoneStr = "";

  ///身份证号信息
  String idStr = "";

  ///简述
  String sketchStr = "";

  String phoneErrorStr = "";

  String sketchErrorStr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getFixReportAppBar(),
      body: BaseBody(child: _bodyView()),
    );
  }

  AppBar _getFixReportAppBar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 0.0,
      centerTitle: true,
      backgroundColor: CustomColors.color021EC9,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _bodyView() {
    return Stack(
      children: [
        const Column(
          children: [
            SizedBox(
              height: 96,
            ),
            Image(
              image: AssetImage("assets/images/icon_home_bg_bottom.png"),
              width: double.infinity,
              height: 55,
              fit: BoxFit.fill,
            ),
          ],
        ),
        CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "assets/images/icon_home_bg_top.png",
                  fit: BoxFit.cover,
                ),
              ),
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 96,
              title: SizedBox(
                height: 96,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image:
                                AssetImage("assets/images/icon_logo_name.png"),
                            width: 125,
                            height: 29,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Container(
                            height: 36,
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1.0),
                              color: CustomColors.colorF82522,
                            ),
                            child: const Center(
                              child: Text(
                                '社会信用体系建设\n重 点 服 务 平 台',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 15),
                margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 14, bottom: 14),
                      width: double.infinity,
                      height: 60,
                      child: const Center(
                        child: Text(
                          "信用修复申请",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: const Text(
                        "*请输入真实信息以确保搜索的准确性",
                        style: TextStyle(
                            fontSize: 12, color: CustomColors.bgRedColor),
                      ),
                    ),
                    inputTextFiled(
                      "请输入需要修复信用人员的姓名",
                      "assets/images/nameIcon.png",
                      textNameController,
                      nameInputFormatterList,
                      TextInputType.text,
                    ),
                    inputTextFiled(
                      "请输入需要修复信用人员的身份证号",
                      "assets/images/idIcon.png",
                      textIdController,
                      idInputFormatterList,
                      TextInputType.text,
                    ),
                    inputTextFiled(
                      "请输入需要修复信用人员电话",
                      "assets/images/phoneIcon.png",
                      textPhoneController,
                      phoneInputFormatterList,
                      TextInputType.number,
                    ),
                    inputTextFiled(
                      "请输入需要修复的问题简述",
                      "assets/images/icon_comment.png",
                      textSketchController,
                      nameInputFormatterList,
                      TextInputType.text,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: const Text(
                        "请您输入要修复信用人员真实准确的姓名，身份证号以及需要修复的问题描述。我们不会泄露您的个人隐私，1-3个工作日内会有工作人员和您取得联系。",
                        style: TextStyle(
                            fontSize: 12, color: CustomColors.bgRedColor),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 14,
                        bottom: 14,
                      ),
                      child: MaterialButton(
                        color: CustomColors.lightBlue,
                        textColor: Colors.white,
                        minWidth: ScreenTool.screenWidth - 32 - 32,
                        height: 49,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _submit();
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "提交修复信息",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget inputTextFiled(
      String hintText,
      String iconPath,
      TextEditingController textEditingController,
      List<TextInputFormatter> inputFormatters,
      TextInputType inputType) {
    InputDecoration decoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
    );

    TextField textField = TextField(
      controller: textEditingController,
      onChanged: (str) {
        setState(() {});
        if (textEditingController == textNameController) {
          nameStr = str;
        } else if (textEditingController == textIdController) {
          idStr = str;
        } else if (textEditingController == textSketchController) {
          sketchStr = str;
        } else {
          phoneStr = str;
        }
      },
      inputFormatters: inputFormatters,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: inputType,
      decoration: decoration,
    );

    return Container(
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
      margin: const EdgeInsets.only(
        left: 16,
        top: 12,
        right: 16,
      ),
      padding: const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(iconPath),
            width: 20,
            height: 20,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: textField,
          ),
        ],
      ),
    );
  }

  bool verifyPhone() {
    bool flag = true;
    if (phoneStr.isEmpty) {
      phoneErrorStr = "手机号不能为空";
      flag = false;
    }
    if (!RegexUtils.verifyPhoneNumber(phoneStr)) {
      phoneErrorStr = "请输入正确手机号";
      flag = false;
    }
    return flag;
  }

  void _submit() {
    if (verifyPhone() == false) {
      ToastUtils.showMessage(phoneErrorStr);
      return;
    }
    if (sketchStr.isEmpty) {
      ToastUtils.showMessage("问题简述不能为空");
      return;
    }
    ReportHomeManager.reportPublicOpinion({
      "desc": sketchStr,
      "idcard": idStr,
      "name": nameStr,
      "phone": phoneStr
    }, (message) {
      if (message.isSuccess) {
        ToastUtils.showMessage("提交成功");
        Navigator.of(context).pop();
      } else {
        ToastUtils.showMessage("提交失败，请稍后再试");
      }
    });
  }
}
