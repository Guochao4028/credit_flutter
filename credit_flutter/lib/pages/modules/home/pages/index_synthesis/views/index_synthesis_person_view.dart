/// *
/// -  @Date: 2023-09-04 18:26
/// -  @LastEditTime: 2023-09-04 18:36
/// -  @Description: 综合页面 个人
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/financial_risk_partial_report_model.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/pop_option_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

/// 个人自查
class IndexSynthesisPersonView extends StatefulWidget {
  IndexSynthesisPersonViewListener? listener;

  IndexSynthesisPersonView({Key? key, this.listener}) : super(key: key);

  @override
  State<IndexSynthesisPersonView> createState() =>
      _IndexSynthesisPersonViewState();
}

class _IndexSynthesisPersonViewState extends State<IndexSynthesisPersonView>
    implements PopOptionWidgetClickListener {
  IndexSynthesisPersonViewListener? _listener;

  /// 委托日期
  String createTime = "";

//是否购买报告
  bool isPurchase = false;

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
    _listener = widget.listener;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  void _ifIdentity(int type, bool bool) {
    _listener?.purchaseIndividualReports(type);
  }

  @override
  void onAffirm(Map<String, dynamic> confirmMap) {}

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

  Widget _body(BuildContext context) {
    return _notPurchased();
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
    var time = DateTime.now();
    createTime = "委托日期：${time.year}-${time.month}-${time.day}";
    return Column(
      children: [
        const Text(
          "职场背调报告",
          style: TextStyle(
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
            const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: Text(
                "姓名：***",
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                _showPayment(context, "职场背调报告");
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
            Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: Text(
                "性别：*",
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.greyBlack,
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
            Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: Text(
                "年龄：**",
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.greyBlack,
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
            Padding(
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
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10, right: 16),
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
                  image: AssetImage("assets/images/icon_warning_search.png"),
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
                  image: AssetImage("assets/images/icon_warning_search.png"),
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
              padding:
                  const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
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
                  image: AssetImage("assets/images/icon_warning_search.png"),
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
              padding:
                  const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
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
              padding:
                  const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
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
                        Text("网络贷款公司",
                            style: TextStyle(
                              fontSize: 12,
                            )),
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
                        Text("小贷公司记录",
                            style: TextStyle(
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Stack(
    //   alignment: AlignmentDirectional.bottomEnd,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 16, bottom: 15, right: 16),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const SizedBox(height: 15),
    //           const Row(
    //             children: [
    //               Image(
    //                 image: AssetImage("assets/images/icon_financial_risk.png"),
    //                 height: 18,
    //               ),
    //               SizedBox(
    //                 width: 5,
    //               ),
    //               Text(
    //                 "金融风险",
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   color: CustomColors.greyBlack,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(
    //             height: 15,
    //           ),
    //           const Padding(
    //             padding: EdgeInsets.only(top: 5, bottom: 5),
    //             child: Row(
    //               children: [
    //                 Text(
    //                   "被冒名开卡查询",
    //                   style: TextStyle(
    //                     color: CustomColors.greyBlack,
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: 8,
    //                 ),
    //                 Expanded(
    //                   child: DottedLine(
    //                     direction: Axis.horizontal,
    //                     lineLength: double.infinity,
    //                     lineThickness: 0.8,
    //                     dashLength: 1.0,
    //                     dashColor: Color(0xFF99C6FF),
    //                     dashGapLength: 1.0,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: 8,
    //                 ),
    //                 Image(
    //                   image:
    //                       AssetImage("assets/images/icon_warning_search.png"),
    //                   height: 20,
    //                 ),
    //                 SizedBox(
    //                   width: 16,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const Padding(
    //             padding: EdgeInsets.only(top: 5, bottom: 5),
    //             child: Row(
    //               children: [
    //                 Text(
    //                   "网贷黑名单查询",
    //                   style: TextStyle(
    //                     color: CustomColors.greyBlack,
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: 8,
    //                 ),
    //                 Expanded(
    //                   child: DottedLine(
    //                     direction: Axis.horizontal,
    //                     lineLength: double.infinity,
    //                     lineThickness: 0.8,
    //                     dashLength: 1.0,
    //                     dashColor: Color(0xFF99C6FF),
    //                     dashGapLength: 1.0,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: 8,
    //                 ),
    //                 Image(
    //                   image:
    //                       AssetImage("assets/images/icon_warning_search.png"),
    //                   height: 20,
    //                 ),
    //                 SizedBox(
    //                   width: 16,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 5, bottom: 5),
    //             child: Container(
    //               width: double.infinity,
    //               padding: const EdgeInsets.only(
    //                   left: 5, top: 6, right: 5, bottom: 6),
    //               decoration: const BoxDecoration(
    //                 color: CustomColors.colorFAF8F8,
    //                 borderRadius: BorderRadius.all(Radius.circular(5)),
    //               ),
    //               child: _instructionsWidget(ScreenTool.screenWidth - 64 - 10),
    //             ),
    //           ),
    //           const Padding(
    //             padding: EdgeInsets.only(top: 5, bottom: 5),
    //             child: Row(
    //               children: [
    //                 Text(
    //                   "互联网金融风险",
    //                   style: TextStyle(
    //                     color: CustomColors.greyBlack,
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: 8,
    //                 ),
    //                 Expanded(
    //                   child: DottedLine(
    //                     direction: Axis.horizontal,
    //                     lineLength: double.infinity,
    //                     lineThickness: 0.8,
    //                     dashLength: 1.0,
    //                     dashColor: Color(0xFF99C6FF),
    //                     dashGapLength: 1.0,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: 8,
    //                 ),
    //                 Image(
    //                   image:
    //                       AssetImage("assets/images/icon_warning_search.png"),
    //                   height: 20,
    //                 ),
    //                 SizedBox(
    //                   width: 16,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 5, bottom: 5),
    //             child: Container(
    //               // width: double.infinity,
    //               padding: const EdgeInsets.only(
    //                   left: 5, top: 6, right: 5, bottom: 6),
    //               // margin: const EdgeInsets.only(top: 5, bottom: 15),
    //               decoration: const BoxDecoration(
    //                 color: CustomColors.colorFAF8F8,
    //                 borderRadius: BorderRadius.all(Radius.circular(5)),
    //               ),
    //               child: const Text(
    //                 "说明：2000+小贷公司记录，核实 命中机构数，逾期订单数累计逾期额度，总放款订单数等。",
    //                 style: TextStyle(
    //                   color: CustomColors.darkGrey,
    //                   fontSize: 10,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 5, bottom: 5),
    //             child: Container(
    //               padding: const EdgeInsets.only(
    //                   left: 5, top: 6, right: 5, bottom: 6),
    //               decoration: const BoxDecoration(
    //                 color: CustomColors.whiteBlueColorFE,
    //                 borderRadius: BorderRadius.all(Radius.circular(5)),
    //               ),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 mainAxisSize: MainAxisSize.max,
    //                 //交叉轴的布局方式，对于column来说就是水平方向的布局方式
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 //就是字child的垂直布局方向，向上还是向下
    //                 verticalDirection: VerticalDirection.down,
    //                 children: [
    //                   const Expanded(
    //                     child: Column(
    //                       children: [
    //                         Text(
    //                           "100+",
    //                           style: TextStyle(
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                         Text("网络贷款公司",
    //                             style: TextStyle(
    //                               fontSize: 12,
    //                             )),
    //                       ],
    //                     ),
    //                   ),
    //                   Container(
    //                     width: 2,
    //                     height: 20,
    //                     color: CustomColors.lightGrey,
    //                   ),
    //                   const Expanded(
    //                     child: Column(
    //                       children: [
    //                         Text(
    //                           "2000+",
    //                           style: TextStyle(
    //                             fontSize: 16,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                         Text("小贷公司记录",
    //                             style: TextStyle(
    //                               fontSize: 12,
    //                             )),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     // Padding(
    //     //   padding: const EdgeInsets.only(bottom: 140),
    //     //   child: Row(
    //     //     mainAxisSize: MainAxisSize.min,
    //     //     children: [
    //     //       Container(
    //     //         padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
    //     //         margin: const EdgeInsets.fromLTRB(24, 15, 24, 15),
    //     //         decoration: const BoxDecoration(
    //     //           borderRadius: BorderRadius.all(Radius.circular(15)),
    //     //           color: CustomColors.connectColor,
    //     //           boxShadow: [
    //     //             BoxShadow(
    //     //               color: Color(0x66000000),
    //     //               offset: Offset(4, 4),
    //     //               blurRadius: 6,
    //     //               spreadRadius: 0,
    //     //             ),
    //     //           ],
    //     //         ),
    //     //         child: InkWell(
    //     //           highlightColor: Colors.transparent,
    //     //           splashColor: Colors.transparent,
    //     //           onTap: () {
    //     //             _ifIdentity(6, false);
    //     //           },
    //     //           child: const Center(
    //     //             child: Text(
    //     //               "查看部分报告 ¥9.9",
    //     //               style: TextStyle(
    //     //                 fontSize: 15,
    //     //                 color: Colors.white,
    //     //               ),
    //     //             ),
    //     //           ),
    //     //         ),
    //     //       ),
    //     //     ],
    //     //   ),
    //     // ),
    //   ],
    // );
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

  Widget _notPurchased() {
    //未购买
    return SizedBox(
      height: ScreenTool.screenHeight,
      width: ScreenTool.screenWidth,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
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
                        height: 45,
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                          decoration:
                                              TextDecoration.lineThrough,
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
                      margin: const EdgeInsets.only(top: 10, right: 16),
                      child: const Image(
                        image: AssetImage("assets/images/icon_top_secret.png"),
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
}

abstract class IndexSynthesisPersonViewListener {
  /// *
  /// -  @description: 购买个人报告
  /// -  @Date: 2023-09-07 10:28
  /// -  @parm: type ：1.全部报告， 6. 9.9元报告
  /// -  @return {*}
  ///
  void purchaseIndividualReports(int type);
}
