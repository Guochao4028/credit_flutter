import 'dart:math';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/report_details_bean.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';

/// @Description: 求职报告详情页
class JobReportDetailsPage extends StatefulWidget {
  String reportId;

  JobReportDetailsPage({Key? key, required this.reportId}) : super(key: key);

  @override
  State<JobReportDetailsPage> createState() => _JobReportDetailsPageState();
}

class _JobReportDetailsPageState extends State<JobReportDetailsPage>
    with SingleTickerProviderStateMixin {
  ReportDetailsBean? reportDetailsBean;

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

  List tabs = ["婚恋风险项", "职场信息", "学历信息", "专业技能", "过往经历", "公开信息"];

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
  GlobalKey key10 = GlobalKey();
  GlobalKey key11 = GlobalKey();
  GlobalKey key12 = GlobalKey();

  var ifVisible = true;
  var sliding = false;
  var clicking = false;

  var currentLocation = 0;

  @override
  void initState() {
    //初始化主页面
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    //监听
    _tabController.addListener(() {
      Log.d("indexIsChanging----${_tabController.indexIsChanging}");
      Log.d("sliding----${sliding}");
      if (!_tabController.indexIsChanging) {
        return;
      }
      if (sliding) {
        // sliding = false;
        return;
      }
      clicking = true;
      Log.i("点击item: ${_tabController.index}");
      String title = tabs[_tabController.index];
      switch (title) {
        case "婚恋风险项":
          Scrollable.ensureVisible(
            key4.currentContext as BuildContext,
          );
          break;
        case "职场信息":
          Scrollable.ensureVisible(
            key6.currentContext as BuildContext,
          );
          break;
        case "学历信息":
          Scrollable.ensureVisible(
            key7.currentContext as BuildContext,
          );
          break;
        case "专业技能":
          Scrollable.ensureVisible(
            key8.currentContext as BuildContext,
          );
          break;
        case "过往经历":
          Scrollable.ensureVisible(
            key10.currentContext as BuildContext,
          );
          break;
        case "公开信息":
          Scrollable.ensureVisible(
            key12.currentContext as BuildContext,
            duration: Duration.zero,
          );
          break;
      }
    });
    _initData();

    _controller.addListener(() {
      // Log.i("打印滚动位置: ${_controller.offset}");
      if (clicking) {
        return;
      }
      var key1Height = key1.currentContext?.size?.height ?? 0.0;
      var key2Height = key2.currentContext?.size?.height ?? 0.0;
      var key3Height = key3.currentContext?.size?.height ?? 0.0;
      var key4Height = key4.currentContext?.size?.height ?? 0.0;
      var key5Height = key5.currentContext?.size?.height ?? 0.0;
      var key6Height = key6.currentContext?.size?.height ?? 0.0;
      var key7Height = key7.currentContext?.size?.height ?? 0.0;
      var key8Height = key8.currentContext?.size?.height ?? 0.0;
      var key9Height = key9.currentContext?.size?.height ?? 0.0;
      var key10Height = key10.currentContext?.size?.height ?? 0.0;
      var key11Height = key11.currentContext?.size?.height ?? 0.0;
      var key12Height = key12.currentContext?.size?.height ?? 0.0;

      var of = _controller.offset + key3Height;
      //职场信息
      var risk = key1Height + key2Height + key3Height;
      //职场信息
      var workplace =
          key1Height + key2Height + key3Height + key4Height + key5Height;
      //学历信息
      var education = key1Height +
          key2Height +
          key3Height +
          key4Height +
          key5Height +
          key6Height;
      //专业技能
      var major = key1Height +
          key2Height +
          key3Height +
          key4Height +
          key5Height +
          key6Height +
          key7Height;
      //过往经历
      var past = key1Height +
          key2Height +
          key3Height +
          key4Height +
          key5Height +
          key6Height +
          key7Height +
          key8Height +
          key9Height;
      //公开信息
      var open = key1Height +
          key2Height +
          key3Height +
          key4Height +
          key5Height +
          key6Height +
          key7Height +
          key8Height +
          key9Height +
          key10Height +
          key11Height;

      if (of > risk && of < risk + key4Height) {
        currentLocation = 0;
      } else if (of > workplace && of < workplace + key6Height) {
        currentLocation = 1;
      } else if (of > education && of < workplace + key7Height) {
        currentLocation = 2;
      } else if (of > major && of < major + key8Height) {
        currentLocation = 3;
      } else if (of > past && of < past + key10Height) {
        currentLocation = 4;
      } else if (of > open && of < open + key12Height) {
        currentLocation = 5;
      } else if (of < risk) {
        currentLocation = 0;
      }

      if (_tabController.index != currentLocation) {
        // _tabController.index = currentLocation;
        sliding = true;
        _tabController.animateTo(currentLocation);
      }
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
                "求职报告详情",
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
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollStartNotification) {
              // _onStartScroll(scrollNotification.metrics);
              print('_onStartScroll');
            } else if (scrollNotification is ScrollUpdateNotification) {
              // _onUpdateScroll(scrollNotification.metrics);
              print('_onUpdateScroll');
            } else if (scrollNotification is ScrollEndNotification) {
              // _onEndScroll(scrollNotification.metrics);
              print('_onEndScroll');
              if (clicking) {
                clicking = false;
              }
              if (sliding) {
                sliding = false;
              }
            }
            return true;
          },
          child: CustomScrollView(
            controller: _controller,
            slivers: [
              //基本信息
              _essentialInfo(),
              //风险提醒
              _remindInfo(),
              //分类
              _tabTab(),
              //婚恋风险项
              _ifRiskItem(),
              //社会经历
              SliverToBoxAdapter(
                child: Container(
                  key: key5,
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
                  decoration: const BoxDecoration(
                    color: CustomColors.color3B8FF9,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: const Center(
                    child: Text(
                      '社会经历',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              //职场信息
              _workplaceInfo(),
              //学历信息
              _academicInfo(),
              //专业技能
              _professionalSkills(),

              //其他信息
              SliverToBoxAdapter(
                child: Container(
                  key: key9,
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
                  decoration: const BoxDecoration(
                    color: CustomColors.color3B8FF9,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: const Center(
                    child: Text(
                      '其他信息',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              //过往经历
              _pastExperience(),

              //其他信息
              SliverToBoxAdapter(
                child: Container(
                  key: key11,
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
                  decoration: const BoxDecoration(
                    color: CustomColors.color3B8FF9,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: const Center(
                    child: Text(
                      '风险警示',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              //公开信息
              _ifPublicInfo(),
              //个人数据使用说明
              _explain(),
            ],
          ),
        ));
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

    return SliverToBoxAdapter(
      child: Stack(
        key: key1,
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
                    hideInfo(1, name),
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
                _addInfoText("性别：${hideInfo(2, gender)}"),
                _addInfoText("民族：${hideInfo(2, nationality)}"),
                _addInfoText("手机号：${hideInfo(2, phoneNumber)}"),
                _addInfoText("婚姻状况：${hideInfo(2, maritalStatus)}"),
                _addInfoText("政治面貌：${hideInfo(2, politicalStatus)}"),
                _addInfoText("出生日期：${hideInfo(2, birthday)}"),
                _addInfoText("身份证号：${hideInfo(2, identityNumber)}"),
                _addInfoText("户籍所在地：${hideInfo(2, domicile)}"),
                _addInfoText("现居地址：${hideInfo(2, currentAddress)}"),
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
        key: key2,
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
          key: key3,
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
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
        ),
      ),
    );
  }

  ///婚恋风险项
  Widget _ifRiskItem() {
    return SliverToBoxAdapter(
      child: _riskItem(),
    );
  }

  ///婚恋风险项
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
      key: key4,
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
                  "婚恋风险项",
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

  ///职场信息
  Widget _workplaceInfo() {
    return SliverToBoxAdapter(
      child: Container(
        key: key6,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var work = reportDetailsBean!.workExperience![index];
                return WidgetTools()
                    .showJobReportDetailsWorkItem(context, index, work);
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
      child: Container(
        key: key7,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var educations = reportDetailsBean!.educations![index];
                return WidgetTools().showJobReportDetailsAcademicItem(
                    context, index, educations);
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
      child: Container(
        key: key8,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var skills = reportDetailsBean!.skillsCertificates![index];
                return WidgetTools()
                    .showJobReportDetailsSkillItem(context, index, skills);
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
      child: Container(
        key: key10,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 1),
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
                return WidgetTools().showJobReportPastExperienceItem(
                    context,
                    (index + 1) == reportDetailsBean?.pastExperience?.length,
                    index,
                    skills);
              },
              itemCount: reportDetailsBean?.pastExperience?.length ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  ///公开信息
  Widget _ifPublicInfo() {
    return SliverToBoxAdapter(
      child: _publicInfo(),
    );
  }

  ///公开信息
  Widget _publicInfo() {
    return Container(
      key: key12,
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
                ),
                if (index != 3 && index != 7 && index != 11)
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

  var jsonData = {
    "idCardName": "李建信",
    "gender": "男",
    "idCard": "512000197706131920",
    "pastExperience": [
      {"createTime": 220896000000, "title": "出生"},
      {"createTime": 441734400000, "title": "就读于乐至县大佛镇红鞍小学"},
      {"createTime": 631123200000, "title": "就读于四川新津中学"},
      {"createTime": 725817600000, "title": "就读于四川师范高中"},
      {"createTime": 820425600000, "title": "就读于北京大学"},
      {"createTime": 946656000000, "title": "就读于北京大学研究生"},
      {"createTime": 1104508800000, "title": "结婚"},
      {"createTime": 1147363200000, "title": "获得计算机一级证书"},
      {"createTime": 1172678400000, "title": "获得环保工程师资格证书"},
      {"createTime": 1333641600000, "title": "获得环境影响评价工程师资格证书"},
      {"createTime": 1430928000000, "title": "获得排水工程师资格证书"},
      {"createTime": 1546272000000, "title": "离婚"},
      {"createTime": 1563206400000, "title": "被列入失信被执行人名单，并对其采取限制高消费措施。"},
      {"createTime": 1599408000000, "title": "获得环境监测资格证书"},
      {"createTime": 0, "title": "目前仍就职于资阳市乐至县环保局。"}
    ],
    "workExperience": [
      {
        "socialSecurityBeginTime": 1059667200000,
        "name": "山东中兴汽车零件部有限公司",
        "beginTime": 1059667200000,
        "endTime": 0,
        "position": "局长",
        "time": "2003.08-至今",
        "socialSecurityEndTime": 0,
        "incomeEstimates": ""
      },
      {
        "socialSecurityBeginTime": 1059667200000,
        "name": "金凤汽车制造山东有限公司",
        "beginTime": 1059667200000,
        "endTime": 0,
        "position": "局长",
        "time": "2003.08-至今",
        "socialSecurityEndTime": 0,
        "incomeEstimates": ""
      }
    ],
    "educations": [
      {
        "name": "乐至县大佛镇红鞍小学",
        "beginTime": 462816000000,
        "diploma": "无",
        "educationalBackground": "小学",
        "endTime": 646761600000
      },
      {
        "name": "四川新津中学",
        "beginTime": 652118400000,
        "diploma": "无",
        "educationalBackground": "初中",
        "endTime": 741456000000
      },
      {
        "name": "四川师范高中",
        "beginTime": 746812800000,
        "diploma": "无",
        "educationalBackground": "高中",
        "endTime": 836150400000
      },
      {
        "name": "北京大学",
        "beginTime": 841507200000,
        "diploma": "本科学位证书",
        "educationalBackground": "本科",
        "endTime": 962380800000
      },
      {
        "name": "北京大学",
        "beginTime": 967737600000,
        "diploma": "硕士学位",
        "educationalBackground": "研究生",
        "endTime": 1056988800000
      }
    ],
    "reportType": 2,
    "id": "62a30ac920b42b6fed230d54",
    "riskWarning": [
      {"createTime": 0, "title": "您有一条劳动纠纷风险，注意查看"},
    ],
    "birthDay": 234979200000,
    "hometown": "四川省资阳市",
    "politicalStatus": "党员",
    "personalRiskInfos": [
      {
        "courtService": 0,
        "filing": 2,
        "judicial": 1,
        "taxViolation": 0,
        "finalCase": 0,
        "judgment": 1,
        "administrative": 1,
        "failure": 1,
        "marketSurveillance": 0,
        "executed": 0,
        "court": 1,
        "courtAnnouncement": 0
      }
    ],
    "currentAddress": "四川省资阳市雁江区东临小区10栋1单元3楼301号",
    "skillsCertificates": [
      {"code": "5603*****600", "createTime": 1147363200000, "name": "计算机一级证书"},
      {
        "code": "6953******00",
        "createTime": 1172678400000,
        "name": "环保工程师资格证书"
      },
      {
        "code": "11254******00",
        "createTime": 1333641600000,
        "name": "环境影响评价工程师资格证书"
      },
      {
        "code": "3692******00",
        "createTime": 1430928000000,
        "name": "排水工程师资格证书"
      },
      {"code": "1684******00", "createTime": 1599408000000, "name": "环境监测资格证书"}
    ],
    "marital": "未婚",
    "nationality": "汉族",
    "phone": "139****1183",
    "publicInformation": [
      {
        "publicCase":
            "四川省资阳市雁江区人民检察院以雁检公诉刑诉[2018]745号起诉书指控被告人樊丽娟犯危险驾驶罪，于2018年11月30日向本院提起公诉。本院于当日立案。",
        "punish": "暂无",
        "link": "",
        "type": 1
      },
      {
        "publicCase":
            "四川省资阳市雁江区人民检察院以雁检公诉刑诉[2022]7127号起诉书指控被告人樊丽娟犯盗窃罪，于2022年5月1日向本院提起公诉。本院于当日立案。",
        "punish": "暂无",
        "link": "",
        "type": 1
      },
      {
        "publicCase":
            "2018年12月28日公开开庭审理了本案。四川省资阳市雁江区人民检察院指派检察员吴文渊、马晨涛、书记员高子奡、石原出庭支持公诉，被告人樊丽娟及辩护人刘宗权到庭参加了诉讼。本案经合议庭评议、审判委员会讨论并作出决定。现已审理终结。",
        "punish": "暂无",
        "link": "",
        "type": 2
      },
      {
        "publicCase":
            "被告人樊丽娟醉酒后在道路上驾驶机动车，其行为已构成危险驾驶罪。公诉机关指控罪名成立，本院予以支持。樊丽娟到案后如实供述犯罪事实，可以从轻处罚。",
        "punish": "暂无",
        "link": "",
        "type": 3
      },
      {
        "publicCase": "经资阳市公安局物证鉴定所鉴定，樊丽娟血液中乙醇含量为169.25mg/100ml，樊丽娟犯危险驾驶罪。",
        "punish": "被告人樊丽娟犯危险驾驶罪，判处拘役二个月，缓刑三个月，并处罚金人民币三千元。",
        "link": "",
        "type": 4
      },
      {
        "publicCase":
            "樊某因选购花卉与店主发生纠纷拨打110报警，在处警民警处置现场警情时，借故提前离开事发现场。民警电话通知其返回现场接受调查，樊某因对民警电话中言语不满，先后六次通过拨打民警电话和发送短信的方式辱骂民警。民警报案后，雁江区公安分局受理该案，调查后认为樊某的行为构成阻碍人民警察依法执行职务。",
        "punish": "对樊某作出行政拘留5日的行政处罚。",
        "link": "",
        "type": 5
      },
      {
        "publicCase":
            "樊某与上海某融资租赁公司签订了《车辆融资租赁合同》，依照合同约定，该公司依据方某对车辆的需求出资93000元购置车辆一台，并将该车辆租赁给方某使用。同时，为确保方某及时足额支付租金，双方另签订了《车辆抵押合同》，约定其将租赁车辆抵押登记给上海某融资租赁公司，并办理抵押登记，为其在《车辆融资租赁合同》中的全部债务提供担保。随后，该公司便将租赁车辆交付给樊某，但樊某却未如约支付租金，经该公司多次向方某催收所欠租金均未果。2021年1月，该公司遂向临湘法院提起诉讼。经法院主持调解，双方达成调解协议，在2021年5月25日前，樊某按月分期支付上海某融资租赁公司车辆融资租金及违约金共计2万余元。协议生效后，樊某按期支付了1万余元租金后便没了下文，该公司遂向法院申请强制执行。",
        "punish":
            "执行人员又多次与方某进行沟通，想起悉心释法，并严肃告知其拒不履行法律义务应承担的后果，但方某仍拒不配合。执行法官将其纳入失信黑名单、限制高消费等强制措施。",
        "link": "",
        "type": 6
      },
      {"publicCase": "暂无", "punish": "暂无", "link": "", "type": 7},
      {"publicCase": "暂无", "punish": "暂无", "link": "", "type": 8},
      {"publicCase": "暂无", "punish": "暂无", "link": "", "type": 9},
      {"publicCase": "暂无", "punish": "暂无", "link": "", "type": 10},
      {"publicCase": "暂无", "punish": "暂无", "link": "", "type": 11},
      {"publicCase": "暂无", "punish": "暂无", "link": "", "type": 12}
    ]
  };

  // 初始化数据
  void _initData() async {
    var data = ReportDetailsBean.fromJson(jsonData);
    reportDetailsBean = data;
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
      if (risk.createTime > 0) {
        var createTime = DateTime.fromMillisecondsSinceEpoch(risk.createTime);
        riskAlertData +=
            "${WidgetTools().timeFormat(createTime, ".")} ${risk.title}\n";
      } else {
        riskAlertData += "${risk.title}\n";
      }
    }
    riskAlert = riskAlertData.trimRight();
    personalRiskInfo = data.personalRiskInfos[0];
    setState(() {});
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
