/// *
/// -  @Date: 2022-06-27 18:21
/// -  @LastEditTime: 2022-06-30 10:21
/// -  @Description:
///
import 'package:credit_flutter/manager/news_manager.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/models/news_list_model.dart';
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
class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> implements OnTabClickListener {
  List<String> newsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Text(
              "行业新闻",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: CustomerTabLayout(
          list: _buildListWidget(),
          onTapListener: this,
          isScrollable: true,
        ),
      ),
    );
  }

  @override
  onTap(int index) {
    Log.i("点击item: $index");
  }

  List<String> listTitle = ["全部", "生活", "发现", "文摘", "飞言", "滇池", "今天"];
  List<Widget> listWidget = [
    const NewsListPage(type: 1),
    const NewsListPage(type: 2),
    const NewsListPage(type: 3),
    const NewsListPage(type: 4),
    const NewsListPage(type: 5),
    const NewsListPage(type: 6),
    const NewsListPage(type: 7),
  ];

  List<TabItem> _buildListWidget() {
    var list = <TabItem>[];
    for (var i = 0; i < listTitle.length; i++) {
      var tabItem = TabItem();
      tabItem.childWidget = listWidget[i];
      tabItem.tabTitle = listTitle[i];
      list.add(tabItem);
    }
    return list;
  }
}
