import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/manager/person_employer_manager.dart';
import 'package:credit_flutter/manager/report_home_manager.dart';
import 'package:credit_flutter/models/company_report_home_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/certification_process_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_sample_page.dart';
import 'package:credit_flutter/pages/modules/report/report_preview_page.dart';
import 'package:credit_flutter/pages/modules/scan_code/scan_code_page.dart';
import 'package:credit_flutter/pages/root/base_body.dart';
import 'package:credit_flutter/pages/root/root_page.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/notification.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

///个人雇主
class PersonEmployerPage extends StatefulWidget {
  const PersonEmployerPage({Key? key}) : super(key: key);

  @override
  State<PersonEmployerPage> createState() => _PersonEmployerPageState();
}

class _PersonEmployerPageState extends State<PersonEmployerPage> {
  String titleStr = "慧眼查";

  // ///处理手机号
  // final textPhoneController = TextEditingController();
  // FocusNode phoneFocusNode = FocusNode();

  ///处理姓名
  final textNameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  ///处理身份证
  final textIdController = TextEditingController();
  FocusNode idFocusNode = FocusNode();

  ///名字信息
  String nameStr = "";

  // ///手机号信息
  // String phoneStr = "";

  ///身份证号信息
  String idStr = "";

  ///名字错误信息
  String nameErrorStr = "";

  // ///手机号错误信息
  // String phoneErrorStr = "";

  ///身份证号错误信息
  String idErrorStr = "";

  List<TextInputFormatter> nameInputFormatterList = [
    FilteringTextInputFormatter.deny(
      RegExp(
          "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]|[0-9]"),
    ),
    LengthLimitingTextInputFormatter(20),
  ];

  // List<TextInputFormatter> phoneInputFormatterList = [
  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //   LengthLimitingTextInputFormatter(11),
  // ];

  List<TextInputFormatter> idInputFormatterList = [
    FilteringTextInputFormatter.allow(RegExp(r'[X,x,0-9]')),
    LengthLimitingTextInputFormatter(18),
  ];

  @override
  void initState() {
    super.initState();

    UserModel.getInfo((model) {
      if (model != null) {
        if (!model.userInfo.getUserVerifiedStatus()) {
          PersonEmployerManager.getNotCertifiedReport((list) {
            if (list.isNotEmpty) {
              _showTip();
            }
          });
        } else {
          ReportHomeManager.getPersonList({
            "userType": 2,
            "pageNum": 1,
            "pageSize": 999,
          }, (object) {
            CompanyReportHomeBean bean = object as CompanyReportHomeBean;
            if (bean.data.isNotEmpty) {
              var box = Hive.box(HiveBoxs.dataBox);
              int ordedTimes = box.get(FinalKeys.ORDER_TIME) ?? 0;
              CompanyReportHomeData homeData = bean.data[0];
              if (ordedTimes == 0) {
                box.put(FinalKeys.ORDER_TIME, homeData.createTimeTs);
                jumpLogic();
              } else {
                if (ordedTimes < homeData.createTimeTs) {
                  box.put(FinalKeys.ORDER_TIME, homeData.createTimeTs);
                  jumpLogic();
                }
              }
            }
          });
        }
      }
    });

    UmengCommonSdk.onPageStart("person_employer_page");
  }

