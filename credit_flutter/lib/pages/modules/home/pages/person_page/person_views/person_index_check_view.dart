/// *
/// -  @Date: 2023-04-27 14:40
/// -  @LastEditTime: 2023-04-27 14:44
/// -  @Description:个人查个人首页
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/scan_code/scan_code_page.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'person_index_view.dart';

class PersonIndexCheckView extends PersonIndexView {
  PersonIndexCheckView(
      {required super.clickListener,
      required super.userModel,
      required super.isInputUM});

  ///处理手机号
  final textPhoneController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();

  ///处理姓名
  final textNameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  ///处理身份证
  final textIdController = TextEditingController();
  FocusNode idFocusNode = FocusNode();

  ///名字信息
  String nameStr = "";

  ///手机号信息
  String phoneStr = "";

  ///身份证号信息
  String idStr = "";

  ///名字错误信息
  String nameErrorStr = "";

  ///手机号错误信息
  String phoneErrorStr = "";

  ///身份证号错误信息
  String idErrorStr = "";

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

  @override
  Widget contentView(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lightGreyF7,
      body: BaseBody(
        child: Stack(
          children: [
            bbackgroundImage(),
            ListView(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Stack(
                        // alignment : AlignmentDirectional.centerEnd,
                        children: [
                          characterMaking(
                              30, "查询报告", 17, true, false, Colors.white, true),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (context) {
                              //           return const ScanCodePage();
                              //         },
                              //       ),
                              //     );
                              //   },
                              //   highlightColor: Colors.transparent,
                              //   splashColor: Colors.transparent,
                              //   child: const Image(
                              //     image: AssetImage(
                              //         "assets/images/icon_scan_code.png"),
                              //     width: 30,
                              //     height: 30,
                              //   ),
                              // ),
                              const SizedBox(
                                width: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      characterMaking(18, "采用超级安全加密方式，确保隐私不被泄漏", 13, false,
                          false, Colors.white, true),
                      const SizedBox(height: 17),
                      characterMaking(30, "全面筛查黑名单及重大风险", 22, true, true,
                          Colors.white, true),
                      const SizedBox(height: 13),
                      characterMaking(22, "及时了解他人风险  ｜  精准报告全面分析 ", 16, false,
                          false, Colors.white, true),
                      const SizedBox(height: 16),
                      homeView(),
                      const SizedBox(height: 10),
                      descriptionView(),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///背景处理
  Widget bbackgroundImage() {
    return SizedBox(
      width: double.infinity,
      height: 345,
      child: Stack(
        children: [
          const Image(
            image: AssetImage("assets/images/personIndexBG.png"),
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
          Positioned(
            left: ScreenTool.screenWidth - 98 + 12,
            bottom: 159,
            child: SizedBox(
              width: 98,
              height: 98,
              child: Image.asset(
                "assets/images/xinIcon.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///字体展示
  Widget characterMaking(double height, String str, double fontSize,
      bool isBold, bool isShadow, Color? color, bool isCenter) {
    return Container(
      width: double.infinity,
      height: height,
      alignment: isCenter ? Alignment.center : Alignment.centerLeft,
      child: Text(
        str,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
          color: color,
          shadows: isShadow
              ? const [Shadow(color: Colors.black, blurRadius: 4)]
              : [],
        ),
      ),
    );
  }

  ///输入页 操作
  Widget homeView() {
    return Container(
      width: double.infinity,
      // height: 348,
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.only(top: 11, left: 16, right: 16, bottom: 14),
      decoration: const BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        children: [
          inputTextFiled(
            "姓    名",
            "请输入被查询人的姓名",
            textNameController,
            nameInputFormatterList,
            TextInputType.text,
            nameFocusNode,
          ),
          inputTextFiled(
            "身份证",
            "请输入被查询人的身份证号",
            textIdController,
            idInputFormatterList,
            TextInputType.text,
            idFocusNode,
          ),
          inputTextFiled(
            "手机号",
            "请输入被查询人的手机号",
            textPhoneController,
            phoneInputFormatterList,
            TextInputType.number,
            phoneFocusNode,
          ),
          Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              width: double.infinity,
              height: 51,
              child: const Text(
                "*本报告时经过他人明确授权后，才可调取他人报告的相关 信息。本报告仅向您个人展示，请注意保护好他人的隐私 数据。",
                style: TextStyle(fontSize: 12, color: CustomColors.color81),
              )),
          const SizedBox(height: 2),
          WidgetTools().createCustomButton(
            ScreenTool.screenWidth - 60,
            "购买报告",
            () {
              Map<String, dynamic> packet = {
                "idCard": idStr,
                "idCardName": nameStr,
                "phone": phoneStr
              };
              clickListener?.tapPurchaseReport(packet);
            },
            bgColor: CustomColors.lightBlue,
            textColor: Colors.white,
            radius: 23,
            height: 40,
            shadow: const BoxShadow(),
          ),
          const SizedBox(height: 9),
          sampleReportView("查看报告样例"),
        ],
      ),
    );
  }

  Widget inputTextFiled(
      String titleText,
      String hintText,
      TextEditingController textEditingController,
      List<TextInputFormatter> inputFormatters,
      TextInputType inputType,
      FocusNode focusNode) {
    InputDecoration decoration = InputDecoration(
      isCollapsed: true,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: Colors.grey,
      ),
    );

    TextField textField = TextField(
      autofocus: false,
      focusNode: focusNode,
      controller: textEditingController,
      onChanged: (str) {
        if (textEditingController == textNameController) {
          nameStr = str;
        } else if (textEditingController == textIdController) {
          idStr = str;
        } else {
          phoneStr = str;
        }

        if (super.isInputUM == true) {
          UmengCommonSdk.onEvent("SeeReportSamplePurchaseLaterInput",
              {"location": "personIndex", "content": str});
        }
      },
      inputFormatters: inputFormatters,
      // cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: inputType,
      decoration: decoration,
    );

    Container line = Container(
      height: 1,
      color: CustomColors.lineColor,
    );
    // textField
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                titleText,
                style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.darkGrey3C,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: textField,
              ),
            ],
          ),
          const SizedBox(height: 19),
          line
        ],
      ),
    );
  }

  ///说明
  Widget descriptionView() {
    return Container(
      width: double.infinity,
      height: 184,
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.only(top: 11, left: 16, right: 16, bottom: 14),
      decoration: const BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        children: [
          characterMaking(
              17, "说明", 12, false, false, CustomColors.darkGrey, false),
          const SizedBox(height: 8),
          const Expanded(
              child: Text(
            "1、请确保为被查询人是本人亲自授权才可查看到其个人信息；\n2、严格遵守监管要求，他人的信息会进行加密处理。\n3、恪守保密原则，未经过同意，不会将信息透露给任何的第三方。\n4、如果因您本人所造成的导致信息泄漏问题，需要您本进行承担。\n",
            style: TextStyle(fontSize: 12, color: CustomColors.darkGrey),
          ))
        ],
      ),
    );
  }

  ///查看报告样例
  Widget sampleReportView(String contentStr) {
    return GestureDetector(
      onTap: () {
        clickListener?.example();
      },
      child: Container(
        width: double.infinity,
        height: 17,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Text(
          contentStr,
          style: const TextStyle(
            fontSize: 12,
            decoration: TextDecoration.underline,
            color: CustomColors.textBlue,
            decorationThickness: 1,
          ),
        ),
      ),
    );
  }
}
