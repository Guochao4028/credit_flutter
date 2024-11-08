/// *
/// -  @Date: 2022-06-09 19:18
/// -  @LastEditTime: 2022-06-20 11:15
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-09 19:18
/// -  @LastEditTime: 2022-06-19 11:08
/// -  @Description:
///
import 'package:credit_flutter/manager/back_check_company_manager.dart';
import 'package:credit_flutter/models/back_check_company_list_model.dart';
import 'package:flutter/material.dart';

import '../../../tools/screen_tool.dart';
import '../../../tools/widget_tool.dart';
import 'company_details.dart';

/*** 
 * @Date: 2022-06-09 10:29
 * @LastEditTime: 2022-06-15 16:49
 * @Description: 公司排名
 */

class CompanyRankingPage extends StatefulWidget {
  const CompanyRankingPage({Key? key}) : super(key: key);

  @override
  State<CompanyRankingPage> createState() => _CompanyRankingPageState();
}

class _CompanyRankingPageState extends State<CompanyRankingPage> {
//公司排行列表
  List<BackCheckCompanyListItemModel> companyRankingList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Map<String, dynamic> pame = {
      "pageNum": 1,
      "pageSize": 10,
    };
    BackCheckCompanyManager.list(pame, (listModel) {
      setState(() {
        BackCheckCompanyListModel liModel =
            listModel as BackCheckCompanyListModel;
        companyRankingList = liModel.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "排行榜",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 12, right: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return WidgetTools().showListViewItem(
                  context,
                  companyRankingList[index],
                  ScreenTool.screenWidth - 24,
                  true,
                  true,
                  index.toString(), () {
                BackCheckCompanyListItemModel model = companyRankingList[index];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        new CompanyDerailsPage(companyId: model.id),
                  ),
                );
              });
            },
            itemCount: companyRankingList.length,
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }
}
