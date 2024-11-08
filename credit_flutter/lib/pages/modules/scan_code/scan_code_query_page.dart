import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/company_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_sample_page.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

///扫码二级代理商二维码查询
class ScanCodeQueryPage extends StatefulWidget {
  String authorizationCode;

  ScanCodeQueryPage({Key? key, required this.authorizationCode})
      : super(key: key);

  @override
  State<ScanCodeQueryPage> createState() => _ScanCodeQueryPageState();
}

class _ScanCodeQueryPageState extends State<ScanCodeQueryPage> {
  String titleStr = "查询报告";

  String licenceName = "";

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

  var authorizationCode = "";

  @override
  void initState() {
    super.initState();
    authorizationCode = widget.authorizationCode.toString();
    CompanyManager.companyGetInfoByCode(
      authorizationCode,
      (map) {
        licenceName = map["licenceName"];
        setState(() {});
      },
    );

    UmengCommonSdk.onPageStart("person_employer_page");
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("person_employer_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseBody(
        child: Stack(
          children: [
            backgroundImage(),
            ListView(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Stack(
                        children: [
                          characterMaking(
                              titleStr, 17, true, false, Colors.white, true),
                        ],
                      ),
                      const SizedBox(height: 12),
                      characterMaking(
                          licenceName, 26, true, false, Colors.white, true),
                      const SizedBox(height: 15),
                      characterMaking(
                          "需要查询您的信用报告", 16, true, false, Colors.white, true),
                      const SizedBox(height: 12),
                      characterMaking("在您购买报告并完成授权后该公司可查看您的信息报告", 12, false,
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
  Widget backgroundImage() {
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
                "assets/images/icon_shandiandun.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///字体展示
  Widget characterMaking(String str, double fontSize, bool isBold,
      bool isShadow, Color? color, bool isCenter) {
    return Container(
      width: double.infinity,
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
            ),
          ),
          const SizedBox(height: 2),
          WidgetTools().createCustomButton(
            ScreenTool.screenWidth - 60,
            "购买报告",
            () {
              Map<String, dynamic> packet = {
                "idCard": idStr,
                "idCardName": nameStr,
                "phone": phoneStr,
                "authorizationCode": authorizationCode,
              };
              tapPurchaseReport(packet);
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
          characterMaking("说明", 12, false, false, CustomColors.darkGrey, false),
          const SizedBox(height: 8),
          const Expanded(
            child: Text(
              "1、请确保为被查询人是本人亲自授权才可查看到其个人信息；\n2、严格遵守监管要求，他人的信息会进行加密处理。\n3、恪守保密原则，未经过同意，不会将信息透露给任何的第三方。\n4、如果因您本人所造成的导致信息泄漏问题，需要您本进行承担。\n",
              style: TextStyle(fontSize: 12, color: CustomColors.darkGrey),
            ),
          ),
        ],
      ),
    );
  }

  ///查看报告样例
  Widget sampleReportView(String contentStr) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NewReportDetailsSamplePage();
            },
          ),
        );
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

  ///购买报告按钮
  void tapPurchaseReport(Map<String, dynamic> map) {
    String idStr = map["idCard"];
    String nameStr = map["idCardName"];
    String phoneStr = map["phone"];

    if (StringTools.isEmpty(nameStr)) {
      ToastUtils.showMessage("姓名不能为空");
      return;
    }
    if (StringTools.checkSpace(nameStr)) {
      ToastUtils.showMessage("姓名中不能有空格或特殊符号");
      return;
    }
    if (StringTools.checkABC(nameStr)) {
      ToastUtils.showMessage("姓名中不能有英文字母");
      return;
    }

    Map idMap = StringTools.verifyCardId(idStr);
    if (idMap["state"] == false) {
      ToastUtils.showMessage(idMap["message"]);
      return;
    }

    if (StringTools.isEmpty(phoneStr)) {
      ToastUtils.showMessage("手机号不能为空");
      return;
    }
    if (!RegexUtils.verifyPhoneNumber(phoneStr)) {
      ToastUtils.showMessage("请输入正确手机号");
      return;
    }

    _goBuy(map);
  }

  ///购买报告
  void _goBuy(Map<String, dynamic> map) {
    ///获取报告价格
    PayManager.getReportPrice(1, (price) {
      PayCheakstandPage page = PayCheakstandPage(
        displayType: PaymentListDisplayType.paymentListAllDisplay,
        fromType: PaymentFromType.paymentFromPersonalPaymentForCompanyPurchase,
        price: price,
        reportType: 1,
      );
      page.packet = map;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return page;
          },
        ),
      ).then((value) {
        if (value != null) {
          Navigator.of(context).pop();
          // textPhoneController.clear();
          // textNameController.clear();
          // textIdController.clear();
          // setState(() {});
        }
      });
    });
  }
}
