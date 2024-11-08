import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/back_check_company_manager.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/pages/modules/company/company_details.dart';
import 'package:credit_flutter/pages/modules/company/new_company_details.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// *
/// @Date: 2022-06-02 15:47
/// @LastEditTime: 2022-06-13 14:12
/// @Description: 搜索结果页
class SearchResultsPage extends StatefulWidget {
  final String keyword;

  const SearchResultsPage({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  //获取本地数据
  SharedPreferences? sp;

  //搜索Controller
  TextEditingController _searchController = TextEditingController();

  //历史记录list
  List<String> historySearchList = [];

  //搜索
  String searchText = "";
  List<BackCheckCompanyListItemModel> seachResultList = [];

  @override
  void initState() {
    super.initState();
    _initSp();
    searchText = widget.keyword;
    BackCheckCompanyManager.list({"productName": widget.keyword}, (object) {
      BackCheckCompanyListModel liModel = object as BackCheckCompanyListModel;
      setState(() {
        seachResultList = liModel.data;
      });
    });
  }

  _initSp() async {
    sp = await SharedPreferences.getInstance();
    List<String>? spList = sp?.getStringList("search_history");

    if (spList != null) {
      historySearchList = spList;
    }
  }

  @override
  Widget build(BuildContext context) {
    _searchController.text = searchText;
    return Scaffold(
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
          height: 33,
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
                  hintStyle:
                      TextStyle(fontSize: 16, color: CustomColors.darkGrey99),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  ///
  Widget _buildBody() {
    if (seachResultList.isEmpty) {
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
              "暂无相关搜索",
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
      return Listener(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: _buildResults(),
            ),
            // PlayWidget(),
          ],
        ),
      );
    }
  }

//搜索结果列表
  // 热门推荐
  Widget _buildResults() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 12, right: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _showListViewItem(
              context, seachResultList[index], ScreenTool.screenWidth, () {
            BackCheckCompanyListItemModel model = seachResultList[index];
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    new NewCompanyDerailsPage(companyId: model.id),
              ),
            );
          });
        },
        itemCount: seachResultList.length,
        shrinkWrap: true,
      ),
    );
  }

  /// *
  /// @description: 公司列表item
  /// @Date: 2022-06-09 15:00
  /// @parm:  data 数据
  ///        itemWidth cell的总宽度
  ///        isBoxShadow 是否显示阴影
  /// @return {*}
//List item
  Widget _showListViewItem(
    BuildContext context,
    BackCheckCompanyListItemModel data,
    double itemWidth,
    listItemAction,
  ) {
    String companyNameStr = "";
    String companyintroductionStr = "";
    String companyImagePath = "";
    if (data != null) {
      companyNameStr = data.productName;
      companyintroductionStr = data.introduction;
      companyImagePath = data.logo;
    }

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
      style: const TextStyle(fontSize: 12.0),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );

    SizedBox box;

    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      GestureDetector(
        onTap: listItemAction,
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                  blurRadius: 4.0, //阴影模糊程度
                  spreadRadius: 1.0 //阴影扩散程度
                  )
            ],
          ),
          // padding: const EdgeInsets.all(10),
          // margin: const EdgeInsets.only(left: 12, right: 12),

          width: itemWidth,

          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                width: 80,
                height: 91,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                        blurRadius: 4.0, //阴影模糊程度
                        spreadRadius: 1.0 //阴影扩散程度
                        )
                  ],
                ),
                child: companyImage,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  height: 103.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),
                      //     公司名称
                      companyNameText,
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
    ]);
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
    BackCheckCompanyManager.list({"productName": searchText}, (object) {
      BackCheckCompanyListModel liModel = object as BackCheckCompanyListModel;
      setState(() {
        seachResultList = liModel.data;
      });
    });
  }
}
