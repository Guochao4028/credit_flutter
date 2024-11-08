/// *
/// -  @Date: 2023-09-11 15:44
/// -  @LastEditTime: 2023-09-11 15:44
/// -  @Description: 雇主 支付成功后填写手机号
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/order_manager.dart';
import 'package:credit_flutter/models/order_list_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/certification_process_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_status/pay_success_page.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/regex_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:credit_flutter/define/define_keys.dart';

class PaySuccessInputPhonePage extends StatefulWidget {
  final String orderNo;
  const PaySuccessInputPhonePage({super.key, required this.orderNo});

  @override
  State<PaySuccessInputPhonePage> createState() =>
      _PaySuccessInputPhonePageState();
}

class _PaySuccessInputPhonePageState extends State<PaySuccessInputPhonePage> {
  String orderId = "";
  TextStyle greyBlackTextStyle = const TextStyle(
    color: CustomColors.greyBlack,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  TextStyle darkGreyTextStyle = const TextStyle(
    color: CustomColors.darkGrey,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  TextStyle lightGreyTextStyle = const TextStyle(
    color: CustomColors.lightGrey,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  final Container _line = Container(
    margin: const EdgeInsets.only(top: 5, bottom: 5),
    height: 2,
    color: CustomColors.lineColor,
  );

  ///输入要查询人的手机号，您要查询的授权请求...
  Container promptInfoContainer = Container(
    padding: const EdgeInsets.only(
      left: 16,
      right: 16,
      top: 11,
    ),
    child: const Text(
      "输入要查询人的手机号，您要查询的授权请求 将会以短信的方式发送到对方手机上，对方授权成功后方可看到要查询的信息。",
      style: TextStyle(
        color: CustomColors.colorE20000,
        fontSize: 10,
      ),
    ),
  );

  ///处理手机号
  final textPhoneController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();

  ///手机号错误信息
  String phoneErrorStr = "";

  ///手机号信息
  String phoneStr = "";

  List<TextInputFormatter> phoneInputFormatterList = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    LengthLimitingTextInputFormatter(11),
  ];

  OrderDetailsModel? detailsModel;

  LoginType loginType = LoginType.employer;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "填写授权手机号",
          style: greyBlackTextStyle,
        ),
      ),
      body: BaseBody(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              _infoRowView(
                  "被查询人姓名", detailsModel?.reportUserName.toString() ?? ""),
              _line,
              _infoRowView(
                  "被查询人身份证号", detailsModel?.reportIdCard.toString() ?? ""),
              _line,
              _inputRowView("被查询人手机号", ""),
              _line,
              promptInfoContainer,
              Container(
                margin: EdgeInsets.only(top: 15),
                child: WidgetTools().createCustomButton(
                  ScreenTool.screenWidth - 60,
                  "下一步",
                  () {
                    cancelFocus();
                    if (verifyPhone()) {
                      OrderManager.orderSupplementPhone(
                          {"orderId": orderId, "phone": phoneStr}, (map) {
                        if (Golbal.token.isNotEmpty) {
                          UserModel.getInfo((model) {
                            if (model != null) {
                              if (model.userInfo.getUserVerifiedStatus()) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => RootPage(
                                        pageNumber: 0,
                                      ),
                                    ),
                                    (route) => route == null);
                              } else {
                                _realNameAuthentication();
                              }
                            }
                          });
                        } else {
                          var box = Hive.box(HiveBoxs.dataBox);
                          box.put(FinalKeys.BUY_PHONE, phoneStr);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => PaySuccessPage(
                                  orderNo: orderId,
                                ),
                              ),
                              (route) => route == null);
                        }
                      });
                    } else {
                      ToastUtils.showMessage(phoneErrorStr);
                    }
                  },
                  bgColor: CustomColors.lightBlue,
                  textColor: Colors.white,
                  radius: 32,
                  height: 40,
                  shadow: const BoxShadow(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRowView(String titleStr, String contentStr) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleStr,
            style: lightGreyTextStyle,
          ),
          Text(
            contentStr,
            style: darkGreyTextStyle,
          )
        ],
      ),
    );
  }

  Widget _inputRowView(String titleStr, String contentStr) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleStr,
            style: greyBlackTextStyle,
          ),
          inputTextFiled(
            "请输入被查询人手机号",
            textPhoneController,
            phoneInputFormatterList,
            TextInputType.number,
          ),
        ],
      ),
    );
  }

  void cancelFocus() {
    phoneFocusNode.unfocus();
  }

  Widget inputTextFiled(
      String hintText,
      TextEditingController textEditingController,
      List<TextInputFormatter> inputFormatters,
      TextInputType inputType) {
    InputDecoration decoration = InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(0),
      isCollapsed: true,
      hintText: hintText,
      hintStyle: const TextStyle(
          fontSize: 15,
          color: CustomColors.color81,
          fontWeight: FontWeight.bold),
    );

    TextField textField = TextField(
      controller: textEditingController,
      textDirection: TextDirection.rtl,
      style: greyBlackTextStyle,
      onChanged: (str) {
        phoneErrorStr = "";
        setState(() {});
        if (textEditingController == textPhoneController) {
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
      alignment: Alignment.centerRight,
      width: 155,
      child: textField,
    );
  }

  Widget addErrorPrompt(String title) {
    return Offstage(
      offstage: StringTools.isEmpty(title),
      child: Container(
        padding: const EdgeInsets.only(left: 34),
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

  void _initData() {
    orderId = widget.orderNo;
    var box = Hive.box(HiveBoxs.dataBox);
    if (Golbal.token.isEmpty) {
      /// 登陆类型
      int type = box.get(FinalKeys.Quick_STANDING);
      if (type != 2) {
        loginType = LoginType.personal;
      }
    }

    if (orderId.isEmpty) {
      orderId = box.get(FinalKeys.Quick_BUY_Order_ID);
    }

    OrderManager.getOrderInfo({
      "orderId": orderId,
    }, (object) {
      detailsModel = object as OrderDetailsModel;
      setState(() {});
    });
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

  void _realNameAuthentication() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const CertificationProcessPage();
        },
      ),
    ).then(
      (value) {
        if (value != null) {
          var certifyId = value["certifyId"];
          var result = value["result"];
          if (result) {
            LoginManager.authCheck(
              {"certifyId": certifyId},
              (message) {
                MineHomeManager.userUpdateUserInfo((message) {
                  ToastUtils.showMessage("认证成功");
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => RootPage(
                          pageNumber: 0,
                        ),
                      ), (route) {
                    return route == null;
                  });
                });
              },
            );
          }
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
