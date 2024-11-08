import 'package:credit_flutter/manager/news_manager.dart';
import 'package:credit_flutter/models/news_details_model.dart';
import 'package:credit_flutter/models/news_list_model.dart';
import 'package:credit_flutter/pages/modules/news/news_details.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

///新闻列表
class NewsListPage extends StatefulWidget {
  final int? type;

  const NewsListPage({Key? key, required this.type}) : super(key: key);

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  //新闻总条数
  int total = 0;

  //当前页
  int currentPage = 0;

  //每页多少条
  int pageSize = 10;

  List<NewsDetailsModel> newsList = [];

  final EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: EasyRefresh(
          header: WidgetTools().getClassicalHeader(),
          footer: WidgetTools().getClassicalFooter(),
          controller: _controller,
          enableControlFinishRefresh: true,
          enableControlFinishLoad: true,
          onRefresh: _onRefresh,
          onLoad: _onLoad,
          child: ListView.builder(
            itemBuilder: (context, index) {
              NewsDetailsModel model = newsList[index];
              return WidgetTools().showNewsViewItem(
                  context, newsList[index], ScreenTool.screenWidth, false, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewsDetailsPage(
                      newsId: model.newsId,
                      type: model.type,
                      coverImage: model.coverImage,
                    ),
                  ),
                );
              });
            },
            itemCount: newsList.length,
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }

  Future _onRefresh() async {
    currentPage = 1;
    Map<String, dynamic> param = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "type": widget.type,
    };
    NewsManger.getNewsList(param, (listModel) {
      NewsListModel newsListModel = listModel as NewsListModel;
      currentPage = newsListModel.currentPage;
      newsList = newsListModel.data;
      _controller.finishRefresh(success: true, noMore: false);
      _controller.finishLoad(success: true, noMore: false);
      setState(() {});
      return "";
    });
  }

  Future _onLoad() async {
    //自定义方法执行下拉操作

    print("_onLoad");

    // int num = currentPage * pageSize;
    // if (num >= total) {
    //   _controller.finishLoad(success: true, noMore: true);
    // } else {
    currentPage++;
    Map<String, dynamic> param = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "type": widget.type,
    };
    NewsManger.getNewsList(param, (listModel) {
      NewsListModel newsListModel = listModel as NewsListModel;
      currentPage = newsListModel.currentPage;
      newsList.addAll(newsListModel.data);
      _controller.finishLoad(success: true, noMore: false);
      setState(() {});
    });
    // }
    return "";
  }

  // 初始化数据
  void _initData() async {
    currentPage = 1;
    Map<String, dynamic> pame = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "type": widget.type,
    };
    NewsManger.getNewsList(pame, (listModel) {
      setState(() {
        NewsListModel newsListModel = listModel as NewsListModel;
        total = newsListModel.total;
        pageSize = newsListModel.pageSize;
        currentPage = newsListModel.currentPage;
        newsList = newsListModel.data;
      });
    });
  }
}
