import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/mine_home_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/manager/person_employer_manager.dart';
import 'package:credit_flutter/manager/report_details_manager.dart';
import 'package:credit_flutter/manager/report_home_manager.dart';
import 'package:credit_flutter/models/company_report_home_bean.dart';
import 'package:credit_flutter/models/financial_risk_partial_report_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/empower/notification_statement_page.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/certification/certification_process_page.dart';
import 'package:credit_flutter/pages/modules/home/views/finance_unlock_view.dart';
import 'package:credit_flutter/pages/modules/mine/about/contact_us_page.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_page.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_sample_page.dart';
import 'package:credit_flutter/pages/modules/scan_code/scan_code_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/new_popup_window.dart';
import 'package:credit_flutter/utils/pop_option_widget.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

/// 个人自查
class RevisionPersonIndexPage extends StatefulWidget {
  const RevisionPersonIndexPage({Key? key}) : super(key: key);

  @override
  State<RevisionPersonIndexPage> createState() =>
      _RevisionPersonIndexPageState();
}

class _RevisionPersonIndexPageState extends State<RevisionPersonIndexPage>
    implements PopOptionWidgetClickListener {
  //姓名
  String name = "";

  //身份证号
  String idCard = "";

  //性别
  String gender = "";

  //年龄
  String age = "";

  //出生日期
  String birth = "";

  //户籍
  String domicile = "";

  //手机号
  String phoneNumber = "";

  //运营商
  String operator = "";

  //社保
  String workAge = "";

  //委托日期
  String createTime = "";

  //交付日期
  String completeTime = "";

  List<String> showList = [
    "失信被执行人",
    "社会不良信息",
    "学历相关信息",
    "终本执行案件",
    "裁判文书信息",
    "税务违法信息",
    "违法行业禁止",
    "失信被执行人信息",
    "限制消费人员",
    "限飞限乘名单",
  ];

// bool isHaveReport = false;

//是否购买报告
  bool isPurchase = false;

//是否实名
  bool verified = false;
  bool verified1 = false;

  //报告类型
  int reportType = -1;

  //底部按钮状态
  int authorizationStatus = -1;

  String reportId = "";
  int authId = 0;

  var ifVisible = false;

  FinancialRiskPartialReportModel? frModel;

  @override
  void initState() {
    super.initState();
    _loadData();
    bus.on("real_name_refresh", (arg) {
      _loadData();
    });
    UmengCommonSdk.onPageStart("revision_person_index_page");
  }

  @override
  void dispose() {
    super.dispose();
    bus.off("real_name_refresh");
    UmengCommonSdk.onPageEnd("revision_person_index_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: CustomColors.lightBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.lightBlue,
        titleSpacing: 0.0,
        centerTitle: true,
        title: const Text(
          "慧眼查",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        actions: [
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
              //     image: AssetImage("assets/images/icon_scan_code.png"),
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
      body: _body(context),
    );
  }

  Widget _topView() {
    if (!verified1) {
      return Container(color: CustomColors.lightBlue, height: 256);
    }
    if (verified) {
      return _userInfo();
    } else {
      return Container(
        height: 256,
        color: CustomColors.lightBlue,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 34,
          bottom: 60,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 12,
            bottom: 12,
          ),
          decoration: const BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Image(
                      image: AssetImage(
                          "assets/images/icon_not_certified_person.png"),
                      fit: BoxFit.fitHeight,
                      height: double.infinity,
                    ),
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewReportDetailsSamplePage(),
                        ),
                      );
                    },
                    child: const Text(
                      "查看报告样例",
                      style: TextStyle(
                        color: CustomColors.lightBlue,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "个人职场背调报告",
                      style: TextStyle(
                        color: CustomColors.greyBlack,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: const ShapeDecoration(
                                    color: CustomColors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                                const Text(
                                  "查学历",
                                  style: TextStyle(
                                    color: CustomColors.greyBlack,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: const ShapeDecoration(
                                    color: CustomColors.redColor914,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                                const Text(
                                  "查证书",
                                  style: TextStyle(
                                    color: CustomColors.greyBlack,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: const ShapeDecoration(
                                    color: CustomColors.redColor61B,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                                const Text(
                                  "查风险",
                                  style: TextStyle(
                                    color: CustomColors.greyBlack,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        UmengCommonSdk.onEvent(
                            "personal_click_query_cow", {"type": "count"});
                        _ifIdentity(1, false);
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: const ShapeDecoration(
                          color: CustomColors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "立即查询",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
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
            ],
          ),
        ),
      );
    }
  }

  Widget _userInfo() {
    String birthday = StringTools.getBirthdayFromCardId(idCard);

    return Container(
      height: 256,
      color: CustomColors.lightBlue,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 34, bottom: 60),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
        decoration: const BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 55,
              child: Row(
                children: [
                  ///头像
                  _headPortrait(name),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        StringTools.hiddenInfoString(name),
                        style: const TextStyle(
                            color: CustomColors.textDarkColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "生于：$birthday",
                        style: const TextStyle(
                          color: CustomColors.lightGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewReportDetailsSamplePage(),
                            ),
                          );
                        },
                        child: const Text(
                          "查看报告样例",
                          style: TextStyle(
                            color: CustomColors.lightBlue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            /// 社保 ，身份证号
            _workInfo(idCard, workAge),
          ],
        ),
      ),
    );
  }

  Widget _headPortrait(String name) {
    if (name.isNotEmpty) {
      name = name.substring(0, 1);
    }
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        //背景
        color: CustomColors.connectColor,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _workInfo(String idCard, String workAge) {
    return SizedBox(
      height: 55,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 4,
              ),
              Text(
                workAge,
                style: const TextStyle(
                    color: CustomColors.textDarkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "社保累计",
                style: TextStyle(
                  color: CustomColors.lightGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 4,
              ),
              Text(
                StringTools.hiddenInfoString(idCard, type: 1),
                style: const TextStyle(
                    color: CustomColors.textDarkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "身份证号",
                style: TextStyle(
                  color: CustomColors.lightGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _classifiedInformationView() {
    return Column(
      children: [
        const SizedBox(
          height: 220,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: CustomColors.connectColor),
            borderRadius: BorderRadius.circular((8.0)),
            color: Colors.white,
          ),
          margin: const EdgeInsets.only(left: 16, right: 16),
          height: 280,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 0, right: 0),
                padding: const EdgeInsets.only(left: 15, top: 18),
                height: 48,
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  "本次综合查询信息",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 180,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  //禁止滑动
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 147 / 21,
                    crossAxisCount: 2,
                    //水平单个子Widget之间间距
                    mainAxisSpacing: 10.0,

                    //垂直单个子Widget之间间距
                    crossAxisSpacing: 10.0,
                  ),
                  // itemCount: itmeList.length,
                  itemCount: showList.length,
                  itemBuilder: (BuildContext context, int index) {
                    //自定义的行 代码在下面
                    return _showGridViewItem(context, showList[index], index);
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 16, right: 16),
                height: 1,
                child: Container(
                  color: CustomColors.darkGreyE5,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                // height: 28,
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "*共记",
                        style: TextStyle(
                          color: CustomColors.darkGrey99,
                          fontSize: 13.0,
                        ),
                      ),
                      TextSpan(
                        text: "20",
                        style: TextStyle(
                            color: CustomColors.redColor61B, fontSize: 13.0),
                      ),
                      TextSpan(
                          text: "类个人信息",
                          style: TextStyle(
                              color: CustomColors.darkGrey99, fontSize: 13.0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "查看时间   永久",
          style: TextStyle(color: CustomColors.darkGrey99, fontSize: 13.0),
        ),
        if (!verified) _flowPathView(),
        const SizedBox(
          height: 70,
        ),
      ],
    );
  }

  Widget _showGridViewItem(BuildContext context, String titleStr, int index) {
    Color textNumberColor = Colors.red;
    String number = (index + 1).toString();

    switch (index) {
      case 0:
        textNumberColor = CustomColors.redColorD46;
        break;
      case 1:
        textNumberColor = CustomColors.redColor704;
        break;
      default:
        textNumberColor = CustomColors.redColor914;
    }

    Widget numberView = SizedBox(
      width: 25,
      child: Text(
        number,
        style: TextStyle(
          color: textNumberColor,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        textAlign: TextAlign.start,
      ),
    );

    Widget titleView = SizedBox(
      child: Text(
        titleStr,
        style: const TextStyle(
          color: CustomColors.lightBlue,
          fontSize: 15,
        ),
        textAlign: TextAlign.start,
      ),
    );

    return SizedBox(
      width: 147,
      height: 21,
      child: Row(
        children: <Widget>[
          numberView,
          Expanded(child: titleView),
        ],
      ),
    );
  }

  Widget _itemView() {
    // bool isHaveReport = userModel.userInfo.reportId.isNotEmpty;
    // double width = 170;
    // if (isHaveReport) {
    //   width = 260;
    // }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(right: 16, left: 16),
      height: 69,
      alignment: Alignment.centerRight,
      child: SizedBox(
        // width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          //交叉轴的布局方式，对于column来说就是水平方向的布局方式
          crossAxisAlignment: CrossAxisAlignment.center,
          //就是字child的垂直布局方向，向上还是向下
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            // 更新
            customUpdateButton(),
            //下载
            customDownloadButton(),
            //查看&购买
            customButton(),
          ],
        ),
      ),
    );
  }

  Widget customUpdateButton() {
    // bool isHaveReport = userModel.userInfo.reportId.isNotEmpty;
    return Offstage(
      offstage: authorizationStatus != 1,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          UmengCommonSdk.onEvent("personal_click_update", {"type": "count"});
          _update();
        },
        child: SizedBox(
          width: 80,
          height: 30,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              color: CustomColors.whiteBlueColorFE,
              width: double.infinity,
              height: double.infinity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "更新",
                    style: TextStyle(
                      color: CustomColors.lightBlue,
                      fontSize: 14,
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

  Widget customDownloadButton() {
    return Offstage(
      offstage: authorizationStatus != 1,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, on) {
                  return PopOptionWidget(
                    titleStr: "下载员工背调报告",
                    imagePath: "assets/images/ed.png",
                    hintText: "请输入您的邮箱号",
                    instructions: "您的员工背调报告会发送到指定邮箱，方便您进行打印",
                    textIconPath: "assets/images/icon_Mailbox.png",
                    identify: "download",
                    pClickListener: this,
                  );
                });
              });
        },
        child: Container(
          width: 80,
          height: 30,
          margin: const EdgeInsets.only(left: 10),
          decoration: const ShapeDecoration(
            color: CustomColors.whiteBlueColorFE,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "下载",
                style: TextStyle(
                  color: CustomColors.lightBlue,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell customButton() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (isPurchase) {
          //以购买
          //2.待授权 3.已拒绝 4.授权中 5.未认证状态下已支付订单
          switch (authorizationStatus) {
            case 1:
              //1.已授权 - 查看
              _look();
              break;
            case 2:
              //2.待授权
              // titleStr = "授权";
              _goEmpower();
              break;
            case 3:
              //3.已拒绝 - 购买
              UmengCommonSdk.onEvent(
                  "personal_click_purchase", {"type": "count"});
              _ifIdentity(1, false);
              break;
            case 4:
              //4.授权中 - 不做操作
              break;
          }
        } else {
          //未购买 - 购买
          _ifIdentity(1, false);
        }
      },
      child: Container(
        width: 80,
        height: 30,
        margin: const EdgeInsets.only(left: 10),
        decoration: const ShapeDecoration(
          color: CustomColors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            buttonTitle(),
          ],
        ),
      ),
    );
  }

  Widget buttonTitle() {
    String titleStr = "";
    Color color = Colors.white;
    if (isPurchase) {
      //以购买
      //2.待授权 3.已拒绝 4.授权中 5.未认证状态下已支付订单
      switch (authorizationStatus) {
        case 1:
          //1.已授权
          titleStr = "查看";
          break;
        case 2:
          //2.待授权
          titleStr = "授权";
          break;
        case 3:
          //3.已拒绝
          titleStr = "购买";
          break;
        case 4:
          //4.授权中
          titleStr = "授权中";
          break;
      }

      // if (isHaveReport) {
      //   titleStr = "查看";
      // } else {
      //   titleStr = "授权";
      // }
    } else {
      titleStr = "购买";
    }
    return Text(
      titleStr,
      style: TextStyle(
        color: color,
        fontSize: 14,
      ),
    );
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
        MineHomeManager.userUpdateUserInfo((message) {
          _loadData();
        });
      },
    );
  }

  void _ifIdentity(int type, bool bool) {
    UserModel.getInfo((model) {
      if (model != null) {
        var userInfo = model.userInfo;
        if (!userInfo.getUserVerifiedStatus()) {
          PersonEmployerManager.getNotCertifiedReport((list) {
            if (list.isNotEmpty) {
              _showTip();
            } else {
              _goBuy(type, bool);
            }
          });
        } else {
          _goBuy(type, bool);
        }
      }
    });
  }

  void _goBuy(int type, bool bool) {
    PayManager.getReportPrice(type, (price) {
      PayCheakstandPage page;
      if (type == 1) {
        if (bool) {
          //五块报告-购买完整版本
          page = PayCheakstandPage(
            displayType: PaymentListDisplayType.paymentListAllDisplay,
            fromType: PaymentFromType.paymentFrom5yuanReportUpgradeType,
            price: price,
            reportType: 1,
          );
        } else {
          //正常购买流程
          page = PayCheakstandPage(
            displayType: PaymentListDisplayType.paymentListAllDisplay,
            fromType: PaymentFromType.paymentFromPersonType,
            price: price,
            reportType: 1,
          );
        }
      } else {
        page = PayCheakstandPage(
          displayType: PaymentListDisplayType.paymentListAllDisplay,
          fromType: PaymentFromType.paymentFromCheckYourselfForFiveYuan,
          price: price,
          reportType: 6,
        );
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    });
  }

  void _loadData() {
    UserModel.getInfo((model) {
      if (model != null) {
        var userInfo = model.userInfo;

        verified = userInfo.getUserVerifiedStatus();
        verified1 = true;
        if (userInfo.getUserVerifiedStatus()) {
          name = userInfo.idCardName;
        } else {
          name = userInfo.telPhone.substring(7, 11);
        }
        var time = DateTime.now();
        createTime = "委托日期：${time.year}-${time.month}-${time.day}";

        if (userInfo.getUserVerifiedStatus()) {
          idCard = userInfo.idCard;
          workAge = userInfo.workAge.isEmpty ? "5" : userInfo.workAge;

          ReportHomeManager.getPersonList({
            "userType": 2,
            "pageNum": 1,
            "pageSize": 999,
          }, (object) {
            _controller.finishRefresh();
            CompanyReportHomeBean bean = object as CompanyReportHomeBean;
            isPurchase = bean.data.isNotEmpty;
            if (bean.data.isEmpty) {
              model.userInfo.reportBuyStatus = 0;
            } else {
              model.userInfo.reportBuyStatus = 1;

              CompanyReportHomeData companyReportHomeData;
              //1.已授权 2.待授权 3.已拒绝 4.授权中 5.未认证状态下已支付订单
              if (bean.data[0].authorizationStatus == 3) {
                //第一条数据是已拒绝
                Iterable<CompanyReportHomeData> tempList = bean.data
                    .where((element) => element.authorizationStatus == 1);
                if (tempList.isNotEmpty) {
                  //存在已经授权的
                  companyReportHomeData = tempList.first;
                } else {
                  //不存在已授权的
                  companyReportHomeData = bean.data[0];
                }
              } else {
                companyReportHomeData = bean.data[0];
              }

              reportType = companyReportHomeData.reportType;
              authorizationStatus = companyReportHomeData.authorizationStatus;
              reportId = companyReportHomeData.reportId.toString();
              authId = companyReportHomeData.reportAuthId;
            }
            if (reportType == 6 && authorizationStatus == 1) {
              ReportDetailsManager.getFinanceRiskPartReportData(reportId,
                  (object) {
                frModel = object as FinancialRiskPartialReportModel;
                // //姓名
                name = frModel?.creditReportDigest.name ?? "";
                // //性别
                gender = frModel?.creditReportDigest.sex ?? "";
                idCard = frModel?.creditReportDigest.idNo ?? "";
                if (gender.isEmpty) {
                  gender = StringTools.getSexFromCardId(idCard);
                }
                // //年龄
                age = frModel?.inputMap.age.toString() ?? "";
                if (age.isEmpty || age == "0") {
                  age = StringTools.getAgeFromCardId(idCard);
                }
                // //出生日期
                var dateTime = DateTime.fromMillisecondsSinceEpoch(
                    frModel?.creditReportDigest.birthday ?? 0);
                birth = "${dateTime.year}.${dateTime.month}.${dateTime.day}";

                // //户籍
                // domicile = model.creditReportDigest.householdAddr;

                // //手机号
                // phoneNumber = model.creditReportDigest.mobile;

                // //运营商
                // var itemData120 = model.detail.operatorHours.itemData120;
                // if (itemData120.isNotEmpty) {
                //   operator = itemData120[0].itemPropValue;
                // }

                // //身份证号
                // idCard = model.creditReportDigest.idNo;

                // //创建时间
                var time = DateTime.fromMillisecondsSinceEpoch(
                    frModel?.reportInfo.createTime ?? 0);
                createTime = "委托日期：${time.year}-${time.month}-${time.day}";

                // //授权完成时间（时间 戳） completeTime
                var complete = DateTime.fromMillisecondsSinceEpoch(
                    frModel?.reportInfo.completeTime ?? 0);
                completeTime =
                    "交付日期：${complete.year}-${complete.month}-${complete.day}";

                setState(() {});
              });
            } else {
              setState(() {});
            }
          });
        } else {
          PersonEmployerManager.getNotCertifiedReport((list) {
            if (list.isNotEmpty) {
              _showTip();
            }
          });
          setState(() {});
        }
      }
    });
  }

  void _look() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewReportDetailsPage(
          reportId: reportId,
          authId: authId.toString(),
        ),
      ),
    );
  }

  void _goEmpower() {
    showDialog(
      context: context,
      builder: (context1) {
        return NewPopupWindowDialog(
          title: "提示",
          confirm: "去授权",
          cancel: "取消",
          content: "需要进行短信授权才可查看个人报告",
          contentAlign: TextAlign.center,
          contentEdgeInsets: const EdgeInsets.only(left: 39, right: 39),
          contentStyle: const TextStyle(fontSize: 15),
          showCancel: true,
          cancelOnTap: () {
            //取消文案
            Navigator.of(context1).pop();
          },
          confirmOnTap: () {
            //确定
            Navigator.of(context1).pop();
            ReportHomeManager.getCompanyNameForMessage(
              {"id": authId.toString()},
              (str) {
                var companyName = str["companyName"];
                var idCard = str["idCard"];
                var name = str["name"];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return NotificationStatementPage(
                        type: 1,
                        companyName: companyName.toString(),
                        idCard: idCard.toString(),
                        name: name.toString(),
                        reportAuthId: authId.toString(),
                      );
                    },
                  ),
                ).then((value) {
                  if (value != null) {
                    _loadData();
                  }
                });
              },
            );
          },
        );
      },
    );
  }

  @override
  void onAffirm(Map<String, dynamic> confirmMap) {
    String id = confirmMap["id"];
    String contentStr = confirmMap["contentStr"];
    if (id == "share") {
      MineHomeManager.shareReport({"code": contentStr}, (message) {
        ToastUtils.showMessage(message.reason);
      });
    }

    if (id == "download") {
      MineHomeManager.downloadReport({"mail": contentStr}, (message) {
        ToastUtils.showMessage(message.reason);
      });
    }
  }

  void _update() {
    showDialog(
      context: context,
      builder: (context) {
        return NewPopupWindowDialog(
          title: "提示",
          confirm: "更新",
          cancel: "取消",
          content: "报告可能有更新记录，需要更新重新购买报告，覆盖之前报告",
          contentAlign: TextAlign.center,
          contentEdgeInsets: const EdgeInsets.only(left: 39, right: 39),
          contentStyle: const TextStyle(fontSize: 15),
          showCancel: true,
          cancelOnTap: () {
            //取消文案
            Navigator.of(context).pop();
          },
          confirmOnTap: () {
            //确定
            Navigator.of(context).pop();
            _ifIdentity(1, false);
          },
        );
      },
    );
  }

  Widget _flowPathView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(width: 1, color: CustomColors.connectColor),
        borderRadius: BorderRadius.circular((8.0)),
      ),
      padding: const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 10),
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
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

  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: false,
  );

  Widget _body(BuildContext context) {
    switch (reportType) {
      case 6:
        return _financeUnlocked(context);
      case 5:
        return _partialReport(context);
      case 1:
        return _normalReport(context);
      default:
        return _notPurchased();
    }
  }

  _warn(IconData icon, String srt) {
    return Container(
      padding: const EdgeInsets.only(left: 4, top: 2, right: 4, bottom: 2),
      decoration: const BoxDecoration(
        color: CustomColors.colorF9DADA,
        borderRadius: BorderRadius.all(
          Radius.circular(2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: CustomColors.warningColor,
          ),
          Text(
            srt,
            style: const TextStyle(
              fontSize: 12,
              color: CustomColors.warningColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _head(BuildContext buildContext) {
    return Column(
      children: [
        Text(
          "$name的职场背调报告",
          style: const TextStyle(
            fontSize: 22,
            color: CustomColors.greyBlack,
            fontWeight: FontWeight.w900,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
          decoration: const BoxDecoration(
            color: CustomColors.connectColor,
            borderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
          ),
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            createTime,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        const Text(
          "报告编号：*******************",
          style: TextStyle(
            fontSize: 16,
            color: CustomColors.connectColor,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "<内部保密文件>",
          style: TextStyle(
            fontSize: 16,
            color: CustomColors.warningColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _warn(Icons.lock_outline, "隐私信息"),
            const SizedBox(width: 5),
            _warn(Icons.lock_outline, "机密信息"),
            const SizedBox(width: 5),
            _warn(Icons.highlight_off_rounded, "禁止分享"),
            const SizedBox(width: 5),
            _warn(Icons.highlight_off_rounded, "限期有效"),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 1,
          color: CustomColors.lineColor,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const SizedBox(width: 16),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                child: Text(
                  "姓名：***",
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.greyBlack,
                  ),
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                _showPayment(context, "$name的职场背调报告");
              },
              child: const Image(
                image: AssetImage("assets/images/icon_close_eyes.png"),
                height: 20,
                width: 24,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                child: Text(
                  "性别：*",
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.greyBlack,
                  ),
                ),
              ),
            ),
            Text(
              "交付类型:职场背调报告",
              style: TextStyle(
                fontSize: 15,
                color: CustomColors.greyBlack,
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 16),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                child: Text(
                  "年龄：**",
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.greyBlack,
                  ),
                ),
              ),
            ),
            Text(
              createTime,
              style: const TextStyle(
                fontSize: 15,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3),
                child: Row(
                  children: [
                    const Text(
                      "风险等级：",
                      style: TextStyle(
                        fontSize: 15,
                        color: CustomColors.greyBlack,
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xFFF6C744),
                      ),
                      child: const Icon(
                        Icons.question_mark,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              "交付日期：************",
              style: TextStyle(
                fontSize: 15,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
              width: double.infinity,
              height: 45,
              margin: const EdgeInsets.fromLTRB(24, 15, 24, 0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: CustomColors.connectColor,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x66000000),
                    offset: Offset(4, 4),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: InkWell(
                  onTap: () {
                    UmengCommonSdk.onEvent(
                        'CheckPersonalPurchase', {"tapType": "登录点击查看全部报告"});
                    _ifIdentity(1, false);
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: const Center(
                    child: Text(
                      "解锁全部背调报告",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF0B034),
                        Color(0xFFEB874F),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "90%用户已查",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _basicInfo() {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 15, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Row(
                children: [
                  Image(
                    image: AssetImage("assets/images/icon_financial_risk.png"),
                    height: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "金融风险",
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.greyBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      "被冒名开卡查询",
                      style: TextStyle(
                        color: CustomColors.greyBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 0.8,
                        dashLength: 1.0,
                        dashColor: Color(0xFF99C6FF),
                        dashGapLength: 1.0,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Image(
                      image:
                          AssetImage("assets/images/icon_warning_search.png"),
                      height: 20,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      "网贷黑名单查询",
                      style: TextStyle(
                        color: CustomColors.greyBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 0.8,
                        dashLength: 1.0,
                        dashColor: Color(0xFF99C6FF),
                        dashGapLength: 1.0,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Image(
                      image:
                          AssetImage("assets/images/icon_warning_search.png"),
                      height: 20,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 5, top: 6, right: 5, bottom: 6),
                  decoration: const BoxDecoration(
                    color: CustomColors.colorFAF8F8,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: _instructionsWidget(ScreenTool.screenWidth - 64 - 10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text(
                      "互联网金融风险",
                      style: TextStyle(
                        color: CustomColors.greyBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 0.8,
                        dashLength: 1.0,
                        dashColor: Color(0xFF99C6FF),
                        dashGapLength: 1.0,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Image(
                      image:
                          AssetImage("assets/images/icon_warning_search.png"),
                      height: 20,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  // width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 5, top: 6, right: 5, bottom: 6),
                  // margin: const EdgeInsets.only(top: 5, bottom: 15),
                  decoration: const BoxDecoration(
                    color: CustomColors.colorFAF8F8,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: const Text(
                    "说明：2000+小贷公司记录，核实 命中机构数，逾期订单数累计逾期额度，总放款订单数等。",
                    style: TextStyle(
                      color: CustomColors.darkGrey,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 5, top: 6, right: 5, bottom: 6),
                  decoration: const BoxDecoration(
                    color: CustomColors.whiteBlueColorFE,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    //交叉轴的布局方式，对于column来说就是水平方向的布局方式
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //就是字child的垂直布局方向，向上还是向下
                    verticalDirection: VerticalDirection.down,
                    children: [
                      const Expanded(
                        child: Column(
                          children: [
                            Text(
                              "100+",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "网络贷款公司",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 20,
                        color: CustomColors.lightGrey,
                      ),
                      const Expanded(
                        child: Column(
                          children: [
                            Text(
                              "2000+",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "小贷公司记录",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 45,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: CustomColors.connectColor,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x66000000),
                      offset: Offset(4, 4),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: InkWell(
                      onTap: () {
                        UmengCommonSdk.onEvent(
                            'CheckPersonalPurchase', {"tapType": "登录点击19.9报告"});
                        _ifIdentity(6, false);
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "部分报告检测",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: " 19.9元 ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              TextSpan(
                                text: "39.9",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: CustomColors.darkGreyE4,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      // Text(
                      //   "部分报告检测19.9元 39.9",
                      //   style: TextStyle(
                      //     fontSize: 17,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _badRecords() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const Row(
            children: [
              Image(
                image: AssetImage("assets/images/icon_social_badness.png"),
                height: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "社会不良记录",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Row(
            children: [
              Text(
                "社会不良信息",
                style: TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 0.8,
                  dashLength: 1.0,
                  dashColor: Color(0xFF99C6FF),
                  dashGapLength: 1.0,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Image(
                image: AssetImage("assets/images/icon_warning_search.png"),
                height: 20,
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Row(
            children: [
              Text(
                "道德不良风险",
                style: TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 0.8,
                  dashLength: 1.0,
                  dashColor: Color(0xFF99C6FF),
                  dashGapLength: 1.0,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Image(
                image: AssetImage("assets/images/icon_warning_search.png"),
                height: 20,
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Row(
            children: [
              Text(
                "道德分：**分",
                style: TextStyle(
                  color: CustomColors.redColor61B,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  _ifIdentity(1, false);
                },
                child: const Center(
                  child: Text(
                    "查看更多报告内容>>",
                    style: TextStyle(
                      color: CustomColors.connectColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _threeMusketeers() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 16),
      color: Colors.white,
      child: const Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/icon_speciality.png"),
                  width: 45,
                  height: 45,
                  fit: BoxFit.fill,
                ),
                Text(
                  "专业",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 16,
                  ),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "完善的背景调查\n流程体系，丰富的背调\n渠道专业的背调报告产出。",
                  style: TextStyle(
                    color: CustomColors.darkGrey99,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/icon_authority.png"),
                  width: 45,
                  height: 45,
                  fit: BoxFit.fill,
                ),
                Text(
                  "杈威",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 16,
                  ),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "信息对接政府\n法院、教育等权威\n数括库，数据安时更新。",
                  style: TextStyle(
                    color: CustomColors.darkGrey99,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/icon_secure.png"),
                  width: 45,
                  height: 45,
                  fit: BoxFit.fill,
                ),
                Text(
                  "安全",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 16,
                  ),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "严格按照国际ISO\n标准采用国际高强度加密\n算法对背景调查数据进行加密。",
                  style: TextStyle(
                    color: CustomColors.darkGrey99,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showPayment(BuildContext buildContext, String name) {
    var screenWidth = ScreenTool.screenWidth * 0.75;
    showDialog(
      context: buildContext,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    height: 55,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2CF9A),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        name,
                        style: const TextStyle(
                          color: CustomColors.greyBlack,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 3),
                          child: Text(
                            "姓名：***",
                            style: TextStyle(
                              fontSize: 15,
                              color: CustomColors.greyBlack,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "交付类型:职场背调报告",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 3),
                          child: Text(
                            "性别：*",
                            style: TextStyle(
                              fontSize: 15,
                              color: CustomColors.greyBlack,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        createTime,
                        style: const TextStyle(
                          fontSize: 15,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const Row(
                    children: [
                      SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 3, bottom: 3),
                          child: Text(
                            "年龄：**",
                            style: TextStyle(
                              fontSize: 15,
                              color: CustomColors.greyBlack,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "交付日期：************",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: Row(
                            children: [
                              const Text(
                                "风险等级：",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: CustomColors.greyBlack,
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xFFF6C744),
                                ),
                                child: const Icon(
                                  Icons.question_mark,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 35,
                          margin: const EdgeInsets.only(left: 16, right: 8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: CustomColors.colorF2F2F2,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66000000),
                                offset: Offset(4, 4),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Text(
                                "取消",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: CustomColors.greyBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 35,
                          margin: const EdgeInsets.only(left: 8, right: 16),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: CustomColors.connectColor,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66000000),
                                offset: Offset(4, 4),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              _ifIdentity(1, false);
                            },
                            child: const Center(
                              child: Text(
                                "立即解锁",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String hideInfo(int type, String content) {
    if (ifVisible) {
      return content;
    }
    var data = "";
    if (type == 1) {
      //名字
      data = StringTools.hiddenInfoString(content);
    } else {
      data = "*" * content.length;
    }
    return data;
  }

  Widget _unlocked(String name) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            Text(
              name,
              style: const TextStyle(
                color: CustomColors.darkGrey99,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Expanded(
              child: DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                lineThickness: 0.8,
                dashLength: 1.0,
                dashColor: CustomColors.darkGrey99,
                dashGapLength: 1.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Icon(
              Icons.lock_outline_rounded,
              color: CustomColors.connectColor,
              size: 18,
            ),
            const Text(
              "待解锁",
              style: TextStyle(
                color: CustomColors.connectColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  ///五块钱报告详情
  Widget _partialReport(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        EasyRefresh(
          header: const ClassicHeader(
            backgroundColor: CustomColors.lightBlue,
            textStyle: TextStyle(
              color: Colors.white,
            ),
            messageStyle: TextStyle(
              color: Colors.white,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          controller: _controller,
          onRefresh: () async {
            _loadData();
          },
          child: SingleChildScrollView(
            child: Container(
              color: CustomColors.lightBlue,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                    padding: const EdgeInsets.only(
                      top: 18,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              height: 55,
                              width: 55,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF5FB6F9),
                                    Color(0xFF317FF1),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    name.isNotEmpty ? name.substring(0, 1) : "",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${hideInfo(1, name)}的职场背调报告",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: CustomColors.greyBlack,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 34),
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      ifVisible = !ifVisible;
                                      setState(() {});
                                    },
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/${ifVisible ? "icon_open_eyes" : "icon_close_eyes"}.png"),
                                      height: 20,
                                      width: 24,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 3),
                                child: Text(
                                  "姓名：${hideInfo(1, name)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "交付类型:职场背调报告",
                              style: TextStyle(
                                fontSize: 15,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 3),
                                child: Text(
                                  "性别：${hideInfo(2, gender)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              createTime,
                              style: const TextStyle(
                                fontSize: 15,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 3),
                                child: Text(
                                  "年龄：${hideInfo(2, age)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              completeTime,
                              style: const TextStyle(
                                fontSize: 15,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: CustomColors.lineColor,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Image(
                                    image: AssetImage(
                                        "assets/images/icon_basic_info.png"),
                                    height: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "基本信息",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CustomColors.greyBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "出生日期：${hideInfo(2, birth)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "证件号码：${hideInfo(2, idCard)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "户籍所在地：${hideInfo(2, domicile)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.phone_android_outlined,
                                    color: CustomColors.connectColor,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "运营商时长",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CustomColors.greyBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "手机号：${hideInfo(2, phoneNumber)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 15),
                                child: Text(
                                  "运营商时长：$operator",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 45,
                          margin: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: CustomColors.connectColor,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66000000),
                                offset: Offset(4, 4),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              _ifIdentity(1, true);
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: const Center(
                              child: Text(
                                "解锁全部背调报告",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _unlocked("学历信息"),
                        _unlocked("工商信息"),
                        _unlocked("道德风险"),
                        _unlocked("司法风险"),
                        _unlocked("金融风险"),
                        _unlocked("失信被执行人"),
                        _unlocked("裁判文书信息"),
                        _unlocked("限制消费人员"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                _ifIdentity(1, false);
                              },
                              child: const Center(
                                child: Text(
                                  "查看更多报告内容>>",
                                  style: TextStyle(
                                    color: CustomColors.connectColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  _threeMusketeers(),
                ],
              ),
            ),
          ),
        ),
        _bottomTip(5),
      ],
    );
  }

  ///完整报告
  Widget _normalReport(BuildContext context) {
    return SizedBox(
      height: ScreenTool.screenHeight,
      width: ScreenTool.screenWidth,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          EasyRefresh(
            header: const ClassicHeader(
              backgroundColor: CustomColors.lightBlue,
              textStyle: TextStyle(
                color: Colors.white,
              ),
              messageStyle: TextStyle(
                color: Colors.white,
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            controller: _controller,
            onRefresh: () async {
              _loadData();
            },
            child: ListView(
              children: [
                Stack(
                  children: [
                    _topView(),
                    _classifiedInformationView(),
                    _contactUsButton(),
                  ],
                ),
              ],
            ),
          ),
          // if (authorizationStatus == 4)
          //   Container(
          //     width: double.infinity,
          //     height: 55,
          //     margin: const EdgeInsets.fromLTRB(18, 0, 18, 90),
          //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          //     decoration: const BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //       color: CustomColors.connectColor,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Color(0x66000000),
          //           offset: Offset(4, 4),
          //           blurRadius: 6,
          //           spreadRadius: 0,
          //         ),
          //       ],
          //     ),
          //     child: const Row(
          //       children: [
          //         Icon(
          //           Icons.access_time,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text(
          //           "您有1份报告正在调取中请稍侯....",
          //           style: TextStyle(
          //               fontSize: 18,
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ],
          //     ),
          //   ),

          if (verified)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _itemView(),
            ),
        ],
      ),
    );
  }

  Widget _notPurchased() {
    //未购买
    return SizedBox(
      height: ScreenTool.screenHeight,
      width: ScreenTool.screenWidth,
      child: SingleChildScrollView(
        child: Container(
          color: CustomColors.lightBlue,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 16, top: 30, right: 16),
                    padding: const EdgeInsets.only(
                      top: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        _head(context),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: CustomColors.lineColor,
                        ),
                        _basicInfo(),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: CustomColors.lineColor,
                        ),
                        _badRecords(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30, right: 16),
                        child: const Image(
                          image:
                              AssetImage("assets/images/icon_top_secret.png"),
                          width: 66,
                        ),
                      )
                    ],
                  )
                ],
              ),
              _flowPathView(),
              _threeMusketeers(),
            ],
          ),
        ),
      ),
    );
  }

  void _goAuthorize(int type) {
    ReportHomeManager.getCompanyNameForMessage(
      {"id": authId.toString()},
      (str) {
        var companyName = str["companyName"];
        var idCard = str["idCard"];
        var name = str["name"];
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NotificationStatementPage(
                type: type,
                companyName: companyName.toString(),
                idCard: idCard.toString(),
                name: name.toString(),
                reportAuthId: authId.toString(),
              );
            },
          ),
        ).then(
          (value) {
            if (value != null) {
              _loadData();
            }
          },
        );
      },
    );
  }

  Widget _bottomTip(int type) {
    //2.待授权 3.已拒绝 4.授权中 5.未认证状态下已支付订单
    switch (authorizationStatus) {
      case 2:
        return Container(
          width: double.infinity,
          height: 55,
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 65),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0x73000000),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(4, 4),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              _goAuthorize(type);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "您有1份报告待授权点击",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  " 去授权",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        );
      case 4:
        return Container(
          width: double.infinity,
          height: 55,
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 65),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0x73000000),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(4, 4),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "您有1份报告正在调取中请稍侯....",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _contactUsButton() {
    return GestureDetector(
      onTap: () {
        UmengCommonSdk.onEvent("RiskRemediation", {
          "location": "pesonIndex",
        });
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ContactUsPage()));
      },
      child: SizedBox(
        child: Column(
          children: [
            const SizedBox(
              height: 500,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 100,
                top: 35,
              ),
              padding: const EdgeInsets.all(16),
              height: 92,
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                //设置四周边框
                border: Border.all(width: 2, color: CustomColors.lightBlue),
              ),
              child: const Row(children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Image(
                    image: AssetImage("assets/images/usButtonIcon.png"),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 20,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "风险修复 | 联系我们",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    Text(
                      "报告异常、风险警报？",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: CustomColors.lightGrey,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: 20,
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Image(
                        image: AssetImage("assets/images/usButtonS.png"),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _instructionsWidget(double width) {
    String str =
        "说明：未知情的情况下被冒名申请网贷查询，各类网络贷款黑名单查询。包括：乐*花、**享借、易*购、**借钱、*借款、**钱包、快*花、*借等100+网络贷款公司。";
    TextStyle textStyle = const TextStyle(
      color: CustomColors.darkGrey,
      fontSize: 10,
    );

    int characterCount = WidgetTools().computationalText(width, textStyle);

    if (characterCount > str.length) {
      return Text(
        str,
        style: textStyle,
      );
    } else {
      String subStr = str.substring(0, characterCount);
      String otherSubStr = str.substring(characterCount);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subStr,
            style: textStyle,
          ),
          SizedBox(
            width: 200,
            child: Text(
              otherSubStr,
              style: textStyle,
            ),
          ),
        ],
      );
    }
  }

  /// *
  /// -  @description: 金融5元报告
  /// -  @Date: 2023-08-30 17:17
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _financeUnlocked(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        EasyRefresh(
          header: const ClassicHeader(
            backgroundColor: CustomColors.lightBlue,
            textStyle: TextStyle(
              color: Colors.white,
            ),
            messageStyle: TextStyle(
              color: Colors.white,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          controller: _controller,
          onRefresh: () async {
            _loadData();
          },
          child: SingleChildScrollView(
            child: Container(
              color: CustomColors.lightBlue,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                    padding: const EdgeInsets.only(
                      top: 18,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              height: 55,
                              width: 55,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF5FB6F9),
                                    Color(0xFF317FF1),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    name.isNotEmpty ? name.substring(0, 1) : "",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${hideInfo(1, name)}的职场背调报告",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: CustomColors.greyBlack,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 34),
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      ifVisible = !ifVisible;
                                      setState(() {});
                                    },
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/${ifVisible ? "icon_open_eyes" : "icon_close_eyes"}.png"),
                                      height: 20,
                                      width: 24,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 3),
                                child: Text(
                                  "姓名：${hideInfo(1, name)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "交付类型:职场背调报告",
                              style: TextStyle(
                                fontSize: 15,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 3),
                                child: Text(
                                  "性别：${hideInfo(2, gender)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              createTime,
                              style: const TextStyle(
                                fontSize: 15,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 3),
                                child: Text(
                                  "年龄：${hideInfo(2, age)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: CustomColors.greyBlack,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              completeTime,
                              style: const TextStyle(
                                fontSize: 15,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),

                        /// 5元金融报告主体
                        _financeContentView(),

                        /// 查看完整报告 按钮
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: CustomColors.lineColor,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45,
                          margin: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: CustomColors.connectColor,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66000000),
                                offset: Offset(4, 4),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              _ifIdentity(1, true);
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: const Center(
                              child: Text(
                                "查看完整报告",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _unlocked("学历信息"),
                        _unlocked("工商信息"),
                        _unlocked("道德风险"),
                        _unlocked("司法风险"),
                        _unlocked("失信被执行人"),
                        _unlocked("裁判文书信息"),
                        _unlocked("限制消费人员"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                _ifIdentity(1, false);
                              },
                              child: const Center(
                                child: Text(
                                  "解锁更多背调信息 >>",
                                  style: TextStyle(
                                    color: CustomColors.connectColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  _threeMusketeers(),
                ],
              ),
            ),
          ),
        ),
        _bottomTip(5),
      ],
    );
  }

  Widget _financeContentView() {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: FinanceUnlockView(frModel),
    );
  }
}
