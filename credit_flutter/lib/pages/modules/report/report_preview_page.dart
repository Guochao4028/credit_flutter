/// *
/// -  @Date: 2023-10-23 13:46
/// -  @LastEditTime: 2023-10-23 13:46
/// -  @Description: 报告预览
///

// ignore_for_file: must_be_immutable

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/pages/modules/pay/pay_payment/pay_checkstand_page.dart';
import 'package:credit_flutter/route/watermark.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportPreviewPage extends StatefulWidget {
  PaymentListDisplayType displayType;
  PaymentFromType fromType;

  ///价格
  final String price;

  ///主要放 身份证 姓名 手机号
  Map<String, dynamic> packet = {};

  ///报告类型
  int? reportType;

  ///价格
  final String yearPrice;

  ReportPreviewPage(
      {required this.fromType,
      required this.displayType,
      required this.price,
      this.reportType,
      this.yearPrice = "0",
      super.key});

  @override
  State<ReportPreviewPage> createState() => _ReportPreviewPageState();
}

class _ReportPreviewPageState extends State<ReportPreviewPage>
    implements ReportPreviewClickListener {
  String name = "";
  String idCard = "";

  @override
  void initState() {
    name = widget.packet["idCardName"];
    if (name.isEmpty) {
      name = "***";
    }
    idCard = widget.packet["idCard"];
    if (idCard.isEmpty) {
      idCard = "******************";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    children: [
                      ReportPreviewHead(
                        name: name,
                      ),
                      //基本信息
                      ReportPreviewEssentialInfo(
                        name: name,
                        identityNumber: idCard,
                      ),
                      // //背调概述
                      ReportPreviewSummarize(
                        listener: this,
                      ),

                      /// 待解锁项
                      ReportPreviewUnlocked(
                        listener: this,
                        price: widget.price,
                      ),

                      ///底部偏移
                      const SizedBox(
                        height: 180,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const IgnorePointer(
          //忽略自定义水印的点击事件
          child: Watermark(rowCount: 4, columnCount: 8, text: "慧眼查"),
        ),
        _bottomView(),
      ],
    );
  }

  /// *
  /// -  @description: 导航栏
  /// -  @Date: 2023-10-23 14:48
  ///
  AppBar _appBar() {
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
  }

  /// *
  /// -  @description: 底部view展示 立即解锁按钮， 说明
  /// -  @Date: 2023-10-23 14:46
  Widget _bottomView() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 70,
            width: 300,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: CustomColors.colorF7DBDB,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "解锁全部背调内容",
                    style: _bottomUnlockTextStyle(18),
                  ),
                  TextSpan(
                    text: "31",
                    style: _bottomUnlockTextStyle(24),
                  ),
                  TextSpan(
                    text: "项",
                    style: _bottomUnlockTextStyle(18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 34,
          ),
          WidgetTools().createCustomInkWellButton(
              "立即解锁￥${widget.price}", () => _payment(),
              buttonWidth: ScreenTool.screenWidth - 64,
              bgColor: CustomColors.connectColor,
              textColor: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              radius: 5),
        ],
      ),
    );
  }

  /// *
  /// -  @description:底部view 说明字体样式固定，可以修改字号
  /// -  @Date: 2023-10-23 14:47
  /// -  @parm: fontSize 字号
  TextStyle _bottomUnlockTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: CustomColors.colorRed171,
    );
  }

  @override
  void tapUnlock() {
    _payment();
  }

  void _payment() {
    PayCheakstandPage page = PayCheakstandPage(
      displayType: widget.displayType,
      fromType: widget.fromType,
      price: widget.price,
      reportType: 2,
      yearPrice: widget.yearPrice,
    );
    page.packet = widget.packet;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}

/// *
/// -  @description: 报告 表头
/// -  @Date: 2023-10-23 16:16
/// -  @parm: 被调查人姓名
///
class ReportPreviewHead extends StatelessWidget {
  String name;

  //报告编号
  String reportId = "报告编号: ********************";

