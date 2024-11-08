/// *
/// -  @Date: 2022-08-19 11:22
/// -  @LastEditTime: 2022-09-27 13:41
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-16 14:24
/// -  @LastEditTime: 2022-09-19 14:02
/// -  @Description:首页
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/demand_center_bean.dart';
import 'package:credit_flutter/models/demand_details_bean.dart';
import 'package:credit_flutter/models/user_model.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../manager/demand_center_manager.dart';
import 'demand_details_page.dart';

class DemandCenterPage extends StatefulWidget {
  const DemandCenterPage({Key? key}) : super(key: key);

  @override
  State<DemandCenterPage> createState() => _DemandCenterPageState();
}

class _DemandCenterPageState extends State<DemandCenterPage> {
  final EasyRefreshController _controller = EasyRefreshController();

  int total = 0;

  //当前页
  int pageNum = 1;

  List<DemandCenterData> dataList = [];

  var userId = "";

  @override
  void dispose() {
    super.dispose();
    Log.d("dispose");
    bus.off("add_release");
  }

  @override
  void deactivate() {
    super.deactivate();
    Log.d("deactivate");
  }

  @override
  void initState() {
    super.initState();

    UserModel.getInfo((model) {
      if (model != null) {
        userId = model.userInfo.id.toString();
      }
    });
    _initData();
    bus.on("add_release", (arg) {
      var bean = DemandDetailsBean.fromJson(arg);
      doesItExist(bean);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorEDF6F6,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "需求中心",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: EasyRefresh(
        header: WidgetTools().getClassicalHeader(),
        footer: WidgetTools().getClassicalFooter(),
        controller: _controller,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        child: ListView.builder(
          itemBuilder: (context, index) {
            var data = dataList[index];
            return WidgetTools().demandCenterItem(context, data, () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => DemandDetailsPage(
                    id: data.id.toString(),
                    userId: userId,
                  ),
                ),
              )
                  .then((value) {
                if (value != null) {
                  pageNum = 1;
                  _initData();
                }
              });
            }, () {
              _launchUrl("tel:${data.phone}");
            });
          },
          itemCount: dataList.length,
          shrinkWrap: true,
        ),
      ),
    );
  }

  Future _onRefresh() async {
    pageNum = 1;
    _initData();
  }

  Future _onLoad() async {
    pageNum++;
    _initData();
  }

  // 初始化数据
  void _initData() async {
    Map<String, dynamic> pame = {
      "pageNum": pageNum,
      "pageSize": 10,
    };
    DemandCenterManager.getDemandCenterList(pame, (bean) {
      var data = bean as DemandCenterBean;

      if (pageNum == 1) {
        _controller.finishRefresh();
        _controller.resetLoadState();
        dataList.clear();
      }
      dataList.addAll(data.data);
      if (dataList.length >= (pageNum * 10)) {
        // 没有更多
        _controller.finishLoad(success: true, noMore: true);
      } else {
        _controller.finishLoad(success: true, noMore: false);
      }
      setState(() {});
    });
  }

  Future<void> _launchUrl(String uri) async {
    if (!await launchUrl(Uri.parse(uri))) {
      throw 'Could not launch $uri';
    }
  }

  doesItExist(DemandDetailsBean bean) {
    bool doesItExist = false;
    for (var data in dataList) {
      if (data.id == bean.id) {
        data.budget = bean.budget;
        data.createTime = 0;
        data.days = bean.days;
        data.description = bean.description;
        data.phone = bean.phone;
        data.reportDetail = bean.reportDetail;
        data.status = bean.status;
        data.title = bean.title;
        data.userId = bean.userId;
        data.validTime = bean.validTime;
        doesItExist = true;
      }
    }
    if (!doesItExist) {
      //列表不存在
      var data = DemandCenterData(
        bean.budget,
        0,
        bean.days,
        bean.description,
        bean.id,
        bean.phone,
        bean.reportDetail,
        bean.status,
        bean.title,
        bean.userId,
        bean.validTime,
      );
      dataList.insert(0, data);
    }
    setState(() {});
  }
}
