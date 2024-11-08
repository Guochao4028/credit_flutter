import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/report_home_manager.dart';
import 'package:credit_flutter/models/company_report_home_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/pages/modules/report/new_report_details_page.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

/// *
/// -  @Date: 2023-03-09 14:48
/// -  @LastEditTime: 2023-03-09 14:48
/// -  @Description: 我的历史报告
///
///
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  ///当前页
  int cPage = 1;

  ///每页10条
  int pageSize = 10;

  ///用户名称
  String uName = "";

  ///数据
  List<CompanyReportHomeData> dataList = [];

  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    UmengCommonSdk.onPageEnd("history_page");

    UserModel.getInfo((model) {
      if (model != null) {
        uName = model.userInfo.idCardName;
      }
    });
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    UmengCommonSdk.onPageEnd("history_page");
  }

  ///初始化数据
  void initData() {
    Map<String, dynamic> pame = {
      "userType": 2,
      "pageNum": cPage,
      "pageSize": pageSize,
    };
    ReportHomeManager.getPersonList(pame, (object) {
      setState(() {
        CompanyReportHomeBean bean = object as CompanyReportHomeBean;
        if (cPage == 1) {
          dataList.clear();
          _controller.finishRefresh(IndicatorResult.success);
          if (dataList.length < 10) {
            _controller.finishLoad(IndicatorResult.noMore);
          }
        } else {
          if (dataList.length < 10) {
            _controller.finishLoad(IndicatorResult.noMore);
          } else {
            _controller.finishLoad(IndicatorResult.success);
          }
        }

        Iterable<CompanyReportHomeData> tempList =
            bean.data.where((element) => element.authorizationStatus == 1);
        dataList.addAll(tempList);
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "我的历史报告",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (dataList.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 102),
        width: double.infinity,
        child: const Column(
          children: [
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
      return Listener(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: _buildRefresh(),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRefresh() {
    return EasyRefresh(
      controller: _controller,
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      child: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            CompanyReportHomeData itemModel = dataList[index];
            return _showListViewItem(context, itemModel, ScreenTool.screenWidth,
                () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewReportDetailsPage(
                    reportId: itemModel.reportId ?? "",
                    authId: itemModel.reportAuthId.toString(),
                  ),
                ),
              );
            });
          },
          itemCount: dataList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  Widget _showListViewItem(
    BuildContext context,
    CompanyReportHomeData data,
    double itemWidth,
    listItemAction,
  ) {
    var createTime = DateTime.fromMillisecondsSinceEpoch(data.createTimeTs);
    String timeStr =
        "查询时间 ：${createTime.year}-${createTime.month}-${createTime.day} ${createTime.hour}:${createTime.minute}:${createTime.second}";

    Text nameText = Text(
      "$uName${data.reportType == 5 ? "（基础信息）" : ""}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      ),
      maxLines: 1,
    );

    Text introductionText = const Text(
      "员工背调报告",
      style: TextStyle(
        fontSize: 13.0,
        color: CustomColors.darkGrey99,
      ),
    );

    Text timeText = Text(
      timeStr,
      style: const TextStyle(
        fontSize: 13.0,
        color: CustomColors.darkGrey99,
      ),
    );

    String directionStr = "assets/images/svg/back.svg";

    ///箭头
    SizedBox direction = SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        directionStr,
        fit: BoxFit.fill,
      ),
    );

    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 20),
      margin: const EdgeInsets.only(top: 10),
      width: itemWidth,
      height: 104,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: InkWell(
        onTap: listItemAction,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  nameText,
                  const SizedBox(
                    height: 11,
                  ),
                  introductionText,
                  timeText,
                ],
              ),
            ),
            direction,
          ],
        ),
      ),
    );
  }

  Future _onRefresh() async {
    cPage = 1;
    initData();
  }

  Future _onLoad() async {
    cPage++;
    initData();
  }
}
