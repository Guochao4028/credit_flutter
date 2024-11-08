/// *
/// @Date: 2022-05-27 09:57
/// @LastEditTime: 2022-06-09 15:39
/// @Description: 所有自定义组件
import 'dart:io';
import 'dart:math';

import 'package:app_installer/app_installer.dart';
import 'package:credit_flutter/manager/version_manager.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/models/comment_bean.dart';
import 'package:credit_flutter/models/company_report_home_bean.dart';
import 'package:credit_flutter/models/demand_center_bean.dart';
import 'package:credit_flutter/models/message_center_bean.dart';
import 'package:credit_flutter/models/my_needs_bean.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/models/report_data_bean.dart';
import 'package:credit_flutter/models/report_details_bean.dart';
import 'package:credit_flutter/models/report_home_bean.dart';
import 'package:credit_flutter/models/salary_evaluation_bean.dart';
import 'package:credit_flutter/models/select_replace_company_bean.dart';
import 'package:credit_flutter/pages/modules/company/exam_reminder/appointment_reminder_page.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

import '../define/define_colors.dart';
import '../models/professional_certificate_bean.dart';
import '../pages/modules/login/login_type_page.dart';
import 'screen_tool.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;

const common14GrayTextStyle = TextStyle(fontSize: 14, color: Colors.grey);
const bold16TextStyle = TextStyle(
    fontSize: 16, color: CustomColors.greyBlack, fontWeight: FontWeight.bold);
const commonGrayTextStyle = TextStyle(fontSize: 14, color: Colors.grey);
const common14TextStyle = TextStyle(fontSize: 14, color: Colors.black87);
const bold18RedTextStyle =
    TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold);
const bold18GrayTextStyle =
    TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold);

class WidgetTools {
  Function? buttonAction;
  Function? listItemAction;

  /// @description:
  /// @Date: 2022-05-27 10:00
  /// @parm: bgColor 背景颜色,
  ///        textColor 字体颜色,
  ///        buttonWidth按钮宽度
  ///        title 按钮上的文字
  /// @return 一个带有圆角的按钮
  MaterialButton createMaterialButton(double buttonWidth, String title,
      Color bgColor, Color textColor, double borderWidth, buttonAction) {
    // 边框样式
    RoundedRectangleBorder shape = RoundedRectangleBorder(
      side: BorderSide(
        width: borderWidth,
        color: borderWidth == 0 ? Colors.white : Colors.blue,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
    );

    Text textWidget = Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    //生成按钮
    return MaterialButton(
      color: bgColor,
      textColor: textColor,
      minWidth: buttonWidth,
      height: 49,
      shape: shape,
      onPressed: () {
        if (buttonAction != null) {
          buttonAction!();
        }
      },
      child: textWidget,
    );
  }

  /// *
  /// -  @description: 自定义按钮
  /// -  @Date: 2022-06-30 15:49
  /// -  @parm: buttonWidth 按钮宽度
  ///           title 按钮标题
  ///           buttonAction 点击方法
  ///           bgColor颜色
  ///           textColor 字体颜色
  ///           borderWidth 边框宽度
  ///           borderColor 边框颜色
  ///           radius圆角
  ///           fontSize 字体大小
  ///           fontWeight 加粗
  ///           height 按钮高度
  /// -  @return {*}
  ///
  Widget createCustomButton(
    double buttonWidth,
    String title,
    buttonAction, {
    Color? bgColor,
    Color? textColor,
    double borderWidth = 0.0,
    Color? borderColor,
    double radius = 0.0,
    double fontSize = 15,
    FontWeight? fontWeight,
    double height = 49,
    BoxShadow? shadow,
  }) {
    // 边框样式
    RoundedRectangleBorder shape = RoundedRectangleBorder(
      side: BorderSide(
        width: borderWidth,
        color: borderColor ?? Colors.white,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
    );

    Text textWidget = Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      maxLines: 1,
    );
    //生成按钮
    return Container(
      width: buttonWidth,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [
          shadow ??
              const BoxShadow(
                color: CustomColors.shadowColor,
                offset: Offset(0, 0),
                blurRadius: 6,
                spreadRadius: 2,
              ),
        ],
      ),
      child: MaterialButton(
        color: bgColor,
        textColor: textColor,
        shape: shape,
        onPressed: () {
          if (buttonAction != null) {
            buttonAction!();
          }
        },
        child: textWidget,
      ),
    );
  }

  /// *
  /// -  @description: 自定义按钮
  /// -  @Date: 2022-06-30 15:49
  /// -  @parm: buttonWidth 按钮宽度
  ///           title 按钮标题
  ///           buttonAction 点击方法
  ///           bgColor颜色
  ///           textColor 字体颜色
  ///           borderWidth 边框宽度
  ///           borderColor 边框颜色
  ///           radius圆角
  ///           fontSize 字体大小
  ///           fontWeight 加粗
  ///           height 按钮高度
  /// -  @return {*}
  ///
  Widget createCustomInkWellButton(
    String title,
    buttonAction, {
    double? buttonWidth,
    Color? bgColor,
    Color? textColor,
    double borderWidth = 0.0,
    Color? borderColor,
    double radius = 0.0,
    double fontSize = 15,
    FontWeight? fontWeight,
    double height = 49,
    BoxShadow? shadow,
    Image? leftImage,
  }) {
    // 边框样式
    RoundedRectangleBorder shape = RoundedRectangleBorder(
      side: BorderSide(
        width: borderWidth,
        color: borderColor ?? Colors.white,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
    );

    Text textWidget = Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
      ),
      textAlign: TextAlign.center,
      // maxLines: 1,
    );

    Widget lView;
    if (leftImage != null) {
      lView = leftImage;
    } else {
      lView = const SizedBox();
    }
    //生成按钮
    return Container(
      width: buttonWidth,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [
          shadow ??
              const BoxShadow(
                color: CustomColors.shadowColor,
                offset: Offset(0, 0),
                blurRadius: 6,
                spreadRadius: 2,
              ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (buttonAction != null) {
            buttonAction!();
          }
        },
        child: Row(children: [
          lView,
          Expanded(child: textWidget),
        ]),
      ),
    );
  }

  /// *
  /// @description: 公司列表item
  /// @Date: 2022-06-09 15:00
  /// @parm:  data 数据
  ///        itemWidth cell的总宽度
  ///        isBoxShadow 是否显示阴影
  /// @return {*}
