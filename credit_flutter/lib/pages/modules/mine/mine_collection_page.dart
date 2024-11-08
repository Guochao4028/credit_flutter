/// *
/// -  @Date: 2022-07-01 16:48
/// -  @LastEditTime: 2022-07-01 16:48
/// -  @Description: 我的收藏
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/news_manager.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/models/news_list_model.dart';
import 'package:credit_flutter/pages/modules/company/company_collection.dart';
import 'package:credit_flutter/pages/modules/news/news_collection.dart';
import 'package:credit_flutter/pages/modules/news/news_details.dart';
import 'package:credit_flutter/pages/modules/news/news_list_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/tab_item.dart';
import 'package:credit_flutter/tools/tab_layout_widget.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

///新闻列表
class MineCollectionPage extends StatefulWidget {
  const MineCollectionPage({Key? key}) : super(key: key);

  @override
  State<MineCollectionPage> createState() => _MineCollectionPageState();
}

class _MineCollectionPageState extends State<MineCollectionPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  TabController? _tabController;
  int _select = 0; //选中tab小标
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: list.length);
    _tabController!.addListener(() {
      setState(() {
        _select = _tabController!.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: CustomColors.whiteBlueColor,
            elevation: 0,
            title: Container(
              height: ScreenTool.height(44),
              child: TabBar(
                  indicatorColor: Colors.white,
                  indicatorPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  isScrollable: true, //设置可滑动
                  controller: _tabController,
                  onTap: (value) {
                    setState(() {
                      _select = value;
                    });
                  },
                  tabs: tabs()),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: TabBarView(
                  controller: _tabController,
                  children: _tabBarViews(),
                ),
              )
            ],
          )),
    );
  }

  //tab标题
  List<String> list = [
    "新闻",
    "公司",
  ];
  List<Widget> tabs() {
    List<Widget> listTab = [];
    for (int i = 0; i < list.length; i++) {
      listTab.add(
        Tab(
            child: Container(
          height: ScreenTool.height(44),
          child: Stack(
            children: [
              Align(
                child: Text(
                  "${list[i]}",
                  style: TextStyle(
                      color:
                          _select == i ? Colors.white : CustomColors.lightGrey),
                ),
                alignment: Alignment.center,
              ),
            ],
          ),
        )),
      );
    }
    return listTab;
  }

  List<Widget> _tabBarViews() {
    return listWidget;
  }

  List<Widget> listWidget = [
    const NewsCollectionPage(),
    const CompanyCollectionPage(),
  ];
}
