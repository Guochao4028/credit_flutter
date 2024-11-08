/// *
/// -  @Date: 2022-08-04 15:01
/// -  @LastEditTime: 2022-08-04 16:43
/// -  @Description: 支付跳转的中间页view
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';

class PayMiddleView {
  PayMiddleViewClickListener? clickListener;
  int pageIntoNumber = 0;
  Widget successfulContentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///图标
        _successfulIconView(),

        ///标题
        _successfulTitleView(),

        const SizedBox(
          height: 13,
        ),

        WidgetTools().createCustomButton(
          224,
          "去看看",
          () => clickListener?.tapClick(),
          bgColor: CustomColors.lightBlue,
          textColor: Colors.white,
          radius: 32,
          height: 50,
          shadow: const BoxShadow(),
        ),
      ],
    );
  }

  Widget _successfulIconView() {
    return Container(
        margin: const EdgeInsets.only(top: 77),
        alignment: Alignment.center,
        width: 115,
        height: 115,
        child: Image.asset("assets/images/payfinish.png"));
  }

  Widget _successfulTitleView() {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      alignment: Alignment.center,
      child:  Column(
        children: const [
          Text(
            "恭喜您",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 13,
          ),
          Text(
            "本次交易成功～",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget failureContentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///图标
        _failureIconView(),

        ///标题
        _failureTitleView(),

        const SizedBox(
          height: 13,
        ),

        WidgetTools().createCustomButton(
          224,
          "去看看",
          () => clickListener?.tapClick(),
          bgColor: CustomColors.lightBlue,
          textColor: Colors.white,
          radius: 32,
          height: 50,
          shadow: const BoxShadow(),
        ),
      ],
    );
  }

  Widget _failureIconView() {
    return Container(
        margin: const EdgeInsets.only(top: 77),
        alignment: Alignment.center,
        width: 115,
        height: 115,
        child: Image.asset("assets/images/icon_abnormal.png"));
  }

  Widget _failureTitleView() {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      alignment: Alignment.center,
      child: Column(
        children: const [
          Text(
            "抱歉",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 13,
          ),
          Text(
            "本次交易失败～",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingContentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///图标
        _loadingIconView(),

        ///标题
        _titleView(),
      ],
    );
  }

  Widget _loadingIconView() {
    return Container(
        margin: const EdgeInsets.only(top: 108),
        alignment: Alignment.center,
        width: 149,
        height: 143,
        child: Image.asset("assets/images/loading.png"));
  }

  Widget _titleView() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      alignment: Alignment.center,
      child: const Text(
        "努力跳转中",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

abstract class PayMiddleViewClickListener {
  ///去看看
  tapClick();
}
