import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/company/background_check/back_tone_company_page.dart';
import 'package:credit_flutter/pages/modules/demand_center/demand_center_page.dart';
import 'package:credit_flutter/pages/modules/demand_center/pages/release_page.dart';
import 'package:credit_flutter/pages/modules/news/news_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../tools/screen_tool.dart';
import '../modules/mine/mine_home/mine_home_page.dart';

/// @Description: 所有页面根页面
class NewRootPage extends StatefulWidget {
  int pageNumber = 0;
  bool isCertigier;

  NewRootPage({
    this.pageNumber = 0,
    this.isCertigier = false,
    Key? key,
  }) : super(key: key);

  @override
  State<NewRootPage> createState() => _NewRootPageState();
}

class _NewRootPageState extends State<NewRootPage> {
  List<Widget> newPages = [
    const BackToneCompanyPage(),
    const DemandCenterPage(),
    const NewsPage(),
    const MineHomePage(),
  ];

  int currentIndex = 0;

  bool isOther = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.pageNumber;
    bus.on("switch_pages", (arg) {
      if (currentIndex != 1) {
        currentIndex = 1;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off("switch_pages");
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.bottom;

    ScreenTool.int(context);
    if (isOther == false) {
      return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: newPages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: CustomColors.color1C0000,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          width: double.infinity,
          height: 55 + statusBarHeight,
          padding: EdgeInsets.only(bottom: statusBarHeight),
          child: Row(
            children: [
              Expanded(
                  child: _addItem(
                      0, "icon_back_tone_yes.png", "icon_back_tone.png", "背调")),
              Expanded(
                  child: _addItem(
                      1, "icon_home_yes.png", "icon_home.png", "需求中心")),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ReleasePage(),
                      ),
                    );
                  },
                  child: const Image(
                    width: 40,
                    height: 40,
                    image: AssetImage("assets/images/icon_release.png"),
                  ),
                ),
              ),
              Expanded(
                  child:
                      _addItem(2, "icon_news_yes.png", "icon_news.png", "资讯")),
              Expanded(
                  child:
                      _addItem(3, "icon_mine_yes.png", "icon_mine.png", "我的")),
            ],
          ),
        ),
      );
    } else {
      return const Scaffold(body: Text("isOther == true"));
    }
  }

  _addItem(int item, String check, String unchecked, String label) {
    return InkWell(
      onTap: () {
        Golbal.checkAccount((success, userModel) {
          if (userModel != null) {
            UserInfo userInfo = userModel.userInfo;
            if (success == true) {
              currentIndex = item;
            } else {
              Navigator.pushNamed(context, "/childAccountInfo",
                  arguments: {"childStatus": userInfo.childStatus});
            }
          }
          setState(() {});
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: 22,
            height: 22,
            image: AssetImage(
                "assets/images/${item == currentIndex ? check : unchecked}"),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            label,
            style: TextStyle(
              color: item == currentIndex
                  ? CustomColors.connectColor
                  : CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
