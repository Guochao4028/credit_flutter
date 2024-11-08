/// *
/// -  @Date: 2022-06-24 18:56
/// -  @LastEditTime: 2022-06-24 19:07
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-24 18:56
/// -  @LastEditTime: 2022-06-24 18:56
/// -  @Description: 新闻收藏列表
///
///

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/models/news_list_model.dart';
import 'package:credit_flutter/pages/modules/news/news_details.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/log.dart';

///新闻列表
class NewsCollectionPage extends StatefulWidget {
  const NewsCollectionPage({Key? key}) : super(key: key);

  @override
  State<NewsCollectionPage> createState() => _NewsCollectionPage();
}

class _NewsCollectionPage extends State<NewsCollectionPage> {
  List<NewsDetailsModel> newsList = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     mainAxisSize: MainAxisSize.min,
      //     children: const [
      //       Text(
      //         "新闻收藏",
      //         style: TextStyle(
      //           color: Colors.black,
      //           fontSize: 17,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     ],
      //   ),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios),
      //     color: Colors.black,
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (newsList.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 102),
        width: double.infinity,
        child: Column(
          children: const [
            Image(
              image: AssetImage("assets/images/seachResults.png"),
              width: 142,
              height: 137,
            ),
            Text(
              "暂无相关收藏",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomColors.darkGrey,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView.builder(
          itemBuilder: (context, index) {
            NewsDetailsModel model = newsList[index];
            return WidgetTools().showNewsViewItem(
                context, newsList[index], ScreenTool.screenWidth, false, () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => NewsDetailsPage(
                        newsId: model.newsId,
                        type: model.type,
                        coverImage: model.coverImage,
                      ),
                    ),
                  )
                  .then((val) => val ? _initData() : null);
            });
          },
          itemCount: newsList.length,
          shrinkWrap: true,
        ),
      );
    }
  }

  // 初始化数据
  void _initData() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList =
          sp.getStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION);
      if (strList != null) {
        List<NewsDetailsModel> modelList = [];
        for (var i = 0; i < strList.length; i++) {
          String str = strList[i];
          Map tem = StringTools.json2Map(str);
          Log.v("--${tem.toString()}");

          NewsDetailsModel model = NewsDetailsModel(
              "",
              tem["coverImage"],
              "",
              "",
              tem["from"],
              "",
              tem["newsId"],
              tem["releaseTime"],
              tem["title"],
              0,
              tem["type"]);
          Log.v("--${tem.toString()}");

          modelList.add(model);
        }
        newsList = modelList;

        setState(() {});
      }
    });
  }
}
