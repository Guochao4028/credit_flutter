/// *
/// -  @Date: 2022-07-01 17:40
/// -  @LastEditTime: 2022-07-01 17:40
/// -  @Description: 公司收藏
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:credit_flutter/pages/modules/company/new_company_details.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyCollectionPage extends StatefulWidget {
  const CompanyCollectionPage({Key? key}) : super(key: key);

  @override
  State<CompanyCollectionPage> createState() => _CompanyCollectionPageState();
}

class _CompanyCollectionPageState extends State<CompanyCollectionPage> {
  //公司列表
  List<BackCheckCompanyListItemModel> companyList = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
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
    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      GestureDetector(
        onTap: listItemAction,
        child: SizedBox(
          width: itemWidth,
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10),
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
    ]);
  }

  // 初始化数据
  void _initData() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList =
          sp.getStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION_COMPANY);
      if (strList != null) {
        List<BackCheckCompanyListItemModel> modelList = [];
        for (var i = 0; i < strList.length; i++) {
          String str = strList[i];
          Map tem = StringTools.json2Map(str);
          BackCheckCompanyListItemModel model = BackCheckCompanyListItemModel(
            tem["id"],
            tem["introduction"],
            tem["logo"],
            tem["name"],
            tem["productName"],
            tem["score"],
            tem["commentCount"] ?? 1,
          );
          modelList.add(model);
        }
        companyList = modelList;
        setState(() {});
      }
    });
  }

  Widget _buildBody() {
    if (companyList.isEmpty) {
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
            BackCheckCompanyListItemModel itemModel = companyList[index];
            return _showListViewItem(
                context, companyList[index], ScreenTool.screenWidth - 24, () {
              Navigator.of(context)
                  .push(
                    new MaterialPageRoute(
                      builder: (context) =>
                          new NewCompanyDerailsPage(companyId: itemModel.id),
                    ),
                  )
                  .then((val) => val ? _initData() : null);
            });
          },
          itemCount: companyList.length,
          shrinkWrap: true,
        ),
      );
    }
  }
}
