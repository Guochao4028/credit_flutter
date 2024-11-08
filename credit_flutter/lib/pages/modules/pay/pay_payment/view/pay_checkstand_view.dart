/// *
/// -  @Date: 2022-07-12 11:03
/// -  @LastEditTime: 2022-07-12 15:22
/// -  @Description:
///
/// *
/// -  @Date: 2022-07-12 11:03
/// -  @LastEditTime: 2022-07-12 11:06
/// -  @Description: 处理收银台view
///
import 'dart:math';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_enums.dart';
import 'package:credit_flutter/models/report_details_bean.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dotted_line/dotted_line.dart';

class PayCheakstandView {
  ///价格
  String price = "";
  String balanceStr = "";

  String formatPrice = "";

  PayCheakstandViewClickListener? clickListener;
  bool _isVip = false;
  bool _isViewVip = false;
  String _originalPrice = "";

  bool _isRechange = true;

  ///支付方式
  List<Map<String, dynamic>> paymentMethods = [];

  /// 购买报告类型
  List<Map<String, dynamic>> reportBuyTypes = [];

  /// 是否显示购买类型
  bool isViewBuyType = false;

  PayCheakstandView(
      {required this.price,
      required this.paymentMethods,
      required this.balanceStr,
      required this.reportBuyTypes,
      required this.isViewBuyType,
      Key? key});

