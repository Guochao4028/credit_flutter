import 'dart:math';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/manager/report_details_manager.dart';
import 'package:credit_flutter/models/report_details_bean.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';

/// @Description: 报告详情页
class ReportDetailsPage extends StatefulWidget {
  final String reportAuthId;

  //	报告类型 1.￥99报告 2.￥198报告 3.￥999报告
  final int reportType;

  bool isSelf = false;

  ReportDetailsPage(
      {Key? key,
      required this.reportAuthId,
      required this.reportType,
      this.isSelf = false})
      : super(key: key);

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage>
    with SingleTickerProviderStateMixin {
  ReportDetailsBean? reportDetailsBean;

  /// 登录类型
  String loginType = "1";

  //	报告类型 1.￥99报告 2.￥198报告 3.￥999报告
  int reportType = 0;

  //名称
  String name = "";

  //性别
  String gender = "";

  //民族
  String nationality = "";

  //手机号
  String phoneNumber = "";

  //婚姻状况
  String maritalStatus = "";

  //政治面貌
  String politicalStatus = "";

  //出生日期
  String birthday = "";

  //身份证号
  String identityNumber = "";

  //户籍所在地
  String domicile = "";

  //现居地址
  String currentAddress = "";

  //风险提醒
  String riskAlert = "";

  //风险提醒
  PersonalRiskInfos? personalRiskInfo;

  late TabController _tabController;

  List tabs1 = [
    "个人风险项", "职场信息", "学历信息", "专业技能", "过往经历",
    // "公司工作图谱",
    "公开信息"
  ];

  List tabs2 = [
    "个人风险项",
    "行业禁止",
    "职场信息",
    "学历信息",
    "专业技能",
    "过往经历",
    // "公司工作图谱",
    "工商注册核查",
    "贷款逾期核查",
    "公开信息"
  ];

  final ScrollController _controller = ScrollController();

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();
  GlobalKey key5 = GlobalKey();
  GlobalKey key6 = GlobalKey();
  GlobalKey key7 = GlobalKey();
  GlobalKey key8 = GlobalKey();
  GlobalKey key9 = GlobalKey();

  // double getY(GlobalKey globalKey) {
  //   RenderBox? renderBox =
  //       globalKey.currentContext?.findRenderObject() as RenderBox?;
  //   var offset = renderBox.localToGlobal(Offset.zero);
  //
  //   Rect r = (renderObject as RenderBox).localToGlobal(Offset.zero) &
  //       (renderObject as RenderBox).size;
  //   // RenderBox box = key.currentContext.findRenderObject();
  //   RenderBox? box = buildContext.findRenderObject();
  //   //final size = box.size;
  //   final topLeftPosition = box?.localToGlobal(Offset.zero);
  //   return topLeftPosition.dy;
  // }

  @override
  void initState() {
    //初始化主页面
    super.initState();
    reportType = widget.reportType;
    if (reportType == 1) {
      _tabController = TabController(length: tabs1.length, vsync: this);
    } else {
      _tabController = TabController(length: tabs2.length, vsync: this);
    }
    //监听
    _tabController.addListener(() {
      Log.i("点击item: ${_tabController.index}");
      String title = "";
      if (reportType != 1) {
        //9个
        title = tabs2[_tabController.index];
      } else {
        //6个
        title = tabs1[_tabController.index];
      }
      switch (title) {
        // ……响应事件……
        case "个人风险项":
          Scrollable.ensureVisible(
            key1.currentContext as BuildContext,
          );

          break;
        case "行业禁止":
          Scrollable.ensureVisible(
            key2.currentContext as BuildContext,
          );

          RenderBox? box =
              key2.currentContext?.findRenderObject() as RenderBox?;
          Offset? position = box?.localToGlobal(Offset.zero);
          Log.i("offset: ${position?.dy}");

          break;
        case "职场信息":
          Scrollable.ensureVisible(
            key3.currentContext as BuildContext,
          );
          break;
        case "学历信息":
          Scrollable.ensureVisible(
            key4.currentContext as BuildContext,
          );
          break;
        case "专业技能":
          Scrollable.ensureVisible(
            key5.currentContext as BuildContext,
          );
          break;
        case "过往经历":
          Scrollable.ensureVisible(
            key6.currentContext as BuildContext,
          );
          break;
        case "工商注册核查":
          Scrollable.ensureVisible(
            key7.currentContext as BuildContext,
          );
          break;
        case "贷款逾期核查":
          Scrollable.ensureVisible(
            key8.currentContext as BuildContext,
          );

          break;
        case "公开信息":
          Scrollable.ensureVisible(
            key9.currentContext as BuildContext,
          );
          break;
      }
    });
    _initData();

    _controller.addListener(() {
      Log.i("打印滚动位置: ${_controller.offset}");
      var of = _controller.offset;

      // if (reportType != 1) {
      //   //九个
      //   var y1 = getY(key1);
      //   var y2 = getY(key2);
      //   Log.i("y1: ${y1}");
      //   Log.i("y2: ${y2}");
      //
      //   // if (of > y2 - y1) {
      //   //
      //   // }
      //
      // } else {
      //   //6个
      // }
      // if (of > threeY - oneY) {
      //   _tabController.animateTo(2);
      // }else if (of > twoY - oneY) {
      //   _tabController.animateTo(1);
      // } else {
      //   _tabController.animateTo(0);
      // }
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "个人报告详情",
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
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          //基本信息
          _essentialInfo(),
          //风险提醒
          _remindInfo(),
          //分类
          _tabTab(),
          //个人风险
          _ifRiskItem(),
          //行业禁止
          _ifIndustryProhibition(),
          //职场信息
          _workplaceInfo(),
          //学历信息
          _academicInfo(),
          //专业技能
          _professionalSkills(),
          //过往经历
          _pastExperience(),
          //工商注册核查
          _ifBusinessCircles(),
          //贷款逾期核查
          _ifOverdueLoan(),
          //公开信息
          _ifPublicInfo(),
          //个人数据使用说明
          _explain(),
        ],
      ),
    );
  }