  void jumpLogic() {
    Golbal.currentIndex = 2;
    ToastUtils.showMessage("授权短信已发送至候选人手机，候选人授权后即可查看报告");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => RootPage(
                  pageNumber: 1,
                  isCertigier: true,
                )),
        (route) => route == null);
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
                      _classifiedInformationView(),
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
          // inputTextFiled(
          //   "手机号",
          //   "请输入被查询人的手机号",
          //   textPhoneController,
          //   phoneInputFormatterList,
          //   TextInputType.number,
          //   phoneFocusNode,
          // ),
          // Container(
          //   padding: const EdgeInsets.only(left: 16, right: 16),
          //   width: double.infinity,
          //   height: 51,
          //   child: const Text(
          //     "*本报告时经过他人明确授权后，才可调取他人报告的相关 信息。本报告仅向您个人展示，请注意保护好他人的隐私 数据。",
          //     style: TextStyle(fontSize: 12, color: CustomColors.color81),
          //   ),
          // ),
          const SizedBox(height: 2),
          WidgetTools().createCustomButton(
            ScreenTool.screenWidth - 60,
            "购买报告",
            () {
              var logOn = Golbal.token.isNotEmpty ? "已登录" : "未登录";
              // UmengCommonSdk.onEvent('individual_employer_click_query', {
              //   'data':
              //       'idCardName:$nameStr、idCard:$idStr、phone:$phoneStr、logOn:$logOn'
              // });
              UmengCommonSdk.onEvent('individual_employer_click_query',
                  {'data': 'idCardName:$nameStr、idCard:$idStr、logOn:$logOn'});
              // Map<String, dynamic> packet = {
              //   "idCard": idStr,
              //   "idCardName": nameStr,
              //   "phone": phoneStr
              // };
              Map<String, dynamic> packet = {
                "idCard": idStr,
                "idCardName": nameStr,
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
        }
        // else {
        //   phoneStr = str;
        // }
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

  Widget _classifiedInformationView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(width: 1, color: CustomColors.connectColor),
        borderRadius: BorderRadius.circular((8.0)),
      ),
      padding: const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 10),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _item("icon_flow_report_purchase", "报告购买"),
              _arrow(),
              _item("icon_flow_identity_authentication", "身份认证"),
              _arrow(),
              _item("icon_flow_send_message", "发送授权短信"),
              _arrow(),
              _item("icon_flow_candidate_authorization", "候选人授权"),
              _arrow(),
              _item("icon_flow_report_delivery", "报告交付"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(String image, String name) {
    return Column(
      children: [
        Image(
          image: AssetImage("assets/images/$image.png"),
          width: 25,
          height: 25,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _arrow() {
    return const Icon(
      Icons.arrow_right_alt,
      color: CustomColors.darkGrey,
      size: 18,
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
    // String phoneStr = map["phone"];

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

    // if (StringTools.isEmpty(phoneStr)) {
    //   ToastUtils.showMessage("手机号不能为空");
    //   return;
    // }
    // if (!RegexUtils.verifyPhoneNumber(phoneStr)) {
    //   ToastUtils.showMessage("请输入正确手机号");
    //   return;
    // }

    _payment(map);
  }

  ///判断身份信息
  _payment(Map<String, dynamic> map) {
    UserModel.getInfo((model) {
      if (model != null) {
        if (model.userInfo.getUserVerifiedStatus()) {
          _goBuy(map);
        } else {
          PersonEmployerManager.getNotCertifiedReport((list) {
            if (list.isNotEmpty) {
              _showTip();
            } else {
              _goBuy(map);
            }
          });
        }
      }
    });
  }

  ///购买报告
  void _goBuy(Map<String, dynamic> map) {
    ///获取报告价格
    PayManager.getReportPrice(1, (price) {
      // PayCheakstandPage page = PayCheakstandPage(
      //   displayType: PaymentListDisplayType.paymentListAllDisplay,
      //   fromType: PaymentFromType.paymentFromPersonBuyPersonReport,
      //   price: price,
      //   reportType: 1,
      // );
      // page.packet = map;
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return page;
      //     },
      //   ),
      // );
      ReportPreviewPage page = ReportPreviewPage(
        displayType: PaymentListDisplayType.paymentListAllDisplay,
        fromType: PaymentFromType.paymentFromPersonBuyPersonReport,
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
        NotificationCener.instance
            .postNotification(FinalKeys.NOTIFICATION_COUNTDOWN);
      });
    });
  }

  ///身份认证弹框
  void _showTip() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(38),
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                const Text(
                  "您有订单未完成\n请进行身份认证以完成订单",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: CustomColors.greyBlack),
                ),
                const SizedBox(
                  height: 14,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.connectColor,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
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
                            _updatePersonalInfo(certifyId);
                          }
                        }
                      },
                    );
                  },
                  child: const Text(
                    "去认证",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///设置认证状态
  void _updatePersonalInfo(String certifyId) {
    LoginManager.authCheck(
      {"certifyId": certifyId},
      (message) {
        MineHomeManager.userUpdateUserInfo((message) {});
        ToastUtils.showMessage("授权短信已发送至候选人手机，候选人授权后即可查看报告");
      },
    );
  }
}
