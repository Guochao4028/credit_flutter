// ignore_for_file: unnecessary_new

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/back_check_company_manager.dart';
import 'package:credit_flutter/models/back_check_company_info_model.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/pages/modules/company/company_ranking_new_page.dart';
import 'package:credit_flutter/pages/modules/company/new_company_details.dart';
import 'package:credit_flutter/pages/modules/company/search/search_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/rendering.dart';
import 'company_details.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// @Date: 2022-06-13 15:17
/// @LastEditTime: 2022-06-16 14:37
/// @Description: 背调公司首页
class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({Key? key}) : super(key: key);

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  final EasyRefreshController _controller = EasyRefreshController();

  //公司列表
  List<BackCheckCompanyListItemModel> companyList = [];

  //新闻总条数
  int total = 0;

  //当前页
  int currentPage = 0;

  //每页多少条
  int pageSize = 10;

  //综合排名
  List<BackCheckCompanyListItemModel> comprehensiveRankingList = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    currentPage = 1;
    Map<String, dynamic> pame = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "type": 1,
    };
    BackCheckCompanyManager.list(pame, (listModel) {
      setState(() {
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;
        total = liModel.total;
        pageSize = liModel.pageSize;
        currentPage = liModel.currentPage;
        companyList = liModel.data;
        // if (liModel.data.length > 3) {
        //   for (var i = 0; i < 3; i++) {
        //     comprehensiveRankingList.add(liModel.data[i]);
        //   }
        // }

        BackCheckCompanyManager.list({"pageNum": 1, "pageSize": 3, "type": 2},
            (cListModel) {
          BackCheckCompanyListModel liModel =
              cListModel as BackCheckCompanyListModel;
          comprehensiveRankingList.add(liModel.data[1]);
          comprehensiveRankingList.add(liModel.data.first);
          comprehensiveRankingList.add(liModel.data.last);
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Row(
          children: [
            Text(
              "背调",
              style: TextStyle(
                color: CustomColors.textDarkColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/images/svg/seachIcon.svg",
              width: 20,
              height: 20,
            ),
            color: Colors.black,
            tooltip: 'Air it',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Listener(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: _buildRefresh(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefresh() {
    return EasyRefresh(
      header: WidgetTools().getClassicalHeader(),
      footer: WidgetTools().getClassicalFooter(),
      controller: _controller,
      enableControlFinishRefresh: true,
      enableControlFinishLoad: true,
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      child: _buildHomePage(),
    );
  }

  Future _onRefresh() async {
    //自定义方法执行下拉操作

    currentPage = 1;
    Map<String, dynamic> pame = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "type": 1,
    };
    BackCheckCompanyManager.list(pame, (listModel) {
      _controller.finishRefresh(success: true);
      _controller.finishLoad(success: true, noMore: false);
      setState(() {
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;
        total = liModel.total;
        pageSize = liModel.pageSize;
        currentPage = liModel.currentPage;
        companyList = liModel.data;
        if (comprehensiveRankingList.isEmpty) {
          BackCheckCompanyManager.list({"pageNum": 1, "pageSize": 3, "type": 2},
              (cListModel) {
            BackCheckCompanyListModel liModel =
                cListModel as BackCheckCompanyListModel;
            comprehensiveRankingList.add(liModel.data[1]);
            comprehensiveRankingList.add(liModel.data.first);
            comprehensiveRankingList.add(liModel.data.last);
            setState(() {});
          });
        }
      });
    });

    return "";
  }

  Future _onLoad() async {
    //自定义方法执行下拉操作

    int num = companyList.length;
    if (num >= total) {
      _controller.finishLoad(success: true, noMore: true);
    } else {
      currentPage++;
      Map<String, dynamic> param = {
        "pageNum": currentPage,
        "pageSize": pageSize,
        "type": 1,
      };
      BackCheckCompanyManager.list(param, (listModel) {
        _controller.finishLoad(success: true, noMore: false);
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;
        companyList.addAll(liModel.data);
        setState(() {});
      });
    }

    return "";
  }

  Widget _buildHomePage() {
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        //综合排名
        _buildComprehensiveRanking(),
        const SizedBox(
          height: 12,
        ),
        //ListView
        _buildCompanyList(),
      ],
    );
  }

  //综合排名
  Widget _buildComprehensiveRanking() {
    return comprehensiveRankingList.isEmpty
        ? const SizedBox()
        : Offstage(
            //是否隐藏
            offstage: comprehensiveRankingList.isNotEmpty ? false : true,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.shadowColor,
                        offset: Offset(0, 0),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///标题
                      Container(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Row(
                          children: [
                            const Text(
                              '排行榜',
                              style: bold16TextStyle,
                            ),
                            const Expanded(child: SizedBox()),
                            InkWell(
                              child: const Text(
                                '查看更多>',
                                style: TextStyle(
                                  color: CustomColors.darkGrey99,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CompanyRnkingNewPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: ScreenTool.screenWidth - 24 - 28,
                        height: 140,
                        // child: GridView.builder(
                        //   physics: const NeverScrollableScrollPhysics(), //禁止滑动
                        //   // controller: scrollController,
                        //   scrollDirection: Axis.horizontal,
                        //   shrinkWrap: true,
                        //   padding: const EdgeInsets.all(0),
                        //   gridDelegate:
                        //       const SliverGridDelegateWithFixedCrossAxisCount(
                        //     childAspectRatio: 140 / 100,
                        //     crossAxisCount: 1,
                        //     //水平单个子Widget之间间距
                        //     mainAxisSpacing: 10.0,
                        //     // mainAxisExtent: itemWidth,
                        //     //垂直单个子Widget之间间距
                        //     crossAxisSpacing: 0.0,
                        //   ),
                        //   itemCount: comprehensiveRankingList.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     //自定义的行 代码在下面
                        //     return _showGridViewItem(context,
                        //         comprehensiveRankingList[index], index);
                        //   },
                        // ),
                        child: Row(
                          children: _rowItem(context),
                        ),
                      ),
                    ],
                  ),
                ),

                ///容器背景图片
                Container(
                  margin: const EdgeInsets.only(left: 14),
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg.png'),
                      fit: BoxFit.fill, // 完全填充
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  // ListView
  Widget _buildCompanyList() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 12, right: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.shadowColor,
            offset: Offset(0, 0),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "精选公司",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomColors.greyBlack,
            ),
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              BackCheckCompanyListItemModel itemModel = companyList[index];
              return _showListViewItem(
                  context, companyList[index], ScreenTool.screenWidth - 24, () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) =>
                        new NewCompanyDerailsPage(companyId: itemModel.id),
                  ),
                );
              });
            },
            itemCount: companyList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  List<Widget> _rowItem(BuildContext context) {
    List<Widget> viewList = [];
    for (var i = 0; i < comprehensiveRankingList.length; i++) {
      Widget view = _showGridViewItem(context, comprehensiveRankingList[i], i);

      viewList.add(Expanded(child: view));
    }

    return viewList;
  }

  Widget _showGridViewItem(
      BuildContext context, BackCheckCompanyListItemModel model, int index) {
    ///logo
    ImageProvider image;
    String companyImagePath = model.logo;
    if (companyImagePath.isEmpty) {
      image = const AssetImage("assets/images/logo.png");
    } else {
      image = NetworkImage(companyImagePath);
    }

    ///王冠标示
    double iconSize = 25;
    double itemSize = 80;
    String iconPath = "";
    String iconString = "";
    double textTop = 8.0;
    double wTop = -10.0;

    if (index == 0) {
      iconPath = "assets/images/svg/皇冠2.svg";
      iconString = "2";
      itemSize = 75;
      textTop = 8.0;
    } else if (index == 1) {
      iconPath = "assets/images/svg/皇冠1.svg";
      iconSize = 30;
      iconString = "1";
      itemSize = 82;
      textTop = 0.0;
      wTop = -13.0;
    } else {
      itemSize = 75;
      iconPath = "assets/images/svg/皇冠3.svg";
      iconString = "3";
      textTop = 8.0;
    }

    IconButton icon = IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        iconPath,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.fill,
      ),
    );

    ///底标

    return InkWell(
      //用inkWell是为了添加点击事件
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (context) =>
                new NewCompanyDerailsPage(companyId: model.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: itemSize,
                  height: itemSize,
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.shadowGreenColor,
                        offset: Offset(0, 0),
                        blurRadius: 6,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image(
                      image: image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  top: wTop,
                  left: 85 - iconSize,
                  child: Container(
                    alignment: Alignment.topRight,
                    child: icon,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 85 - 14,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: CustomColors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    width: 14,
                    height: 14,
                    child: Text(
                      iconString,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //一个图标 公司icon

            //一个文本
            Container(
              margin: EdgeInsets.only(top: textTop),
              child: Text(
                model.productName,
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

  Widget _showListViewItem(
    BuildContext context,
    BackCheckCompanyListItemModel data,
    double itemWidth,
    listItemAction,
  ) {
    String companyNameStr = data.productName;
    String companyintroductionStr = data.introduction;
    String companyImagePath = data.logo;

    ImageProvider image;
    if (companyImagePath.isEmpty) {
      image = const AssetImage("assets/images/logo.png");
    } else {
      image = NetworkImage(companyImagePath);
    }

    Image companyImage = Image(
      image: image,
      width: 80,
      height: 103,
      fit: BoxFit.fitWidth,
    );

    Text companyNameText = Text(
      companyNameStr,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      ),
      maxLines: 1,
    );
    Text companyintroductionText = Text(
      companyintroductionStr,
      style: const TextStyle(fontSize: 12.0, height: 1.5),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: listItemAction,
          child: SizedBox(
            width: itemWidth,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  width: 80,
                  height: 91,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.shadowColor,
                        offset: Offset(0, 0),
                        blurRadius: 6,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: companyImage,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 103.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 8,
                        ),
                        //     公司名称
                        companyNameText,
                        const SizedBox(
                          height: 5,
                        ),
                        //    公司简介
                        companyintroductionText,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
