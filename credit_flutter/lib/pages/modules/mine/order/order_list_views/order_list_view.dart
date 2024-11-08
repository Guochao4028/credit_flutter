// /// *
// /// -  @Date: 2022-08-30 15:01
// /// -  @LastEditTime: 2022-08-30 15:01
// /// -  @Description:处理订单列表view
// ///

// import 'package:credit_flutter/define/define_block.dart';
// import 'package:credit_flutter/define/define_colors.dart';
// import 'package:credit_flutter/models/order_list_model.dart';
// import 'package:credit_flutter/tools/string_tool.dart';
// import 'package:credit_flutter/tools/widget_tool.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';

// class OrderListView implements OrderListItemViewClickListener {
//   final EasyRefreshController controller = EasyRefreshController();
//   OrderListViewClickListener? clickListener;

//   OrderListView({this.clickListener});

//   Widget contentView(List<OrderDetailsModel> orderList) {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         OrderDetailsModel model = orderList[index];
//         return OrderListItemView(
//           onStart: (() {}),
//           detailsModel: model,
//           listener: this,
//         );
//       },
//       itemCount: orderList.length,
//       // physics: const NeverScrollableScrollPhysics(),
//     );

    // return EasyRefresh(
    //   header: WidgetTools().getClassicalHeader(),
    //   footer: WidgetTools().getClassicalFooter(),
    //   controller: controller,
    //   enableControlFinishRefresh: true,
    //   enableControlFinishLoad: true,
    //   onRefresh: _onRefresh,
    //   onLoad: _onLoad,
    //   child: ListView.builder(
    //     itemBuilder: (context, index) {
    //       OrderDetailsModel model = orderList[index];
    //       return OrderListItemView(
    //         onStart: (() {}),
    //         detailsModel: model,
    //         listener: this,
    //       );
    //     },
    //     itemCount: orderList.length,
    //     // physics: const NeverScrollableScrollPhysics(),
    //   ),
    // );
//   }

//   Future _onRefresh() async {
//     clickListener?.onRefresh(controller);
//   }

//   Future _onLoad() async {
//     clickListener?.onLoad(controller);
//   }

//   @override
//   deleteOrderListItem(OrderDetailsModel model) {
//     clickListener?.deleteOrderListItem(model);
//   }

//   @override
//   operationInvoice(OrderDetailsModel model) {
//     clickListener?.operationInvoice(model);
//   }

//   @override
//   tapOrderListItem(OrderDetailsModel model) {
//     clickListener?.tapOrderListItem(model);
//   }
// }

// abstract class OrderListViewClickListener {
//   ///点击list item
//   tapOrderListItem(OrderDetailsModel model);

//   ///删除List Item
//   deleteOrderListItem(OrderDetailsModel model);

//   ///发票操作
//   operationInvoice(OrderDetailsModel model);
//   onRefresh(EasyRefreshController controller);
//   onLoad(EasyRefreshController controller);
// }

// class OrderListItemView extends StatefulWidget {
//   OrderDetailsModel detailsModel;
//   OrderListItemViewClickListener? listener;
//   OrderListItemView(
//       {Key? key,
//       required this.onStart,
//       required this.detailsModel,
//       this.listener})
//       : super(key: key);
//   final VoidCallback onStart;

//   @override
//   State<OrderListItemView> createState() => _OrderListItemViewState();
// }

// class _OrderListItemViewState extends State<OrderListItemView>
//     with SingleTickerProviderStateMixin {
//   OrderListItemViewClickListener? _listener;
//   double start = 0;
//   bool isOpen = false;
//   double maxMove = 62;
//   bool isTapDelete = false;
//   OrderDetailsModel? detailsModel;
//   late final AnimationController controller = AnimationController(
//       lowerBound: 0,
//       upperBound: maxMove,
//       duration: const Duration(milliseconds: 300),
//       vsync: this)
//     ..addListener(() {
//       start = controller.value;
//       setState(() {});
//     });

//   @override
//   void initState() {
//     detailsModel = widget.detailsModel;
//     _listener = widget.listener;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 170,
//       width: double.infinity,
//       padding: const EdgeInsets.only(top: 10, right: 16, left: 16),
//       child: GestureDetector(
//         child: Stack(
//           children: [
//             Positioned(
//               right: 0,
//               child: deleteOperationView(),
//             ),

