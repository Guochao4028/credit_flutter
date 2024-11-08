import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/financial_risk_partial_report_model.dart';
import 'package:credit_flutter/models/partial_report_model.dart';
import 'package:credit_flutter/models/report_data_bean.dart';
import 'package:credit_flutter/pages/modules/home/views/finance_unlock_view.dart';
import 'package:credit_flutter/route/watermark.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../manager/report_details_manager.dart';
import '../../../models/professional_certificate_bean.dart';

import 'package:hive_flutter/hive_flutter.dart';

/// @Description: 芝麻数据-报告详情页 五块钱报告
class FinancePartReportDetailsPage extends StatefulWidget {
  String reportId;
  String authId;

  FinancePartReportDetailsPage(
      {Key? key, required this.reportId, required this.authId})
      : super(key: key);

  @override
  State<FinancePartReportDetailsPage> createState() =>
      _FinancePartReportDetailsPage();
}

class _FinancePartReportDetailsPage
    extends State<FinancePartReportDetailsPage> {
  //名称
  String name = "";

  //报告创建时间
  String createTime = "";

  //授权完成时间（时间 戳）
  String completeTime = "";

  //报告编号
  String reportNumber = "报告编号: ";

  //性别
  String gender = "";

  //手机号
  String phoneNumber = "";

  //运营商
  String operator = "";

  //年龄
  String age = "";

  //出生日期
  String birthday = "";

  //身份证号
  String identityNumber = "";

  //户籍所在地
  String domicile = "";

  FinancialRiskPartialReportModel? frModel;

  //学历
  List<ProfessionalCertificateBean> educationalBackground =
      <ProfessionalCertificateBean>[];

  //专业证书列表
  List<ProfessionalCertificateBean> professionalCertificateList =
      <ProfessionalCertificateBean>[];

  //工商信息
  List<ItemData136> itemData136 = <ItemData136>[];

  //"开庭公告记录核实"
  List<ItemData755> itemData755 = <ItemData755>[];

  //刑事裁判文书核实
  List<ProfessionalCertificateBean> criminalAdjudicationList =
      <ProfessionalCertificateBean>[];

  //有限诉讼记录核实
  List<ItemData261> itemData261 = <ItemData261>[];

  //法院失信被执行人核实
  List<ProfessionalCertificateBean> peopleWhoLoseCreditList =
      <ProfessionalCertificateBean>[];

  //法院被执行人核实
  List<ProfessionalCertificateBean> executedPersonList =
      <ProfessionalCertificateBean>[];

  //限制高消费名单
  List<ProfessionalCertificateBean> limitHighConsumptionList =
      <ProfessionalCertificateBean>[];

  //限制出入境名单
  List<ProfessionalCertificateBean> restrictedEntryAndExitList =
      <ProfessionalCertificateBean>[];

  //社会不良信息核实
  var badSocialInfoType = "0";

  //道德不良风险记录核实
  var moralHazard = 0;

  //税务不良记录核实
  var badTaxRecord = 0;

  //违禁药品风险核实
  var prohibitedDrugs = 0;

  //网贷黑名单
  var onlineLoanBlacklist = false;

  //授权书地址
  var url = "";

  var ifVisible = true;

  ///  是否要弹窗
  bool isPop = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    //初始化主页面
    super.initState();
    UmengCommonSdk.onPageStart("part_report_details_page");
    _initData(widget.reportId.toString());

    var box = Hive.box(HiveBoxs.dataBox);
    bool firstOpen = box.get(FinalKeys.FIRST_OPEN_REPORT_DETAILS) ?? false;
    if (!firstOpen) {
      isPop = true;
    } else {
      String reportIds = box.get(FinalKeys.POP_REPORT_ID) ?? "";
      String popTime = box.get(FinalKeys.REPORT_DETAILS_TIMING) ?? "";
      int days = StringTools.getTimeDifference(popTime);
      if (!reportIds.contains(widget.reportId) && days > 7) {
        isPop = true;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("part_report_details_page");
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - (76 * 3)) {
        if (isPop) {
          // widget_tool
          var box = Hive.box(HiveBoxs.dataBox);
          box.put(FinalKeys.REPORT_DETAILS_TIMING, StringTools.getNowTime());
          String idStr = box.get(FinalKeys.POP_REPORT_ID) ?? "";
          if (idStr.isNotEmpty) {
            idStr = "$idStr,${widget.reportId}";
          } else {
            idStr = widget.reportId;
          }
          UmengCommonSdk.onEvent("CommentPopup", {"type": "count"});

          WidgetTools().showComment(context);
          isPop = false;
        }
      }
    });
    return Stack(
      children: [
        Scaffold(
          //导航
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "报告详情",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: CustomColors.colorF1F4F9,
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                _head(),
                //基本信息
                _essentialInfo(),
                //个人数据使用说明
                _explain(),
              ],
            ),
          ),
        ),
        const IgnorePointer(
          //忽略自定义水印的点击事件
          child: Watermark(rowCount: 4, columnCount: 8, text: "慧眼查"),
        ),
      ],
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Container(
          color: CustomColors.color3B8FF9,
          height: 149,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 16, top: 30, right: 16),
          padding:
              const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Column(
            children: [
              Text(
                "$name的职场背调报告",
                style: const TextStyle(
                  fontSize: 26,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
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
              Text(
                hideInfo(1, name),
                style: const TextStyle(
                  fontSize: 18,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                reportNumber,
                style: const TextStyle(
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
              const SizedBox(height: 16),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30, right: 16),
              child: const Image(
                image: AssetImage("assets/images/icon_top_secret.png"),
                width: 66,
              ),
            )
          ],
        )
      ],
    );
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

  Widget _essentialInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                width: 2,
                height: 15,
                decoration: const BoxDecoration(
                  color: CustomColors.connectColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(1),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  "委托信息",
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
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
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: _addInfoText("姓名：${hideInfo(1, name)}"),
              ),
              const Text(
                "交付类型:职场背调报告",
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.greyBlack,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _addInfoText("性别：${hideInfo(2, gender)}"),
              ),
              Text(
                createTime,
                style: const TextStyle(
                  fontSize: 15,
                  color: CustomColors.greyBlack,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _addInfoText("年龄：${hideInfo(2, age)}"),
              ),
              Text(
                completeTime,
                style: const TextStyle(
                  fontSize: 15,
                  color: CustomColors.greyBlack,
                ),
              ),
            ],
          ),
          _addInfoText("出生日期：${hideInfo(2, birthday)}"),
          _addInfoText("身份证号：${hideInfo(2, identityNumber)}"),
          _addInfoText("户籍所在地：${hideInfo(2, domicile)}"),
          //          _addInfoText("手机号：${hideInfo(2, phoneNumber)}"),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: double.infinity,
            height: 1,
            color: CustomColors.colorC3C3C3,
          ),
          FinanceUnlockView(frModel),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: double.infinity,
            height: 1,
            color: CustomColors.colorC3C3C3,
          ),
          const Row(
            children: [
              Image(
                width: 15,
                height: 15,
                image: AssetImage("assets/images/icon_red_sigh.png"),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "重要说明",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            "重要说明：受客户委托，本报告由慧眼查提供。在被核实目标知悉且同意授权的情况下，就授权项目进行调查核实，所有信息均通过合法途径获得。慧眼查竭力确保其提供的数据准确可靠，但不保证所提供的数据绝对正确可靠；对于任何因资料不准确遗漏或因根据、依赖本报告资料所做决定、行动或不行动，以及收集与传递过程中的偏差而导致的损失或损害，慧眼查概不负责（不论是民事侵权行为责任或合约责任或其它）。版权由慧眼查全权拥有。",
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addInfoText(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          color: CustomColors.greyBlack,
        ),
      ),
    );
  }

  ///个人数据使用说明
  Widget _explain() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 50),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage(
                      "assets/images/icon_personal_authorization_description.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "个人授权说明",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _getAuthorizationStatement(),
        ],
      ),
    );
  }

  _getAuthorizationStatement() {
    if (url.isNotEmpty) {
      return Image(
        image: NetworkImage(url),
        fit: BoxFit.fitWidth,
      );
    } else {
      return const SizedBox();
    }
  }

  // 初始化数据
  void _initData(String reportId) async {
    ReportDetailsManager.getFinanceRiskPartReportData(reportId, (object) {
      var data = object as FinancialRiskPartialReportModel;
      var inputMap = data.inputMap;
      var detail = data.detail;
      this.frModel = data;

      //姓名
      name =
          StringTools.hiddenInfoString(data.creditReportDigest.name, type: 0);

      //创建时间
      var time =
          DateTime.fromMillisecondsSinceEpoch(data.reportInfo.createTime);
      createTime = "委托日期：${time.year}-${time.month}-${time.day}";

      //授权完成时间（时间 戳） completeTime
      var complete =
          DateTime.fromMillisecondsSinceEpoch(data.reportInfo.completeTime);
      completeTime = "交付日期：${complete.year}-${complete.month}-${complete.day}";

      //报告编号
      reportNumber = "报告编号:${data.creditReportDigest.reportId}";

      //性别
      if (data.creditReportDigest.sex.isEmpty) {
        gender = StringTools.getSexFromCardId(data.creditReportDigest.idNo);
      } else {
        gender = data.creditReportDigest.sex;
      }

      //手机号
      phoneNumber = StringTools.phoneEncryption(data.creditReportDigest.mobile);

      //年龄
      if (inputMap.age == 0) {
        age = StringTools.getAgeFromCardId(data.creditReportDigest.idNo);
      } else {
        age = inputMap.age.toString();
      }
      //出生日期
      var dateTime =
          DateTime.fromMillisecondsSinceEpoch(data.creditReportDigest.birthday);
      birthday = "${dateTime.year}.${dateTime.month}.${dateTime.day}";
      //身份证号
      identityNumber =
          StringTools.hiddenInfoString(data.creditReportDigest.idNo, type: 1);

      //户籍所在地
      domicile = data.creditReportDigest.householdAddr;

      setState(() {});

      ReportDetailsManager.getAuthStuffUrl(widget.authId, (object) {
        url = object;
        setState(() {});
      });
    });
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
}
