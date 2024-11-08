/// *
/// -  @Date: 2022-06-22 15:40
/// -  @LastEditTime: 2022-06-22 15:49
/// -  @Description: 自定义 弹窗
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:flutter/material.dart';

class NewPopupWindowDialog extends Dialog {
  ///标题
  final String title;

  ///内容
  final String? content;

  ///取消文案
  final String? cancel;

  final GestureTapCallback? cancelOnTap;

  ///确认文案
  final String? confirm;

  final GestureTapCallback? confirmOnTap;

  ///内容的边距
  final EdgeInsets contentEdgeInsets;

  ///内容字体
  final TextStyle contentStyle;

  ///内容对齐方式
  final TextAlign contentAlign;

  ///是否显示取消按钮
  final bool showCancel;

  const NewPopupWindowDialog({
    super.key,
    this.title = '标题',
    this.cancel = '取消',
    this.confirm = '确定',
    this.content = '',
    this.showCancel = true,
    this.contentEdgeInsets = EdgeInsets.zero,
    this.contentStyle =
        const TextStyle(fontSize: 15, color: CustomColors.greyBlack),
    this.contentAlign = TextAlign.left,
    this.cancelOnTap,
    this.confirmOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(38),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
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
              margin: const EdgeInsets.only(top: 22, bottom: 14),
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CustomColors.greyBlack),
              ),
            ),

            /// 内容
            Offstage(
              offstage: content!.isEmpty,
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 17),
                padding: contentEdgeInsets,
                child: Text(
                  content!,
                  textAlign: contentAlign,
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
    if (showCancel!) {
      return Container(
        height: 43,
        margin: const EdgeInsets.only(bottom: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: cancelOnTap,
              child: Container(
                width: 120,
                height: 35,
                margin: const EdgeInsets.only(left: 12),
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
                  cancel!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.lightGrey,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: confirmOnTap,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
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
                  confirm!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CustomColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: confirmOnTap,
        child: Container(
          height: 35,
          width: 120,
          margin: const EdgeInsets.only(bottom: 22),
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
          alignment: Alignment.center,
          child: Text(
            confirm!,
            style: const TextStyle(
                fontSize: 14,
                color: CustomColors.lightGrey,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