//             ///item view
//             Positioned(
//               left: -start,
//               right: start,
//               child: GestureDetector(
//                 onTap: () {
//                   _listener?.tapOrderListItem(detailsModel!);
//                 },
//                 child: Column(
//                   children: [
//                     infoView(),
//                     operationView(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         onHorizontalDragDown: (DragDownDetails details) {
//           // _close();
//           return widget.onStart();
//         },
//         onHorizontalDragUpdate: (DragUpdateDetails details) {
//           setState(() {
//             start -= details.delta.dx;
//             if (start <= 0) {
//               start = 0;
//             }
//             if (start >= maxMove) {
//               start = maxMove;
//             }
//           });
//         },
//         onHorizontalDragEnd: (DragEndDetails details) {
//           controller.value = start;
//           if (start == maxMove) {
//             isOpen = true;
//           } else if (start > maxMove / 2) {
//             controller.animateTo(maxMove);
//             isOpen = true;
//           } else if (start < maxMove / 2) {
//             _close();
//           }
//         },
//       ),
//     );
//   }

//   /// *
//   /// -  @description: List Item 上半部信息
//   /// -  @Date: 2022-08-31 10:23
//   /// -  @parm:
//   /// -  @return {*}
//   ///
//   Widget infoView() {
//     int type = detailsModel?.type ?? 0;
//     String contentStr = "";
//     String titleStr = "";
//     String iconPathStr = "assets/images/svg/SVIP.svg";
//     int quantity = detailsModel?.quantity ?? 0;
//     int unit = detailsModel?.unit ?? 0;
//     String name = detailsModel?.reportUserName ?? "";

//     ///1.vip
//     ///2.svip
//     ///3.公司购买慧眼币
//     ///4.企业增加人数
//     ///5.公司购买个人报告
//     ///6.个人购买慧眼币
//     ///7.会员升级
//     ///8.个人购买报告
//     ///9.公司报告升级
//     ///10.去购买
//     switch (type) {
//       case 1:
//         {
//           titleStr = "VIP会员";
//           contentStr = "开通$quantity年VIP会员服务";

//           iconPathStr = "assets/images/svg/VIP.svg";
//         }
//         break;
//       case 2:
//         {
//           titleStr = "SVIP会员";
//           contentStr = "开通$quantity年SVIP会员服务";
//           iconPathStr = "assets/images/svg/SVIP.svg";
//         }
//         break;
//       case 3:
//       case 6:
//         {
//           titleStr = "慧眼币充值";
//           contentStr = "购买$quantity个慧眼币";
//           iconPathStr = "assets/images/svg/biIcon.svg";
//         }
//         break;
//       case 4:
//         {
//           titleStr = "增加企业人数";
//           contentStr = "购买$quantity个企业人数";
//           iconPathStr = "assets/images/svg/biIcon.svg";
//         }
//         break;
//       case 5:
//       case 8:
//       case 9:
//       case 10:
//         {
//           titleStr = "员工背调报告";
//           contentStr = "$name的员工背调报告";
//           iconPathStr = "assets/images/svg/biIcon.svg";
//         }
//         break;
//       case 7:
//         {
//           titleStr = "会员升级";
//           contentStr = "会员升级";
//           iconPathStr = "assets/images/svg/biIcon.svg";
//         }
//         break;
//       default:
//     }

//     SizedBox icon = SizedBox(
//       width: 18,
//       height: 18,
//       child: SvgPicture.asset(
//         iconPathStr,
//         fit: BoxFit.fill,
//       ),
//     );

//     ///箭头
//     SizedBox direction = SizedBox(
//       width: 16,
//       height: 16,
//       child: SvgPicture.asset(
//         "assets/images/svg/back.svg",
//         fit: BoxFit.fill,
//         color: CustomColors.darkGreyE6,
//       ),
//     );
//     return Column(
//       children: [
//         Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(4),
//               topRight: Radius.circular(4),
//             ),
//           ),
//           padding: const EdgeInsets.only(left: 15, right: 16),
//           height: 45,
//           child: Row(
//             children: [
//               icon,
//               const SizedBox(width: 2),
//               Text(
//                 titleStr,
//                 style: const TextStyle(
//                   color: CustomColors.textDarkColor,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Expanded(child: SizedBox()),
//               const Text(
//                 "已完成",
//                 style: TextStyle(
//                   color: CustomColors.warningColor,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(height: 1, color: CustomColors.color1A000),
//         Container(
//           height: 59,
//           color: Colors.white,
//           padding: const EdgeInsets.only(left: 38, right: 16, top: 14),
//           alignment: Alignment.topLeft,
//           child: Row(
//             children: [
//               Text(
//                 contentStr,
//                 style: const TextStyle(
//                   color: CustomColors.darkGrey,
//                   fontSize: 15,
//                 ),
//               ),
//               const Expanded(child: SizedBox()),
//               direction
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   /// *
//   /// -  @description: List Item 下半部操作
//   /// -  @Date: 2022-08-31 10:24
//   /// -  @parm:
//   /// -  @return {*}
//   ///
//   Widget operationView() {
//     double amount = detailsModel?.amount ?? 0.0;
//     String price = StringTools.numberFormat(amount.toString(), true);

