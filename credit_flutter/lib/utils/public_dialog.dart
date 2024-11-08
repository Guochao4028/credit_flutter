/// *
/// -  @Date: 2022-06-22 15:40
/// -  @LastEditTime: 2022-06-22 15:49
/// -  @Description: 自定义 弹窗
///

import 'dart:ui';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';

class PublicDialog extends Dialog {
  ///标题
  final String title;

  ///内容
  final String content;

  ///功能按钮文案
  final String functionTitle;

  ///取消文案
  final String cancelTitle;

  ///标题字体
  final TextStyle titleStyle;

  ///内容字体
  final TextStyle contentStyle;

  ///是否显示功能按钮
  final bool showFunction;

  ///是否显示取消按钮
  final bool showCancel;

  final ClickListener? clickListener;

  const PublicDialog(
      {this.title = "",
      this.content = "",
      this.functionTitle = "",
      this.cancelTitle = "",
      this.titleStyle = const TextStyle(
        fontSize: 18,
        color: CustomColors.textDarkColor,
        fontWeight: FontWeight.bold,
      ),
      this.contentStyle = const TextStyle(
        fontSize: 18,
        color: CustomColors.textDarkColor,
      ),
      this.showFunction = true,
      this.showCancel = true,
      this.clickListener,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 210,
        ),
        width: double.infinity,
        margin: const EdgeInsets.all(38),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///标题
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 28),
              child: Text(
                title,
                style: titleStyle,
              ),
            ),

            /// 内容
            Offstage(
              offstage: content.isEmpty,
              child: Container(
                margin: const EdgeInsets.only(bottom: 17),
                padding: const EdgeInsets.only(left: 38, right: 38),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: contentStyle,
                ),
              ),
            ),

            _getBottomWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _getBottomWidget(context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 30, bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // ///是否显示功能按钮
          //   final bool showFunction;
          //
          //   ///是否显示取消按钮
          //   final bool ;
          if (showCancel)
            InkWell(
              child: Container(
                width: 120,
                height: 35,
                // margin: const EdgeInsets.only(left: 12),
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    side: BorderSide(
                      width: 1,
                      color: CustomColors.lightGrey,
                    ),
                  ),
                ),
                child: Text(
                  cancelTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.lightGrey,
                  ),
                ),
              ),
              onTap: () => {
                Navigator.of(context).pop(),
                clickListener?.onCancel(),
              },
            ),
          if (showCancel && showFunction)
            const SizedBox(
              width: 12,
            ),
          if (showFunction)
            InkWell(
              child: Container(
                // margin: const EdgeInsets.only(right: 12),
                width: 120,
                height: 35,
                decoration: const ShapeDecoration(
                  color: CustomColors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    side: BorderSide(
                      width: 0,
                      color: CustomColors.lightGrey,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  functionTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.whiteColor,
                  ),
                ),
              ),
              onTap: () => {
                Navigator.of(context).pop(),
                clickListener?.onConfirm(),
              },
            ),
        ],
      ),
    );
  }
}

abstract class ClickListener {
  void onConfirm();

  void onCancel();
}
