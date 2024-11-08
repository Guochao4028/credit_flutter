import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/home/pages/company_page/vertical_query_page.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../../../manager/news_manager.dart';
import '../../../../../models/news_details_model.dart';
import '../../../../../models/news_list_model.dart';
import '../../../news/news_details.dart';
import '../../../report/job_report_details_page.dart';
import 'over_scroll_behavior.dart';

class NewCompanyIndexPage extends StatefulWidget {
  const NewCompanyIndexPage({Key? key}) : super(key: key);

  @override
  State<NewCompanyIndexPage> createState() => _NewCompanyIndexPageState();
}

class _NewCompanyIndexPageState extends State<NewCompanyIndexPage> {
  final EasyRefreshController _controller = EasyRefreshController();

  //当前页
  int pageNum = 1;

  List<NewsDetailsModel> newsList = [];

  ScrollController controller = ScrollController();

  var noMore = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (noMore) {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent - (107 * 3)) {
          pageNum++;
          _initData();
        }
      }
    });
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: Stack(
          children: [
            // const Image(
            //   image: AssetImage("assets/images/icon_new_homepage_bg_top.png"),
            //   height: 88,
            //   width: double.infinity,
            //   fit: BoxFit.fill,
            // ),
            Container(
              height: 88,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, bottom: 10),
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage("assets/images/icon_wisdom.png"),
                        width: 22,
                        height: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // Text(
                      //   '慧眼查·',
                      //   style: TextStyle(
                      //     fontSize: 13.0,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      // Text(
                      //   '社会信用体系建设重点服务平台',
                      //   style: TextStyle(
                      //     fontSize: 10.0,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        scrollBehavior: OverScrollBehavior(),
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Column(
                  children: const [
                    Image(
                      image: AssetImage(
                          "assets/images/icon_new_homepage_bg_bottom.png"),
                      width: double.infinity,
                      height: 108,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 9, right: 9),
                        child: Stack(
                          children: [
                            const Image(
                              image: AssetImage(
                                  "assets/images/icon_picture_job_report.png"),
                              height: 164,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            Container(
                              height: 164,
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: const [
                                        Text(
                                          '查询他人报告信息',
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          '避免他人信息风险',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const VerticalQueryPage(
                                                  type: 1,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Image(
                                            image: AssetImage(
                                                "assets/images/icon_one_click_query.png"),
                                            height: 30,
                                            width: 106,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => JobReportDetailsPage(
                                      reportId: "",
                                    ),
                                  ),
                                );
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //     const VerticalQueryPage(
                                //       type: 2,
                                //     ),
                                //   ),
                                // );
                              },
                              child: SizedBox(
                                height: 96,
                                child: Stack(
                                  children: [
                                    const Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/icon_job_report_card.png"),
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    '求职报告查询',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            child: Text(
                                              '招聘求职专用',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 2, bottom: 2),
                                            width: 55,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '立即查询',
                                                style: TextStyle(
                                                  color:
                                                      CustomColors.color7EA7F1,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const VerticalQueryPage(
                                      type: 3,
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 96,
                                child: Stack(
                                  children: [
                                    const Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/icon_marriage_report_card.png"),
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    '婚恋报告查询',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Expanded(
                                            child: Text(
                                              '相亲结婚专用',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 55,
                                            padding: const EdgeInsets.only(
                                                top: 2, bottom: 2),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '立即查询',
                                                style: TextStyle(
                                                  color:
                                                      CustomColors.colorF17C7C,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 45,
            title: Container(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              height: 45,
              width: double.infinity,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  const Text(
                    '企业资讯',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: CustomColors.greyBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 58,
                    height: 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF1252FF),
                          Color(0xFFFFFFFF),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((content, index) {
              var newsData = newsList[index];
              return WidgetTools().showHomeNewsViewItem(context, newsData, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewsDetailsPage(
                      newsId: newsData.newsId,
                      type: newsData.type,
                      coverImage: newsData.coverImage,
                    ),
                  ),
                );
              });
            }, childCount: newsList.length),
          ),
        ],
      ),
    );
  }

  void _initData() {
    Map<String, dynamic> param = {
      "pageNum": pageNum,
      "pageSize": 5,
      "type": 1,
      "hideLoading": true,
    };
    NewsManger.getNewsList(param, (listModel) {
      NewsListModel newsListModel = listModel as NewsListModel;
      newsList.addAll(newsListModel.data);
      if (newsList.length < newsListModel.total) {
        _controller.finishLoad(noMore: false);
      } else {
        noMore = false;
        _controller.finishLoad(noMore: true);
      }
      setState(() {});
    });
  }
}