//     Widget buttonView = const SizedBox(
//       height: 1,
//       width: 1,
//     );

//     if (detailsModel?.isOpenInvoice() ?? false) {
//       switch (detailsModel?.invoiceStatus) {
//         case 0:
//           {
//             String buttonTitle = "开发票";

//             buttonView = WidgetTools().createCustomInkWellButton(buttonTitle,
//                 () {
//               _listener?.operationInvoice(detailsModel!);
//             },
//                 bgColor: CustomColors.connectColor,
//                 textColor: Colors.white,
//                 radius: 15,
//                 fontSize: 15,
//                 height: 30,
//                 shadow: const BoxShadow(),
//                 buttonWidth: 82);
//           }
//           break;
//         case 1:
//         case 2:
//           {
//             String buttonTitle = "查看发票";

//             buttonView = WidgetTools().createCustomInkWellButton(buttonTitle,
//                 () {
//               _listener?.operationInvoice(detailsModel!);
//             },
//                 bgColor: CustomColors.connectColor,
//                 textColor: Colors.white,
//                 radius: 15,
//                 fontSize: 15,
//                 height: 30,
//                 shadow: const BoxShadow(),
//                 buttonWidth: 82);
//           }
//           break;
//         default:
//       }
//     }

//     return Container(
//       height: 54,
//       decoration: const BoxDecoration(
//         color: CustomColors.colorFFD9,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(4),
//           bottomRight: Radius.circular(4),
//         ),
//       ),
//       padding: const EdgeInsets.only(left: 16, right: 16),
//       alignment: Alignment.center,
//       child: Row(
//         children: [
//           const Text(
//             "支付金额：",
//             style: TextStyle(
//               fontSize: 13,
//             ),
//           ),
//           Text(
//             price,
//             style: const TextStyle(
//               color: CustomColors.warningColor,
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Expanded(child: SizedBox()),
//           buttonView,
//         ],
//       ),
//     );
//   }

//   /// *
//   /// -  @description: 删除面板
//   /// -  @Date: 2022-08-31 10:25
//   /// -  @parm:
//   /// -  @return {*}
//   ///
//   Widget deleteOperationView() {
//     SizedBox icon = SizedBox(
//       width: 30,
//       height: 30,
//       child: SvgPicture.asset(
//         "assets/images/svg/deleteButton.svg",
//         fit: BoxFit.fill,
//       ),
//     );

//     // Color bgColor =
//     //     isTapDelete == true ? CustomColors.warningColor : Colors.transparent;

//     // Color textColor =
//     //     isTapDelete == true ? Colors.white : CustomColors.greyBlack;

//     Color bgColor = Colors.transparent;

//     Color textColor = CustomColors.greyBlack;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           // isTapDelete = !isTapDelete;
//           _listener?.deleteOrderListItem(detailsModel!);
//         });
//       },
//       child: Container(
//         height: 170,
//         alignment: Alignment.center,
//         color: bgColor,
//         width: maxMove,
//         child: Column(
//           children: [
//             const Expanded(child: SizedBox()),
//             icon,
//             Text(
//               "删除",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: textColor,
//               ),
//             ),
//             const Expanded(child: SizedBox()),
//           ],
//         ),
//       ),
//     );
//   }

//   void _close() {
//     controller.animateTo(0);
//     isOpen = false;
//   }
// }

// abstract class OrderListItemViewClickListener {
//   ///点击list item
//   tapOrderListItem(OrderDetailsModel model);

//   ///删除List Item
//   deleteOrderListItem(OrderDetailsModel model);

//   ///发票操作
//   operationInvoice(OrderDetailsModel model);
// }