  Widget cheakstabContentView(bool isVip, String originalPrice, bool isViewVip,
      bool isRechange, PaymentFromType fromType) {
    _isVip = isVip;
    _isViewVip = isViewVip;
    _originalPrice = originalPrice;
    _isRechange = isRechange;
    formatPrice = StringTools.numberFormat(price, true);

    List<Widget> children = [];
    switch (fromType) {
      case PaymentFromType.paymentFromCheckYourselfForFiveYuan:

        /// 购买5元报告
        children.add(_firstPurchase5YuanReport());
        break;
      case PaymentFromType.paymentFrom5yuanReportUpgradeType:

        /// 购买5元报告后再次购买
        children.add(_purchase5yuanReportUpgrade());
        break;
      default:
        if (isViewBuyType == true) {
          /// 选择购买类型(单次购买，订阅)
          children.add(_selectPaymentType(reportBuyTypes));
        } else {
          ///报告原价
          children.add(_originalPriceView());

          ///价格
          children.add(_priceView());
        }
    }

    ///支付方式 ->标题
    children.add(_titleView());

    ///支付方式 -> 列表
    children.add(_contentListView(paymentMethods));
    if (fromType != PaymentFromType.paymentFromQuickBuyType &&
        fromType != PaymentFromType.paymentFromQuickBuyPersonType) {
      ///vip文案
      children.add(_copywriting());
    }

    ///支付按钮
    children.add(_payButtonView());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _firstPurchase5YuanReport() {
    return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
        height: 280,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 标题
            const SizedBox(
              // padding: const EdgeInsets.only(left: 16),
              height: 22,
              child: Text(
                "本次购买内容:",
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.colorE6000,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Image(
                      image:
                          AssetImage("assets/images/icon_financial_risk.png"),
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
                    child: const Text(
                      "说明：未知情的情况下被冒名申请网贷查询，各类网络贷款黑名单查询。包括：乐*花、**享借、易*购、**借钱、*借款、**钱包、快*花、*借等100+网络贷款公司。",
                      style: TextStyle(
                        color: CustomColors.darkGrey,
                        fontSize: 10,
                      ),
                    ),
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
              ],
            ),
          ],
        ));
  }

  Widget _getGridView(List<String> list) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 160 / 20,
        crossAxisCount: 2,
        //水平单个子Widget之间间距
        mainAxisSpacing: 5,
        //垂直单个子Widget之间间距
        crossAxisSpacing: 0,
      ),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return _showGridViewItem(
          list[index],
        );
      },
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _showGridViewItem(String gridTitle) {
    return SizedBox(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "●",
            style: TextStyle(fontSize: 5),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(gridTitle),
        ],
      ),
    );
  }

  Widget _iconTitie(String titleStr, String iconStr) {
    return Container(
        color: Colors.white,
        height: 22,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            SizedBox(
              height: 18,
              width: 22,
              child: Image(
                image: AssetImage(iconStr),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              titleStr,
              style: const TextStyle(
                  fontSize: 17,
                  color: CustomColors.colorE6000,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget _purchase5yuanReportUpgrade() {
    List<String> info = [
      "学历信息",
      "工商信息",
      "道德风险",
      "司法风险",
      "金融风险",
      "失信被执行人",
      "裁判文书信息",
      "限制消费人员",
    ];
    return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(top: 15),
        height: 230,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 标题
            Container(
              padding: const EdgeInsets.only(left: 16),
              height: 20,
              child: const Text(
                "解锁完成报告:",
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.colorE6000,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              height: 190,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _listViewItem(info[index]);
                },
                itemCount: info.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ));
  }

  Widget _listViewItem(String rowTitleStr) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          const SizedBox(
            width: 12,
          ),
          Text(
            rowTitleStr,
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
    );
  }

  Widget _originalPriceView() {
    bool isView = _originalPrice.isEmpty;
    if (isView == false) {
      if (_isVip == false) {
        isView = true;
      }
    }
    String p = StringTools.numberFormat(_originalPrice, true);
    return Offstage(
      offstage: isView,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 22, left: 38, right: 38),
        height: 55,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "应付：",
                style: TextStyle(
                    fontSize: 24,
                    color: CustomColors.lightBlue,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                p,
                style: const TextStyle(
                  fontSize: 24,
                  color: CustomColors.lightBlue,
                  // fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectPaymentType(List<Map<String, dynamic>> list) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(top: 15),
      height: 159,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          Map itmeModel = list[index];
          return _buildItem(itmeModel, index);
        },
      ),
    );
  }

  Widget _buildItem(Map model, int index) {
    String titleStr = model["titleStr"];
    String isSelected = model["isSelected"];
    String description = model["description"];
    String originalPrice = model["originalPrice"];
    String itemPrice = model["price"];

    String p = originalPrice;
    String p1 = StringTools.numberFormat(itemPrice, false);
    String problem = model["problem"];

    ///标题
    Text titeView = Text(
      titleStr,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );

    ///描述
    Text descriptionView = Text(
      description,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 11,
        color: CustomColors.darkGrey,
      ),
    );

    ///原价
    Text originalPriceView = Text(
      p,
      style: const TextStyle(
        fontSize: 15,
        color: CustomColors.colorFFA3,
        // fontWeight: FontWeight.bold,
        decoration: TextDecoration.lineThrough,
      ),
    );
    Color itemBGColor = Colors.white;
    double left = 22.0, right = 22.0;

    if (isSelected == "1") {
      left = 16.0;
      right = 16.0;
      itemBGColor = CustomColors.colorFDF2F;
    }
    Widget problemView;
    if (problem == "1") {
      problemView = GestureDetector(
        onTap: () {
          clickListener?.tapProblemItem();
        },
        child: SizedBox(
          width: 16,
          height: 16,
          child: SvgPicture.asset(
            "assets/images/svg/problem.svg",
            fit: BoxFit.fill,
          ),
        ),
      );
    } else {
      problemView = const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        clickListener?.tapBuyReportListItem(index);
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.colorFE7E7,
            width: 1,
          ),
          color: itemBGColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(9),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          top: 9,
          bottom: 8,
        ),
        margin: EdgeInsets.only(left: left, right: right, top: 11),
        child: Row(
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titeView,
                  Expanded(
                    child: SizedBox(
                      child: Row(
                        children: [
                          descriptionView,
                          const SizedBox(
                            width: 3,
                          ),
                          problemView,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              child: Row(
                children: [
                  originalPriceView,
                  const Text(
                    "￥",
                    style: TextStyle(
                      fontSize: 11,
                      color: CustomColors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    p1,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CustomColors.lightBlue,
                      fontWeight: FontWeight.bold,
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

  Widget _priceView() {
    return Container(
      color: Colors.white,
      height: 62,
      alignment: Alignment.center,
      // margin: const EdgeInsets.only(top: 20, bottom: 22),
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        formatPrice,
        style: const TextStyle(
            color: CustomColors.lightBlue,
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _titleView() {
    return Container(
      color: Colors.white,
      height: 41,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: const Text(
        "支付方式",
        style: TextStyle(
          fontSize: 17,
          color: CustomColors.colorE6000,
        ),
      ),
    );
  }

  Widget _contentListView(List<Map<String, dynamic>> list) {
    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      color: Colors.white,
      padding: const EdgeInsets.only(top: 14),
      height: list.length * 50,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          Map itmeModel = list[index];
          return _listItemView(itmeModel, index);
        },
      ),
    );
  }

  Widget _listItemView(Map model, int index) {
    String imagePath = "";
    String isSelected = model["isSelected"];
    String icon = model["icon"];
    String name = model["name"];
    if (isSelected == "1") {
      imagePath = model["selected"];
    } else {
      imagePath = model["normal"];
    }

    ///item分割线
    Container line = Container(
      margin: EdgeInsets.only(top: 14),
      height: 1,
      color: CustomColors.color1A000,
    );

    Widget view;
    if (name.contains("慧眼币")) {
      String str = StringTools.numberFormat(balanceStr, false);
      name += "(剩余$str币)";

      if (_isRechange == false) {
        view = const SizedBox();
      } else {
        if (PlatformUtils.isIOS) {
          view = const SizedBox();
        } else {
          view = WidgetTools().createCustomInkWellButton(
              "充值(充值优惠)", () => clickListener?.tapRecharge(),
              bgColor: CustomColors.lightBlue,
              textColor: Colors.white,
              radius: 12,
              fontSize: 13,
              height: 24,
              buttonWidth: 114,
              shadow: const BoxShadow());
        }
      }
    } else {
      view = const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        clickListener?.tapListItem(index);
      },
      child: Container(
        color: Colors.white,
        height: 51,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 9),
                SvgPicture.asset(
                  icon,
                  fit: BoxFit.fill,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 15, color: CustomColors.textDarkColor),
                ),
                const Expanded(child: SizedBox()),
                view,
              ],
            ),
            line,
          ],
        ),
      ),
    );
  }

  Widget _copywriting() {
    if (_isViewVip == false) {
      _isVip = true;
    }

    return Offstage(
      offstage: _isVip,
      child: Container(
        margin: const EdgeInsets.only(bottom: 17),
        padding: const EdgeInsets.only(left: 38, right: 38),
        child: Container(
          // padding: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Text(
                "VIP享受9折优惠，SVIP享受8折优惠",
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.lightBlue,
                ),
              ),
              const Expanded(child: SizedBox()),
              WidgetTools().createCustomInkWellButton(
                  "去开通", () => clickListener?.tapOpenVip(),
                  bgColor: CustomColors.lightBlue,
                  textColor: Colors.white,
                  radius: 12,
                  fontSize: 13,
                  height: 24,
                  buttonWidth: 73,
                  shadow: const BoxShadow())
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.only(left: 16, right: 16),
    //   alignment: Alignment.center,
    //   child: Row(
    //     children: [
    //       const Text(
    //         "VIP享受9折优惠，SVIP享受8折优惠",
    //         style: TextStyle(
    //           fontSize: 15,
    //           color: CustomColors.lightBlue,
    //         ),
    //       ),
    //       const Expanded(child: SizedBox()),
    //       WidgetTools().createCustomInkWellButton(
    //           "去开通", () => clickListener?.tapOpenVip(),
    //           bgColor: CustomColors.lightBlue,
    //           textColor: Colors.white,
    //           radius: 12,
    //           fontSize: 13,
    //           height: 24,
    //           shadow: const BoxShadow())
    //     ],
    //   ),
    // );
  }

  Widget _payButtonView() {
    String buttonText = "支付$formatPrice";
    return Container(
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: WidgetTools().createCustomButton(
        ScreenTool.screenWidth - 60,
        buttonText,
        () => clickListener?.tapPay(),
        bgColor: CustomColors.lightBlue,
        textColor: Colors.white,
        radius: 32,
        height: 50,
        shadow: const BoxShadow(),
      ),
    );
  }
}

abstract class PayCheakstandViewClickListener {
  ///选择支付方式
  tapListItem(int index);

  ///选择报告购买类型
  tapBuyReportListItem(int index);

  ///点击问题
  tapProblemItem();

  ///开通vip
  tapOpenVip();

  ///支付
  tapPay();

  ///充值
  tapRecharge();
}
