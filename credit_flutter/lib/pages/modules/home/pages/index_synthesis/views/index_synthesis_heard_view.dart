/// *
/// -  @Date: 2023-09-04 15:09
/// -  @LastEditTime: 2023-09-04 15:09
/// -  @Description: 综合首页 HeardView
///
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:flutter/material.dart';

class IndexSynthesisHeardView implements TabBarListener {
  final IndexSynthesisHeardClickListener? clickListener;

  IndexSynthesisHeardView({
    required this.clickListener,
  });

  AppBar getAppBar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 0.0,
      centerTitle: true,
      backgroundColor: CustomColors.color021EC9,
      title: const Text(
        FinalKeys.environment ? '' : '慧眼查-测试',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
      // leading: Container(
      //   padding: const EdgeInsets.all(15),
      //   child: InkWell(
      //     /// 未登录时 首页 扫一扫
      //     onTap: () => clickListener?.tapScan(),
      //     highlightColor: Colors.transparent,
      //     splashColor: Colors.transparent,
      //     child: const Image(
      //       image: AssetImage("assets/images/icon_scan_code.png"),
      //       fit: BoxFit.fitHeight,
      //     ),
      //   ),
      // ),
      actions: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => clickListener?.tapRiskRemediation(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/usButtonIcon.png"),
                color: Colors.white,
                width: 14,
                height: 14,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                '风险修复',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget heardBackdropView() {
    return Stack(
      children: [
        Image.asset(
          "assets/images/icon_home_bg_top.png",
          fit: BoxFit.cover,
          height: 150,
        ),
        Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/images/icon_logo_name.png"),
                    width: 125,
                    height: 50,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.0),
                      color: CustomColors.colorF82522,
                    ),
                    child: const Center(
                      child: Text(
                        '国家社会信用体系建设\n重 点 服 务 平 台',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 55,
              child: Stack(children: [
                // Image(
                //   image: AssetImage("assets/images/icon_home_bg_bottom.png"),
                //   width: double.infinity,
                //   height: 55,
                //   fit: BoxFit.fill,
                // ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IndexSynthesisHeardViewTabBar(
                        tabBarListener: this,
                      ),
                    ],
                  ),
                )
              ]),
            )
          ],
        )
      ],
    );
  }

  @override
  void tapTabbar(int index) {
    clickListener?.tapToggle(index);
  }
}

abstract class IndexSynthesisHeardClickListener {
  /// 扫描二维码
  void tapScan();

  /// 风险修复
  void tapRiskRemediation();

  /// 点击tabbar 切换
  void tapToggle(int index);
}

// ignore: must_be_immutable
class IndexSynthesisHeardViewTabBar extends StatefulWidget {
  TabBarListener? tabBarListener;

  IndexSynthesisHeardViewTabBar({
    this.tabBarListener,
    super.key,
  });

  @override
  State<IndexSynthesisHeardViewTabBar> createState() =>
      _IndexSynthesisHeardViewTabBarState();
}

class _IndexSynthesisHeardViewTabBarState
    extends State<IndexSynthesisHeardViewTabBar>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabBarListener? tabBarListener;
  final List<String> titles = ["雇主背调", "个人自查"];

  int _select = 0; //选中tab小标
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: titles.length, vsync: this);
    tabBarListener = widget.tabBarListener;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                _select = 0;
                tabBarListener?.tapTabbar(0);
              },
              child: Image(
                image: AssetImage(
                    "assets/images/${_select == 0 ? "icon_but_employer" : "icon_but_employer_no"}.png"),
                height: 32,
                fit: BoxFit.fitHeight,
              ),
            ),
            Visibility(
              visible: _select == 0,
              maintainAnimation: true,
              maintainSize: true,
              maintainState: true,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(2.5)),
                ),
                margin: const EdgeInsets.only(top: 5),
                width: 32,
                height: 5,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                _select = 1;
                tabBarListener?.tapTabbar(1);
              },
              child: Image(
                image: AssetImage(
                    "assets/images/${_select == 1 ? "icon_but_personal" : "icon_but_personal_no"}.png"),
                height: 32,
                fit: BoxFit.fitHeight,
              ),
            ),
            Visibility(
              visible: _select == 1,
              maintainAnimation: true,
              maintainSize: true,
              maintainState: true,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(2.5)),
                ),
                margin: const EdgeInsets.only(top: 5),
                width: 32,
                height: 5,
              ),
            ),
          ],
        )
      ],
    );
    // return TabBar(
    //   indicatorColor: Colors.transparent,
    //   indicatorPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    //   isScrollable: true,
    //   //设置可滑动
    //   controller: _tabController,
    //   onTap: (value) {
    //     setState(() {
    //       _select = value;
    //       tabBarListener?.tapTabbar(value);
    //     });
    //   },
    //   tabs: _tabs(),
    // );
  }

  List<Widget> _tabs() {
    List<Widget> listTab = [];
    listTab.add(
      Tab(
        child: SizedBox(
          // height: ScreenTool.height(34),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage(
                      "assets/images/${_select == 0 ? "icon_but_employer" : "icon_but_employer_no"}.png"),
                  width: 137,
                  height: 48,
                ),
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     titles[i],
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: _select == i
              //             ? Colors.white
              //             : CustomColors.lightGrey),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
    listTab.add(
      Tab(
        child: SizedBox(
            // height: ScreenTool.height(34),
            child: Column(
          children: [
            Image(
              image: AssetImage(
                  "assets/images/${_select == 1 ? "icon_but_personal" : "icon_but_personal_no"}.png"),
              // width: 137,
              height: 28,
              fit: BoxFit.fitHeight,
            ),
          ],
        )),
      ),
    );
    // for (int i = 0; i < titles.length; i++) {
    //   listTab.add(
    //     Tab(
    //       child: SizedBox(
    //         height: ScreenTool.height(34),
    //         child: Stack(
    //           children: [
    //             Align(
    //               alignment: Alignment.center,
    //               child: Image(
    //                 image: AssetImage("assets/images/${_select == i?"icon_but_employer":"icon_but_employer_no"}.png"),
    //                 width: 30,
    //                 height: 30,
    //               ),
    //             ),
    //             // Align(
    //             //   alignment: Alignment.center,
    //             //   child: Text(
    //             //     titles[i],
    //             //     style: TextStyle(
    //             //         fontWeight: FontWeight.bold,
    //             //         color: _select == i
    //             //             ? Colors.white
    //             //             : CustomColors.lightGrey),
    //             //   ),
    //             // ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }
    return listTab;
  }

  @override
  bool get wantKeepAlive => true;
}

abstract class TabBarListener {
  void tapTabbar(int index);
}
