// ignore_for_file: unnecessary_new

/***
 * @Date: 2022-05-31 13:40
 * @LastEditTime: 2022-06-16 14:35
 * @Description: 背调公司搜索页
 */
import 'dart:ui';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/back_check_company_manager.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/pages/modules/company/new_company_details.dart';
import 'package:credit_flutter/pages/modules/company/search/search_results_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //历史记录list
  List<String> historySearchList = [];

  //热门搜索
  List<BackCheckCompanyListItemModel> hotSeachList = [];

  //搜索Controller
  final TextEditingController _searchController = TextEditingController();

  //搜索
  String searchText = "";

  //获取本地数据
  SharedPreferences? sp;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initSp();
  }

//初始化本地数据
  _initSp() async {
    sp = await SharedPreferences.getInstance();
    List<String>? spList = sp?.getStringList("search_history");

    if (spList != null) {
      historySearchList = spList;
    }

    Map<String, dynamic> param = {
      "pageNum": 1,
      "pageSize": 5,
      "type": 2,
    };
    BackCheckCompanyManager.list(param, (listModel) {
      setState(() {
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;
        hotSeachList = liModel.data;
      });
    });
  }

  // 搜索
  void _search() {
    setState(() {
      if (historySearchList.contains(searchText)) {
        historySearchList.remove(searchText);
      }
      historySearchList.insert(0, searchText);
      if (historySearchList.length > 5) {
        historySearchList.removeAt(historySearchList.length - 1);
      }
      _searchController.text = searchText;
    });
    sp?.setStringList("search_history", historySearchList);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
              builder: (_) => SearchResultsPage(keyword: searchText)),
        )
        .then((val) => val ? _getsetState() : null);
  }

  _getsetState() {
    setState(() {
      List<String>? spList = sp?.getStringList("search_history");
      if (spList != null) {
        historySearchList = spList;
        searchText = historySearchList.first;
        _searchController.text = searchText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: CustomColors.connectColor,
            elevation: 0,
            titleSpacing: 0.0,
            leadingWidth: 30,
            actions: [
              IconButton(
                icon: const Text(
                  "搜索",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (_searchController.text.isNotEmpty) {
                    setState(() {
                      searchText = _searchController.text;
                      _search();
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  }
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              alignment: Alignment.centerRight,
              color: Colors.white,
              onPressed: () => Navigator.pop(context, true),
            ),
            title: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              height: 35,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    maxLines: 1,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(500)
                    ],
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.search,
                    onEditingComplete: () {
                      if (_searchController.text.isNotEmpty) {
                        searchText = _searchController.text;
                        FocusManager.instance.primaryFocus?.unfocus();
                        _search();
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      isCollapsed: true,
                      hintText: "请输入公司名称",
                      hintStyle: TextStyle(
                          fontSize: 16, color: CustomColors.darkGrey99),
                    ),
                  ),
                ],
              ),
            ),
            // title: Container(
            //   padding: const EdgeInsets.only(left: 10, right: 10),
            //   height: 33,
            //   decoration: const BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.all(Radius.circular(16)),
            //     boxShadow: [
            //       BoxShadow(
            //         color: CustomColors.shadowColor,
            //         offset: Offset(0, 0),
            //         blurRadius: 2,
            //         spreadRadius: 1,
            //       ),
            //     ],
            //   ),
            //   child: TextField(
            //     controller: _searchController,
            //     cursorColor: Colors.black,
            //     textInputAction: TextInputAction.search,
            //     textAlignVertical: TextAlignVertical.center,
            //     maxLines: 1,
            //     onEditingComplete: () {
            //       searchText = _searchController.text.isEmpty
            //           ? '一诺背调'
            //           : _searchController.text;
            //       FocusManager.instance.primaryFocus?.unfocus();
            //       _search();
            //     },
            //     decoration: InputDecoration(
            //       border: InputBorder.none,
            //       hintText: "一诺背调",
            //       hintStyle: const TextStyle(
            //         fontSize: 12,
            //         color: CustomColors.darkGrey99,
            //       ),
            //       // icon: SvgPicture.asset(
            //       //   "assets/images/svg/seachIcon.svg",
            //       //   width: 15,
            //       //   height: 15,
            //       // ),
            //     ),
            //   ),
            // ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Listener(
                    onPointerMove: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: _buildUnSearchingPage(),
                    ),
                    // PlayWidget(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建搜索中的布局
  Widget _buildSearchingPage() {
    return Column(
      children: [
        Text("搜索"),
      ],
    );
  }

  // 历史搜索
  Widget _buildHistorySearch() {
    return Offstage(
      offstage: historySearchList.isEmpty,
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        decoration: const BoxDecoration(
          color: CustomColors.lightGreyFB,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    '搜索历史',
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.darkGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/images/svg/delete.svg",
                    width: 15,
                    height: 15,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                              "确定清空全部历史记录？",
                              style: common14GrayTextStyle,
                            ),
                            actions: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '取消',
                                  style:
                                      TextStyle(color: CustomColors.lightGrey),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    historySearchList.clear();
                                    sp?.remove("search_history");
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '清空',
                                  style: TextStyle(
                                      color: CustomColors.warningColor),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                )
              ],
            ),
            Wrap(
              spacing: 20,
              children: historySearchList
                  .map(
                    (v) => GestureDetector(
                      onTap: () {
                        searchText = v;
                        _search();
                      },
                      child: Chip(
                        backgroundColor: Colors.white,
                        label: Text(
                          v,
                          style: const TextStyle(
                              fontSize: 12, color: CustomColors.darkGrey99),
                        ),
                        // deleteIcon: Image(
                        //   width: 10,
                        //   height: 10,
                        //   image: AssetImage("assets/images/cha.png"),
                        // ),
                        // onDeleted: () {
                        //   setState(() {
                        //     if (historySearchList.contains(v)) {
                        //       historySearchList.remove(v);
                        //     }
                        //     sp?.setStringList(
                        //         "search_history", historySearchList);
                        //   });
                        // },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // 构建未搜索时的布局
  Widget _buildUnSearchingPage() {
    return ListView(
      // padding: EdgeInsets.symmetric(
      //   horizontal: 40,
      //   vertical: 30,
      // ),
      children: <Widget>[
        _buildHistorySearch(),
        _buildHotSearch(),
      ],
    );
  }

  // 热门推荐
  Widget _buildHotSearch() {
    return Container(
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
          const Text(
            '热门公司榜',
            style: bold16TextStyle,
          ),
          const SizedBox(
            height: 15,
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return _showListViewItem(
                context,
                hotSeachList[index],
                ScreenTool.screenWidth - 24,
                index,
                () {
                  BackCheckCompanyListItemModel model = hotSeachList[index];
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (context) =>
                          new NewCompanyDerailsPage(companyId: model.id),
                    ),
                  );
                },
              );
            },
            itemCount: hotSeachList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  Widget _showListViewItem(
    BuildContext context,
    BackCheckCompanyListItemModel data,
    double itemWidth,
    int index,
    listItemAction,
  ) {
    BoxDecoration temDecoration = const BoxDecoration(
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
    );

    String companyNameStr = "";
    String companyintroductionStr = "";
    String companyImagePath = "";
    companyNameStr = data.name;
    companyintroductionStr = data.introduction;
    companyImagePath = data.logo;

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
      // fit: BoxFit.fill,
      fit: BoxFit.fitWidth,
    );

    Text companyNameText = Text(
      companyNameStr,
      style: const TextStyle(
        fontSize: 12.0,
        color: CustomColors.greyBlack,
      ),
      maxLines: 1,
    );

    Text companyNumberText = const Text(
      "19675人查看",
      style: TextStyle(
        fontSize: 10.0,
        color: CustomColors.darkGrey99,
      ),
      maxLines: 1,
    );

    return Column(children: [
      GestureDetector(
        onTap: listItemAction,
        child: Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          width: itemWidth,
          child: Row(
            children: <Widget>[
              ///排序
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.centerLeft,
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ///公司logo
              Container(
                width: 45,
                height: 45,
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
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //     公司名称
                      companyNameText,
                      companyNumberText,
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
    ]);
  }
}
