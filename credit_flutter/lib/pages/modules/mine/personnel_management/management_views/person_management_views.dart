/// *
/// -  @Date: 2022-09-06 17:13
/// -  @LastEditTime: 2022-09-06 17:15
/// -  @Description:
///
/// *
/// -  @Date: 2022-09-06 17:13
/// -  @LastEditTime: 2022-09-06 17:13
/// -  @Description: 人员管理views
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/person_management_list_model.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PersonManagementView {
  PersonManagementClickListener? clickListener;

  PersonManagementView({this.clickListener});

  List<PersonManagementListItemModel> _list = [];
  String _personNumber = "0";

  Widget contentView(
      List<PersonManagementListItemModel> modelList, String number) {
    _list = modelList;
    _personNumber = number;
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          _remainingNumberView(),
          // _searchView(),
          _listView(),
        ],
      ),
    );
  }

  Widget emptyContentView(String number) {
    _personNumber = number;
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          _remainingNumberView(),
          _searchView(),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: Image.asset(
                "assets/images/emptyIcon1.png",
                width: 247,
                height: 187,
              ),
            ),
          )
        ],
      ),
    );
    ;
  }

  /// *
  /// -  @description: 剩余可添加人数
  /// -  @Date: 2022-09-06 17:37
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _remainingNumberView() {
    String numberStr = _personNumber;
    TextStyle textStyle =
        const TextStyle(fontSize: 16, color: CustomColors.redColor61B);
    return Container(
      padding: const EdgeInsets.only(right: 16),
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Text(
            "剩余可添加人数 ",
            style: textStyle,
          ),
          Text(
            numberStr,
            style: textStyle,
          ),
          const SizedBox(width: 12),
          WidgetTools().createCustomInkWellButton("充值", () {
            clickListener?.tapRecharge();
          },
              bgColor: CustomColors.connectColor,
              textColor: Colors.white,
              radius: 15,
              fontSize: 10,
              height: 24,
              shadow: const BoxShadow(),
              buttonWidth: 38),
          const Expanded(child: SizedBox()),
          WidgetTools().createCustomInkWellButton("添加管理员", () {
            clickListener?.tapAddingAdministrator();
          },
              bgColor: CustomColors.connectColor,
              textColor: Colors.white,
              radius: 15,
              fontSize: 12,
              height: 24,
              shadow: const BoxShadow(),
              buttonWidth: 78),
        ],
      ),
    );
  }

  /// *
  /// -  @description: 搜索姓名
  /// -  @Date: 2022-09-06 17:39
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _searchView() {
    InputDecoration decoration = InputDecoration(
      border: InputBorder.none,
      hintText: "请输入姓名",
      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      icon: SvgPicture.asset(
        "assets/images/svg/seachIcon.svg",
        width: 15,
        height: 15,
      ),
    );

    TextField textField = TextField(
      onChanged: (str) {},
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      decoration: decoration,
    );

    return Container(
      color: CustomColors.colorF7F8FC,
      height: 34,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.only(left: 14),
      child: textField,
    );
  }

  /// *
  /// -  @description: 姓名操作列表
  /// -  @Date: 2022-09-06 17:55
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _listView() {
    double listHeight = ScreenTool.screenHeight -
        (84 +
            ScreenTool.bottomSafeHeight +
            ScreenTool.topSafeHeight +
            ScreenTool.navigationBarHeight);

    return SizedBox(
      width: double.infinity,
      height: listHeight,
      child: ListView.builder(
        itemBuilder: (context, index) {
          PersonManagementListItemModel mdoel = _list[index];
          return _buildListItem(mdoel);
        },
        itemCount: _list.length,
      ),
    );
  }

  Widget _buildListItem(PersonManagementListItemModel mdoel) {
    Widget line = Container(
      width: double.infinity,
      height: 1,
      color: CustomColors.color1C0000,
    );

    return Container(
      height: 73,
      width: double.infinity,
      child: Column(
        children: [_itemRowView(mdoel), line],
      ),
    );
  }

  Widget _itemRowView(PersonManagementListItemModel mdoel) {
    String name = mdoel.name;
    String phone = mdoel.phone;

    ///1启用, 2,禁用， 3，激活
    int tpye = 1;
    String buttonTitleStr = "";
    Color buttonColor = CustomColors.connectColor;
    if (mdoel.status == 0) {
      buttonTitleStr = "启用";
      tpye = 1;
    } else if (mdoel.status == 1) {
      buttonTitleStr = "禁用";
      tpye = 2;
    } else if (mdoel.status == 2) {
      buttonTitleStr = "激活";
      tpye = 3;
      buttonColor = CustomColors.lightGrey;
    }

    return Container(
      height: 72,
      width: double.infinity,
      padding: const EdgeInsets.only(right: 16, top: 15, bottom: 15),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.textDarkColor),
              ),
              Text(
                phone,
                style: const TextStyle(
                    fontSize: 14, color: CustomColors.darkGrey99),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 128,
            height: 30,
            child: Row(
              children: [
                WidgetTools().createCustomInkWellButton(buttonTitleStr, () {
                  clickListener?.tapItemOperation(tpye, mdoel);
                },
                    bgColor: buttonColor,
                    textColor: Colors.white,
                    radius: 16,
                    fontSize: 15,
                    height: 30,
                    shadow: const BoxShadow(),
                    buttonWidth: 60),
                const SizedBox(width: 8),
                WidgetTools().createCustomInkWellButton("删除", () {
                  clickListener?.tapItemOperation(0, mdoel);
                },
                    bgColor: CustomColors.redColor61B,
                    textColor: Colors.white,
                    radius: 16,
                    fontSize: 15,
                    height: 30,
                    shadow: const BoxShadow(),
                    buttonWidth: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

abstract class PersonManagementClickListener {
  tapRecharge();

  tapAddingAdministrator();

  tapItemOperation(int tpye, PersonManagementListItemModel model);
}
