/// *
/// -  @Date: 2022-07-18 18:29
/// -  @LastEditTime: 2022-07-18 18:30
/// -  @Description: 处理所有 资产管理 页面view
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/product_model.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';

class AssetManagementView {
  /// 用户信息
  final UserModel model;

  ///动画
  Animation<num>? animation;

  ///套餐列表
  List dataLists = [];

  ///登录类型
  String loginType;

  ///监听
  AssetManagementViewClickListener? clickListener;

  /// 选中的套餐
  ProductModel? selectModel;

  AssetManagementView(this.model,
      {required this.dataLists,
      required this.loginType,
      this.clickListener,
      this.selectModel,
      Key? key});

  Widget contentView() {
    String buttonTitle = "支付¥${selectModel?.price ?? 0}";
    bool isCompanyLogin = loginType == "1" ? true : false;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _informationView(isCompanyLogin),
          _optionCombo(),
          _instructions(),
          const SizedBox(
            height: 9,
          ),
          WidgetTools().createCustomButton(
            ScreenTool.screenWidth - 60,
            buttonTitle,
            () {
              clickListener?.tapPay();
            },
            bgColor: CustomColors.lightBlue,
            radius: 32,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

  /// *
  /// -  @description: 信息
  /// -  @Date: 2022-07-19 14:13
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _informationView(bool isCompany) {
    String name = "";
    if (isCompany == false) {
      name = "我的资产";
    } else {
      name = StringTools.truncateConcatenatedString(
        model.userInfo.companyInfo.name,
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 6, left: 7, right: 7),
      height: 168,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/AssetIcon.png'),
          fit: BoxFit.fill, // 完全填充
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    clickListener?.tapOrder();
                  },
                  child: const Text(
                    "我的订单>",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                        animation: animation!,
                        builder: (context, child) {
                          return Text(
                            StringTools.numberFormat(
                                animation!.value.toString(), false),
                            style: const TextStyle(
                              color: CustomColors.goldenColorFDE7B,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    const Text(
                      "慧眼币",
                      style: TextStyle(
                        color: CustomColors.goldenColorFDE7B,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// *
  /// -  @description: 选择套餐
  /// -  @Date: 2022-07-19 14:15
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _optionCombo() {
    return Container(
      width: double.infinity,
      // height: 150,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "充值金额",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 110,
            child: _getGridView(),
          ),
        ],
      ),
    );
  }

  Widget _getGridView() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 3,
        //水平单个子Widget之间间距
        mainAxisSpacing: 0,
        //垂直单个子Widget之间间距
        crossAxisSpacing: 19,
      ),
      itemCount: dataLists.length,
      itemBuilder: (BuildContext context, int index) {
        //自定义的行 代码在下面
        // return _showGridViewItem(
        // context, itmeList[pageViewNumber + index]);

        return _showGridViewItem(context, dataLists[index], index);
      },
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _showGridViewItem(
      BuildContext context, ProductModel model, int index) {
    Color bordeColor;
    Color textColor;
    Widget icon;
    if (model.isSelected) {
      bordeColor = CustomColors.lightBlue;
      textColor = CustomColors.lightBlue;
      icon = Image.asset(
        "assets/images/AssetSelected.png",
        height: 20,
      );
    } else {
      bordeColor = CustomColors.darkGreyE4;
      textColor = CustomColors.darkGrey;
      icon = const SizedBox(
        height: 20,
      );
    }

    return InkWell(
      //用inkWell是为了添加点击事件
      onTap: () {
        clickListener?.tapListItem(index);
      },
      child: Stack(
        children: [
          Container(
            height: 110,
            padding: const EdgeInsets.only(top: 17),
            decoration: BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              //设置四周边框
              border: Border.all(width: 1, color: bordeColor),
            ),
            child: Column(
              children: [
                const Text(
                  "慧眼币",
                  style: TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 14,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¥",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      model.title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                Text(
                  model.subTitle,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          Positioned(
            height: 20,
            width: 20,
            top: 110 - 20,
            right: 0,
            child: Row(
              children: [const Expanded(child: SizedBox()), icon],
            ),
          ),
        ],
      ),
    );
  }

  Widget _instructions() {
    return InkWell(
      //用inkWell是为了添加点击事件
      onTap: () {
        clickListener?.tapInstructions();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 34),
        child: Column(
          children: const [
            Text(
              "慧眼币说明",
              style: TextStyle(
                color: CustomColors.lightBlue,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class AssetManagementViewClickListener {
  ///选择套餐方式
  tapListItem(int index);

  ///慧眼币说明
  tapInstructions();

  ///支付
  tapPay();

  tapOrder();
}
