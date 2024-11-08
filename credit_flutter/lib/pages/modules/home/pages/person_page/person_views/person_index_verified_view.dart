/// *
/// -  @Date: 2022-09-19 14:40
/// -  @LastEditTime: 2022-09-19 14:40
/// -  @Description: 用户未认证 页面
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/person_views/person_index_view.dart';
import 'package:flutter/material.dart';

class PersonIndexVerifiedView extends PersonIndexView {
  // List<String> showList = [
  //   "失信被执行人",
  //   "社保个税信息",
  //   "职场学历信息",
  //   "终本执行案件",
  //   "裁判文书信息",
  //   "税务违法信息",
  //   "违法行业禁止",
  //   "失信被执行人信息",
  //   "限制消费人员",
  //   "限飞限乘名单",
  // ];

  PersonIndexVerifiedView(
      {required super.clickListener,
      required super.userModel,
      required super.isInputUM});

  @override
  Widget contentView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _heardView(),
          _promptView(),
          _classifiedInformationView(),
          _button(),
        ],
      ),
    );
  }

  Widget _heardView() {
    return Container(
      margin: const EdgeInsets.only(top: 17, bottom: 6),
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/ph.png",
        width: 198,
        height: 202,
      ),
    );
  }

  Widget _promptView() {
    return Container(
      height: 56,
      width: 300,
      margin: const EdgeInsets.only(bottom: 3),
      alignment: Alignment.center,
      child: const Text(
        "个人使用者需要认证后才可以下载或购买自己的信用报告",
        style: TextStyle(
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _classifiedInformationView() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: CustomColors.connectColor),
        borderRadius: BorderRadius.circular((8.0)),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: 272,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 0, right: 0),
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              color: CustomColors.connectColor,
            ),
            child: const Text(
              "认证后可查询",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 180,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(), //禁止滑动
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 147 / 21,
                crossAxisCount: 2,
                //水平单个子Widget之间间距
                mainAxisSpacing: 10.0,

                //垂直单个子Widget之间间距
                crossAxisSpacing: 10.0,
              ),
              // itemCount: itmeList.length,
              itemCount: showList.length,
              itemBuilder: (BuildContext context, int index) {
                //自定义的行 代码在下面

                return _showGridViewItem(context, showList[index], index);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 1,
            child: Container(
              color: CustomColors.darkGreyE5,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 28,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: "*共记",
                      style: TextStyle(
                          color: CustomColors.darkGrey99, fontSize: 13.0)),
                  TextSpan(
                    text: "20",
                    style: TextStyle(
                        color: CustomColors.redColor61B, fontSize: 13.0),
                  ),
                  TextSpan(
                      text: "类个人信息",
                      style: TextStyle(
                          color: CustomColors.darkGrey99, fontSize: 13.0)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showGridViewItem(BuildContext context, String titleStr, int index) {
    Color textNumberColor = Colors.red;
    String number = (index + 1).toString();

    switch (index) {
      case 0:
        textNumberColor = CustomColors.redColorD46;
        break;
      case 1:
        textNumberColor = CustomColors.redColor704;
        break;
      default:
        textNumberColor = CustomColors.redColor914;
    }

    Widget numberView = SizedBox(
      width: 18,
      height: 17,
      child: Text(
        number,
        style: TextStyle(
          color: textNumberColor,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        textAlign: TextAlign.start,
      ),
    );

    Widget titleView = SizedBox(
      width: 120,
      height: 21,
      child: Text(
        titleStr,
        style: const TextStyle(
          color: CustomColors.lightBlue,
          fontSize: 15,
        ),
        textAlign: TextAlign.start,
      ),
    );

    return Container(
      width: 147,
      height: 21,
      child: Row(
        children: <Widget>[
          numberView,
          const Expanded(child: SizedBox()),
          titleView,
        ],
      ),
    );
  }

  Widget _button() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 20),
      child: InkWell(
        onTap: () {
          super.clickListener?.tapGoCertification();
        },
        child: SizedBox(
          width: 315,
          height: 50,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            child: Container(
              color: CustomColors.connectColor,
              width: double.infinity,
              height: double.infinity,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "去认证",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