//List item
  Widget showListViewItem(
    BuildContext context,
    BackCheckCompanyListItemModel data,
    double itemWidth,
    bool isBoxShadow,
    bool ranking,
    String rankingStr,
    listItemAction,
  ) {
    BoxDecoration temDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: CustomColors.shadowColor,
          offset: Offset(0, 0),
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
    );

    BoxDecoration? decoration = isBoxShadow ? temDecoration : null;
    String companyNameStr = "";
    String companyintroductionStr = "";
    String companyImagePath = "";
    if (data != null) {
      companyNameStr = data.productName;
      companyintroductionStr = data.introduction;
      companyImagePath = data.logo;
    }

    ImageProvider image;
    if (companyImagePath.isEmpty) {
      image = const AssetImage("assets/images/logo.png");
    } else {
      image = NetworkImage(companyImagePath);
    }

    Image companyImage = Image(
      image: image,
      width: 80,
      height: 103,
      // fit: BoxFit.fill,
      fit: BoxFit.fitWidth,
    );

    Text companyNameText = Text(
      companyNameStr,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      ),
      maxLines: 1,
    );
    Text companyintroductionText = Text(
      companyintroductionStr,
      style: const TextStyle(fontSize: 12.0),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );

    SizedBox box;

    if (ranking == true) {
      box = SizedBox(
        width: 20,
        height: 20,
        child: Container(
          child: _icon(rankingStr),
        ),
      );
    } else {
      box = const SizedBox(
        width: 10,
        height: 0,
      );
    }

    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      GestureDetector(
        onTap: listItemAction,
        child: Container(
          // padding: const EdgeInsets.all(10),
          // margin: const EdgeInsets.only(left: 12, right: 12),
          width: itemWidth,
          decoration: decoration,
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: 80,
                height: 91,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.shadowColor,
                      offset: Offset(0, 0),
                      blurRadius: 6,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: companyImage,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  padding: const EdgeInsets.only(right: 10),
                  height: 103.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),
                      //     公司名称
                      companyNameText,
                      //    公司简介
                      companyintroductionText,
                    ],
                  ),

                  // child: Row(
                  //   children: [
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: <Widget>[
                  //         const SizedBox(
                  //           height: 8,
                  //         ),
                  //         //     公司名称
                  //         companyNameText,
                  //         //    公司简介
                  //         companyintroductionText,
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ),
              ),
              box,
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ]);
  }

  Widget _icon(String rankingStr) {
    int i = int.parse(rankingStr) + 1;
    if (i == 1) {
      return const Image(image: AssetImage("assets/images/排行一.png"));
    } else if (i == 2) {
      return const Image(image: AssetImage("assets/images/排行二.png"));
    } else if (i == 3) {
      return const Image(image: AssetImage("assets/images/排行三.png"));
    } else {
      return Container(
        //设置 child 居中
        alignment: const Alignment(0, 0),
        height: 15,
        width: 15,
        //边框设置
        decoration: BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          //设置四周边框
          border: Border.all(width: 2, color: CustomColors.lightGrey),
        ),

        child: Text(
          i.toString(),
          style: const TextStyle(fontSize: 10, color: CustomColors.greyBlack),
        ),
      );
    }
  }

  /// @description: 新闻列表item
  /// @parm:  data 数据
  ///        itemWidth cell的总宽度
  ///        isBoxShadow 是否显示阴影
  Widget showNewsViewItem(
    BuildContext context,
    NewsDetailsModel data,
    double itemWidth,
    bool isBoxShadow,
    listItemAction,
  ) {
    BoxDecoration temDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: CustomColors.shadowColor,
          offset: Offset(0, 0),
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
    );

    BoxDecoration? decoration = isBoxShadow ? temDecoration : null;

    String title = data.title;
    String picture = "";
    if (!StringTools.isEmpty(data.coverImage)) {
      picture = data.coverImage!;
    }

    String source = data.from;
    String date = data.releaseTime;
    // String read = data.;
    Image image;
    if (!StringTools.isEmpty(picture)) {
      if (picture.contains("mp4")) {
        picture +=
            "?spm=qipa250&x-oss-process=video/snapshot,t_7000,f_jpg,w_800,h_600,m_fast";
      }

      image = Image(
        image: NetworkImage(picture),
        width: 100,
        height: 80,
        fit: BoxFit.fitHeight,
      );
    } else {
      image = Image(
        width: 0,
        height: 0,
        image: AssetImage("assets/images/logo.png"),
      );
    }

    Expanded titleText = Expanded(
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: CustomColors.textDarkColor,
          fontSize: 15.0,
        ),
        maxLines: 2,
      ),
    );

    Text sourceText = Text(
      "    新闻来源:$source",
      style: const TextStyle(fontSize: 13.0, color: CustomColors.lightGrey),
    );

    Text dateText = Text(
      date,
      style: const TextStyle(fontSize: 13.0, color: CustomColors.lightGrey),
    );

    // Text readText = Text(
    //   read,
    //   style: const TextStyle(fontSize: 13.0, color: CustomColors.lightGrey),
    // );

    Expanded expanded = Expanded(
      child: Row(
        // children: [sourceText, dateText, readText],
        children: [
          dateText,
          sourceText,
        ],
      ),
    );

    return Column(children: [
      InkWell(
        onTap: listItemAction,
        child: Container(
          height: 110,
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          width: itemWidth,
          decoration: decoration,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: image,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 15.0),
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      titleText,
                      expanded,
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: 0.5,
        width: double.infinity,
        child: redBox,
      ),
    ]);
  }

  /// @description:
  /// @parm:  data 数据
  ///        itemWidth cell的总宽度
  ///        isBoxShadow 是否显示阴影
  Widget showSelectViewItem(
    BuildContext context,
    Map<String, dynamic> data,
    listItemAction,
  ) {
    var name = data["name"];
    var isSelect = data["isSelect"];

    Image selectImage = Image(
      width: 18,
      height: 18,
      image: isSelect
          ? const AssetImage("assets/images/icon_select.png")
          : const AssetImage("assets/images/icon_unchecked.png"),
    );

    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 22.0, right: 22.0),
      width: double.infinity,
      child: InkWell(
        onTap: listItemAction,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            selectImage,
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 15.5),
                height: double.infinity,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        color: CustomColors.textDarkColor,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// @description:
  /// @parm:  data 数据
  ///        itemWidth cell的总宽度
  ///        isBoxShadow 是否显示阴影
  Widget showReportHomeItem(
    BuildContext context,
    ReportHomeDataBean data,
    onTap,
  ) {
    var bgColor = Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
        Random().nextInt(256), 0.2);
    var textColor = bgColor.withAlpha(255);

    Container surnam = Container(
      height: 37,
      width: 37,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            data.idCardNameCode.isNotEmpty
                ? data.idCardNameCode.substring(0, 1)
                : "",
            style: TextStyle(
              fontSize: 22,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );

    Widget markView = Text("");
    if (data.reportType == 4) {
      markView = const Text(
        "（年付）",
        style: TextStyle(
          fontSize: 16,
          color: CustomColors.darkGrey99,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    String buttonText = "";
    Color buttonBg = CustomColors.connectColor;

    ///是否可点击 默认可点击，只有在授权中时不能点击
    bool onTapFlag = true;
    if (data.authorizationStatus == 1) {
      //1.已授权
      if (data.buyStatus == 0) {
        // 0.未购买
        buttonText = "去购买";
      } else {
        //1.已购买
        buttonText = "查看";
      }
    } else if (data.authorizationStatus == 2) {
      //2.待授权
      buttonText = "待授权";
    } else if (data.authorizationStatus == 3) {
      //3.已拒绝
      buttonText = "拒绝原因";
    } else if (data.authorizationStatus == 4) {
      //3.授权中
      buttonText = "授权中";
      onTapFlag = false;
      buttonBg = CustomColors.darkGrey99;
    } else {
      buttonText = "查看";
    }

    InkWell button = InkWell(
      onTap: onTapFlag == true ? onTap : () {},
      child: SizedBox(
        width: 75,
        height: 30,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              color: buttonBg,
              width: double.infinity,
              height: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ]),
            )),
      ),
    );

    return Container(
      height: 66,
      padding: const EdgeInsets.only(left: 20.0, right: 16.0),
      width: double.infinity,
      // child: GestureDetector(
      //   onTap: listItemAction,
      child: Row(
        children: <Widget>[
          surnam,
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          textAlign: TextAlign.end,
                          data.idCardNameCode,
                          style: const TextStyle(
                            fontSize: 16,
                            color: CustomColors.greyBlack,
                          ),
                        ),
                        markView,
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "身份证号：${data.idCardNumCode}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: CustomColors.darkGrey99,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          button,
        ],
      ),
      // ),
    );
  }

  ///个人授权列表
  Widget showPersonalAuthorizationItem(
      BuildContext context, CompanyReportHomeData data, onTap) {
    var bgColor = Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
        Random().nextInt(256), 0.2);
    var textColor = bgColor.withAlpha(255);

    double withd = 75;

    Container surnam = Container(
      height: 37,
      width: 37,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            data.companyName.isNotEmpty ? data.companyName.substring(0, 1) : "",
            style: TextStyle(
              fontSize: 22,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );

    String buttonText = "";
    Color buttonColor = CustomColors.connectColor;
    bool onTapFlag = true;
    if (data.authorizationStatus == 1) {
      //1.已授权
      buttonText = "查看";
      buttonColor = CustomColors.connectColor;
    } else if (data.authorizationStatus == 2) {
      //2.待授权
      buttonText = "待授权";
      buttonColor = CustomColors.connectColor;

      if (data.phone.isEmpty) {
        buttonText = "填写授权号码";
        buttonColor = CustomColors.connectColor;
        withd = 110;
      }
    } else if (data.authorizationStatus == 3) {
      buttonColor = CustomColors.connectColor;
      //3.已拒绝
      buttonText = "拒绝原因";
    } else if (data.authorizationStatus == 4) {
      //3.授权中
      buttonText = "授权中";
      onTapFlag = false;
      buttonColor = CustomColors.darkGrey99;
    }

    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTimeTs);
    String time =
        "申请时间：${createTime.year}年${createTime.month}月${createTime.day}日";

    InkWell button = InkWell(
      onTap: onTapFlag == true ? onTap : () {},
      child: SizedBox(
        width: withd,
        height: 30,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              color: buttonColor,
              width: double.infinity,
              height: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ]),
            )),
      ),
    );

    // return Container(
    //   padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 16.0),
    //   width: double.infinity,
    //   child: Column(
    //     children: <Widget>[
    //       Row(
    //         children: [
    //           surnam,
    //           const SizedBox(
    //             width: 8,
    //           ),
    //           Expanded(
    //             child: Text(
    //               data.companyName,
    //               textAlign: TextAlign.left,
    //               softWrap: true,
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 2,
    //               style: const TextStyle(
    //                 fontSize: 16,
    //                 color: CustomColors.greyBlack,
    //               ),
    //             ),
    //           ),
    //           button,
    //         ],
    //       ),
    //       Row(
    //         children: [
    //           const SizedBox(
    //             width: 37,
    //           ),
    //           Expanded(
    //             child: Container(
    //               margin: const EdgeInsets.only(left: 8),
    //               child: Text(
    //                 time,
    //                 textAlign: TextAlign.left,
    //                 softWrap: true,
    //                 overflow: TextOverflow.ellipsis,
    //                 maxLines: 1,
    //                 style: const TextStyle(
    //                   fontSize: 14,
    //                   color: CustomColors.darkGrey99,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             width: 75,
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    //   // ),
    // );

    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 15, right: 16.0),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          surnam,
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data.companyName}${data.reportType == 5 ? "（基础信息）" : ""}",
                    textAlign: TextAlign.left,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomColors.greyBlack,
                    ),
                  ),
                  Text(
                    time,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CustomColors.darkGrey99,
                    ),
                  ),
                ],
              ),
            ),
          ),
          button,
        ],
      ),
    );
  }

  Widget redBox = const DecoratedBox(
    position: DecorationPosition.background,
    decoration: BoxDecoration(color: CustomColors.lineColor),
  );

  /// @description: 报告详情 工作经历
  /// @parm:  data 数据
  ///        itemWidth cell的总宽度
  ///        isBoxShadow 是否显示阴影
  Widget showReportDetailsWorkItem(
    BuildContext context,
    int index,
    WorkExperience data,
  ) {
    String time = "";
    var beginTime = DateTime.fromMillisecondsSinceEpoch(data.beginTime);
    if (data.endTime == 0) {
      time = "${WidgetTools().timeFormat(beginTime, ".")}-至今";
    } else {
      var endTime = DateTime.fromMillisecondsSinceEpoch(data.endTime);
      time =
          "${WidgetTools().timeFormat(beginTime, ".")}-\n${WidgetTools().timeFormat(endTime, ".")}";
    }

    String social = "";
    if (data.socialSecurityBeginTime == 0 && data.socialSecurityEndTime == 0) {
      social = "无";
    } else if (data.socialSecurityEndTime == 0) {
      var socialSecurityBeginTime =
          DateTime.fromMillisecondsSinceEpoch(data.socialSecurityBeginTime);
      social =
          "${socialSecurityBeginTime.year}.${socialSecurityBeginTime.month}.${socialSecurityBeginTime.day}-至今";
    } else {
      var socialSecurityBeginTime =
          DateTime.fromMillisecondsSinceEpoch(data.socialSecurityBeginTime);
      var socialSecurityEndTime =
          DateTime.fromMillisecondsSinceEpoch(data.socialSecurityEndTime);
      social =
          "${socialSecurityBeginTime.year}.${socialSecurityBeginTime.month}.${socialSecurityBeginTime.day}-\n${socialSecurityEndTime.year}.${socialSecurityEndTime.month}.${socialSecurityEndTime.day}";
    }

    return Column(children: [
      IntrinsicHeight(
        child: Row(
          children: [
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: CustomColors.colorDAE9FE,
            ),
            Expanded(
              flex: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    "$index",
                    style: const TextStyle(
                      fontSize: 10,
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
                child: Center(
                  child: Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 24,
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 19,
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    data.position,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 21,
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    social,
                    style: const TextStyle(
                      fontSize: 10,
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
          ],
        ),
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColors.colorDAE9FE,
      ),
    ]);
  }

  /// @description: 求职报告详情 工作经历
  Widget showJobReportDetailsWorkItem(
    BuildContext context,
    int index,
    WorkExperience data,
  ) {
    String time = "";
    var beginTime = DateTime.fromMillisecondsSinceEpoch(data.beginTime);
    if (data.endTime == 0) {
      time = "${WidgetTools().timeFormat(beginTime, ".")}～至今";
    } else {
      var endTime = DateTime.fromMillisecondsSinceEpoch(data.endTime);
      time =
          "${WidgetTools().timeFormat(beginTime, ".")}～${WidgetTools().timeFormat(endTime, ".")}";
    }

    String social = "";
    if (data.socialSecurityBeginTime == 0 && data.socialSecurityEndTime == 0) {
      social = "无";
    } else if (data.socialSecurityEndTime == 0) {
      var socialSecurityBeginTime =
          DateTime.fromMillisecondsSinceEpoch(data.socialSecurityBeginTime);
      social =
          "${socialSecurityBeginTime.year}.${socialSecurityBeginTime.month}.${socialSecurityBeginTime.day}~至今";
    } else {
      var socialSecurityBeginTime =
          DateTime.fromMillisecondsSinceEpoch(data.socialSecurityBeginTime);
      var socialSecurityEndTime =
          DateTime.fromMillisecondsSinceEpoch(data.socialSecurityEndTime);
      social =
          "${socialSecurityBeginTime.year}.${socialSecurityBeginTime.month}.${socialSecurityBeginTime.day}~${socialSecurityEndTime.year}.${socialSecurityEndTime.month}.${socialSecurityEndTime.day}";
    }

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
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                data.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "工作时间：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "工作职位：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                data.position,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "工作行业：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                "汽车维修",
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "收入预估：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                "5千~7千",
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "社保缴纳：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                social,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  /// @description: 报告详情 学历信息
  /// @parm:  data 数据
  Widget showReportDetailsAcademicItem(
    BuildContext context,
    int index,
    Educations data,
  ) {
    String time = "";
    var beginTime = DateTime.fromMillisecondsSinceEpoch(data.beginTime);
    var endTime = DateTime.fromMillisecondsSinceEpoch(data.endTime);
    time =
        "${WidgetTools().timeFormat(beginTime, ".")}-\n${WidgetTools().timeFormat(endTime, ".")}";

    return Column(children: [
      IntrinsicHeight(
        child: Row(
          children: [
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: CustomColors.colorDAE9FE,
            ),
            Expanded(
              flex: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    "$index",
                    style: const TextStyle(
                      fontSize: 10,
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
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 17,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    data.educationalBackground,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 19,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    data.diploma,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 24,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    time,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
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
          ],
        ),
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColors.colorDAE9FE,
      ),
    ]);
  }

  /// @description: 报告详情 学历信息
  /// @parm:  data 数据
  Widget showJobReportDetailsAcademicItem(
    BuildContext context,
    int index,
    Educations data,
  ) {
    var beginTime = DateTime.fromMillisecondsSinceEpoch(data.beginTime);
    var endTime = DateTime.fromMillisecondsSinceEpoch(data.endTime);

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
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                data.educationalBackground,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "毕业学校：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                data.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "学位证书：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                data.diploma,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "学      制：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                "3年",
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "入学时间：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                WidgetTools().timeFormat(beginTime, "date"),
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "毕业时间：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                WidgetTools().timeFormat(endTime, "date"),
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  /// @description: 报告详情 专业技能
  /// @parm:  data 数据
  Widget showReportDetailsSkillItem(
    BuildContext context,
    int index,
    SkillsCertificates data,
  ) {
    String time = "";
    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);
    time = WidgetTools().timeFormat(createTime, "date");

    return Column(children: [
      IntrinsicHeight(
        child: Row(
          children: [
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: CustomColors.colorDAE9FE,
            ),
            Expanded(
              flex: 10,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "$index",
                    style: const TextStyle(
                      fontSize: 10,
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
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 10,
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
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 24,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    data.code,
                    style: const TextStyle(
                      fontSize: 10,
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
          ],
        ),
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColors.colorDAE9FE,
      ),
    ]);
  }

  /// @description: 报告详情 专业技能
  /// @parm:  data 数据
  Widget showJobReportDetailsSkillItem(
    BuildContext context,
    int index,
    SkillsCertificates data,
  ) {
    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);

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
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                data.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "获得时间：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                WidgetTools().timeFormat(createTime, "date"),
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "证书编号：",
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.darkGrey,
              ),
            ),
            Expanded(
              child: Text(
                data.code,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  /// @description: 报告详情
  /// @parm:  data 数据
  Widget showJudicialRiskItem(
    BuildContext context,
    int index,
    ItemData136 data,
  ) {
    List<ProfessionalCertificateBean> businessInfoList =
        <ProfessionalCertificateBean>[];
    for (var item in data.itemPropValue) {
      List<ProfessionalCertificateContent> content =
          <ProfessionalCertificateContent>[];
      var name = "";
      for (var item1 in item) {
        if (item1.itemPropLabel.contains("企业（机构）名称") ||
            item1.itemPropLabel.contains("企业名称")) {
          name = item1.itemPropValue;
        } else {
          content.add(ProfessionalCertificateContent(
              item1.itemPropLabel, item1.itemPropValue));
        }
      }
      businessInfoList.add(ProfessionalCertificateBean(name, content, ""));
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.itemPropLabel,
                style: const TextStyle(
                  fontSize: 15,
                  color: CustomColors.connectColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: businessInfoList.length,
          itemBuilder: (context, index) {
            var contentData = businessInfoList[index];
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
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        contentData.name,
                        style: const TextStyle(
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contentData.content.length,
                  itemBuilder: (context, index) {
                    var content = contentData.content[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            "${content.title}：",
                            style: const TextStyle(
                              fontSize: 12,
                              color: CustomColors.darkGrey,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              content.content,
                              style: const TextStyle(
                                fontSize: 12,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 10,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// @description: 报告详情 专业技能
  /// @parm:  data 数据
  Widget showReportPastExperienceItem(
    BuildContext context,
    bool index,
    PastExperience data,
  ) {
    ImageProvider bg;
    Color textColor;

    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);
    String title = "";

    if (index) {
      textColor = Colors.white;
      bg = const AssetImage('assets/images/icon_current_experience.png');
      title = data.title;
    } else {
      textColor = CustomColors.greyBlack;
      bg = const AssetImage('assets/images/icon_experience.png');
      title = "${WidgetTools().timeFormat(createTime, "date")}${data.title}";
    }

    return SizedBox(
      // padding: const EdgeInsets.az(top: 10),
      width: double.infinity,
      child: Row(
        children: [
          const Image(
            image: AssetImage("assets/images/icon_pentagram_circle.png"),
            width: 18,
            height: 18,
          ),
          Expanded(
            child: Container(
              // color: Colors.red,
              padding: const EdgeInsets.only(
                  left: 34, top: 16, right: 5, bottom: 16),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                //   centerSlice: Rect.fromLTRB(32, 5, 32, 5),
                image: bg,
              )),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// @description: 报告详情 专业技能
  /// @parm:  data 数据
  Widget showJobReportPastExperienceItem(
    BuildContext context,
    bool difference,
    int index,
    PastExperience data,
  ) {
    Color textColor;

    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);
    String title = "";

    if (difference) {
      textColor = CustomColors.color3B8FF9;
      title = data.title;
    } else {
      textColor = CustomColors.greyBlack;
      title = "${WidgetTools().timeFormat(createTime, "date")}${data.title}";
    }

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
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
    // return SizedBox(
    //   // padding: const EdgeInsets.az(top: 10),
    //   width: double.infinity,
    //   child: Row(
    //     children: [
    //       const Image(
    //         image: AssetImage("assets/images/icon_pentagram_circle.png"),
    //         width: 18,
    //         height: 18,
    //       ),
    //       Expanded(
    //         child: Container(
    //           // color: Colors.red,
    //           padding: const EdgeInsets.only(
    //               left: 34, top: 16, right: 5, bottom: 16),
    //           decoration: BoxDecoration(
    //               image: DecorationImage(
    //             fit: BoxFit.fill,
    //             //   centerSlice: Rect.fromLTRB(32, 5, 32, 5),
    //             image: bg,
    //           )),
    //           child: Text(
    //             title,
    //             style: TextStyle(
    //               fontSize: 14,
    //               color: textColor,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  /// @description: 报告详情 工商注册核查
  /// @parm:  data 数据
  Widget showReportDetailsBusinessCirclesItem(
    BuildContext context,
    int index,
    CompanyRegistrationInfos data,
  ) {
    String time = "";
    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);
    time = WidgetTools().timeFormat(createTime, "date");

    return Column(children: [
      IntrinsicHeight(
        child: Row(
          children: [
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: CustomColors.colorDAE9FE,
            ),
            Expanded(
              flex: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    "$index",
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 25,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 19,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    data.position,
                    style: const TextStyle(
                      fontSize: 10,
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
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    data.capital,
                    style: const TextStyle(
                      fontSize: 10,
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
          ],
        ),
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColors.colorDAE9FE,
      ),
    ]);
  }

  /// @description: 报告详情 贷款逾期核查
  /// @parm:  data 数据
  Widget showReportDetailsOverdueLoanItem(
    BuildContext context,
    int index,
    LoanInfos data,
  ) {
    String time = "";
    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);
    time = WidgetTools().timeFormat(createTime, "-");

    return Column(children: [
      IntrinsicHeight(
        child: Row(
          children: [
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: CustomColors.colorDAE9FE,
            ),
            Expanded(
              flex: 10,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "$index",
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 27,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    data.bankName,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 23,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 22,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    data.amount,
                    style: const TextStyle(
                      fontSize: 10,
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
              flex: 18,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    data.overdueStatus == 0 ? "否" : "是",
                    style: const TextStyle(
                      fontSize: 10,
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
          ],
        ),
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColors.colorDAE9FE,
      ),
    ]);
  }

  /// @description: 报告详情 公开信息
  /// @parm:  data 数据
  Widget showReportPublicInfoItem(
    BuildContext context,
    int index,
    PublicInformation data,
  ) {
    AssetImage assetImage =
        const AssetImage("assets/images/icon_risk_item.png");
    String name = "";
    int content = 0;
    //1.立案信息 2.开庭公告 3.司法案件 4.判决文书 5.行政处罚 6.失信信息
    // 7.被执行人 8.送达公告 9.终本案件 10.市场监督 11.税收违法 12.法院公告
    switch (data.type) {
      case 1:
        name = "立案信息";
        assetImage =
            const AssetImage("assets/images/icon_filing_information.png");
        break;
      case 2:
        name = "开庭公告";
        assetImage =
            const AssetImage("assets/images/icon_opening_announcement.png");
        break;
      case 3:
        name = "司法案件";
        assetImage = const AssetImage("assets/images/icon_judicial_cases.png");
        break;
      case 4:
        name = "判决文书";
        assetImage =
            const AssetImage("assets/images/icon_judgment_document.png");
        break;
      case 5:
        name = "行政处罚";
        assetImage =
            const AssetImage("assets/images/icon_administrative_sanction.png");
        break;
      case 6:
        name = "失信信息";
        assetImage =
            const AssetImage("assets/images/icon_dishonest_information.png");
        break;
      case 7:
        name = "被执行人";
        assetImage = const AssetImage("assets/images/icon_executed.png");
        break;
      case 8:
        name = "送达公告";
        assetImage =
            const AssetImage("assets/images/icon_service_announcement.png");
        break;
      case 9:
        name = "终本案件";
        assetImage = const AssetImage("assets/images/icon_final_case.png");
        break;
      case 10:
        name = "市场监督";
        assetImage =
            const AssetImage("assets/images/icon_market_supervision.png");
        break;
      case 11:
        name = "税收违法";
        assetImage =
            const AssetImage("assets/images/icon_illegal_taxation.png");
        break;
      case 12:
        name = "法院公告";
        assetImage =
            const AssetImage("assets/images/icon_court_announcement.png");
        break;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
            top: 10,
            bottom: 6,
          ),
          child: Row(
            children: [
              Image(
                width: 18,
                height: 18,
                image: assetImage,
              ),
              const SizedBox(width: 3),
              Text(
                name,
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
            decoration: BoxDecoration(
              color: CustomColors.colorE8F8FE,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(
                color: CustomColors.colorC2DCFF,
                width: 1,
              ),
            ),
            width: double.infinity,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 12, top: 28, right: 12, bottom: 15),
                  child: Text(
                    data.publicCase,
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
        if (index > 1)
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
              margin: const EdgeInsets.only(top: 5, bottom: 15),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 12, top: 28, right: 12, bottom: 15),
                    child: Text(
                      data.punish,
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
                          "处罚",
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
                            color: CustomColors.colorF94E4E,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
      ],
    );
  }

  ClassicalHeader getClassicalHeader() {
    return ClassicalHeader(
      refreshText: '拉动刷新',
      refreshReadyText: '释放刷新',
      refreshingText: '刷新中...',
      refreshedText: '刷新完成',
      refreshFailedText: '刷新失败',
      noMoreText: '没有更多',
      infoText: '更新于 %T',
    );
  }

  ClassicalFooter getClassicalFooter() {
    return ClassicalFooter(
      loadText: '推送加载',
      loadReadyText: '释放加载',
      loadingText: '正在加载...',
      loadedText: '加载完成',
      loadFailedText: '加载失败',
      noMoreText: '没有更多',
      infoText: '更新于 %T',
    );
  }

  /// @description: 新闻列表item
  /// @parm:  data 数据
  ///        itemWidth cell的总宽度
  ///        isBoxShadow 是否显示阴影
  Widget showBackToneCommentItem(
    BuildContext context,
    CommentDataBean data,
    GestureTapCallback fabulous,
    GestureTapCallback more,
  ) {
    Image collection;
    if (data.selfLike == 1) {
      collection = const Image(
        image: AssetImage("assets/images/icon_liked.png"),
        width: 14,
        height: 14,
      );
    } else {
      collection = const Image(
        image: AssetImage("assets/images/icon_not_liked.png"),
        width: 14,
        height: 14,
      );
    }

    var beginTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);
    String time = "${beginTime.year}-${beginTime.month}-${beginTime.day}";

    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 45,
            child: Row(
              children: [
                const Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 30,
                  height: 30,
                ),
                const SizedBox(
                  width: 9,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        "匿名用户",
                        style: TextStyle(
                            fontSize: 14, color: CustomColors.greyBlack),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        time,
                        style: const TextStyle(
                            fontSize: 11, color: CustomColors.darkGrey99),
                      ),
                    ),
                  ],
                )),
                InkWell(
                  onTap: fabulous,
                  child: Row(
                    children: [
                      Text(
                        data.likeCount.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: data.selfLike == 1
                                ? CustomColors.colorFF1C1C
                                : CustomColors.colorB7B7B7),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      collection
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: more,
                  child: const Image(
                    image: AssetImage("assets/images/icon_ellipsis.png"),
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 39.0, bottom: 12.0),
            child: Text(
              softWrap: true,
              // overflow: TextOverflow.ellipsis,
              // maxLines: 3,
              data.content,
              style:
                  const TextStyle(fontSize: 11, color: CustomColors.darkGrey99),
            ),
          ),
        ],
      ),
    );
  }

  Widget showReportItem(
    BuildContext context,
    Map<String, dynamic> data,
    GestureTapCallback callback,
  ) {
    String name = data["name"];
    bool select = data["isSelect"];
    bool isLine = data["isLine"];

    Widget collection;
    if (select) {
      collection = const Image(
        image: AssetImage("assets/images/successful.png"),
        width: 14,
        height: 14,
      );
    } else {
      collection = const SizedBox(
        width: 14,
        height: 14,
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      width: double.infinity,
      height: 45,
      child: Column(
        children: [
          Expanded(
              child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: callback,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 14, color: CustomColors.greyBlack),
                  ),
                ),
                collection,
              ],
            ),
          )),
          if (!isLine)
            Container(
              height: 1,
              width: double.infinity,
              color: CustomColors.colorF1F1F1,
              padding: const EdgeInsets.only(left: 39.0, bottom: 12.0),
            ),
        ],
      ),
    );
  }

  //公司列表
  Widget changeCompanyItem(
    BuildContext context,
    SelectReplaceCompanyBean data,
    GestureTapCallback callback,
  ) {
    String butText = "更换";
    Color bgColor = CustomColors.color3189F6;
    Color butColor = Colors.white;
    // 1已认证 2认证中 3失败
    if (data.verifiedStatus == 1) {
      butText = "更换";
      bgColor = CustomColors.color3189F6;
      butColor = Colors.white;
    } else if (data.verifiedStatus == 2) {
      butText = "认证中";
      bgColor = CustomColors.colorDFDFDF;
      butColor = CustomColors.darkGrey99;
    } else if (data.verifiedStatus == 3) {
      butText = "认证失败";
      bgColor = CustomColors.colorFE0404;
      butColor = Colors.white;
    }

    String headImgUrl =
        "https://static.oss.cdn.oss.gaoshier.cn/image/0a50f76b-1651-441d-a8a1-cd38c688e8e0.jpg";
    if (data.headImgUrl.isNotEmpty) {
      headImgUrl = data.headImgUrl;
    }

    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      width: double.infinity,
      height: 72,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: NetworkImage(headImgUrl),
                  width: 42,
                  height: 42,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              data.name,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 15, color: CustomColors.greyBlack),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data.licenceName,
                          softWrap: true,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 12, color: CustomColors.darkGrey),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: callback,
                  child: Container(
                    width: 66,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: const BorderRadius.all(Radius.circular(33)),
                    ),
                    child: Text(
                      butText,
                      style: TextStyle(
                        color: butColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: CustomColors.color1C0000,
          ),
        ],
      ),
    );
  }

  ///VIP或SVIP
  Widget getMemberLogo(int type) {
    if (type == 1) {
      return Container(
        height: 16,
        width: 42,
        decoration: const BoxDecoration(
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(7.5)),
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE9D0),
              Color(0xFFFFCD95),
            ],
          ),
        ),
        margin: const EdgeInsets.only(right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage("assets/images/icon_vip.png"),
              width: 10,
              height: 10,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "VIP",
              style: TextStyle(
                color: Color(0xFFC59058),
                fontSize: 8,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 16,
        width: 42,
        decoration: const BoxDecoration(
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(7.5)),
          gradient: LinearGradient(
            colors: [
              Color(0xFFFDD41A),
              Color(0xFFFFA303),
            ],
          ),
        ),
        margin: const EdgeInsets.only(right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage("assets/images/icon_svip.png"),
              width: 10,
              height: 10,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "SVIP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget newsItem(
    BuildContext context,
    Data data,
    GestureTapCallback callback,
    GestureTapCallback onTap,
  ) {
    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTimeTs);
    String time = "${createTime.year}.${createTime.month}.${createTime.day}";

    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      // The start action pane is the one at the left or the top side.  startActionPane
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const BehindMotion(),
        extentRatio: 0.25,
        //是否可以拖动删除
        dragDismissible: false,
        // All actions are defined in the children parameter.
        children: [
          InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage("assets/images/icon_delete_button.png"),
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    "删除",
                    style:
                        TextStyle(fontSize: 12, color: CustomColors.greyBlack),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      child: InkWell(
        onTap: callback,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          margin: const EdgeInsets.only(left: 16.0, top: 10, right: 16.0),
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      const Image(
                        image: AssetImage("assets/images/icon_news_item.png"),
                        width: 25,
                        height: 25,
                      ),
                      if (data.readStatus == 0)
                        Container(
                          width: 8,
                          height: 8,
                          //边框设置
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4444),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            //设置四周边框
                            border: Border.all(width: 1, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Expanded(
                    child: Text(
                      "消息提醒",
                      style: TextStyle(
                          fontSize: 15, color: CustomColors.greyBlack),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                        fontSize: 15, color: CustomColors.greyBlack),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                data.title,
                style:
                    const TextStyle(fontSize: 13, color: CustomColors.darkGrey),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: CustomColors.color1C0000,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "查看>",
                    style:
                        TextStyle(fontSize: 13, color: CustomColors.greyBlack),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appointmentReminderItem(
    BuildContext context,
    int index,
    int currentDate,
    GlobalKey current,
    Map<String, dynamic> data,
    MyCallBackListener onTap,
  ) {
    var month = data["month"];
    List<Map<String, dynamic>> bean = data["data"];
    return Container(
        key: index == currentDate ? current : null,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              month,
              style:
                  const TextStyle(fontSize: 22, color: CustomColors.greyBlack),
            ),
            const SizedBox(height: 15),
            Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                children: bean.map<Widget>((Map<String, dynamic> tag) {
                  var name = tag["name"];
                  bool isCheck = tag["isCheck"];
                  return InkWell(
                    onTap: () {
                      tag["isCheck"] = !tag["isCheck"];
                      onTap.myCallBack();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15, bottom: 8),
                      decoration: BoxDecoration(
                        color:
                            isCheck ? CustomColors.connectColor : Colors.white,
                        border: Border.all(
                            color: isCheck
                                ? CustomColors.connectColor
                                : CustomColors.colorBBBBBB,
                            width: 1.0),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              isCheck ? Colors.white : CustomColors.greyBlack,
                        ),
                      ),
                    ),
                  );
                }).toList())
          ],
        ));
  }

  Widget examReminderItem(
    BuildContext context,
    Map<String, dynamic> data,
    DateTime now,
    GestureTapCallback callback,
  ) {
    var title = "";
    var time = data["time"];
    var topping = data["topping"];
    var remind = data["remind"];
    var split = time.split("-");
    var choice =
        DateTime(int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));

    //是否在choice之后 false
    var after = now.isBefore(choice);

    var atSameMomentAs = now.isAtSameMomentAs(choice);
    var inDays = choice.difference(now).inDays;

    if (inDays < 0) {
      inDays = inDays.abs();
    }

    Color bgColor;
    Color color;

    if (after || atSameMomentAs) {
      //没过期
      bgColor = Colors.white;
      color = CustomColors.connectColor;
      title = data["title"];
    } else {
      //过期了
      bgColor = CustomColors.colorBEBEBE;
      color = CustomColors.colorED1717;
      title = "${data["title"]} 已经过去";
    }

    return InkWell(
      onTap: callback,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: bgColor,
          boxShadow: const [
            BoxShadow(
              color: CustomColors.color80ECECEC,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.greyBlack,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "$time",
                    style: const TextStyle(
                      color: CustomColors.darkGrey99,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 10, top: 8, right: 10, bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: color,
              ),
              child: Row(
                children: [
                  Text(
                    "$inDays",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  const Text(
                    "天",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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

  Widget salaryQueryItem(
    BuildContext context,
    String data,
    bool isOne,
    GestureTapCallback callback,
  ) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: callback,
      child: Container(
        height: 56,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 18, right: 18),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      data,
                      style: const TextStyle(
                        color: CustomColors.greyBlack,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (!isOne)
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: const Color(0xFFEDEDED),
            ),
          ],
        ),
      ),
    );
  }

  Widget salaryQueryTwoItem(
    BuildContext context,
    SalaryEvaluationBean data,
    GestureTapCallback callback,
  ) {
    Color color;
    if (data.isSelect) {
      color = Colors.white;
    } else {
      color = const Color(0xFFF6F5FA);
    }

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: callback,
      child: Container(
        color: color,
        height: 56,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                data.label2,
                style: const TextStyle(
                  color: CustomColors.greyBlack,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget salaryQueryThreeItem(
    BuildContext context,
    String data,
    GestureTapCallback callback,
  ) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: callback,
      child: Container(
        height: 56,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 18, right: 18),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      data,
                      style: const TextStyle(
                        color: CustomColors.greyBlack,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: const Color(0xFFEDEDED),
            ),
          ],
        ),
      ),
    );
  }

  Widget salaryQuerySearchItem(
    BuildContext context,
    SalaryEvaluationBean data,
    GestureTapCallback callback,
  ) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.only(left: 18, top: 10, right: 18, bottom: 10),
        child: Row(
          children: [
            Text(
              "${data.label1}-${data.label2}-${data.name}",
              style: const TextStyle(
                color: CustomColors.greyBlack,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget demandCenterItem(
    BuildContext context,
    DemandCenterData data,
    GestureTapCallback callback,
    GestureTapCallback tel,
  ) {
    String time = "";
    if (data.createTime <= 0) {
      time = "发布时间：刚刚";
    } else {
      var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTime);
      time = "发布时间：${formatDate(createTime, [
            yyyy,
            '-',
            mm,
            '-',
            dd,
            " ",
            HH,
            ':',
            nn,
            ':',
            ss
          ])}";
    }
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: callback,
      child: Container(
        width: double.infinity,
        // height: 160,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Image(
                image: AssetImage("assets/images/icon_demand_not_expired.png"),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 16, top: 14, right: 16, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: CustomColors.greyBlack,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        data.budget > 0 ? "¥${data.budget.toInt()}" : "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: CustomColors.greyBlack,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(
                      color: CustomColors.darkGrey99,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.colorEDF6F6,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: CustomColors.connectColor,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          time,
                          style: const TextStyle(
                            color: CustomColors.darkGrey99,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: tel,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, top: 3, right: 20, bottom: 3),
                          decoration: const BoxDecoration(
                            color: CustomColors.connectColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.5)),
                          ),
                          child: const Text(
                            "立即联系",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myNeedsItem(
    BuildContext context,
    MyNeedsData data,
    DateTime dateTime,
    GestureTapCallback details,
    GestureTapCallback again,
    GestureTapCallback delete,
  ) {
    String time = "";
    if (data.status == 2) {
      time = "当前任务已过期";
    } else {
      var createTime = DateTime.fromMillisecondsSinceEpoch(data.validTime);
      var difference = createTime.difference(dateTime);
      time =
          "${difference.inDays}天${difference.inHours - (difference.inDays * 24)}小时后过期";
    }

    String assetName;
    if (data.status != 2) {
      assetName = "assets/images/icon_demand_not_expired.png";
    } else {
      assetName = "assets/images/icon_demand_expiration.png";
    }

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: details,
      child: Container(
        width: double.infinity,
        // height: 160,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        margin: const EdgeInsets.only(left: 16, top: 10, right: 16),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Image(
                image: AssetImage(assetName),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 16, top: 12, right: 16, bottom: 12),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (data.status == 3)
                        PopupMenuButton(
                          offset: const Offset(-2.0, 2.0),
                          color: Colors.transparent,
                          elevation: 0,
                          enabled: true,
                          padding: const EdgeInsets.all(0.0),
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                enabled: false,
                                padding: const EdgeInsets.all(0.0),
                                value: "dota",
                                child: Stack(
                                  children: [
                                    const Positioned(
                                      left: 0,
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/icon_popup_bg.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 14,
                                          top: 13,
                                          right: 6,
                                          bottom: 6),
                                      width: double.infinity,
                                      child: Text(
                                        data.reportDetail.isEmpty
                                            ? "您发布的内容被举报次数过多可能涉嫌违规已被强制下架，请编辑后重新发布或删除该需求。"
                                            : data.reportDetail.trim(),
                                        style: const TextStyle(
                                          color: Color(0xFFF61B1B),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ];
                          },
                          child: Row(
                            children: const [
                              Image(
                                image: AssetImage(
                                    "assets/images/icon_demand_warning.png"),
                                width: 15,
                                height: 15,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 8,
                              )
                            ],
                          ),
                        ),
                      Expanded(
                        child: Text(
                          data.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: CustomColors.greyBlack,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        data.budget > 0 ? "¥${data.budget.toInt()}" : "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: CustomColors.greyBlack,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(
                      color: CustomColors.darkGrey99,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.colorEDF6F6,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "过期时间",
                        style: TextStyle(
                          color: CustomColors.greyBlack,
                          fontSize: 11,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: CustomColors.connectColor,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              time,
                              style: const TextStyle(
                                color: CustomColors.darkGrey99,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          if (data.status == 2)
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: again,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.only(
                                    left: 20, top: 3, right: 20, bottom: 3),
                                decoration: const BoxDecoration(
                                  color: CustomColors.connectColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.5)),
                                ),
                                child: const Text(
                                  "重新发布",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: delete,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 32, top: 3, right: 32, bottom: 3),
                              decoration: const BoxDecoration(
                                color: CustomColors.redColor61B,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.5)),
                              ),
                              child: const Text(
                                "删除",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// @description: 新闻列表item
  /// @parm:  data 数据
  Widget showHomeNewsViewItem(
    BuildContext context,
    NewsDetailsModel data,
    listItemAction,
  ) {
    String title = data.title;
    String picture = "";
    if (!StringTools.isEmpty(data.coverImage)) {
      picture = data.coverImage!;
    }

    String source = data.from;
    String date = data.releaseTime;

    Widget image;
    if (!StringTools.isEmpty(picture)) {
      if (picture.contains("mp4")) {
        picture +=
            "?spm=qipa250&x-oss-process=video/snapshot,t_7000,f_jpg,w_800,h_600,m_fast";
      }
      image = Container(
        margin: const EdgeInsets.only(right: 18.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Image(
            image: NetworkImage(picture),
            width: 115,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      image = const SizedBox();
    }

    Expanded titleText = Expanded(
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: CustomColors.textDarkColor,
          fontSize: 14.0,
        ),
        maxLines: 3,
      ),
    );

    Text sourceText = Text(
      "    新闻来源:$source",
      style: const TextStyle(fontSize: 10.0, color: CustomColors.lightGrey),
    );

    Text dateText = Text(
      date,
      style: const TextStyle(fontSize: 10.0, color: CustomColors.lightGrey),
    );

    Expanded expanded = Expanded(
      child: Row(
        // children: [sourceText, dateText, readText],
        children: [
          dateText,
          sourceText,
        ],
      ),
    );

    return InkWell(
      onTap: listItemAction,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: 106,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            padding: const EdgeInsets.only(top: 15, bottom: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                image,
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        titleText,
                        expanded,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: CustomColors.colorF1F1F1,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          ),
        ],
      ),
    );
  }

  String timeFormat(DateTime time, String interval) {
    if (interval == "date") {
      if (time.day <= 1) {
        //判断月
        if (time.month <= 1) {
          return "${time.year}年";
        } else {
          return "${time.year}年${time.month}月";
        }
      } else {
        return "${time.year}年${time.month}月${time.day}日";
      }
    } else {
      if (time.day <= 1) {
        //判断月
        if (time.month <= 1) {
          return "${time.year}";
        } else {
          return "${time.year}$interval${time.month}";
        }
      } else {
        return "${time.year}$interval${time.month}$interval${time.day}";
      }
    }
  }

  void showNotLoggedIn(BuildContext context) {
    var screenWidth = ScreenTool.screenWidth * 0.8;
    var screenHeight = screenWidth * 1.153;
    UmengCommonSdk.onEvent("LoginPopup", {"type": "count"});
    showDialog(
      context: context,
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  const Image(
                    image: AssetImage("assets/images/icon_not_logged_in.png"),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              UmengCommonSdk.onEvent(
                                  "click_nologin", {"type": "count"});
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: screenWidth,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: CustomColors.color979797, width: 1),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(17.5),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "暂不登录",
                                  style: TextStyle(
                                      color: CustomColors.darkGrey99,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 36,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              UmengCommonSdk.onEvent(
                                  "click_login", {"type": "count"});
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginTypePage()));
                            },
                            child: Container(
                              width: screenWidth,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: CustomColors.connectColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(17.5),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "立即登录",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void showComment(BuildContext buildContext) {
    var screenWidth = ScreenTool.screenWidth * 0.65;
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
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text(
                        "觉得好用就留下个评价吧",
                        style: TextStyle(
                          color: CustomColors.greyBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.lightGrey,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                        if (Platform.isIOS) {
                          AppInstaller.goStore(
                              "com.nowcheck.hycha", "6444669734",
                              review: true);
                        } else if (Platform.isAndroid) {
                          _toMarket();
                        }
                      },
                      child: const Center(
                        child: Text(
                          "挺好! 给个好评",
                          style: TextStyle(
                            color: CustomColors.connectColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.lightGrey,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                        showFeedback(buildContext);
                      },
                      child: const Center(
                        child: Text(
                          "不好用，去反馈",
                          style: TextStyle(
                            color: CustomColors.connectColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: CustomColors.lightGrey,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                        child: Text(
                          "我再用用",
                          style: TextStyle(
                            color: CustomColors.connectColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void showFeedback(BuildContext buildContext) {
    var screenWidth = ScreenTool.screenWidth * 0.85;
    var businessLicense = TextEditingController();

    showDialog(
      context: buildContext,
      builder: (context) {
        return StatefulBuilder(builder: (context, update) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.clear),
                          color: CustomColors.greyBlack,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        bottom: 12,
                      ),
                      child: const Center(
                        child: Text(
                          "请留下您宝贵的意见，我们会做的更好!",
                          style: TextStyle(
                            color: CustomColors.greyBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          width: 1,
                          color: CustomColors.lightGrey,
                        ),
                      ),
                      margin: const EdgeInsets.only(left: 18, right: 18),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextField(
                            minLines: 3,
                            maxLines: 10,
                            textAlign: TextAlign.start,
                            onChanged: (text) {
                              update(() {});
                            },
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(50),
                              // FilteringTextInputFormatter.deny(
                              //   RegExp(
                              //       "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"),
                              // ),
                            ],
                            controller: businessLicense,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              isCollapsed: true,
                              hintText: "请输入",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: CustomColors.lightGrey,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${businessLicense.text.length}/50",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: CustomColors.lightGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (businessLicense.text.toString().isEmpty) {
                          ToastUtils.showMessage("请填写要反馈的内容");
                          return;
                        }

                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        }

                        VersionManager.addOpinion(
                            businessLicense.text.toString(), (str) {
                          ToastUtils.showMessage("反馈成功");
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 16),
                        width: 120,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: CustomColors.connectColor,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: const Center(
                          child: Text(
                            "提交",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }

  final List<String> _marketUrls = [
    "vivomarket://details?id=com.nowcheck.hycha&th_name=need_comment",
    "oaps://mk/developer/comment?pkg=com.nowcheck.hycha",
    "appmarket://details?id=com.nowcheck.hycha",
    "mimarket://details?id=com.nowcheck.hycha",
  ];

  //"itms-apps://itunes.apple.com/app/com.nowcheck.hycha?action=write-review",

  Future<String> _getLaunchUrl() async {
    for (String item in _marketUrls) {
      if (await canLaunchUrl(Uri.parse(item))) {
        return item;
      }
    }
    return "";
  }

  // 评分按钮点击事件调用：
  Future<void> _toMarket() async {
    String url = (await _getLaunchUrl());
    // 评分引导弹窗出现的时机调用：
    if (url.isNotEmpty) {
      // 显示评分引导弹窗
      await launchUrl(Uri.parse(url));
    } else {
      await launchUrl(Uri.parse("market://details?id=com.nowcheck.hycha"));
    }
  }

  /// 保存图片到相册
  Future<dynamic> saveImage(GlobalKey key) async {
    EasyLoading.show();
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      EasyLoading.dismiss();
      ToastUtils.showMessage("操作成功");
    }
  }

  ///给定宽度 计算文本可以显示多少字
  int computationalText(double width, TextStyle style) {
    String str =
        "说明：未知情的情况下被冒名申请网贷查询，各类网络贷款黑名单查询。包括：乐*花、**享借、易*购、**借钱、*借款、**钱包、快*花、*借等100+网络贷款公司。";

    TextPainter painter = TextPainter(
      maxLines: 1,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: str,
        style: style,
      ),
    );
    painter.layout(maxWidth: width);

    ///获取文本的像素宽度和字体大小
    double textWidth = painter.width;
    double characterWidth = textWidth / str.length;
    int characterCount = (textWidth / characterWidth).floor();
    return characterCount;
  }

  /// *
  /// -  @description: 点击图片预览（单张）
  /// -  @parm: String imgUrl 图片的url，只接受网络图片
  void tapImagePreview(BuildContext buildContext, String imgUrl) {
    showDialog(
      context: buildContext,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imgUrl),
                );
              },
              itemCount: 1,
              backgroundDecoration: null,
              enableRotation: true,
            ),
          ),
        );
      },
    );
  }
}
