import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/back_check_company_manager.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/pages/modules/company/new_company_details.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// *
/// -  @Date: 2022-06-27 16:36
/// -  @LastEditTime: 2022-06-27 16:36
/// -  @Description: 新的 公司排行榜
///
class CompanyRnkingNewPage extends StatefulWidget {
  const CompanyRnkingNewPage({Key? key}) : super(key: key);

  @override
  State<CompanyRnkingNewPage> createState() => _CompanyRnkingNewPageState();
}

class _CompanyRnkingNewPageState extends State<CompanyRnkingNewPage> {
  //当前页
  int currentPage = 0;

  //每页多少条
  int pageSize = 10;

  //公司列表
  List<BackCheckCompanyListItemModel> companyList = [];

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
      "type": 2,
    };
    BackCheckCompanyManager.list(pame, (listModel) {
      setState(() {
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;

        pageSize = liModel.pageSize;
        currentPage = liModel.currentPage;
        companyList = liModel.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.whiteBlueColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              const Image(
                image: AssetImage("assets/images/Rnkingtop.png"),
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 16,
                      bottom: 49,
                    ),
                    child: const Text(
                      "排行榜",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2, 3.0),
                            blurRadius: 4.0,
                            color: CustomColors.lightBlue,
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///表头
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Text("排名"),
                        SizedBox(
                          width: 22,
                        ),
                        Text("名称"),
                        Expanded(child: SizedBox()),
                        Text("评分"),
                      ],
                    ),
                  ),
                  _buildCompanyRankingList(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ListView
  Widget _buildCompanyRankingList() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            itemBuilder: (context, index) {
              BackCheckCompanyListItemModel model = companyList[index];
              return _showListViewItem(context, index, model);
            },
            itemCount: companyList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  Widget _showListViewItem(
      BuildContext context, int index, BackCheckCompanyListItemModel model) {
    ///item分割线
    Container line = Container(
      height: 1,
      color: CustomColors.lightGreyF4,
    );

    Color borderColor;

    /// 排名
    Widget icon;
    if (index < 3) {
      if (index == 0) {
        icon = const Image(
          image: AssetImage(
            "assets/images/2.0x/排行一.png",
          ),
          fit: BoxFit.fill,
        );
        borderColor = CustomColors.borderYColor;
      } else if (index == 1) {
        icon = const Image(
          image: AssetImage(
            "assets/images/2.0x/排行二.png",
          ),
          fit: BoxFit.fill,
        );
        borderColor = CustomColors.borderGreyColor;
      } else {
        icon = const Image(
          image: AssetImage(
            "assets/images/2.0x/排行三.png",
          ),
          fit: BoxFit.fill,
        );
        borderColor = CustomColors.borderBColor;
      }
    } else {
      borderColor = CustomColors.lightGrey;
      icon = Text((index + 1).toString());
    }

    ///logo
    ImageProvider image;
    String companyImagePath = model.logo;
    // model.logo;
    if (companyImagePath.isEmpty) {
      image = const AssetImage("assets/images/logo.png");
    } else {
      image = NetworkImage(companyImagePath);
    }
    Container iconContainer = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: CustomColors.shadowColor,
            offset: Offset(0, 0),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Image(
          image: image,
          fit: BoxFit.fitWidth,
        ),
      ),
    );

    Text companyNameText = Text(
      model.name,
      style: const TextStyle(
        fontSize: 14.0,
      ),
      maxLines: 2,
    );

    // Container

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (context) =>
                new NewCompanyDerailsPage(companyId: model.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 11, right: 16, top: 15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 33,
                  height: 33,
                  alignment: Alignment.center,
                  child: icon,
                ),
                const SizedBox(
                  width: 16,
                ),
                iconContainer,
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 9.0, right: 9),
                    child: companyNameText,
                  ),
                ),
                Text(
                  model.score.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: CustomColors.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            line,
          ],
        ),
      ),
    );
  }
}
