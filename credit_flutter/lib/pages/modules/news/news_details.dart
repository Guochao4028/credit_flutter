/***
 * @Date: 2022-05-30 16:19
 * @LastEditTime: 2022-06-16 15:18
 * @Description: 新闻详情
 */

import 'dart:async';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/news_manager.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/pages/modules/mine/reach_us.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 引入解析html的插件
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class NewsDetailsPage extends StatefulWidget {
  final int? newsId;
  final int? type;
  final String? coverImage;

  const NewsDetailsPage(
      {Key? key, required this.newsId, this.type, this.coverImage})
      : super(key: key);

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  NewsDetailsModel? newsModel;

  List<Map<String, dynamic>> bottomSheetList = [
    {
      "image": "assets/images/svg/shoucang.svg",
      "title": "收藏",
      "selectedImage": "assets/images/svg/shoucangzhong.svg",
      "selected": 0
    },
    {
      "image": "assets/images/svg/jubao.svg",
      "title": "内容举报",
      "selectedImage": "assets/images/svg/jubao.svg",
      "selected": 0
    },
    {
      "image": "assets/images/svg/fankuiguanli.svg",
      "title": "功能反馈",
      "selectedImage": "assets/images/svg/fankuiguanli.svg",
      "selected": 0
    },
  ];

  //记录收藏list
  List<Map<String, dynamic>> collectionList = [];

  @override
  void initState() {
    super.initState();
    _getData();
    startTime = DateTime.now();
    UmengCommonSdk.onPageStart("news_details_page");
  }

  DateTime? startTime;

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("news_details_page");
    var logOn = Golbal.token.isNotEmpty ? "已登录" : "未登录";
    UmengCommonSdk.onEvent("news_details_page_stay", {
      "data": "time:${differenceTime(startTime!, DateTime.now())}、logOn:$logOn"
    });
  }

  @override
  Widget build(BuildContext context) {
    bool flag = newsModel == null ? false : true;

    Map tem = bottomSheetList[0];
    int selected = tem["selected"];
    String imageIconPath = selected == 0 ? tem["image"] : tem["selectedImage"];

    Widget floatingActionButton = SizedBox();
    if (selected == 1) {}

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "文章详情",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_horiz),
            color: Colors.black,
            tooltip: 'Air it',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return _bottomSheet();
                },
              );
            },
          ),
        ],
      ),
      //TODO 王高屁要求隐藏
      // floatingActionButton: FloatingActionButton(
      //   child: Column(
      //     children: <Widget>[
      //       const SizedBox(
      //         height: 10,
      //       ),
      //       SizedBox(
      //         width: 15,
      //         height: 15,
      //         child: SvgPicture.asset(
      //           imageIconPath,
      //           fit: BoxFit.fill,
      //           color: Colors.white,
      //         ),
      //       ),
      //       //一个文本
      //       Container(
      //         padding: const EdgeInsets.only(top: 5),
      //         child: const Text(
      //           "收藏",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //             fontSize: 12,
      //             color: CustomColors.whiteColor,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   onPressed: () {
      //     for (var item in bottomSheetList) {
      //       item["selected"] = 0;
      //     }
      //     Map tempMap = tem;
      //     int tempSelected = selected == 0 ? 1 : 0;
      //     tempMap["selected"] = tempSelected;
      //
      //     if (tempSelected == 1) {
      //       saveDataModel();
      //       ToastUtils.showMessage("收藏成功");
      //     } else {
      //       cancelDataModel();
      //       ToastUtils.showMessage("取消收藏成功");
      //     }
      //     setState(() {});
      //   },
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              Text(
                flag ? newsModel!.title : "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _pCrateHeard(
                      "来源：",
                      flag ? newsModel!.from : "",
                      const TextStyle(
                        fontSize: 10,
                        color: CustomColors.darkGrey,
                      ),
                      const TextStyle(
                        fontSize: 10,
                        color: CustomColors.lightBlue,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    _pCrateHeard(
                      "发布时间：",
                      flag ? newsModel!.releaseTime : "",
                      const TextStyle(
                        fontSize: 10,
                        color: CustomColors.darkGrey,
                      ),
                      const TextStyle(
                        fontSize: 10,
                        color: CustomColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: CustomColors.darkGrey,
              ),
              flag == true
                  ?
                  // 官方代码
                  HtmlWidget(
                      // 渲染的数据
                      // data:
                      newsModel!.content,
                      // 自定义样式
                      // style: {},
                      // customRender: {
                      //   "flutter": ((context, parsedChild) {
                      //     return const FlutterLogo(
                      //       style: FlutterLogoStyle.horizontal,
                      //     );
                      //   })
                      // },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  /// @description: 生成 来源，发布时间
  /// @Date: 2022-05-30 21:03
  /// @parm: 标题，内容
  /// @return 容器
  SizedBox _pCrateHeard(String title, String content, TextStyle titleStyle,
      TextStyle contentStyle) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Text(
            content,
            style: contentStyle,
          ),
        ],
      ),
    );
  }

  // 获取数据
  void _getData() async {
    var data = {'newsId': widget.newsId, "type": widget.type};
    newsModel = await NewsManger.getNews(data);
    if (newsModel != null) {
      _comparativeCollectionData();
      setState(() {});
    } else {
      print("newsModel is null");
    }
  }

  /// *
  /// -  @description: 比较收藏数据
  /// -  @Date: 2022-06-24 18:20
  /// -  @return {*}
  ///
  void _comparativeCollectionData() {
    if (newsModel != null) {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((sp) {
        List<String>? strList =
            sp.getStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION);
        List<String> temStrList = [];
        if (strList != null) {
          for (var i = 0; i < strList.length; i++) {
            String str = strList[i];
            Map tem = StringTools.json2Map(str);
            int id = tem["newsId"];
            if (id == newsModel!.newsId) {
              Map tem = bottomSheetList[0];
              tem["selected"] = 1;
              setState(() {});
              break;
            }
          }
        }
      });
    }
  }

  /// *
  /// -  @description: 收藏新闻
  /// -  @Date: 2022-06-24 18:16
  /// -  @parm:
  /// -  @return {*}
  ///
  void saveDataModel() {
    String title = newsModel!.title;
    int newsId = newsModel!.newsId;
    String? coverImage = widget.coverImage;
    String releaseTime = newsModel!.releaseTime;
    String from = newsModel!.from;
    int type = widget.type!;

    Map<String, dynamic> newsMap = {
      "title": title,
      "newsId": newsId,
      "coverImage": coverImage,
      "releaseTime": releaseTime,
      "from": from,
      "type": type
    };

    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList =
          sp.getStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION);
      if (strList != null) {
        strList.add(StringTools.map2Json(newsMap));
      } else {
        strList = [];
        strList.add(StringTools.map2Json(newsMap));
      }
      sp.setStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION, strList);
    });
  }

  /// *
  /// -  @description: 取消收藏
  /// -  @Date: 2022-06-24 18:16
  /// -  @parm:
  /// -  @return {*}
  ///
  void cancelDataModel() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList =
          sp.getStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION);
      List<String> temStrList = [];
      if (strList != null) {
        for (var i = 0; i < strList.length; i++) {
          String str = strList[i];
          Map tem = StringTools.json2Map(str);
          int id = tem["newsId"];
          if (id == newsModel!.newsId) {
            continue;
          }
          temStrList.add(str);
        }
      }
      sp.setStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION, temStrList);
    });
  }

  /// *
  /// -  @description: 底部sheet
  /// -  @Date: 2022-06-24 14:42
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _bottomSheet() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 140,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Container(
            // color: CustomColors.lightGrey,
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            height: 80,
            width: ScreenTool.screenWidth,
            child: GridView.builder(
              // physics: new NeverScrollableScrollPhysics(), //禁止滑动
              // controller: scrollController,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 1,
                //水平单个子Widget之间间距
                mainAxisSpacing: 10.0,
                // mainAxisExtent: itemWidth,
                //垂直单个子Widget之间间距
                crossAxisSpacing: 10.0,
              ),
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                //自定义的行 代码在下面
                return _showGridViewItem(context, bottomSheetList[index]);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            color: Colors.transparent,
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  "取消",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _showGridViewItem(BuildContext context, Map tmp) {
    int selected = tmp["selected"];
    String imageIconPath = selected == 0 ? tmp["image"] : tmp["selectedImage"];
    String title = tmp["title"];

    return InkWell(
      //用inkWell是为了添加点击事件
      onTap: () {
        if (title == "收藏") {
          for (var item in bottomSheetList) {
            item["selected"] = 0;
          }
          Map tempMap = tmp;
          int tempSelected = selected == 0 ? 1 : 0;
          tempMap["selected"] = tempSelected;

          if (tempSelected == 1) {
            saveDataModel();
            ToastUtils.showMessage("收藏成功");
          } else {
            cancelDataModel();
            ToastUtils.showMessage("取消收藏成功");
          }
          Navigator.pop(context, true);
          setState(() {});
        } else {
          Navigator.pop(context, true);
          setState(() {});
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => ReachUs(title)),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        width: 50,
        height: 50,
        child: Column(
          children: <Widget>[
            SizedBox(
                width: 30,
                height: 30,
                child: SvgPicture.asset(
                  imageIconPath,
                  fit: BoxFit.fill,
                )),
            //一个文本
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.greyBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int differenceTime(DateTime stsrt, DateTime end) {
    return end.difference(stsrt).inSeconds;
  }
}
