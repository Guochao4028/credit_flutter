/// *
/// -  @Date: 2023-09-06 11:29
/// -  @LastEditTime: 2023-09-06 11:29
/// -  @Description: 综合页面 企业 常见问题
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/faq_model.dart';
import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class IndexSynthesisCompanyFAQView extends StatefulWidget {
  List faqList;
  IndexSynthesisCompanyFAQView({super.key, required this.faqList});

  @override
  State<IndexSynthesisCompanyFAQView> createState() =>
      _IndexSynthesisCompanyFAQViewState();
}

class _IndexSynthesisCompanyFAQViewState
    extends State<IndexSynthesisCompanyFAQView> {
  bool question1 = false;
  bool question2 = false;

  List _faqList = [];

  double listHigth = 500;

  @override
  Widget build(BuildContext context) {
    _faqList = widget.faqList;
    return contentView();
  }

  Widget contentView() {
    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/icon_left_line.png"),
                width: 52,
                height: 3,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                '常见问题',
                style: TextStyle(
                  fontSize: 16.0,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Image(
                image: AssetImage("assets/images/icon_right_line.png"),
                width: 52,
                height: 3,
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: _faqList.length,
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return questionOne(_faqList[index], index);
          },
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        )
      ],
    );
  }

  Widget questionOne(FAQModel data, int index) {
    String title = "${index + 1}. " + data.title;
    String content = data.content;
    Widget widget;
    if (content.contains("&&")) {
      List<String> splitValues = content.split("&&");
      widget = Column(
        children: [
          Text(splitValues[0]),
          Image.asset("assets/images/shuomin.png"),
          Text(splitValues[1]),
        ],
      );
    } else {
      widget = Text(content);
    }

    bool isSeleced = data.isSeleced;
    return Column(
      children: [
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            UmengCommonSdk.onEvent('ClickFAQNumber', {"tapProblem": title});

            for (FAQModel map in _faqList) {
              map.isSeleced = false;
            }
            FAQModel map = _faqList[index];
            map.isSeleced = !isSeleced;

            setState(() {});
          },
          child: Row(
            children: [
              Icon(isSeleced
                  ? Icons.arrow_drop_down_sharp
                  : Icons.arrow_drop_up_sharp),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: isSeleced,
          child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: widget),
        ),
      ],
    );
  }
}