  Widget _essentialInfo() {
    var bgColor = Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
        Random().nextInt(256), 0.4);
    var textColor = bgColor.withAlpha(255);

    Container surname = Container(
      margin: const EdgeInsets.only(left: 32, top: 16),
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name.isNotEmpty ? name.substring(0, 1) : "",
            style: TextStyle(
              fontSize: 40,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            color: CustomColors.color3B8FF9,
            height: 149,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, top: 30, right: 16),
            padding:
                const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 16),
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
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomColors.greyBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                _addInfoText("性别：$gender"),
                _addInfoText("民族：$nationality"),
                _addInfoText("手机号：$phoneNumber"),
                _addInfoText("婚姻状况：$maritalStatus"),
                _addInfoText("政治面貌：$politicalStatus"),
                _addInfoText("出生日期：$birthday"),
                _addInfoText("身份证号：$identityNumber"),
                _addInfoText("户籍所在地：$domicile"),
                _addInfoText("现居地址：$currentAddress"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: const [
                    Image(
                      width: 15,
                      height: 15,
                      image: AssetImage("assets/images/icon_red_sigh.png"),
                    ),
                    SizedBox(
                      width: 5,
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
                const Text(
                  "本报告是经您个人明确授权后，我们才向合法存有您个人数据的机构去调取本报告相关内容。本报告仅向您和公司个人展示，请注意保护好报告中所展示的您的个人隐私数据。",
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          surname,
        ],
      ),
    );
  }

