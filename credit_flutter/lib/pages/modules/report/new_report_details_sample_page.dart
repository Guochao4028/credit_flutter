import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/login_manager.dart';
import 'package:credit_flutter/manager/pay_manager.dart';
import 'package:credit_flutter/manager/report_details_sample_manager.dart';
import 'package:credit_flutter/models/report_data_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/route/watermark.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/report_widget_tool.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/views/back_to_top.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../models/professional_certificate_bean.dart';

/// @Description: 芝麻数据-样例报告详情页
class NewReportDetailsSamplePage extends StatefulWidget {
  int type = 1;

  NewReportDetailsSamplePage({Key? key, this.type = 1}) : super(key: key);

  @override
  State<NewReportDetailsSamplePage> createState() =>
      _NewReportDetailsSamplePageState();
}

class _NewReportDetailsSamplePageState
    extends State<NewReportDetailsSamplePage> {
  //名称
  String name = "张*";

  //报告创建时间
  String createTime = "委托日期：2023-2-20";

  //授权完成时间（时间 戳）
  String completeTime = "交付日期：2023-2-20";

  //性别
  String gender = "女";

  //报告编号
  String reportId = "报告编号: 4202307010067391739";

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

  final ScrollController _controller = ScrollController();

  // bool showBtn = false;

  DateTime? startTime;

  /// 记录   学历区域 位置
  final GlobalKey _educationAreaKey = GlobalKey();

  /// 记录   专业证书 位置
  final GlobalKey _proCerKey = GlobalKey();

  /// 记录   工商信息 位置
  final GlobalKey _comInfoKey = GlobalKey();

  /// 记录   司法风险 位置
  final GlobalKey _juRiskKey = GlobalKey();

  /// 记录   社会不良记录 位置
  final GlobalKey _badRecordKey = GlobalKey();

  /// 记录   金融风险 位置
  final GlobalKey _finRiskKey = GlobalKey();

  /// 记录   学历区域标题 位置
  final GlobalKey _educationAreaTitleKey = GlobalKey();

  /// 记录   专业证书标题 位置
  final GlobalKey _proCerTitleKey = GlobalKey();

  /// 记录   工商信息标题 位置
  final GlobalKey _comInfoTitleKey = GlobalKey();

  /// 记录   司法风险标题 位置
  final GlobalKey _juRiskTitleKey = GlobalKey();

  // /// 记录   社会不良记录标题 位置
  final GlobalKey _badRecordTitleKey = GlobalKey();

  /// 记录   金融风险标题 位置
  final GlobalKey _finRiskTitleKey = GlobalKey();

  final GlobalKey _ZTHZTitleKey = GlobalKey();

  double zthzY = 0;

  ///记录所有组件y坐标
  List<double> _allLocationUIY = [];

  /// 保存所有key
  List<GlobalKey> _titleKeys = [];

  /// 记录当前滚动的是那个组件
  int _location = -1;

  /// 记录控件变化的时间节点
  List<DateTime> _changeTiming = [];

  /// 记录控件变化的位置
  List<int> _changeLoction = [];
  List<String> _changeLoctionStr = [];

  @override
  void initState() {
    //初始化主页面
    super.initState();

    Future.delayed(const Duration(milliseconds: 50), () {
      shuiyin = true;
      _initData();
    });

    UmengCommonSdk.onPageStart("report_sample_page");
    startTime = DateTime.now();

    var box = Hive.box(HiveBoxs.dataBox);
    bool firstOpen = box.get(FinalKeys.FIRST_OPEN_REPORT_SAMPLE) ?? false;
    if (!firstOpen) {
      box.put(FinalKeys.FIRST_OPEN_REPORT_SAMPLE, true);
    }
  }

  @override
  void dispose() {
    UmengCommonSdk.onPageEnd("report_sample_page");
    UmengCommonSdk.onEvent("ReportDetailsSampleStay",
        {"time": "${differenceTime(startTime!, DateTime.now())}"});

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      int index = _getListFindCloseY(_controller.offset);
      if (index != _location) {
        int ms = 0;
        _changeTiming.add(DateTime.now());
        if (_changeTiming.length == 1) {
          /// 计算时间 返回的是毫秒
          ms = differenceTime(startTime!, DateTime.now(), type: 1);
        } else {
          /// 当前位置
          int curr = _changeTiming.length - 1;

          /// 当前位置的上一个位置
          int last = _changeTiming.length - 2;
          ms =
              differenceTime(_changeTiming[last], _changeTiming[curr], type: 1);
        }

        String a = _location.toString();
        String b = index.toString();
        _changeLoctionStr.add(a + " -> " + b);
        _changeLoction.add(_location);
        _location = index;
        String locationName = "";
        switch (_location) {
          case 0:
            {
              locationName = "金融风险";
            }
            break;
          case 1:
            {
              locationName = "社会不良记录";
            }
            break;
          case 2:
            {
              locationName = "司法诉讼";
            }
            break;
          case 3:
            {
              locationName = "工商信息";
            }
            break;
          case 4:
            {
              locationName = "资格证书";
            }
            break;
          case 5:
            {
              locationName = "学历信息";
            }
            break;
          default:
            {
              locationName = "heard 位置";
            }
        }
        UmengCommonSdk.onEvent(
          "ReportDetailsSampleBlcok",
          {
            "instructions": "$locationName 区域停留 $ms 毫秒",
            "locationName": locationName,
            "stopTime": ms,
          },
        );
      }
    });

    Future.delayed(Duration(milliseconds: 500), () {
      print("延迟500毫秒后输出");
      _allLocationUIY = [];
      _allLocationUIY.add(_getWidgetPositionByGlobalKey(_finRiskKey));
      _allLocationUIY.add(_getWidgetPositionByGlobalKey(_badRecordKey));
      _allLocationUIY.add(_getWidgetPositionByGlobalKey(_juRiskKey));
      _allLocationUIY.add(_getWidgetPositionByGlobalKey(_comInfoKey));
      _allLocationUIY.add(_getWidgetPositionByGlobalKey(_proCerKey));
      _allLocationUIY.add(_getWidgetPositionByGlobalKey(_educationAreaKey));
      _titleKeys = [];
      _titleKeys.add(_finRiskTitleKey);
      _titleKeys.add(_badRecordTitleKey);
      _titleKeys.add(_juRiskTitleKey);
      _titleKeys.add(_comInfoTitleKey);
      _titleKeys.add(_proCerTitleKey);
      _titleKeys.add(_educationAreaTitleKey);
    });

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Scaffold(
            appBar: _appBar(),
            backgroundColor: CustomColors.colorF1F4F9,
            body: NotificationListener<ScrollNotification>(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      children: [
                        _head(),
                        //基本信息
                        _essentialInfo(),
                        //阅读说明
                        _readInstructions(),
                        //整体汇总
                        _overallSummary(),
                        if (shuiyin) _residue(),
                      ],
                    ),
                  ),
                  BackToTop(
                    _controller,
                    bottom: 150,
                    offsetTop: 970 + 100,
                    interval: 100,
                    isAuto: true,
                  ),
                ],
              ),
              onNotification: (scrollNotification) {
                ScrollMetrics metrics = scrollNotification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent) {
                  UmengCommonSdk.onEvent("sample_slide_to_the_bottom", {
                    "time": "${differenceTime(startTime!, DateTime.now())}"
                  });
                }
                if (scrollNotification is ScrollStartNotification) {
                  _onStartScroll(scrollNotification.metrics);
                } else if (scrollNotification is ScrollEndNotification) {
                  _onEndScroll(scrollNotification.metrics);
                }
                return true;
              },
            )),
        if (shuiyin)
          const IgnorePointer(
            //忽略自定义水印的点击事件
            child: Watermark(rowCount: 4, columnCount: 8, text: "慧眼查"),
          ),
        if (widget.type != 1)
          Container(
            margin: const EdgeInsets.all(32),
            height: 45,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: CustomColors.connectColor,
              borderRadius: BorderRadius.all(Radius.circular(22.5)),
            ),
            child: InkWell(
              onTap: () {
                UmengCommonSdk.onEvent("click_report", {"type": "count"});
                // Golbal.isSample = true;
                _loginOut(LoginType.personal);
              },
              child: const Center(
                child: Text(
                  "查看我的报告",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
              const Text(
                "中国科技某某有限公司",
                style: TextStyle(
                  fontSize: 18,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
                reportId,
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

          _displayType(0),
        ],
      ),
    );

    // Container surname = Container(
    //   margin: const EdgeInsets.only(left: 32, top: 16),
    //   height: 70,
    //   width: 70,
    //   decoration: const BoxDecoration(
    //     gradient: LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [
    //         Color(0xFF5FB6F9),
    //         Color(0xFF317FF1),
    //       ],
    //     ),
    //     borderRadius: BorderRadius.all(Radius.circular(4)),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Text(
    //         name.isNotEmpty ? name.substring(0, 1) : "",
    //         style: const TextStyle(
    //           fontSize: 40,
    //           color: Colors.white,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       )
    //     ],
    //   ),
    // );
    // return Stack(
    //   children: [
    //     Container(
    //       color: CustomColors.color3B8FF9,
    //       height: 149,
    //     ),
    //     Container(
    //       width: double.infinity,
    //       margin: const EdgeInsets.only(left: 16, top: 30, right: 16),
    //       padding:
    //       const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
    //       decoration: const BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(3), topRight: Radius.circular(3))),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             margin: const EdgeInsets.only(left: 84),
    //             child: Text(
    //               hideInfo(1, name),
    //               style: const TextStyle(
    //                 fontSize: 16,
    //                 color: CustomColors.greyBlack,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             margin: const EdgeInsets.only(left: 84, top: 5),
    //             child: Text(
    //               createTime,
    //               style: const TextStyle(
    //                 fontSize: 12,
    //                 color: CustomColors.darkGrey,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 8,
    //           ),
    //           _addInfoText("性别：${hideInfo(2, gender)}"),
    //           _addInfoText("手机号：${hideInfo(2, phoneNumber)}"),
    //           _addInfoText("年龄：${hideInfo(2, age)}"),
    //           _addInfoText("出生日期：${hideInfo(2, birthday)}"),
    //           _addInfoText("身份证号：${hideInfo(2, identityNumber)}"),
    //           _addInfoText("户籍所在地：${hideInfo(2, domicile)}"),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           const Row(
    //             children: [
    //               Image(
    //                 width: 15,
    //                 height: 15,
    //                 image: AssetImage("assets/images/icon_red_sigh.png"),
    //               ),
    //               SizedBox(
    //                 width: 8,
    //               ),
    //               Text(
    //                 "重要说明",
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   color: CustomColors.greyBlack,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(
    //             height: 6,
    //           ),
    //           const Text(
    //             "重要说明：受客户委托，本报告由慧眼查提供。在被核实目标知悉且同意授权的情况下，就授权项目进行调查核实，所有信息均通过合法途径获得。慧眼查竭力确保其提供的数据准确可靠，但不保证所提供的数据绝对正确可靠；对于任何因资料不准确遗漏或因根据、依赖本报告资料所做决定、行动或不行动，以及收集与传递过程中的偏差而导致的损失或损害，慧眼查概不负责（不论是民事侵权行为责任或合约责任或其它）。版权由慧眼查全权拥有。",
    //             style: TextStyle(
    //               fontSize: 14,
    //               color: CustomColors.darkGrey,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     surname,
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         Container(
    //           margin: const EdgeInsets.only(top: 50, right: 34),
    //           child: InkWell(
    //             onTap: () {
    //               ifVisible = !ifVisible;
    //               setState(() {});
    //             },
    //             child: Image(
    //               image: AssetImage(
    //                   "assets/images/${ifVisible ? "icon_open_eyes" : "icon_close_eyes"}.png"),
    //               height: 20,
    //               width: 24,
    //             ),
    //           ),
    //         ),
    //       ],
    //     )
    //   ],
    // );
  }

  Widget _addInfoText(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 15,
          color: CustomColors.greyBlack,
        ),
      ),
    );
  }

  Widget _readInstructions() {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
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
          // Row(
          //   children: [
          //     _JudgeRisk(2),
          //     const SizedBox(
          //       width: 6,
          //     ),
          //     const Text(
          //       "查得相关记录，建议关注！",
          //       style: TextStyle(
          //         fontSize: 13,
          //         color: CustomColors.greyBlack,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 6),
          // Row(
          //   children: [
          //     _JudgeRisk(3),
          //     const SizedBox(
          //       width: 6,
          //     ),
          //     const Text(
          //       "查得相关记录，建议关注！",
          //       style: TextStyle(
          //         fontSize: 13,
          //         color: CustomColors.greyBlack,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 6),
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
    //[0, 1, 2, 3, 4, 5]
    List data = List.from([5, 4, 3, 2, 1, 0]);

    int allHorizontalPadding = 0;
    int columnCount = 3;
    double cellWidth =
        ((MediaQuery.of(context).size.width - allHorizontalPadding) /
            columnCount);
    double desiredCellHeight = 65;
    double childAspectRatio = cellWidth / desiredCellHeight;

    return Container(
      key: _ZTHZTitleKey,
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
          Container(
            width: double.infinity,
            height: 46,
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "点击跳转至对应区域",
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.lightGrey,
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

  Widget _addTitle(String name, GlobalKey key) {
    return Container(
      key: key,
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
      key: _educationAreaKey,
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
      key: _proCerKey,
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
              "说明：通过候选人提交的电子驾照信息核实",
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
      key: _comInfoKey,
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
      key: _juRiskKey,
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
          //_limitedLitigationRecord(),
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
      key: _badRecordKey,
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
          // Column(
          //   children: [
          //     const Row(
          //       children: [
          //         Text(
          //           "道德不良风险",
          //           style: TextStyle(
          //             color: CustomColors.greyBlack,
          //             fontSize: 14,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         SizedBox(
          //           width: 8,
          //         ),
          //         Expanded(
          //           child: DottedLine(
          //             direction: Axis.horizontal,
          //             lineLength: double.infinity,
          //             lineThickness: 0.8,
          //             dashLength: 1.0,
          //             dashColor: Color(0xFF99C6FF),
          //             dashGapLength: 1.0,
          //           ),
          //         ),
          //         SizedBox(
          //           width: 8,
          //         ),
          //         // moralHazard
          //         // _JudgeRisk(badSocialInfoType == "0" ? 4 : 1),
          //       ],
          //     ),
          //     const SizedBox(
          //       height: 2,
          //     ),
          //     Row(
          //       children: [
          //         const Text(
          //           "道德分：",
          //           style: TextStyle(
          //             color: CustomColors.greyBlack,
          //             fontSize: 14,
          //           ),
          //         ),
          //         Text(
          //           "$moralHazard分",
          //           style: const TextStyle(
          //             color: CustomColors.greyBlack,
          //             fontSize: 14,
          //           ),
          //         ),
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
          //         "说明：通过行业用户道德风险数据库核实（偷*、*访、*逃、吸*、涉*、购买管制*具记录）",
          //         style: TextStyle(
          //           color: CustomColors.darkGrey,
          //           fontSize: 10,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // Column(
          //   children: [
          //     Row(
          //       children: [
          //         const Text(
          //           "税务不良记录",
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
          //         _JudgeRisk(badTaxRecord > 0 ? 1 : 4),
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
          //         "说明：通过各级税务平台披露的违法数据库核实",
          //         style: TextStyle(
          //           color: CustomColors.darkGrey,
          //           fontSize: 10,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
      key: _finRiskKey,
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
                    "网贷黑名单查询",
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
                  "说明：未知情的情况下被冒名申请网贷查询，各类网络贷款黑名单查询。包括：乐*花、**享借、易*购、**借钱、*借款、**钱包、快*花、*借等100+网络贷款公司（持续更新）。",
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 10,
                  ),
                ),
              ),
              Row(
                children: [
                  const Text(
                    "网贷逾期查询",
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
                  "说明：是否存在各类网络贷款逾期查询",
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
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _displayType(1),
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
                  child: GestureDetector(
                    onTap: () {
                      _tapScrollable(index);
                    },
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

      //创建时间（时间戳）
      var time =
          DateTime.fromMillisecondsSinceEpoch(data.reportInfo.createTime);
      createTime = "委托日期：${time.year}-${time.month}-${time.day}";

      //授权完成时间（时间 戳） completeTime
      var complete =
          DateTime.fromMillisecondsSinceEpoch(data.reportInfo.completeTime);
      completeTime = "交付日期：${complete.year}-${complete.month}-${complete.day}";

      //报告编号
      reportId = "报告编号:${data.creditReportDigest.reportId}";
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
        professionalCertificateList.add(
            ProfessionalCertificateBean("驾驶证", content, "说明：通过候选人提交的电子驾照信息核实"));
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

  Widget _residue() {
    var c = Column(
      children: [
        //金融风险
        _addTitle("金融风险", _finRiskTitleKey),
        _financialRisk(),

        // //社会不良记录
        _addTitle("社会不良记录", _badRecordTitleKey),
        _badSocialRecord(),

        //司法风险
        _addTitle("司法诉讼", _juRiskTitleKey),
        _judicialRisk(),

        //工商信息
        _addTitle("工商信息", _comInfoTitleKey),
        _businessInfo(),

        //专业证书
        _addTitle("专业证书", _proCerTitleKey),
        _professionalCertificate(),

        //社会经历
        _addTitle("学历信息", _educationAreaTitleKey),
        _academicInfo(),
        //个人数据使用说明
        _explain(),
      ],
    );

    return c;
  }

  AppBar? _appBar() {
    if (widget.type == 1) {
      return AppBar(
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
      );
    } else {
      return AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.color3B8FF9,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "报告样例详情",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  _onStartScroll(ScrollMetrics metrics) {
    UmengCommonSdk.onEvent("ReportDetailsSampleScrollStart",
        {"state": "ScrollStart", "time": "scrollStart ->  ${DateTime.now()}"});
  }

  _onEndScroll(ScrollMetrics metrics) {
    UmengCommonSdk.onEvent("ReportDetailsSampleScrollEnd",
        {"state": "ScrollEnd", "time": "ScrollEnd ->  ${DateTime.now()}"});
  }

  int differenceTime(DateTime stsrt, DateTime end, {int type = 0}) {
    if (type == 1) {
      return end.difference(stsrt).inMilliseconds;
    }
    return end.difference(stsrt).inSeconds;
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

  Widget _importantNote() {
    return const Column(
      children: [
        Row(
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
        SizedBox(
          height: 6,
        ),
        Text(
          "重要说明：受客户委托，本报告由慧眼查提供。在被核实目标知悉且同意授权的情况下，就授权项目进行调查核实，所有信息均通过合法途径获得。慧眼查竭力确保其提供的数据准确可靠，但不保证所提供的数据绝对正确可靠；对于任何因资料不准确遗漏或因根据、依赖本报告资料所做决定、行动或不行动，以及收集与传递过程中的偏差而导致的损失或损害，慧眼查概不负责（不论是民事侵权行为责任或合约责任或其它）。版权由慧眼查全权拥有。调查结果仅供参考，如有异议，以官方证明文件为准。",
          style: TextStyle(
            fontSize: 14,
            color: CustomColors.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _agreement() {
    return Column(
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
    );
  }

  Widget _displayType(int position) {
    if (Golbal.reportOrder == 0) {
      return position == 0 ? _importantNote() : _agreement();
    } else {
      return position == 0 ? _agreement() : _importantNote();
    }
  }

  double _getWidgetPositionByGlobalKey(GlobalKey key) {
    RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    Offset position = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    // return position;
    Size size = renderBox?.size ?? const Size(0, 0);

    /// 所有标题 位置
    double a = position.dy - 100;
    double b = ScreenTool.screenHeight / 3;
    return a - b;
  }

  int _getListFindCloseY(double offsetY) {
    int index = -1;
    for (int i = 0; i < _allLocationUIY.length; i++) {
      if (i + 1 == _allLocationUIY.length) {
        index = -1;
        break;
      }
      if (offsetY >= _allLocationUIY[i] && offsetY < _allLocationUIY[i + 1]) {
        index = i;
        break;
      }
    }

    return index;
  }

  /// *
  /// -  @description: 点击 分类 滚动跳转
  /// -  @Date: 2023-08-29 16:55
  /// -  @parm:  点击的位置
  /// -  @return {*}
  ///
  void _tapScrollable(int index) {
    int location = (5 - index).abs();
    GlobalKey key = _titleKeys[location];
    Scrollable.ensureVisible(key.currentContext as BuildContext);
  }

  void _loginOut(LoginType type) {
    var box = Hive.box(HiveBoxs.dataBox);
    box.put(FinalKeys.Quick_STANDING, 1);

    String jsonStr = Golbal.token;
    if (jsonStr.isEmpty) {
      /// 调用未登录支付
      _loginOutPayment({});
    }

    // SharedPreferences.getInstance().then((value) {
    //   String loginType = "2";
    //   int requestUserType = 2;
    //   value.setString(FinalKeys.LOGIN_TYPE, loginType);
    //   value.setInt(FinalKeys.LOGIN_USER_TYPE, requestUserType);
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) {
    //       // return LoginPage(type: type);
    //       return LoginNewPage(type: type);
    //     }),
    //   );
    // });
  }

  void _loginOutPayment(Map<String, dynamic> map) {
    /// 1. 先判断是否存在临时身份
    /// 有临时身份沿用临时身份的token
    /// 没有临时身份分配临时身份
    UserModel.getTempUserInfo((model) {
      if (model != null) {
        ///个人
        _goBuy();
      } else {
        LoginManager.userGuestLogin((message) {
          ///个人
          _goBuy();
        });
      }
    });
  }

  void _goBuy() {
    //完整版
    PayManager.getReportPrice(1, (price) {
      PayCheakstandPage page = PayCheakstandPage(
        displayType: PaymentListDisplayType.paymentListOnlyOtherDisplay,
        fromType: PaymentFromType.paymentFromQuickBuyPersonType,
        price: price,
        reportType: 1,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    });
  }
}
