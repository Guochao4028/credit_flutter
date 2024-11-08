/***
 * @Date: 2022-05-27 11:09
 * @LastEditTime: 2022-06-09 18:26
 * @Description: 选择公司页面
 */
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/pages/modules/company/company_home_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

// 每个页面展示四个item
const int EVERY_PAGE_GRID_COUNT = 6;

class SelectCompanyPage extends StatefulWidget {
  const SelectCompanyPage({Key? key}) : super(key: key);

  @override
  State<SelectCompanyPage> createState() => _SelectCompanyPageState();
}

class _SelectCompanyPageState extends State<SelectCompanyPage> {
  bool flag = false;

  ScrollController scrollController = ScrollController();

  SwiperController swiperController = SwiperController();

  //当前显示的是itmeList第几个
  int currentPageNumber = 0;
  List<Map<String, dynamic>> showList = [];
  List<Map<String, dynamic>> itmeList = [
    {
      "name": "复兴新媒体",
      "isSelected": "0",
    },
    {
      "name": "中数据数字",
      "isSelected": "0",
    },
    {
      "name": "小屋信息",
      "isSelected": "0",
    },
    {
      "name": "携程计算机",
      "isSelected": "0",
    },
    {
      "name": "小桔科技",
      "isSelected": "0",
    },
    {
      "name": "蒜芽信息",
      "isSelected": "0",
    },
  ];

  @override
  @override
  Widget build(BuildContext context) {
    double allWidth = (ScreenTool.screenWidth - (32 + (9.5 * 2)));
    double buttoneWidth = ScreenTool.screenWidth - 60;
    double itemWidth = allWidth / 3;
    int itemLength = itmeList.length;
    var numPage = itmeList.length % EVERY_PAGE_GRID_COUNT == 0
        ? (itmeList.length ~/ EVERY_PAGE_GRID_COUNT)
        : (itmeList.length ~/ EVERY_PAGE_GRID_COUNT + 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _titleText("请选择您要管理的公司"),
            const SizedBox(
              height: 55,
            ),
            SizedBox(
              width: ScreenTool.screenWidth,
              height: 251,
              child: Swiper(
                key: UniqueKey(),
                autoplay: false,
                //指示器位于分页下面还是内部
                outer: true,
                fade: 1,
                viewportFraction: 1,
                itemCount: numPage,
                loop: false,
                scale: 0.95,
                controller: swiperController,
                layout: SwiperLayout.DEFAULT,
                index: currentPageNumber,

                itemBuilder: (BuildContext context, int pageIndex) {
                  currentPageNumber = pageIndex;
                  showList.clear();
                  // if (pageIndex >= numPage) {}
                  for (var i = 0; i < numPage; i++) {
                    if (pageIndex == i) {
                      int endNumber = (i + 1) * EVERY_PAGE_GRID_COUNT;
                      if (endNumber >= itmeList.length) {
                        endNumber = itmeList.length;
                      }
                      showList = itmeList
                          .getRange(i * EVERY_PAGE_GRID_COUNT, endNumber)
                          .toList();
                    }
                  }
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    //禁止滑动
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1 / 1,
                      crossAxisCount: 2,
                      //水平单个子Widget之间间距
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: itemWidth,
                      //垂直单个子Widget之间间距
                      crossAxisSpacing: 35.0,
                    ),
                    // itemCount: itmeList.length,
                    itemCount: showList.length,
                    itemBuilder: (BuildContext context, int index) {
                      //自定义的行 代码在下面
                      // return _showGridViewItem(
                      // context, itmeList[pageViewNumber + index]);

                      return _showGridViewItem(context, showList[index]);
                    },
                  );
                },
                pagination: const SwiperPagination(
                  margin: EdgeInsets.all(5.0),
                  builder: DotSwiperPaginationBuilder(
                      color: CustomColors.lightTransparentBlue,
                      activeColor: CustomColors.lightBlue,
                      size: 4,
                      activeSize: 4),
                ),
              ),
            ),
            const SizedBox(
              height: 94,
            ),
            WidgetTools().createMaterialButton(
                buttoneWidth,
                "进入",
                flag ? Colors.blue : CustomColors.lightTransparentBlue,
                Colors.white,
                0, () {
              if (flag == true) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    // builder: (context) => new NewsDetailsPage(newsId: 50),
                    // builder: (context) =>
                    //     new CompanyDerailsPage(companyId: 1),
                    // builder: (context) => new SearchPage(),
                    // builder: (context) => new CompanyRankingPage(),
                    builder: (context) => const CompanyHomePage(),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Text _titleText(String titleStr) {
    TextStyle style = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return Text(
      titleStr,
      style: style,
    );
  }

  Widget _showGridViewItem(BuildContext context, Map temp) {
    String isSelected = temp["isSelected"].toString();
    String bgImagePath = isSelected == "0"
        ? "assets/images/scpanybg.png"
        : "assets/images/sedcpanybg.png";
    String iconPath = isSelected == "0"
        ? "assets/images/sIcon.png"
        : "assets/images/sedIcon.png";
    Container iconImage = Container(
      width: 108,
      height: 108,
      child: SvgPicture.asset(
        bgImagePath,
      ),
    );
    return InkWell(
      //用inkWell是为了添加点击事件
      onTap: () {
        flag = true;
        for (var item in itmeList) {
          item["isSelected"] = "0";
        }
        Map a = temp;
        a["isSelected"] = "1";
        setState(() {});
      },
      child: Container(
        width: 108,
        height: 108,
        decoration: BoxDecoration(
          //背景
          image: DecorationImage(
            image: AssetImage(bgImagePath),
            fit: BoxFit.fill, // 完全填充
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            //一个图标
            Row(
              children: [
                Expanded(child: SizedBox()),
                Image(
                  image: AssetImage(iconPath),
                ),
                const SizedBox(
                  width: 9,
                ),
              ],
            ),
            //一个文本
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                temp["name"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
