import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/report_details_sample_manager.dart';
import 'package:credit_flutter/models/report_data_bean.dart';
import 'package:credit_flutter/route/watermark.dart';
import 'package:credit_flutter/tools/report_widget_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../models/professional_certificate_bean.dart';

/// @Description: 旧版-样例报告详情页
class ReportSampleItemPage extends StatefulWidget {
  const ReportSampleItemPage({Key? key}) : super(key: key);

  @override
  State<ReportSampleItemPage> createState() => _ReportSampleItemPageState();
}

class _ReportSampleItemPageState extends State<ReportSampleItemPage> {
  //名称
  String name = "张*";

  //报告创建时间
  String createTime = "报告生成时间：2023-2-20";

  //性别
  String gender = "女";

  //手机号
  String phoneNumber = "152********";

  //年龄
  String age = "36";

  //出生日期
  String birthday = "1988.3.8";

  //身份证号
  String identityNumber = "512************920";

  //户籍所在地
  String domicile = "四川省******";

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

  var ifVisible = true;

  var shuiyin = false;

  @override
  void initState() {
    //初始化主页面
    super.initState();
    UmengCommonSdk.onPageStart("report_sample_page");

    UmengCommonSdk.onEvent(
        "ReportDetailsSample", {"state": "start", "time": "${DateTime.now()}"});

    Future.delayed(const Duration(milliseconds: 500), () {
      shuiyin = true;
      _initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("report_sample_page");

    UmengCommonSdk.onEvent(
        "ReportDetailsSample", {"state": "end", "time": "${DateTime.now()}"});
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                //基本信息
                _essentialInfo(),
                //阅读说明
                _readInstructions(),
                //整体汇总
                _overallSummary(),
                //社会经历
                _addTitle("学历信息"),
                _academicInfo(),
                //专业证书
                _addTitle("专业证书"),
                _professionalCertificate(),
                //工商信息
                _addTitle("工商信息"),
                _businessInfo(),
                //司法风险
                _addTitle("司法诉讼"),
                _judicialRisk(),
                //社会不良记录
                _addTitle("社会不良记录"),
                _badSocialRecord(),
                //金融风险
                _addTitle("金融风险"),
                _financialRisk(),
                //个人数据使用说明
                _explain(),
              ],
            ),
          ),
        ),
        if (shuiyin)
          const IgnorePointer(
            //忽略自定义水印的点击事件
            child: Watermark(rowCount: 4, columnCount: 8, text: "慧眼查"),
          ),
      ],
    );
  }

  Widget _essentialInfo() {
    Container surname = Container(
      margin: const EdgeInsets.only(left: 32, top: 16),
      height: 70,
      width: 70,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF5FB6F9),
            Color(0xFF317FF1),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name.isNotEmpty ? name.substring(0, 1) : "",
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
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
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3), topRight: Radius.circular(3))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 84),
                child: Text(
                  hideInfo(1, name),
                  style: const TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 84, top: 5),
                child: Text(
                  createTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CustomColors.darkGrey,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              _addInfoText("性别：${hideInfo(2, gender)}"),
              _addInfoText("手机号：${hideInfo(2, phoneNumber)}"),
              _addInfoText("年龄：${hideInfo(2, age)}"),
              _addInfoText("出生日期：${hideInfo(2, birthday)}"),
              _addInfoText("身份证号：${hideInfo(2, identityNumber)}"),
              _addInfoText("户籍所在地：${hideInfo(2, domicile)}"),
              const SizedBox(
                height: 10,
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
                "重要说明：受客户委托，本报告由慧眼查提供。在被核实目标知悉且同意授权的情况下，就授权项目进行调查核实，所有信息均通过合法途径获得。慧眼查竭力确保其提供的数据准确可靠，但不保证所提供的数据绝对正确可靠；对于任何因资料不准确遗漏或因根据、依赖本报告资料所做决定、行动或不行动，以及收集与传递过程中的偏差而导致的损失或损害，慧眼查概不负责（不论是民事侵权行为责任或合约责任或其它）。版权由慧眼查全权拥有。调查结果仅供参考，如有异议，以官方证明文件为准。",
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
        surname,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, right: 34),
              child: InkWell(
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

  Widget _readInstructions() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            children: [
              Image(
                image: AssetImage("assets/images/icon_read_instructions.png"),
                width: 18,
                height: 18,
                // fit: BoxFit.fill,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "阅读说明",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _JudgeRisk(1),
              const SizedBox(
                width: 6,
              ),
              const Text(
                "查得相关记录，建议关注！",
                style: TextStyle(
                  fontSize: 13,
                  color: CustomColors.greyBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _JudgeRisk(2),
              const SizedBox(
                width: 6,
              ),
              const Text(
                "查得相关记录，建议关注！",
                style: TextStyle(
                  fontSize: 13,
                  color: CustomColors.greyBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _JudgeRisk(3),
              const SizedBox(
                width: 6,
              ),
              const Text(
                "查得相关记录，建议关注！",
                style: TextStyle(
                  fontSize: 13,
                  color: CustomColors.greyBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _JudgeRisk(4),
              const SizedBox(
                width: 6,
              ),
              const Text(
                "结果属实/无风险项需要关注！",
                style: TextStyle(
                  fontSize: 13,
                  color: CustomColors.greyBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _overallSummary() {
    List data = List.from([0, 1, 2, 3, 4, 5]);

    int allHorizontalPadding = 0;
    int columnCount = 3;
    double cellWidth =
        ((MediaQuery.of(context).size.width - allHorizontalPadding) /
            columnCount);
    double desiredCellHeight = 65;
    double childAspectRatio = cellWidth / desiredCellHeight;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 46,
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: const Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_overall_summary.png"),
                ),
                SizedBox(width: 6),
                Text(
                  "整体汇总",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GridView.count(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: childAspectRatio,
            children: data.map((index) => _itemRisk(index)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _addTitle(String name) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      decoration: const BoxDecoration(
        color: CustomColors.color3B8FF9,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  ///学历信息
  _academicInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_education_info.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "学历信息",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _ifAcademicInfoData(),
        ],
      ),
    );
  }

  _ifAcademicInfoData() {
    if (educationalBackground.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var professionalCertificate = educationalBackground[index];
          return ReportWidgetTools().showReportGeneralPurposeItem(
              context, index, professionalCertificate);
        },
        itemCount: educationalBackground.length,
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: CustomColors.color3B8FF9,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                child: const Center(
                  child: Text(
                    "1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  "无相关记录",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.connectColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
            margin: const EdgeInsets.only(top: 5, bottom: 15),
            decoration: const BoxDecoration(
              color: CustomColors.colorFAF8F8,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: const Text(
              "说明：通过国内高等教育学位数据库核实（2008年9月以后获取）",
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 10,
              ),
            ),
          ),
        ],
      );
    }
  }

  _professionalCertificate() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_qualification.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "专业技能",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _ifProfessionalCertificate(),
        ],
      ),
    );
  }

  _ifProfessionalCertificate() {
    if (educationalBackground.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var professionalCertificate = professionalCertificateList[index];
          return ReportWidgetTools().showReportGeneralPurposeItem(
              context, index, professionalCertificate);
        },
        itemCount: professionalCertificateList.length,
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: CustomColors.color3B8FF9,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
                child: const Center(
                  child: Text(
                    "1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  "无相关记录",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.connectColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
            margin: const EdgeInsets.only(top: 5, bottom: 15),
            decoration: const BoxDecoration(
              color: CustomColors.colorFAF8F8,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: const Text(
              "说明：通过各地交通管理局驾驶证公开信息数据库核实",
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 10,
              ),
            ),
          ),
        ],
      );
    }
  }

  _businessInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_business_info.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "工商信息",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var itemData = itemData136[index];
              return ReportWidgetTools()
                  .showBusinessInfoItem(context, index, itemData);
            },
            itemCount: itemData136.length,
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
            margin: const EdgeInsets.only(bottom: 15),
            decoration: const BoxDecoration(
              color: CustomColors.colorFAF8F8,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: const Text(
              "说明：通过国家企业信用信息数据库核实",
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _judicialRisk() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_judicial_risk.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "司法信息",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          //开庭公告
          _hearingAnnouncement(),
          //刑事案件记录
          _criminalCase(),
          //有限诉讼记录核实
          _limitedLitigationRecord(),
          //法院失信被执行人核实
          _peopleWhoLoseCredit(),
          //法院被执行人核实
          _executedPerson(),
          //限制高消费名单
          _limitHighConsumption(),
          //限制出入境名单
          _restrictedEntryAndExit(),
        ],
      ),
    );
  }

  _hearingAnnouncement() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "开庭公告",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                dashColor: Color(0xFF99C6FF),
                dashGapLength: 1.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            _JudgeRisk(_getHearingAnnouncementJudgeRisk()),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var itemData = itemData755[index];
            return ReportWidgetTools()
                .showHearingAnnouncementItem(context, index, itemData);
          },
          itemCount: itemData755.length,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            color: CustomColors.colorFAF8F8,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Text(
            "说明：通过各级地方法院等公开数据库核实",
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  _getHearingAnnouncementJudgeRisk() {
    if (itemData755.isNotEmpty) {
      for (var item in itemData755) {
        if (item.itemPropValue.isNotEmpty) {
          return 1;
        }
      }
      return 4;
    } else {
      return 4;
    }
  }

  _criminalCase() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "刑事案件",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                dashColor: Color(0xFF99C6FF),
                dashGapLength: 1.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            _JudgeRisk(criminalAdjudicationList.isEmpty ? 4 : 1),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var itemData = criminalAdjudicationList[index];
            return ReportWidgetTools()
                .showCriminalAdjudicationItem(context, index, itemData);
          },
          itemCount: criminalAdjudicationList.length,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            color: CustomColors.colorFAF8F8,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Text(
            "说明：通过各级地方法院公共数据库核实",
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  _limitedLitigationRecord() {
    if (itemData261.isEmpty) {
      return Column(
        children: [
          Row(
            children: [
              const Text(
                "个人涉诉记录",
                style: TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
                  dashColor: Color(0xFF99C6FF),
                  dashGapLength: 1.0,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              _JudgeRisk(4),
            ],
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
            margin: const EdgeInsets.only(bottom: 15),
            decoration: const BoxDecoration(
              color: CustomColors.colorFAF8F8,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: const Text(
              "说明：通过各级地方法院公共数据库核实",
              style: TextStyle(
                color: CustomColors.darkGrey,
                fontSize: 10,
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const Row(
            children: [
              Text(
                "个人涉诉记录",
                style: TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var itemData = itemData261[index];

              List<ProfessionalCertificateBean> dataList =
                  <ProfessionalCertificateBean>[];
              for (var i = 0; i < itemData.itemPropValue.length; i++) {
                var itemPropValue = itemData.itemPropValue[i];
                List<ProfessionalCertificateContent> content =
                    <ProfessionalCertificateContent>[];
                for (var item in itemPropValue) {
                  content.add(ProfessionalCertificateContent(
                      item.itemPropLabel, item.itemPropValue));
                }
                dataList.add(ProfessionalCertificateBean(
                    "${itemData.itemPropLabel}${i + 1}", content, ""));
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Text(
                        itemData.itemPropLabel,
                        style: const TextStyle(
                          color: CustomColors.greyBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
                          dashColor: Color(0xFF99C6FF),
                          dashGapLength: 1.0,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      _JudgeRisk(itemData.itemPropValue.isEmpty ? 4 : 1),
                    ],
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var itemData = dataList[index];

                      return ReportWidgetTools()
                          .showLimitedLitigationRecordItem(
                              context, index, itemData);
                    },
                    itemCount: dataList.length,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 5, top: 6, right: 5, bottom: 6),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: const BoxDecoration(
                      color: CustomColors.colorFAF8F8,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: const Text(
                      "说明：通过各级地方法院公共数据库核实",
                      style: TextStyle(
                        color: CustomColors.darkGrey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: itemData261.length,
          ),
        ],
      );
    }
  }

  _peopleWhoLoseCredit() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "法院失信被执行人",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                dashColor: Color(0xFF99C6FF),
                dashGapLength: 1.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            _JudgeRisk(peopleWhoLoseCreditList.isEmpty ? 4 : 1),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var itemData = peopleWhoLoseCreditList[index];
            return ReportWidgetTools()
                .showCriminalAdjudicationItem(context, index, itemData);
          },
          itemCount: peopleWhoLoseCreditList.length,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            color: CustomColors.colorFAF8F8,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Text(
            "说明：通过各级地方法院、全国执行信息公开平台等公开数据库核实",
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  _executedPerson() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "法院被执行人",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                dashColor: Color(0xFF99C6FF),
                dashGapLength: 1.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            _JudgeRisk(executedPersonList.isEmpty ? 4 : 1),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var itemData = executedPersonList[index];
            return ReportWidgetTools()
                .showCriminalAdjudicationItem(context, index, itemData);
          },
          itemCount: executedPersonList.length,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            color: CustomColors.colorFAF8F8,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Text(
            "说明：通过各级地方法院、全国执行信息公开平台等公开数据库核实",
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  _limitHighConsumption() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "限制高消费名单",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                dashColor: Color(0xFF99C6FF),
                dashGapLength: 1.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            _JudgeRisk(limitHighConsumptionList.isEmpty ? 4 : 1),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var itemData = limitHighConsumptionList[index];
            return ReportWidgetTools()
                .showCriminalAdjudicationItem(context, index, itemData);
          },
          itemCount: limitHighConsumptionList.length,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            color: CustomColors.colorFAF8F8,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Text(
            "说明：通过各级地方法院公开执行信息、全国执行信息公开平台等公开数据库核实",
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  _restrictedEntryAndExit() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "限制出入境名单",
              style: TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                dashColor: Color(0xFF99C6FF),
                dashGapLength: 1.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            _JudgeRisk(restrictedEntryAndExitList.isEmpty ? 4 : 1),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var itemData = restrictedEntryAndExitList[index];
            return ReportWidgetTools()
                .showCriminalAdjudicationItem(context, index, itemData);
          },
          itemCount: restrictedEntryAndExitList.length,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(
            color: CustomColors.colorFAF8F8,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: const Text(
            "说明：通过候选人提交的出入境记录授权信息核实",
            style: TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _badSocialRecord() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_social_badness.png"),
                ),
                SizedBox(width: 3),
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
          ),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    "社会不良信息",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                      dashColor: Color(0xFF99C6FF),
                      dashGapLength: 1.0,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _JudgeRisk(badSocialInfoType == "0" ? 4 : 1),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  const Text(
                    "查询结果：",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _getBadSocialInfoType(),
                    style: const TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
                margin: const EdgeInsets.only(top: 5, bottom: 15),
                decoration: const BoxDecoration(
                  color: CustomColors.colorFAF8F8,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: const Text(
                  "说明：通过国内治安负面数据库核实",
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
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
                  // moralHazard
                  // _JudgeRisk(badSocialInfoType == "0" ? 4 : 1),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  const Text(
                    "道德分：",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "$moralHazard分",
                    style: const TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
                margin: const EdgeInsets.only(top: 5, bottom: 15),
                decoration: const BoxDecoration(
                  color: CustomColors.colorFAF8F8,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: const Text(
                  "说明：通过行业用户道德风险数据库核实（偷盗、上访、在逃、吸毒、涉赌、购买管制刀具记录）",
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    "税务不良记录",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                      dashColor: Color(0xFF99C6FF),
                      dashGapLength: 1.0,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _JudgeRisk(badTaxRecord > 0 ? 1 : 4),
                ],
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
                margin: const EdgeInsets.only(top: 5, bottom: 15),
                decoration: const BoxDecoration(
                  color: CustomColors.colorFAF8F8,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: const Text(
                  "说明：通过各级税务平台披露的违法数据库核实",
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          // Column(
          //   children: [
          //     Row(
          //       children: [
          //         const Text(
          //           "违禁药品风险",
          //           style: TextStyle(
          //             color: CustomColors.greyBlack,
          //             fontSize: 14,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         const SizedBox(
          //           width: 8,
          //         ),
          //         const Expanded(
          //           child: DottedLine(
          //             direction: Axis.horizontal,
          //             lineLength: double.infinity,
          //             lineThickness: 0.8,
          //             dashLength: 1.0,
          //             dashColor: Color(0xFF99C6FF),
          //             dashGapLength: 1.0,
          //           ),
          //         ),
          //         const SizedBox(
          //           width: 8,
          //         ),
          //         _JudgeRisk(
          //             (prohibitedDrugs > 25 && prohibitedDrugs <= 50) ? 1 : 4),
          //       ],
          //     ),
          //     Container(
          //       width: double.infinity,
          //       padding:
          //           const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
          //       margin: const EdgeInsets.only(top: 5, bottom: 15),
          //       decoration: const BoxDecoration(
          //         color: CustomColors.colorFAF8F8,
          //         borderRadius: BorderRadius.all(Radius.circular(5)),
          //       ),
          //       child: const Text(
          //         "说明：通过行业违禁药品风险数据库核实",
          //         style: TextStyle(
          //           color: CustomColors.darkGrey,
          //           fontSize: 10,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _financialRisk() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_financial_risk.png"),
                ),
                SizedBox(width: 3),
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
          ),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    "网贷黑名单",
                    style: TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
                      dashColor: Color(0xFF99C6FF),
                      dashGapLength: 1.0,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _JudgeRisk(onlineLoanBlacklist ? 1 : 4),
                ],
              ),
              const SizedBox(height: 2),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
                margin: const EdgeInsets.only(top: 5, bottom: 15),
                decoration: const BoxDecoration(
                  color: CustomColors.colorFAF8F8,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: const Text(
                  "说明：通过三方网贷机构平台核实",
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getBadSocialInfoType() {
    var content = "无风险";
    switch (badSocialInfoType) {
      case "0":
        content = "无风险";
        break;
      case "1":
        content = "前科";
        break;
      case "2":
        content = "涉毒";
        break;
      case "3":
        content = "吸毒";
        break;
      case "4":
        content = "在逃";
        break;
      case "5":
        content = "重点关注";
        break;
      case "6":
        content = "其他轻微风险";
        break;
    }
    return content;
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
    return const Image(
      image: AssetImage("assets/images/icon_authorization_statement.jpg"),
      fit: BoxFit.fitWidth,
    );
  }

  Widget _itemRisk(int index) {
    AssetImage assetImage =
        const AssetImage("assets/images/icon_risk_item.png");
    String name = "";
    int content = 0;
    switch (index) {
      case 0:
        name = "学历信息";
        // content = personalRiskInfo?.filing ?? 0;
        // if ((personalRiskInfo?.filing ?? 0) > 0) {
        //   assetImage = const AssetImage(
        //       "assets/images/icon_filing_information_warn.png");
        // } else {
        assetImage = const AssetImage("assets/images/icon_education_info.png");
        // }
        break;
      case 1:
        name = "资格证书";
        // content = personalRiskInfo?.court ?? 0;
        // if ((personalRiskInfo?.court ?? 0) > 0) {
        //   assetImage = const AssetImage(
        //       "assets/images/icon_opening_announcement_warn.png");
        // } else {
        assetImage = const AssetImage("assets/images/icon_qualification.png");
        // }
        break;
      case 2:
        name = "工商信息";
        // content = personalRiskInfo?.judicial ?? 0;
        // if ((personalRiskInfo?.judicial ?? 0) > 0) {
        //   assetImage =
        //       const AssetImage("assets/images/icon_judicial_cases_warn.png");
        // } else {
        assetImage = const AssetImage("assets/images/icon_business_info.png");
        // }
        break;
      case 3:
        name = "司法诉讼";
        // content = personalRiskInfo?.judgment ?? 0;
        // if ((personalRiskInfo?.judgment ?? 0) > 0) {
        //   assetImage =
        //       const AssetImage("assets/images/icon_judgment_document_warn.png");
        // } else {
        assetImage = const AssetImage("assets/images/icon_judicial_risk.png");
        // }
        break;
      case 4:
        name = "社会不良";
        // content = personalRiskInfo?.judgment ?? 0;
        // if ((personalRiskInfo?.judgment ?? 0) > 0) {
        //   assetImage = const AssetImage(
        //       "assets/images/icon_administrative_sanction_warn.png");
        // } else {
        assetImage = const AssetImage("assets/images/icon_social_badness.png");
        // }
        break;
      case 5:
        name = "金融风险";
        // content = personalRiskInfo?.failure ?? 0;
        // if ((personalRiskInfo?.failure ?? 0) > 0) {
        //   assetImage = const AssetImage(
        //       "assets/images/icon_dishonest_information_warn.png");
        // } else {
        assetImage = const AssetImage("assets/images/icon_financial_risk.png");
        // }
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0x121B7CF6),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              width: 22,
                              height: 22,
                              image: assetImage,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (content > 0)
                        Container(
                          padding: const EdgeInsets.only(top: 2, right: 5),
                          child: Text(
                            content.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (index != 2 && index != 5)
                  Container(
                    margin: const EdgeInsets.only(top: 7, bottom: 7),
                    width: 1,
                    height: double.infinity,
                    color: const Color(0x121B7CF6),
                    // color: const Color(0x121B7CF6),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 初始化数据
  void _initData() async {
    ReportDetailsSampleManager.getReportData((object) {
      var data = object as ReportDataBean;
      var creditReportDigest = data.creditReportDigest;
      var inputMap = data.inputMap;
      //创建时间
      name = StringTools.hiddenInfoString(creditReportDigest.name, type: 0);

      //名称
      var time =
          DateTime.fromMillisecondsSinceEpoch(data.reportInfo.createTime);
      createTime = "报告生成时间：${time.year}-${time.month}-${time.day}";
      //性别
      gender = creditReportDigest.sex;
      if (gender.isEmpty) {
        gender = StringTools.getSexFromCardId(creditReportDigest.idNo);
      }

      //手机号
      phoneNumber = StringTools.phoneEncryption(creditReportDigest.mobile);

      //年龄
      age = inputMap.age.toString();
      if (age.isEmpty || age == "0") {
        age = StringTools.getAgeFromCardId(creditReportDigest.idNo);
      }
      //出生日期
      var dateTime =
          DateTime.fromMillisecondsSinceEpoch(creditReportDigest.birthday);
      birthday = "${dateTime.year}.${dateTime.month}.${dateTime.day}";
      //身份证号
      identityNumber =
          StringTools.hiddenInfoString(creditReportDigest.idNo, type: 1);

      //户籍所在地
      domicile = creditReportDigest.householdAddr;
      var detail = data.detail;
      //国内高等教育学位
      var domesticDegree = detail.domesticDegree;
      var itemData184L = domesticDegree?.itemData184 ?? [];
      if (itemData184L.isNotEmpty) {
        List<ProfessionalCertificateContent> content =
            <ProfessionalCertificateContent>[];
        for (var item in itemData184L) {
          for (var item1 in item.itemPropValue) {
            for (var item2 in item1) {
              content.add(ProfessionalCertificateContent(
                  item2.itemPropLabel, item2.itemPropValue));
            }
          }
        }
        educationalBackground.add(ProfessionalCertificateBean(
            "国内高等教育学位", content, "说明：通过国内高等教育学位数据库核实（2008年9月以后获取）"));
      }

      //国内高等教育学历
      var domesticEducationalBackground = detail.domesticEducationalBackground;
      var itemData403L = domesticEducationalBackground?.itemData403 ?? [];
      if (itemData403L.isNotEmpty) {
        List<ProfessionalCertificateContent> content =
            <ProfessionalCertificateContent>[];
        for (var item in itemData403L) {
          for (var item1 in item.itemPropValue) {
            for (var item2 in item1) {
              content.add(ProfessionalCertificateContent(
                  item2.itemPropLabel, item2.itemPropValue));
            }
          }
        }
        educationalBackground.add(ProfessionalCertificateBean(
            "国内高等教育学历", content, "说明： 通过国内高等教育学历数据库核实（2001年9月以后获取）"));
      }

      //国际高等教育学历
      var overseasEducationalBackground = detail.overseasEducationalBackground;
      var itemData746L = overseasEducationalBackground?.itemData746 ?? [];
      if (itemData746L.isNotEmpty) {
        List<ProfessionalCertificateContent> content =
            <ProfessionalCertificateContent>[];
        for (var item in itemData746L) {
          content.add(ProfessionalCertificateContent(
              item.itemPropLabel, item.itemPropValue));
        }
        educationalBackground.add(ProfessionalCertificateBean(
            "国际高等教育学历", content, "说明：通过教育部认证的国际学历数据库核实"));
      }
      //国内技工教育学历
      var technicalColleges = detail.technicalColleges;
      var itemData182L = technicalColleges?.itemData182 ?? [];
      if (itemData182L.isNotEmpty) {
        List<ProfessionalCertificateContent> content =
            <ProfessionalCertificateContent>[];
        for (var item in itemData182L) {
          content.add(ProfessionalCertificateContent(
              item.itemPropLabel, item.itemPropValue));
        }
        educationalBackground.add(ProfessionalCertificateBean(
            "国内技工教育学历", content, "说明：通过国内技工教育学历数据库核实"));
      }

      //驾驶证
      var driverLicenseInfo = detail.driverLicenseInfo;
      var itemData194L = driverLicenseInfo?.itemData194 ?? [];
      if (itemData194L.isNotEmpty) {
        List<ProfessionalCertificateContent> content =
            <ProfessionalCertificateContent>[];
        for (var item in itemData194L) {
          content.add(ProfessionalCertificateContent(
              item.itemPropLabel, item.itemPropValue));
        }
        professionalCertificateList.add(ProfessionalCertificateBean(
            "驾驶证", content, "说明：通过各地交通管理局驾驶证公开信息数据库核实"));
      }

      //会计专业资格核实
      var accountingQualification = detail.accountingQualification;
      if (accountingQualification.itemData418.isNotEmpty) {
        List<ProfessionalCertificateContent> content =
            <ProfessionalCertificateContent>[];
        for (var item in accountingQualification.itemData418) {
          content.add(ProfessionalCertificateContent(
              item.itemPropLabel, item.itemPropValue));
        }
        professionalCertificateList.add(
            ProfessionalCertificateBean("会计证", content, "说明：通过财政部会计资格证数据库核实"));
      }

      //工商信息
      var businessInfo = detail.businessInfo;
      var itemData136L = businessInfo?.itemData136 ?? [];
      if (itemData136L.isNotEmpty) {
        itemData136 = itemData136L;
      }

      //开庭公告
      var hearingAnnouncement = detail.hearingAnnouncement;
      var itemData755L = hearingAnnouncement?.itemData755 ?? [];
      if (itemData755L.isNotEmpty) {
        itemData755 = itemData755L;
      }

      //刑事案件
      var criminalAdjudicationDocument = detail.criminalAdjudicationDocument;
      var itemData764L = criminalAdjudicationDocument?.itemData764 ?? [];
      if (itemData764L.isNotEmpty) {
        var itemData764 = itemData764L[0];
        for (var i = 0; i < itemData764.itemPropValue.length; i++) {
          var itemPropValue = itemData764.itemPropValue[i];
          List<ProfessionalCertificateContent> content =
              <ProfessionalCertificateContent>[];
          for (var item in itemPropValue) {
            content.add(ProfessionalCertificateContent(
                item.itemPropLabel, item.itemPropValue));
          }
          criminalAdjudicationList
              .add(ProfessionalCertificateBean("刑事案件${i + 1}", content, ""));
        }
      }

      //"有限诉讼记录核实"
      var limitedLitigationRecord = detail.limitedLitigationRecord;
      var itemData261L = limitedLitigationRecord?.itemData261 ?? [];
      if (itemData261L.isNotEmpty) {
        itemData261 = itemData261L;
      }

      //法院失信被执行人
      var peopleWhoLoseCredit = detail.peopleWhoLoseCredit;
      var itemData452L = peopleWhoLoseCredit?.itemData452 ?? [];
      if (itemData452L.isNotEmpty) {
        var itemData764 = itemData452L[0];
        for (var i = 0; i < itemData764.itemPropValue.length; i++) {
          var itemPropValue = itemData764.itemPropValue[i];
          List<ProfessionalCertificateContent> content =
              <ProfessionalCertificateContent>[];
          for (var item in itemPropValue) {
            content.add(ProfessionalCertificateContent(
                item.itemPropLabel, item.itemPropValue));
          }
          peopleWhoLoseCreditList.add(
              ProfessionalCertificateBean("法院失信被执行人${i + 1}", content, ""));
        }
      }

      //法院被执行人
      var executedPerson = detail.executedPerson;
      var itemData453L = executedPerson?.itemData453 ?? [];
      if (itemData453L.isNotEmpty) {
        var itemData453 = itemData453L[0];
        for (var i = 0; i < itemData453.itemPropValue.length; i++) {
          var itemPropValue = itemData453.itemPropValue[i];
          List<ProfessionalCertificateContent> content =
              <ProfessionalCertificateContent>[];
          for (var item in itemPropValue) {
            content.add(ProfessionalCertificateContent(
                item.itemPropLabel, item.itemPropValue));
          }
          executedPersonList
              .add(ProfessionalCertificateBean("法院被执行人${i + 1}", content, ""));
        }
      }

      //限制高消费名单记录核实
      var limitHighConsumption = detail.limitHighConsumption;
      var itemData757L = limitHighConsumption?.itemData757 ?? [];
      if (itemData757L.isNotEmpty) {
        var itemData453 = itemData757L[0];
        for (var i = 0; i < itemData453.itemPropValue.length; i++) {
          var itemPropValue = itemData453.itemPropValue[i];
          List<ProfessionalCertificateContent> content =
              <ProfessionalCertificateContent>[];
          for (var item in itemPropValue) {
            content.add(ProfessionalCertificateContent(
                item.itemPropLabel, item.itemPropValue));
          }
          limitHighConsumptionList
              .add(ProfessionalCertificateBean("限制高消费名单${i + 1}", content, ""));
        }
      }

      //限制高消费名单记录核实
      var restrictedEntryAndExit = detail.restrictedEntryAndExit;
      var itemData769L = restrictedEntryAndExit?.itemData769 ?? [];
      if (itemData769L.isNotEmpty) {
        var itemData453 = itemData769L[0];
        for (var i = 0; i < itemData453.itemPropValue.length; i++) {
          var itemPropValue = itemData453.itemPropValue[i];
          List<ProfessionalCertificateContent> content =
              <ProfessionalCertificateContent>[];
          for (var item in itemPropValue) {
            content.add(ProfessionalCertificateContent(
                item.itemPropLabel, item.itemPropValue));
          }
          restrictedEntryAndExitList
              .add(ProfessionalCertificateBean("限制出入境名单${i + 1}", content, ""));
        }
      }

      //社会不良信息核实
      var itemData205L = detail.badSocialInfo?.itemData205 ?? [];
      if (itemData205L.isNotEmpty) {
        var itemData205 = itemData205L[0];
        badSocialInfoType = itemData205.itemPropValue;
      }

      //道德不良风险记录核实
      var itemData421L = detail.moralHazard?.itemData421 ?? [];
      if (itemData421L.isNotEmpty) {
        var itemData421 = itemData421L[0];
        moralHazard = itemData421.itemPropValue;
      }

      //税务不良记录核实
      if (detail.badTaxRecord!.itemData423.isNotEmpty) {
        for (var item in detail.badTaxRecord!.itemData423) {
          if (item.itemPropLabel == "相关人记录数") {
            badTaxRecord = int.parse(item.itemPropValue);
          }
        }
      }

      //违禁药品风险核实
      var itemData425L = detail.prohibitedDrugs?.itemData425 ?? [];
      if (itemData425L.isNotEmpty) {
        var itemData425 = itemData425L[0];
        prohibitedDrugs = itemData425.itemPropValue;
      }

      //网贷黑名单
      if (detail.onlineLoanBlacklist!.itemData138.isNotEmpty) {
        var itemData138 = detail.onlineLoanBlacklist!.itemData138[0];
        onlineLoanBlacklist = itemData138.itemPropValue == "命中";
      }

      setState(() {});
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

  Widget _JudgeRisk(int type) {
    String url = "";
    switch (type) {
      case 1:
        url = "assets/images/icon_high_risk.png";
        break;
      case 2:
        url = "assets/images/icon_medium_risk.png";
        break;
      case 3:
        url = "assets/images/icon_low_risk.png";
        break;
      default:
        url = "assets/images/icon_no_risk.png";
        break;
    }
    return Image(
      image: AssetImage(url),
      width: 16,
      height: 16,
    );
  }
}
