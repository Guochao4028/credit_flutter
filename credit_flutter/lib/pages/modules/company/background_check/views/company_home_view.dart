/// *
/// -  @Date: 2022-08-12 17:26
/// -  @LastEditTime: 2022-08-12 17:28
/// -  @Description: 背调 首页 view
///
import 'package:banner_carousel/banner_carousel.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompanyBackgroundCheckView implements ScreeningBarListener {
  List<BackCheckCompanyListItemModel> _comprehensiveRankingList = [];
  List<BackCheckCompanyListItemModel> _companyList = [];
  List<Map<String, dynamic>> _screeningList = [];
  CompanyHomeViewListener? clickListener;
  double _statusHeight = 0.0;

  String loadingText = "加载中.....";

  CompanyBackgroundCheckView({this.clickListener, Key? key});

  PageController? _pageController;

  /// *
  /// -  @description: 头视图
  /// -  @Date: 2022-08-17 13:25
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _headView() {
    double expandedHeight = 0.0,
        titleViewHeight = 131,
        feedbackHeight = 131,
        recommendedHeight = 40;

    expandedHeight += titleViewHeight;
    expandedHeight += feedbackHeight;
    expandedHeight += recommendedHeight;
    if (_comprehensiveRankingList.isNotEmpty) {
      expandedHeight += 190;
    }
    // return SliverAppBar(
    //   floating: false,
    //   pinned: true,
    //   elevation: 0,
    //   backgroundColor: Colors.transparent,
    //   expandedHeight: expandedHeight,
    //   toolbarHeight: 40,
    //   flexibleSpace: FlexibleSpaceBar(
    //   background: Column(
    //     children: [
    //       Stack(
    //         children: <Widget>[
    //           AppBar(
    //             backgroundColor: Colors.transparent,
    //             elevation: 0,
    //           ),
    //           homeTilteView(() {
    //             ///搜索栏点击事件
    //             clickListener?.tapSearch();
    //           }, "一诺背调"),
    //           feedback(() {
    //             ///意见反馈
    //             clickListener?.tapFeedback();
    //           }),
    //         ],
    //       ),
    //       comprehensiveRanking(_comprehensiveRankingList),
    //       rankingTitleView(),
    //     ],
    //   ),
    // ),
    // bottom: ScreeningBar(
    //   screeningList: _screeningList,
    //   listener: this,
    // ),
    // );

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              homeTilteView(() {
                ///搜索栏点击事件
                clickListener?.tapSearch();
              }, "一诺背调"),
              Listener(
                onPointerDown: (PointerDownEvent e) {
                  //按下
                  clickListener?.onPointerDown();
                },
                onPointerUp: (PointerUpEvent e) {
                  //抬起
                  clickListener?.onPointerUp();
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 131 - 37,
                  ),
                  child: BannerCarousel(
                    pageController: _pageController,
                    indicatorBottom: false,
                    customizedIndicators: const IndicatorModel.animation(
                        width: 8,
                        height: 8,
                        spaceBetween: 2,
                        widthAnimation: 8),
                    margin: const EdgeInsets.all(0),
                    activeColor: Colors.white,
                    disableColor: const Color(0xB3D8D8D8),
                    customizedBanners: [
                      rankingList(() {
                        ///排行榜
                        clickListener?.tapRankingList();
                      }),
                      feedback(() {
                        ///意见反馈
                        clickListener?.tapFeedback();
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          servicesTitleView(),
          const SizedBox(height: 10),
          popularServices(() {
            //薪资测评
            clickListener?.salaryEvaluation();
          }, () {
            //证书提醒
            clickListener?.certificateReminder();
          }),
          // comprehensiveRanking(_comprehensiveRankingList),
          rankingTitleView(),
          ScreeningBar(
            screeningList: _screeningList,
            listener: this,
          ),
        ],
      ),
    );
  }

  Widget rankingTitleView() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              ///容器背景图片
              Container(
                margin: const EdgeInsets.only(left: 22, top: 15),
                width: 42,
                height: 23,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/rectangular.png'),
                    fit: BoxFit.fill, // 完全填充
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.only(left: 16, right: 16),
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ///标题
                    Container(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Row(
                        children: const [
                          Text(
                            '精选公司',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  /// *
  /// -  @description: 头视图搜索栏，偏移到107时显示
  /// -  @Date: 2022-08-17 13:25
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget _heardViewSeachBar() {
    return GestureDetector(
      onTap: (() {
        clickListener?.tapSearch();
      }),
      child: Container(
        width: ScreenTool.screenWidth,
        height: 60 + _statusHeight,
        decoration: const BoxDecoration(
          color: CustomColors.lightBlue,
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Row(
            children: [
              const SizedBox(
                // width: 44,
                child: Text(
                  "背调",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 23, right: 0),
                  padding: const EdgeInsets.only(left: 28),
                  height: 30,
                  width: ScreenTool.screenWidth - 32 - 44 - 23,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          "assets/images/svg/seachIcon.svg",
                        ),
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      const Text(
                        "一诺背调",
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomColors.darkGrey99,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeView(
    double statusHeight,
    ScrollController scrollController,
    bool isHidden,
    bool isScreeningHidden,
    List<BackCheckCompanyListItemModel> rankingList,
    List<BackCheckCompanyListItemModel> companyList,
    List<Map<String, dynamic>> screeningList,
    bool isLoadMore,
    PageController? pageController,
  ) {
    _pageController = pageController;
    _comprehensiveRankingList = rankingList;
    _comprehensiveRankingList = rankingList;
    _companyList = companyList;
    _screeningList = screeningList;
    _statusHeight = statusHeight;
    double top = (60 + _statusHeight);
    return RefreshIndicator(
      child: Stack(
        children: [
          CustomScrollView(
            // physics: ScrollPhysics(),
            controller: scrollController,
            slivers: <Widget>[
              _headView(),
              SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate(_buildListItem,
                      childCount: _companyList.length),
                  itemExtent: 113.0),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: isLoadMore,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Center(
                      child: Text(loadingText),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Offstage(
            offstage: isHidden,
            child: _heardViewSeachBar(),
          ),
          Offstage(
            offstage: isScreeningHidden,
            child: Container(
              height: 60 + _statusHeight + 46,
              padding: EdgeInsets.only(top: top),
              child: ScreeningBar(
                screeningList: _screeningList,
                listener: this,
              ),
            ),
          ),
        ],
      ),
      onRefresh: () {
        return _RrefreshPull().then((value) {
          print('success');
        }).catchError((error) {
          print('failed');
        });
      },
    );

    // return Stack(
    //   children: [
    //     CustomScrollView(
    //       controller: scrollController,
    //       slivers: <Widget>[
    //         _headView(),
    //         SliverFixedExtentList(
    //             delegate: SliverChildBuilderDelegate(_buildListItem,
    //                 childCount: _companyList.length),
    //             itemExtent: 113.0),
    //       ],
    //     ),
    //     Offstage(
    //       offstage: isHidden,
    //       child: _heardViewSeachBar(),
    //     ),
    //   ],
    // );
  }

  Future<String> _RrefreshPull() async {
    clickListener?.refreshPull();
    return "_RrefreshPull";
  }

// 列表项
  Widget _buildListItem(BuildContext context, int index) {
    BackCheckCompanyListItemModel itemModel = _companyList[index];
    return _showListViewItem(context, itemModel, () {
      clickListener?.tapCompanyInfo(itemModel);
    });
  }

  Widget _showListViewItem(
    BuildContext context,
    BackCheckCompanyListItemModel data,
    listItemAction,
  ) {
    String companyNameStr = data.productName;
    String companyintroductionStr = data.introduction;
    String companyImagePath = data.logo;
    double score = data.score;
    int commentCount = data.commentCount;
    ImageProvider image;
    if (companyImagePath.isEmpty) {
      image = const AssetImage("assets/images/logo.png");
    } else {
      image = NetworkImage(companyImagePath);
    }

    Image companyImage = Image(
      image: image,
      width: 92,
      height: 102,
      fit: BoxFit.fitWidth,
    );

    Text companyNameText = Text(
      companyNameStr,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      ),
      maxLines: 2,
    );

    ///分数
    Text scoreText = Text(
      "$score分",
      style: const TextStyle(
        fontSize: 12.0,
        color: CustomColors.darkGrey99,
      ),
      maxLines: 1,
    );

    ///点评
    Text reviewText = Text(
      "｜   $commentCount点评",
      style: const TextStyle(
        fontSize: 12.0,
        color: CustomColors.darkGrey99,
      ),
      maxLines: 1,
    );

    ///评价
    Text evaluation = Text(
      companyintroductionStr,
      style: const TextStyle(fontSize: 12.0, height: 1.5),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
    return Container(
      width: double.infinity,
      height: 113,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: InkWell(
        onTap: listItemAction,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 102,
                    height: 92,
                    padding: const EdgeInsets.only(
                        top: 2, left: 6, right: 6, bottom: 2),
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
                    child: companyImage,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 93,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///公司名称
                          companyNameText,
                          const SizedBox(
                            height: 5,
                          ),

                          ///评价
                          evaluation,
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                                height: 15,
                                child: SvgPicture.asset(
                                  "assets/images/svg/star.svg",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),

                              ///分数
                              scoreText,
                              const SizedBox(
                                width: 7,
                              ),

                              ///点评
                              reviewText
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 9,
              ),
              Container(
                height: 1,
                color: CustomColors.colorEDF6F6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// *
  /// -  @description: 背调公司首页title
  /// -  @Date: 2022-08-12 17:33
  /// -  @parm: onClick 搜索点击事件
  /// -  @return {*}
  ///
  Widget homeTilteView(Function onClick, String seachText) {
    return Container(
      height: 131,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/companyHomeBg.png'),
            fit: BoxFit.fill),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          children: [
            const SizedBox(
              // width: 44,
              child: Text(
                "背调",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (() {
                  onClick();
                }),
                child: Container(
                  margin: const EdgeInsets.only(left: 23, right: 0),
                  padding: const EdgeInsets.only(left: 28),
                  height: 30,
                  // width: ScreenTool.screenWidth - 32 - 44 - 23,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          "assets/images/svg/seachIcon.svg",
                        ),
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      Text(
                        seachText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CustomColors.darkGrey99,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// *
  /// -  @description: 反馈意见
  /// -  @Date: 2022-08-15 10:05
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget feedback(Function onClick) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 26, right: 16),
        margin: const EdgeInsets.only(left: 16, right: 16),
        height: 131,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/banner_feedback.png'),
            fit: BoxFit.fill, // 完全填充
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "反馈意见随时提交",
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
              ),
            ),
            const Text(
              "我们将用心帮助您！",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 77,
              height: 20,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/buttonBg.png'),
                    fit: BoxFit.fill, // 完全填充
                  ),
                ),
                child: const Text(
                  "查看详情",
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.textBlue,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// *
  /// -  @description: 排行榜
  /// -  @Date: 2022-08-15 10:05
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget rankingList(Function onClick) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 26, right: 16),
        margin: const EdgeInsets.only(left: 16, right: 16),
        height: 131,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/banner_ranking_list.png'),
            fit: BoxFit.fill, // 完全填充
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "排行榜全新上线",
              style: TextStyle(
                fontSize: 21,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 77,
              height: 20,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: const Text(
                  "查看排名",
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.textBlue,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///热门服务标题
  Widget servicesTitleView() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              ///容器背景图片
              Container(
                margin: const EdgeInsets.only(left: 22, top: 15),
                width: 42,
                height: 23,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/rectangular.png'),
                    fit: BoxFit.fill, // 完全填充
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.only(left: 16, right: 16),
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ///标题
                    Container(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Row(
                        children: const [
                          Text(
                            '热门服务',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  ///热门服务
  Widget popularServices(Function onClick1, Function onClick2) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              onClick1();
            },
            child: SizedBox(
              height: 101,
              child: Stack(
                children: [
                  const Image(
                    fit: BoxFit.fill,
                    image:
                        AssetImage("assets/images/icon_salary_evaluation.png"),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  '薪资测评',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Image(
                                image: AssetImage(
                                    "assets/images/icon_circular_arrow.png"),
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            '各个行业薪资测评',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          width: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Center(
                            child: Text(
                              '查询',
                              style: TextStyle(
                                color: CustomColors.color59A1F8,
                                fontSize: 12,
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
              onClick2();
            },
            child: SizedBox(
              height: 101,
              child: Stack(
                children: [
                  const Image(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        "assets/images/icon_certificate_reminder.png"),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  '证书提醒',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Image(
                                image: AssetImage(
                                    "assets/images/icon_circular_arrow.png"),
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            '证书详情详细说明',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          width: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Center(
                            child: Text(
                              '添加',
                              style: TextStyle(
                                color: CustomColors.color8F8EF8,
                                fontSize: 12,
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
    );
  }

  /// *
  /// -  @description: 综合排名
  /// -  @Date: 2022-08-15 11:24
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget comprehensiveRanking(List comprehensiveRankingList) {
    return comprehensiveRankingList.isEmpty
        ? const SizedBox()
        : Offstage(
            //是否隐藏
            offstage: comprehensiveRankingList.isNotEmpty ? false : true,
            child: Stack(
              children: [
                ///容器背景图片
                Container(
                  margin: const EdgeInsets.only(left: 22, top: 15),
                  width: 42,
                  height: 23,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/rectangular.png'),
                      fit: BoxFit.fill, // 完全填充
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  decoration: const BoxDecoration(color: Colors.white),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            InkWell(
                              child: const Text(
                                '更多 >',
                                style: TextStyle(
                                  color: CustomColors.darkGrey99,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                clickListener?.tapMore();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: ScreenTool.screenWidth - 32,
                        height: 160,
                        child: Row(
                          children: _rowItem(comprehensiveRankingList),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  List<Widget> _rowItem(List comprehensiveRankingList) {
    List<Widget> viewList = [];
    for (var i = 0; i < comprehensiveRankingList.length; i++) {
      Widget view = _showGridViewItem(comprehensiveRankingList[i], i);

      viewList.add(Expanded(child: view));
    }
    return viewList;
  }

  Widget _showGridViewItem(BackCheckCompanyListItemModel model, int index) {
    ///logo
    ImageProvider image;
    String companyImagePath = model.logo;
    if (companyImagePath.isEmpty) {
      image = const AssetImage("assets/images/logo.png");
    } else {
      image = NetworkImage(companyImagePath);
    }

    ///王冠标示
    double iconSize = 27;
    double itemSize = 85;
    String iconPath = "";
    String iconString = "";
    double iconWTop = -10.0;
    double iconLeft = 85 - iconSize;
    Color borderColor;
    double borderWidth = 0.0;
    double iconBottom = 10.0;
    double textLeft = 85 - 17;
    double textBottom = 0.0;
    if (index == 0) {
      iconPath = "assets/images/svg/皇冠2.svg";
      iconString = "2";
      borderColor = CustomColors.darkGreyC3C6;
      borderWidth = 1.5;
      iconWTop = 18;
      iconLeft = 85 - 20;
      textLeft = 85 - 27;
      textBottom = 0;
    } else if (index == 1) {
      iconPath = "assets/images/svg/皇冠1.svg";
      iconSize = 37;
      iconString = "1";
      itemSize = 108;
      borderColor = CustomColors.borderYColor993E;
      borderWidth = 2.5;
      iconBottom = 15;
      iconWTop = -4;
      iconLeft = 75;
    } else {
      iconPath = "assets/images/svg/皇冠3.svg";
      iconString = "3";
      borderColor = CustomColors.borderYColor88C;
      borderWidth = 1.5;
      iconWTop = 18;
      iconLeft = 85 - 20;
      textLeft = 85 - 27;
    }

    IconButton icon = IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        iconPath,
        width: iconSize,
        height: iconSize,
      ),
    );

    ///底标
    return InkWell(
      //用inkWell是为了添加点击事件
      onTap: () {
        clickListener?.tapCompanyInfo(model);
      },
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              //一个图标 公司icon
              Container(
                color: Colors.white,
                width: 108 + 8,
                height: 108 + 18,
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Container(
                      width: itemSize,
                      height: itemSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: borderColor, width: borderWidth),
                        shape: BoxShape.circle,
                        boxShadow: const [
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
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: textBottom,
                      left: textLeft,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: CustomColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        width: 16,
                        height: 16,
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
              ),
              Positioned(
                top: iconWTop,
                left: iconLeft,
                child: Container(
                  child: icon,
                ),
              ),
            ],
          ),

          //一个文本
          Container(
            margin: const EdgeInsets.only(top: 10),
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
    );
  }

  /// *
  /// -  @description: 公司列表
  /// -  @Date: 2022-08-15 15:50
  /// -  @parm:
  /// -  @return {*}
  ///
  Widget builderCompanyList(List companyList) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              ///容器背景图片
              Container(
                margin: const EdgeInsets.only(left: 22, top: 15),
                width: 42,
                height: 23,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/rectangular.png'),
                    fit: BoxFit.fill, // 完全填充
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                margin: const EdgeInsets.only(left: 16, right: 16),
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ///标题
                    Container(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Row(
                        children: const [
                          Text(
                            '精选公司',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  @override
  tapScreening(Map<String, dynamic> model) {
    clickListener?.tapScreening(model);
  }
}

/// *
/// -  @description: 筛选栏
/// -  @Date: 2022-08-17 13:28
class ScreeningBar extends StatefulWidget
    implements PreferredSizeWidget, ScreeningBarListener {
  static const double _kTabHeight = 46.0;
  List<Map<String, dynamic>> screeningList;

  ScreeningBarListener? listener;

  ScreeningBar({required this.screeningList, this.listener, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScreeningBarState(listener: this);
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(_kTabHeight);
  }

  @override
  tapScreening(Map<String, dynamic> model) {
    listener?.tapScreening(model);
  }
}

class _ScreeningBarState extends State<ScreeningBar> {
  List<Map<String, dynamic>> _screeningList = [];
  ScreeningBarListener? listener;

  _ScreeningBarState({this.listener});

  @override
  void initState() {
    super.initState();
    setState(() {
      _screeningList = widget.screeningList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      height: 46,
      width: double.infinity,
      child: Row(
        children: _screeningWidgets(_screeningList),
      ),
    );
  }

  List<Widget> _screeningWidgets(List<Map<String, dynamic>> titles) {
    List<Widget> viewList = [];
    for (var i = 0; i < titles.length; i++) {
      Map<String, dynamic> map = titles[i];

// {"title": "评分", "isSelected": false, "isHidden": false, "id": "3"},
      DropHeadWidget view = DropHeadWidget(
        map["title"],
        map["isSelected"],
        () {
          _printTitle(map);
        },
        isHiddenIcon: map["isHidden"],
        isRepeat: map["isRepeat"],
        direction: map["direction"],
      );

      viewList.add(Expanded(child: view));
    }
    return viewList;
  }

  _printTitle(Map<String, dynamic> model) {
    listener?.tapScreening(model);
  }
}

class DropHeadWidget extends StatefulWidget {
  String title;
  bool isForward;
  Function onClick;
  double headFontSize;
  bool isHiddenIcon;
  bool isRepeat;
  String direction;
  IconData iconData;

  DropHeadWidget(this.title, this.isForward, this.onClick,
      {this.headFontSize = 14.0,
      this.iconData = Icons.arrow_drop_down_outlined,
      this.isHiddenIcon = true,
      this.isRepeat = false,
      this.direction = "",
      key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DropHeadWidgetState();
  }
}

class _DropHeadWidgetState extends State<DropHeadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> shAnimation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DropHeadWidget oldWidget) {
    if (widget.isForward) {
      if (widget.isRepeat == true && widget.direction.isNotEmpty) {
        if (widget.direction == "a") {
          controller.forward();
        } else {
          controller.reverse();
        }
      } else {
        controller.forward();
      }
    } else {
      controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    shAnimation = Tween(begin: .0, end: .5).animate(controller)
      ..addStatusListener((status) {
        setState(() {
          if (status == AnimationStatus.completed) {
          } else {}
        });
      });
    if (widget.isForward) {
      if (widget.isRepeat == true && widget.direction.isNotEmpty) {
        if (widget.direction == "a") {
          controller.forward();
        } else {
          controller.reverse();
        }
      } else {
        controller.forward();
      }
    } else {
      controller.reverse();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? headTextStyle;
    Icon iconData;
    if (widget.isRepeat) {
      if (widget.isForward) {
        headTextStyle ??=
            TextStyle(fontSize: widget.headFontSize, color: Colors.blue);
        iconData = Icon(
          widget.iconData,
          color: Colors.blue,
          size: 20,
        );
      } else {
        headTextStyle = TextStyle(
            fontSize: widget.headFontSize, color: const Color(0xff333333));
        iconData = Icon(
          widget.iconData,
          size: 20,
          color: const Color(0xff333333),
        );
      }
      //
    } else {
      if (shAnimation.isCompleted) {
        headTextStyle ??=
            TextStyle(fontSize: widget.headFontSize, color: Colors.blue);
        iconData = Icon(
          widget.iconData,
          color: Colors.blue,
          size: 20,
        );
        //
      } else {
        headTextStyle = TextStyle(
            fontSize: widget.headFontSize, color: const Color(0xff333333));
        iconData = Icon(
          widget.iconData,
          size: 20,
          color: const Color(0xff333333),
        );
      }
    }

    return InkWell(
      onTap: () {
        widget.onClick();
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title, style: headTextStyle),
            widget.isHiddenIcon == false
                ? RotationTransition(
                    turns: shAnimation,
                    child: iconData,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

abstract class CompanyHomeViewListener {
  tapSearch();

  tapFeedback();

  tapRankingList();

  onPointerDown();

  onPointerUp();

  tapMore();

  tapCompanyInfo(BackCheckCompanyListItemModel model);

  tapScreening(Map<String, dynamic> model);

  refreshPull();

  //薪资测评
  salaryEvaluation();
  //证书提醒
  certificateReminder();
}

abstract class ScreeningBarListener {
  tapScreening(Map<String, dynamic> model);
}
