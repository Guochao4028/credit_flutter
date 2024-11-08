/// *
/// -  @Date: 2022-09-19 14:41
/// -  @LastEditTime: 2022-09-19 14:41
/// -  @Description: 个人首页基类
///
import 'package:credit_flutter/models/user_model.dart';
import 'package:flutter/material.dart';

class PersonIndexView {
  List<String> showList = [
    "失信被执行人",
    "社会不良信息",
    "学历相关信息",
    "终本执行案件",
    "裁判文书信息",
    "税务违法信息",
    "违法行业禁止",
    "失信被执行人信息",
    "限制消费人员",
    "限飞限乘名单",
  ];
  bool isInputUM = false;
  PersonIndexViewClickListener? clickListener;
  UserModel userModel;
  PersonIndexView(
      {required this.clickListener,
      required this.userModel,
      required this.isInputUM});
  Widget appBar(String titleStr) {
    //标题
    Widget titleView = Container(
      alignment: Alignment.center,
      child: Text(
        titleStr,
        style: const TextStyle(fontSize: 17),
      ),
    );

    return Row(
      children: [
        const SizedBox(
          width: 94,
        ),
        Expanded(
          child: titleView,
        ),
        const SizedBox(
          width: 94,
        ),
      ],
    );
  }

  Widget contentView(BuildContext context) {
    return const Text("contentView");
  }
}

abstract class PersonIndexViewClickListener {
  tapGoCertification();
  tapShare();
  tapDownload(UserModel model);
  tapUpdate(UserModel model);
  tapBuy();
  tapCheck(UserModel model);
  tapResend(UserModel userModel);
  example();
  tapPurchaseReport(Map<String, dynamic> map);
}
