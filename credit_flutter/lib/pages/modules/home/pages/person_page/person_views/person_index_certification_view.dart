/// *
/// -  @Date: 2022-09-19 14:42
/// -  @LastEditTime: 2022-09-19 14:42
/// -  @Description: 用户认证 页面
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/home/pages/person_page/person_views/person_index_view.dart';
import 'package:credit_flutter/pages/modules/scan_code/scan_code_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';

class PersonIndexCertiticationView extends PersonIndexView {
  PersonIndexCertiticationView(
      {required super.clickListener,
      required super.userModel,
      required super.isInputUM});

  @override
  Widget contentView(BuildContext context) {
    return SizedBox(
      height: ScreenTool.screenHeight,
      width: ScreenTool.screenWidth,
      child: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  _userInfo(),
                  _classifiedInformationView(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) {
                      //           return const ScanCodePage();
                      //         },
                      //       ),
                      //     );
                      //   },
                      //   highlightColor: Colors.transparent,
                      //   splashColor: Colors.transparent,
                      //   child: const Image(
                      //     image: AssetImage("assets/images/icon_scan_code.png"),
                      //     width: 30,
                      //     height: 30,
                      //   ),
                      // ),
                      const SizedBox(
                        width: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _itemView(),
          ),
        ],
      ),
    );
  }

  Widget _userInfo() {
    String uName = userModel.userInfo.idCardName;
    String idCard = userModel.userInfo.idCard;
    String workAge =
        userModel.userInfo.workAge.isEmpty ? "5" : userModel.userInfo.workAge;
    String birthday = StringTools.getBirthdayFromCardId(idCard);

    return Container(
      height: 256,
      color: CustomColors.lightBlue,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 34, bottom: 60),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
        decoration: const BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 55,
              child: Row(
                children: [
                  ///头像
                  _headPortrait(uName),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        StringTools.hiddenInfoString(uName),
                        style: const TextStyle(
                            color: CustomColors.textDarkColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "生于：$birthday",
                        style: const TextStyle(
                          color: CustomColors.lightGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          clickListener?.example();
                        },
                        child: const Text(
                          "查看报告样例",
                          style: TextStyle(
                            color: CustomColors.lightBlue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            /// 社保 ，身份证号
            _workInfo(idCard, workAge),
          ],
        ),
      ),
    );
  }

  Widget _headPortrait(String name) {
    name = name.substring(0, 1);
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        //背景
        color: CustomColors.connectColor,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _workInfo(String idCard, String workAge) {
    return SizedBox(
      height: 55,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 4,
              ),
              Text(
                workAge,
                style: const TextStyle(
                    color: CustomColors.textDarkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "社保累计",
                style: TextStyle(
                  color: CustomColors.lightGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 4,
              ),
              Text(
                StringTools.hiddenInfoString(idCard, type: 1),
                style: const TextStyle(
                    color: CustomColors.textDarkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "身份证号",
                style: TextStyle(
                  color: CustomColors.lightGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _classifiedInformationView() {
    return Column(
      children: [
        const SizedBox(
          height: 220,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: CustomColors.connectColor),
            borderRadius: BorderRadius.circular((8.0)),
            color: Colors.white,
          ),
          margin: const EdgeInsets.only(left: 16, right: 16),
          height: 280,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 0, right: 0),
                padding: const EdgeInsets.only(left: 15, top: 18),
                height: 48,
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  "本次综合查询信息",
                  style: TextStyle(
                    color: CustomColors.greyBlack,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 180,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  //禁止滑动
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
              const SizedBox(
                height: 15,
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
                // height: 28,
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
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "查看时间   永久",
          style: TextStyle(color: CustomColors.darkGrey99, fontSize: 13.0),
        ),
        const SizedBox(
          height: 90,
        ),
      ],
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
      width: 25,
      // height: 17,
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
      // width: 120,
      // height: 21,
      child: Text(
        titleStr,
        style: const TextStyle(
          color: CustomColors.lightBlue,
          fontSize: 15,
        ),
        textAlign: TextAlign.start,
      ),
    );

    return SizedBox(
      width: 147,
      height: 21,
      child: Row(
        children: <Widget>[
          numberView,
          Expanded(child: titleView),
        ],
      ),
    );
  }

  Widget _itemView() {
    bool isHaveReport = userModel.userInfo.reportId.isNotEmpty;
    // bool isPurchase = false;
    bool isPurchase = userModel.userInfo.getReportBuyStatus();
    double width = 170;
    if (isHaveReport) {
      width = 260;
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(right: 16, left: 16),
      height: 69,
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          //交叉轴的布局方式，对于column来说就是水平方向的布局方式
          crossAxisAlignment: CrossAxisAlignment.center,
          //就是字child的垂直布局方向，向上还是向下
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            // 更新
            customUpdateButton(),
            // //分享
            // customShareButton(),
            //下载
            customDownloadButton(),
            //查看&购买
            customButton(isHaveReport, isPurchase),
          ],
        ),
      ),
    );
  }

  InkWell customDownloadButton() {
    return InkWell(
      onTap: () {
        clickListener?.tapDownload(super.userModel);
      },
      child: SizedBox(
        width: 80,
        height: 30,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          child: Container(
            color: CustomColors.whiteBlueColorFE,
            width: double.infinity,
            height: double.infinity,
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "下载",
                    style: TextStyle(
                      color: CustomColors.lightBlue,
                      fontSize: 14,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  InkWell customShareButton() {
    return InkWell(
      onTap: () {
        clickListener?.tapShare();
      },
      child: SizedBox(
        width: 80,
        height: 30,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          child: Container(
            color: CustomColors.whiteBlueColorFE,
            width: double.infinity,
            height: double.infinity,
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "分享",
                    style: TextStyle(
                      color: CustomColors.lightBlue,
                      fontSize: 14,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget customUpdateButton() {
    bool isHaveReport = userModel.userInfo.reportId.isNotEmpty;
    return Offstage(
      offstage: !isHaveReport,
      child: InkWell(
        onTap: () {
          clickListener?.tapUpdate(userModel);
        },
        child: SizedBox(
          width: 80,
          height: 30,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            child: Container(
              color: CustomColors.whiteBlueColorFE,
              width: double.infinity,
              height: double.infinity,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "更新",
                      style: TextStyle(
                        color: CustomColors.lightBlue,
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

  InkWell customButton(bool isHaveReport, bool isPurchase) {
    return InkWell(
      onTap: () {
        if (isPurchase) {
          if (isHaveReport) {
            clickListener?.tapCheck(super.userModel);
          } else {
            clickListener?.tapResend(super.userModel);
          }
        } else {
          clickListener?.tapBuy();
        }
      },
      child: SizedBox(
        width: 80,
        height: 30,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          child: Container(
            color: CustomColors.lightBlue,
            width: double.infinity,
            height: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                buttonTitle(isHaveReport, isPurchase),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonTitle(bool isHaveReport, bool isPurchase) {
    String titleStr = "";
    Color color = Colors.white;
    if (isPurchase) {
      if (isHaveReport) {
        titleStr = "查看";
      } else {
        titleStr = "授权";
      }
    } else {
      titleStr = "购买";
    }
    return Text(
      titleStr,
      style: TextStyle(
        color: color,
        fontSize: 14,
      ),
    );
  }
}
