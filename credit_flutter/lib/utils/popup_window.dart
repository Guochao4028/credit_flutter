/// *
/// -  @Date: 2022-06-22 15:40
/// -  @LastEditTime: 2022-06-22 15:49
/// -  @Description: 自定义 弹窗
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';

class PopupWindowDialog extends Dialog {
  ///标题
  final String title;

  ///内容
  final String? content;

  ///内容图片
  final String? contentImage;

  // ///取消背景颜色
  // final Color? cancelColor;

  ///取消文案
  final String? cancel;

  // ///确认背景颜色
  // final Color? confirmColor;

  ///确认文案
  final String? confirm;

  ///内容的边距
  final EdgeInsets contentEdgeInsets;

  ///内容字体
  final TextStyle contentStyle;

  ///内容对齐方式
  final TextAlign contentAlign;

  ///弹窗标示
  final String identity;

  ///是否显示取消按钮
  final bool? showCancel;
  final ClickListener? clickListener;
  final double maxHeight;

  const PopupWindowDialog(
      {
      // this.cancelColor = Colors.white,
      // this.confirmColor = CustomColors.lightBlue,
      this.title = '标题',
      this.cancel = '取消',
      this.confirm = '确定',
      this.content = '',
      this.showCancel = true,
      this.contentImage = "",
      this.identity = "",
      this.clickListener,
      this.contentEdgeInsets = EdgeInsets.zero,
      this.contentStyle =
          const TextStyle(fontSize: 15, color: CustomColors.greyBlack),
      this.contentAlign = TextAlign.left,
      this.maxHeight = 255,
      Key? key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
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

            /// 内容图片
            _contentImage(context),

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

  Widget _contentImage(context) {
    Widget widget;
    if (StringTools.isEmpty(contentImage)) {
      widget = const SizedBox(
        height: 0,
      );
    } else {
      widget = SizedBox(
        width: 43,
        height: 43,
        child: Image(
          image: AssetImage(contentImage!),
          fit: BoxFit.fill,
        ),
      );
    }

    return widget;
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
              onTap: () => {
                clickListener?.onCancel(),
                Navigator.of(context).pop(),
              },
            ),
            InkWell(
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
              onTap: () => {
                Navigator.of(context).pop(),
                clickListener
                    ?.onConfirm({"title": confirm!, "identity": identity}),
              },
            ),
          ],
        ),
      );
    } else {
      return InkWell(
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
        onTap: () => {
          clickListener?.onConfirm({"title": confirm!, "identity": identity}),
          Navigator.of(context).pop(),
        },
      );
    }
  }
}

abstract class ClickListener {
  void onConfirm(Map<String, dynamic> confirmMap);

  void onCancel();
}

/// *
/// -  @description: 授权弹窗
/// -  @Date: 2022-07-11 11:28
/// -  @parm:
/// -  @return {*}
///
class AuthorizationPopupWindowDialog extends Dialog {
  ///授权码
  final String authorizationCode;
  final ClickListener? clickListener;

  const AuthorizationPopupWindowDialog(
      {Key? key, this.authorizationCode = '', this.clickListener});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
            // maxHeight: 433,
            ),
        width: double.infinity,
        margin: const EdgeInsets.all(38),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
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
              margin: const EdgeInsets.only(top: 28, bottom: 20),
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: Image.asset("assets/images/alertIcon.png"),
            ),
            const Text(
              "您的专属授权码",
              style: TextStyle(fontSize: 14, color: CustomColors.lightGrey),
            ),

            Container(
              margin: const EdgeInsets.only(top: 14, bottom: 22),
              child: Text(
                authorizationCode,
                style: const TextStyle(
                  fontSize: 36,
                  color: CustomColors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 35, right: 35),
              margin: const EdgeInsets.only(bottom: 8),
              child: const Text(
                "该授权码可以分享给您需要查看员工背调报告的用户，让用户在报告页面点击分享按钮后填入后进行授权即可。",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.lightGrey,
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
    return InkWell(
      child: Container(
        height: 35,
        width: 209,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: const ShapeDecoration(
          color: CustomColors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "复制授权码",
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () => {
        clickListener
            ?.onConfirm({"title": "authorizationCode", "identity": "99"}),
        Navigator.of(context).pop(),
      },
    );
  }
}