  ReportPreviewHead({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    var time = DateTime.now();
    String createTime = "委托日期：${time.year}-${time.month}-${time.day}";
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
              // const Text(
              //   "中国科技某某有限公司",
              //   style: TextStyle(
              //     fontSize: 18,
              //     color: CustomColors.greyBlack,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 10),
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

  String hideInfo(int type, String content) {
    var data = "";
    if (type == 1) {
      //名字
      data = StringTools.hiddenInfoString(content);
    } else {
      data = "*" * content.length;
    }
    return data;
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
}

/// *
/// -  @description: 基础信息
/// -  @Date: 2023-10-23 16:17
/// -  @parm: 被调查人姓名， 被调查人身份证
///
class ReportPreviewEssentialInfo extends StatefulWidget {
  String name;
  String identityNumber;

  ReportPreviewEssentialInfo(
      {required this.name, required this.identityNumber, super.key});

  @override
  State<ReportPreviewEssentialInfo> createState() =>
      _ReportPreviewEssentialInfoState();
}

class _ReportPreviewEssentialInfoState
    extends State<ReportPreviewEssentialInfo> {
  var ifVisible = true;
  String name = "";
  String gender = "";
  String age = "";
  String createTime = "";
  String completeTime = "";
  String birthday = "";
  String identityNumber = "";
  String domicile = "";

  @override
  void initState() {
    super.initState();
    name = widget.name;
    String carId = widget.identityNumber;
    if (carId != "******************") {
      identityNumber = StringTools.hiddenInfoString(carId, type: 1);
      gender = StringTools.getSexFromCardId(carId);
      birthday = StringTools.getBirthdayFromCardId(carId);
      domicile = "${StringTools.getDistrictFromCardId(carId)}********";
      age = StringTools.getAgeFromCardId(carId);
    } else {
      identityNumber = widget.identityNumber;
      gender = "*";
      birthday = "****-**-**";
      domicile = "********";
      age = '**';
    }
  }

  @override
  Widget build(BuildContext context) {
    return _essentialInfo();
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
                  "基础信息",
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
          fontSize: 15,
          color: CustomColors.greyBlack,
        ),
      ),
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
}

/// *
/// -  @description: 背调概述
/// -  @Date: 2023-10-23 16:18
///
class ReportPreviewSummarize extends StatelessWidget {
  ReportPreviewClickListener? listener;

  ReportPreviewSummarize({super.key, this.listener});

  @override
  Widget build(BuildContext context) {
    List data = List.from([0, 1, 2, 3, 4, 5]);

    int allHorizontalPadding = 0;
    int columnCount = 3;
    double cellWidth =
        ((MediaQuery.of(context).size.width - allHorizontalPadding) /
            columnCount);
    double desiredCellHeight = 100;
    double childAspectRatio = cellWidth / desiredCellHeight;
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
                  "背调概述",
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.greyBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          _finalReportView(),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "更多背调内容，解锁完整版背调信息",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GridView.count(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: childAspectRatio,
            children: data.map((index) => _itemRisk(index)).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              listener?.tapUnlock();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/images/guodu3.png"),
                  fit: BoxFit.fill, // 完全填充
                ),
              ),
              child: const Text(
                "立即解锁完整背调报告",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// *
  /// -  @description: 总结 色块 统计
  /// -  @Date: 2023-10-23 18:10
  /// -  @return {*}
  ///
  Widget _finalReportView() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/guodu1.png"),
                fit: BoxFit.fill, // 完全填充
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    "assets/images/svg/dun.svg",
                    fit: BoxFit.fill,
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "6",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "共查询项",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/guodu2.png"),
                fit: BoxFit.fill, // 完全填充
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    "assets/images/svg/fxts.svg",
                    fit: BoxFit.fill,
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "背调异常项",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
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
        assetImage = const AssetImage("assets/images/icon_education_info.png");
        break;
      case 1:
        name = "资格证书";
        assetImage = const AssetImage("assets/images/icon_qualification.png");
        break;
      case 2:
        name = "工商信息";
        assetImage = const AssetImage("assets/images/icon_business_info.png");
        break;
      case 3:
        name = "司法风险";
        assetImage = const AssetImage("assets/images/icon_judicial_risk.png");
        break;
      case 4:
        name = "社会不良";
        assetImage = const AssetImage("assets/images/icon_social_badness.png");
        break;
      case 5:
        name = "金融风险";

        assetImage = const AssetImage("assets/images/icon_financial_risk.png");
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
                              width: 25,
                              height: 25,
                              image: assetImage,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
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
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportPreviewUnlocked extends StatelessWidget {
  ReportPreviewClickListener? listener;
  String price;

  ReportPreviewUnlocked({super.key, this.listener, required this.price});

  @override
  Widget build(BuildContext context) {
    List info = [
      {"title": "社会不良信息查询", "opacity": 0.0},
      {"title": "社会不良风险评分", "opacity": 0.0},
      {"title": "网贷黑名单查询", "opacity": 0.0},
      {"title": "网贷逾期查询", "opacity": 0.0},
      {"title": "税务不良记录", "opacity": 0.0},
      {"title": "违禁药品风险", "opacity": 0.0},
      {"title": "开庭公告记录", "opacity": 0.0},
      {"title": "刑事案件记录", "opacity": 0.0},
      {"title": "个人涉诉记录", "opacity": 0.0},
      {"title": "民事案件记录", "opacity": 0.2},
      {"title": "行政案件记录", "opacity": 0.4},
      {"title": "非诉保全审查", "opacity": 0.6},
      {"title": "执行案件", "opacity": 0.8},
    ];
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
          const SizedBox(
            height: 8,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "还有31项背调内容待解锁",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 600,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _listViewItem(info[index]);
              },
              itemCount: info.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          WidgetTools().createCustomInkWellButton("立即解锁￥${price}", () {
            listener?.tapUnlock();
          },
              buttonWidth: ScreenTool.screenWidth - 64,
              bgColor: CustomColors.connectColor,
              textColor: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              radius: 5),
        ],
      ),
    );
  }

  Widget _listViewItem(Map map) {
    String title = map["title"];
    double opacity = map["opacity"];
    int a = (255 * opacity).toInt();
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: CustomColors.darkGrey99,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
        ),
        Container(
          height: 45,
          color: Color.fromARGB(a, 255, 255, 255),
        )
      ],
    );
  }
}

abstract class ReportPreviewClickListener {
  void tapUnlock();
}