  Widget _addInfoText(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 14,
        color: CustomColors.greyBlack,
      ),
    );
  }

  Widget _remindInfo() {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
        padding: const EdgeInsets.only(left: 16, top: 8, right: 12, bottom: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "风险提醒",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.colorED3833,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 5),
                width: 1,
                height: double.infinity,
                color: CustomColors.colorC7C7C7,
              ),
              Expanded(
                child: Text(
                  riskAlert,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CustomColors.colorED3833,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabTab() {
    return SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: true,
      delegate: _SliverAppBarDelegate(
        maxHeight: 45,
        minHeight: 45,
        child: Container(
          width: double.infinity,
          height: 45,
          margin: const EdgeInsets.only(left: 16, right: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          child: TabBar(
            labelColor: CustomColors.connectColor,
            unselectedLabelColor: CustomColors.darkGrey,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabController,
            tabs: reportType == 1
                ? tabs1.map((e) => Tab(text: e)).toList()
                : tabs2.map((e) => Tab(text: e)).toList(),
          ),
        ),
      ),
    );
  }

  ///个人风险项
  Widget _ifRiskItem() {
    Widget widget;
    if (reportType == 1) {
      widget = _doNotShow(224.0, "assets/images/icon_risk_bg.png",
          "assets/images/icon_risk_item.png", "个人风险项");
    } else {
      widget = _riskItem();
    }
    return SliverToBoxAdapter(
      key: key1,
      child: widget,
    );
  }

  ///个人风险项
  Widget _riskItem() {
    List data = List.from([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);

    int allHorizontalPadding = 0;
    int columnCount = 4;
    double cellWidth =
        ((MediaQuery.of(context).size.width - allHorizontalPadding) /
            columnCount);
    double desiredCellHeight = 65;
    double childAspectRatio = cellWidth / desiredCellHeight;

    return Container(
      width: double.infinity,
      // height: 251,
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
            child: Row(
              children: const [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_risk_item.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "个人风险项",
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: childAspectRatio,
            children: data.map((index) => _itemRisk(index)).toList(),
          ),
        ],
      ),
    );
  }

  ///行业禁止
  Widget _ifIndustryProhibition() {
    Widget widgetBody;
    if (reportType == 1 || widget.isSelf == true) {
      widgetBody = const SizedBox();
    } else if (reportType == 2) {
      widgetBody = _doNotShow(
          331.0,
          "assets/images/icon_industry_prohibition_bg.png",
          "assets/images/icon_industry_prohibition.png",
          "行业禁止");
    } else {
      widgetBody = _industryProhibition();
    }
    return SliverToBoxAdapter(
      key: key2,
      child: widgetBody,
    );
  }

  ///行业禁止
  Widget _industryProhibition() {
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
            child: Row(
              children: const [
                Image(
                  width: 18,
                  height: 18,
                  image:
                      AssetImage("assets/images/icon_industry_prohibition.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "行业禁止",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: CustomColors.colorE8F8FE,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(
                  color: CustomColors.colorC2DCFF,
                  width: 1,
                ),
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 12, top: 28, right: 12, bottom: 15),
                    child: Text(
                      reportDetailsBean?.industryBan?.thing ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.greyBlack,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: CustomColors.connectColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            bottomRight: Radius.circular(2)),
                      ),
                      width: 40,
                      height: 20,
                      child: const Center(
                        child: Text(
                          "案件",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 5, right: 11),
                        child: const Text(
                          "查看详情 >",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.connectColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                color: CustomColors.colorE8E8E8,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(
                  color: CustomColors.colorD8D8D8,
                  width: 1,
                ),
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, top: 5, right: 16),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 12, top: 28, right: 12, bottom: 15),
                    child: Text(
                      reportDetailsBean?.industryBan?.banIndustry ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.greyBlack,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: CustomColors.colorB9B9B9,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            bottomRight: Radius.circular(2)),
                      ),
                      width: 40,
                      height: 20,
                      child: const Center(
                        child: Text(
                          "禁止",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                color: CustomColors.colorFEE8E8,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                border: Border.all(
                  color: CustomColors.colorF7DBDB,
                  width: 1,
                ),
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: 16, top: 5, right: 16, bottom: 15),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 12, top: 28, right: 12, bottom: 15),
                    child: Text(
                      reportDetailsBean?.industryBan?.proposedBanIndustry ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.greyBlack,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: CustomColors.colorF94E4E,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            bottomRight: Radius.circular(2)),
                      ),
                      width: 40,
                      height: 20,
                      child: const Center(
                        child: Text(
                          "建议",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  ///职场信息
  Widget _workplaceInfo() {
    return SliverToBoxAdapter(
      key: key3,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: Row(
                children: const [
                  Image(
                    width: 18,
                    height: 18,
                    image: AssetImage("assets/images/icon_workplace_info.png"),
                  ),
                  SizedBox(width: 3),
                  Text(
                    "职场信息",
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.greyBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: CustomColors.colorEDF5FE,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(2), topLeft: Radius.circular(2)),
                border: Border.all(
                  color: CustomColors.colorDAE9FE,
                  width: 1,
                ),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "序\n号",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: CustomColors.colorDAE9FE,
                  ),
                  Expanded(
                    flex: 26,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "公司名称",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 24,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "工作时间",
                          style: TextStyle(
                            color: CustomColors.greyBlack,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 19,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "工作职位",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 21,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "社保缴纳",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var work = reportDetailsBean!.workExperience![index];
                return WidgetTools()
                    .showReportDetailsWorkItem(context, index, work);
              },
              itemCount: reportDetailsBean?.workExperience?.length ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  ///学历信息
  Widget _academicInfo() {
    return SliverToBoxAdapter(
      key: key4,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: Row(
                children: const [
                  Image(
                    width: 18,
                    height: 18,
                    image: AssetImage("assets/images/icon_academic_info.png"),
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
            Container(
              decoration: BoxDecoration(
                color: CustomColors.colorEDF5FE,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(2), topLeft: Radius.circular(2)),
                border: Border.all(
                  color: CustomColors.colorDAE9FE,
                  width: 1,
                ),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "序\n号",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: CustomColors.colorDAE9FE,
                  ),
                  Expanded(
                    flex: 30,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "毕业学校",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 17,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "学历",
                          style: TextStyle(
                            color: CustomColors.greyBlack,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 19,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "学位证书",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 24,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "毕业时间",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var educations = reportDetailsBean!.educations![index];
                return WidgetTools()
                    .showReportDetailsAcademicItem(context, index, educations);
              },
              itemCount: reportDetailsBean?.educations?.length ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  ///专业技能
  Widget _professionalSkills() {
    return SliverToBoxAdapter(
      key: key5,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: Row(
                children: const [
                  Image(
                    width: 18,
                    height: 18,
                    image: AssetImage(
                        "assets/images/icon_professional_skills.png"),
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
            Container(
              decoration: BoxDecoration(
                color: CustomColors.colorEDF5FE,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(2), topLeft: Radius.circular(2)),
                border: Border.all(
                  color: CustomColors.colorDAE9FE,
                  width: 1,
                ),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "序\n号",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: CustomColors.colorDAE9FE,
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "证书名称",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 26,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "获得时间",
                          style: TextStyle(
                            color: CustomColors.greyBlack,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 24,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Center(
                        child: Text(
                          "证书编号",
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var skills = reportDetailsBean!.skillsCertificates![index];
                return WidgetTools()
                    .showReportDetailsSkillItem(context, index, skills);
              },
              itemCount: reportDetailsBean?.skillsCertificates?.length ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  ///过往经历
  Widget _pastExperience() {
    return SliverToBoxAdapter(
      key: key6,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: Row(
                children: const [
                  Image(
                    width: 18,
                    height: 18,
                    image: AssetImage("assets/images/icon_past_experience.png"),
                  ),
                  SizedBox(width: 3),
                  Text(
                    "过往经历",
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var skills = reportDetailsBean!.pastExperience![index];
                return WidgetTools().showReportPastExperienceItem(
                    context,
                    (index + 1) == reportDetailsBean?.pastExperience?.length,
                    skills);
              },
              itemCount: reportDetailsBean?.pastExperience?.length ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  ///工商注册核查
  Widget _ifBusinessCircles() {
    Widget widgetBody;
    if (reportType == 1 || widget.isSelf == true) {
      widgetBody = const SizedBox();
    } else if (reportType == 2) {
      widgetBody = _doNotShow(
          208.0,
          "assets/images/icon_business_circles_bg.jpg",
          "assets/images/icon_business_circles.png",
          "工商注册核查");
    } else {
      widgetBody = _businessCircles();
    }
    return SliverToBoxAdapter(
      key: key7,
      child: widgetBody,
    );
  }

  ///工商注册核查
  Widget _businessCircles() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: const [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_business_circles.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "工商注册核查",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CustomColors.colorEDF5FE,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(2), topLeft: Radius.circular(2)),
              border: Border.all(
                color: CustomColors.colorDAE9FE,
                width: 1,
              ),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "序\n号",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "公司名称",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 19,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "成立日期",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "职位",
                        style: TextStyle(
                          color: CustomColors.greyBlack,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 26,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "注册资本",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var company = reportDetailsBean!.companyRegistrationInfos![index];
              return WidgetTools().showReportDetailsBusinessCirclesItem(
                  context, index, company);
            },
            itemCount: reportDetailsBean?.companyRegistrationInfos?.length ?? 0,
          ),
        ],
      ),
    );
  }

  ///贷款逾期核查
  Widget _ifOverdueLoan() {
    Widget widgetBody;
    if (reportType == 1 || widget.isSelf == true) {
      widgetBody = const SizedBox();
    } else if (reportType == 2) {
      widgetBody = _doNotShow(
          208.0,
          "assets/images/icon_business_circles_bg.jpg",
          "assets/images/icon_overdue_loan.png",
          "贷款逾期核查");
    } else {
      widgetBody = _overdueLoan();
    }
    return SliverToBoxAdapter(
      key: key8,
      child: widgetBody,
    );
  }

  ///贷款逾期核查
  Widget _overdueLoan() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: const [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_overdue_loan.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "贷款逾期核查",
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: CustomColors.colorEDF5FE,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(2), topLeft: Radius.circular(2)),
              border: Border.all(
                color: CustomColors.colorDAE9FE,
                width: 1,
              ),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "序\n号",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 27,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "银行名称",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 23,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "贷款时间",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 22,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "贷款金额",
                        style: TextStyle(
                          color: CustomColors.greyBlack,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 18,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Center(
                      child: Text(
                        "是否逾期",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var loanInfos = reportDetailsBean!.loanInfos![index];
              return WidgetTools()
                  .showReportDetailsOverdueLoanItem(context, index, loanInfos);
            },
            itemCount: reportDetailsBean?.loanInfos?.length ?? 0,
          ),
        ],
      ),
    );
  }

  ///公开信息
  Widget _ifPublicInfo() {
    Widget widget;
    if (reportType == 1) {
      widget = _doNotShow(375.0, "assets/images/icon_public_info_bg.png",
          "assets/images/icon_public_info.png", "公开信息");
    } else {
      widget = _publicInfo();
    }
    return SliverToBoxAdapter(
      key: key9,
      child: widget,
    );
  }

  ///公开信息
  Widget _publicInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: Row(
              children: const [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage("assets/images/icon_public_info.png"),
                ),
                SizedBox(width: 3),
                Text(
                  "公开信息",
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var public = reportDetailsBean!.publicInformation![index];
              return WidgetTools()
                  .showReportPublicInfoItem(context, index, public);
            },
            itemCount: reportDetailsBean?.publicInformation?.length ?? 0,
          ),
        ],
      ),
    );
  }

  ///个人数据使用说明
  Widget _explain() {
    return SliverToBoxAdapter(
      child: Container(
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
            SizedBox(
              width: double.infinity,
              height: 46,
              child: Row(
                children: const [
                  Image(
                    width: 18,
                    height: 18,
                    image: AssetImage("assets/images/icon_explain.png"),
                  ),
                  SizedBox(width: 3),
                  Text(
                    "个人数据使用说明",
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.greyBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "1、本报告著作权属于慧眼查，未经慧眼查书面许可，任何人不得复制、摘录、转载或发表。",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "2、本报告内容以第三方平台数据为依据，不是《个人征信报告》，也不同于其他机构出具的有关用户的各种报告。",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "3、如果用户本人将此报告提供给他人或向他人展示，我们善意提醒用户由于上述行为，用户的个人信息可能会被泄露，由此可能会给用户带来不利的后果或无法预知的危害，请注意保护个人信息。",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "4、本报告只有用户和公司才能看得到，我们不会也无法向他人提供这份报告。",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "5、本报告是经用户授权同意后，慧眼查才向合法存有个人信息的机构采集用户的个人信息并实时生成本报告。",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "6、用户认可慧眼查及相关数据合作方不保证本报告内容的及时性、准确性、完整性和合理性。本报告内容仅供用户和公司参考，由于用户本人或他人使用本报告而产生的任何后果或结果均与慧眼查和数据合作方无关，慧眼查和数据合作方不承担任何责任，也不享受由于使用此报告可能给用户本人或他人带来的任何利益。",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "7、如果根据用户本人与其他机构或个人的约定，需要向这些机构或个人提供本报告，这是用户本人与这些机构或个人之间的事情，是否提供本报告是用户个人的权利或义务，与慧眼查无关，慧眼查无权过问也无需知晓。",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.greyBlack,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "8、此报告长期有效。",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.greyBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///不展示
  Widget _doNotShow(
      double height, String bgImage, String iconImage, String title) {
    return Container(
      width: double.infinity,
      // height: 251,
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Image(
            width: double.infinity,
            height: height,
            image: AssetImage(bgImage),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
            width: double.infinity,
            height: 46,
            child: Row(
              children: [
                Image(
                  width: 18,
                  height: 18,
                  image: AssetImage(iconImage),
                ),
                const SizedBox(width: 3),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 55),
            width: 180,
            height: 115,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(2)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                    blurRadius: 4.0, //阴影模糊程度
                    spreadRadius: 1.0 //阴影扩散程度
                    )
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 30,
                  color: CustomColors.connectColor,
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      const Center(
                        child: Text(
                          "购买后可查看",
                          style: TextStyle(
                            fontSize: 13,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          int type = reportType + 1;
                          PayManager.getReportPrice(type, (price) {
                            PaymentFromType paymentType = loginType == "1"
                                ? PaymentFromType.paymentFromReportDetailsType
                                : PaymentFromType
                                    .paymentFromPersonReportUpgradeType;

                            if (Golbal.isWX == true) {
                              PayWXMiniProgramClass.price = price;
                              PayWXMiniProgramClass.reportType = type;
                              PayWXMiniProgramClass.reportAuthId =
                                  widget.reportAuthId;
                              PayWXMiniProgramClass.toPay(paymentType);
                            } else {
                              PayCheakstandPage page = PayCheakstandPage(
                                displayType: PaymentListDisplayType
                                    .paymentListAllDisplay,
                                fromType: paymentType,
                                price: price,
                                reportType: type,
                                reportAuthId: widget.reportAuthId,
                              );

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => page,
                                ),
                              );
                            }
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 22,
                          color: CustomColors.connectColor,
                          child: const Center(
                            child: Text(
                              "去购买",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRisk(int index) {
    AssetImage assetImage =
        const AssetImage("assets/images/icon_risk_item.png");
    String name = "";
    int content = 0;
    switch (index) {
      case 0:
        name = "立案信息";
        content = personalRiskInfo?.filing ?? 0;
        if ((personalRiskInfo?.filing ?? 0) > 0) {
          assetImage = const AssetImage(
              "assets/images/icon_filing_information_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_filing_information.png");
        }
        break;
      case 1:
        name = "开庭公告";
        content = personalRiskInfo?.court ?? 0;
        if ((personalRiskInfo?.court ?? 0) > 0) {
          assetImage = const AssetImage(
              "assets/images/icon_opening_announcement_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_opening_announcement.png");
        }
        break;
      case 2:
        name = "司法案件";
        content = personalRiskInfo?.judicial ?? 0;
        if ((personalRiskInfo?.judicial ?? 0) > 0) {
          assetImage =
              const AssetImage("assets/images/icon_judicial_cases_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_judicial_cases.png");
        }
        break;
      case 3:
        name = "判决文书";
        content = personalRiskInfo?.judgment ?? 0;
        if ((personalRiskInfo?.judgment ?? 0) > 0) {
          assetImage =
              const AssetImage("assets/images/icon_judgment_document_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_judgment_document.png");
        }
        break;
      case 4:
        name = "行政处罚";
        content = personalRiskInfo?.judgment ?? 0;
        if ((personalRiskInfo?.judgment ?? 0) > 0) {
          assetImage = const AssetImage(
              "assets/images/icon_administrative_sanction_warn.png");
        } else {
          assetImage = const AssetImage(
              "assets/images/icon_administrative_sanction.png");
        }
        break;
      case 5:
        name = "失信信息";
        content = personalRiskInfo?.failure ?? 0;
        if ((personalRiskInfo?.failure ?? 0) > 0) {
          assetImage = const AssetImage(
              "assets/images/icon_dishonest_information_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_dishonest_information.png");
        }
        break;
      case 6:
        name = "被执行人";
        content = personalRiskInfo?.executed ?? 0;
        if ((personalRiskInfo?.executed ?? 0) > 0) {
          assetImage = const AssetImage("assets/images/icon_executed_warn.png");
        } else {
          assetImage = const AssetImage("assets/images/icon_executed.png");
        }
        break;
      case 7:
        name = "送达公告";
        content = personalRiskInfo?.courtService ?? 0;
        if ((personalRiskInfo?.courtService ?? 0) > 0) {
          assetImage = const AssetImage(
              "assets/images/icon_service_announcement_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_service_announcement.png");
        }
        break;
      case 8:
        name = "终本案件";
        content = personalRiskInfo?.finalCase ?? 0;
        if ((personalRiskInfo?.finalCase ?? 0) > 0) {
          assetImage =
              const AssetImage("assets/images/icon_final_case_warn.png");
        } else {
          assetImage = const AssetImage("assets/images/icon_final_case.png");
        }
        break;
      case 9:
        name = "市场监督";
        content = personalRiskInfo?.marketSurveillance ?? 0;
        if ((personalRiskInfo?.marketSurveillance ?? 0) > 0) {
          assetImage = const AssetImage(
              "assets/images/icon_market_supervision_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_market_supervision.png");
        }
        break;
      case 10:
        name = "税收违法";
        content = personalRiskInfo?.taxViolation ?? 0;
        if ((personalRiskInfo?.taxViolation ?? 0) > 0) {
          assetImage =
              const AssetImage("assets/images/icon_illegal_taxation_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_illegal_taxation.png");
        }
        break;
      case 11:
        name = "法院公告";
        content = personalRiskInfo?.courtAnnouncement ?? 0;
        if ((personalRiskInfo?.courtAnnouncement ?? 0) > 0) {
          assetImage = const AssetImage(
              "assets/images/icon_court_announcement_warn.png");
        } else {
          assetImage =
              const AssetImage("assets/images/icon_court_announcement.png");
        }
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
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
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
    );
  }

  // 初始化数据
  void _initData() async {
    if (widget.isSelf == false) {
      loginType = "1";
      ReportDetailsManager.getReportDetails(widget.reportAuthId.toString(),
          (object) {
        var data = object as ReportDetailsBean;
        reportDetailsBean = data;
        reportType = data.reportType;
        name = data.idCardName;
        gender = data.gender;
        nationality = data.nationality;
        phoneNumber = data.phone;
        maritalStatus = data.marital;
        politicalStatus = data.politicalStatus;
        var dateTime = DateTime.fromMillisecondsSinceEpoch(data.birthDay);
        birthday = "${dateTime.year}.${dateTime.month}.${dateTime.day}";
        identityNumber = data.idCard;
        domicile = data.hometown;
        currentAddress = data.currentAddress;
        String riskAlertData = "";
        for (var risk in data.riskWarning) {
          var createTime = DateTime.fromMillisecondsSinceEpoch(risk.createTime);
          riskAlertData +=
              "${WidgetTools().timeFormat(createTime, ".")} ${risk.title}\n";
        }
        riskAlert = riskAlertData.trimRight();
        personalRiskInfo = data.personalRiskInfos[0];
        setState(() {});
      });
    } else {
      loginType = "2";
      ReportDetailsManager.getSelfReportDetails((object) {
        var data = object as ReportDetailsBean;
        reportDetailsBean = data;
        reportType = data.reportType;
        name = data.idCardName;
        gender = data.gender;
        nationality = data.nationality;
        phoneNumber = data.phone;
        maritalStatus = data.marital;
        politicalStatus = data.politicalStatus;
        var dateTime = DateTime.fromMillisecondsSinceEpoch(data.birthDay);
        birthday = "${dateTime.year}.${dateTime.month}.${dateTime.day}";
        identityNumber = data.idCard;
        domicile = data.hometown;
        currentAddress = data.currentAddress;
        String riskAlertData = "";
        for (var risk in data.riskWarning) {
          var createTime = DateTime.fromMillisecondsSinceEpoch(risk.createTime);
          riskAlertData +=
              "${createTime.year}.${createTime.month}.${createTime.day} ${risk.title}\n";
        }
        riskAlert = riskAlertData.trimRight();
        personalRiskInfo = data.personalRiskInfos[0];
        setState(() {});
      });
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
