/// *
/// -  @Date: 2023-09-18 16:30
/// -  @LastEditTime: 2023-09-18 16:32
/// -  @Description: 首页 说明弹窗
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';

class InstructionsWindowDialog extends Dialog {
  const InstructionsWindowDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      constrainedAxis: Axis.horizontal,
      child: Column(
        children: [
          const Center(
            child: Text(
              "快速了解 “慧眼查”\n个人自查/员工背调",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _popupItem("assets/images/1qushi.png", "信息全",
                    "金融风险、社会不良、司法风险、工商信息", false),
                _popupItem("assets/images/2renshu.png", "受众广",
                    "1000+合作企业、19,443,552+背调报告", false),
                _popupItem("assets/images/3anquan.png", "数据权威可靠",
                    "金融风险、社会不良、司法风险、工商信息", true),
                const SizedBox(
                  height: 18,
                ),
                WidgetTools().createCustomButton(
                    double.infinity, "我知道了", () => Navigator.of(context).pop(),
                    bgColor: Colors.white,
                    textColor: CustomColors.lightBlue,
                    fontWeight: FontWeight.w900,
                    radius: 32,
                    height: 50,
                    borderColor: CustomColors.lightBlue,
                    shadow: const BoxShadow(),
                    fontSize: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _popupItem(
    String iconStr,
    String titleStr,
    String contentStr,
    bool isImage,
  ) {
    TextStyle itemStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 18,
    );

    TextStyle contentStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 16,
    );
    Widget conentView;

    if (isImage == true) {
      conentView = Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: const Image(
              image: AssetImage("assets/images/shuomin.png"),
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          const Text(
            "个人和企业背调查询平台",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "中国",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                TextSpan(
                  text: "千万+",
                  style: TextStyle(
                    fontSize: 25,
                    color: CustomColors.redColor61B,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "用户的选择",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
        ],
      );
    } else {
      conentView = Text(
        contentStr,
        style: contentStyle,
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        image: DecorationImage(
          image: AssetImage('assets/images/1bg.png'),
          fit: BoxFit.fill,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(2, 2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage(iconStr),
                width: 22,
                height: 22,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                titleStr,
                style: itemStyle,
              ),
            ],
          ),
          const SizedBox(height: 2),
          conentView,
        ],
      ),
    );
  }
}
