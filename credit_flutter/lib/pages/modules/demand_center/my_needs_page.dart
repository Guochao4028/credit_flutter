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
import 'package:credit_flutter/models/my_needs_bean.dart';
import 'package:credit_flutter/pages/modules/demand_center/edit_eequirements_page.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/event_bus.dart';
import 'package:credit_flutter/utils/popup_window.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../manager/demand_center_manager.dart';

class MyNeedsPage extends StatefulWidget {
  const MyNeedsPage({Key? key}) : super(key: key);

  @override
  State<MyNeedsPage> createState() => _MyNeedsPageState();
}

class _MyNeedsPageState extends State<MyNeedsPage> implements ClickListener {
  final EasyRefreshController _controller = EasyRefreshController();

  int total = 0;

  //当前页
  int pageNum = 1;

  List<MyNeedsData> dataList = [];

  //1:删除  2:从新发布
  int type = 0;

  @override
  void initState() {
    super.initState();
    _initData();
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
              "我的需求",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
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
            return WidgetTools().myNeedsItem(context, data, DateTime.now(), () {
              if (data.status == 3) {
                return;
              }
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => EditRequirementsPage(
                    data: data,
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
              //从新发布
              type = 2;
              _showDialog(data.id.toString(), "重新发布");
            }, () {
              //删除
              type = 1;
              _showDialog(data.id.toString(), "确定要删除吗，删除后任务需要重新发布");
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
    DemandCenterManager.getDemandCenterMyList(pame, (bean) {
      var data = bean as MyNeedsBean;

      if (pageNum == 1) {
        _controller.finishRefresh();
        _controller.resetLoadState();
        dataList.clear();
      }
      dataList.addAll(data.data);
      if (dataList.length < (pageNum * 10)) {
        // 没有更多
        _controller.finishLoad(success: true, noMore: true);
      } else {
        _controller.finishLoad(success: true, noMore: false);
      }
      setState(() {});
    });
  }

  void _showDialog(String id, String content) {
    showDialog(
        context: context,
        builder: (context) {
          return PopupWindowDialog(
            contentEdgeInsets: const EdgeInsets.only(left: 15, right: 15),
            title: "提示",
            confirm: "确认",
            cancel: "取消",
            content: content,
            identity: id,
            clickListener: this,
          );
        });
  }

  @override
  void onCancel() {}

  @override
  void onConfirm(Map<String, dynamic> confirmMap) {
    var id = confirmMap["identity"];
    if (type == 1) {
      DemandCenterManager.demandCenterMyDelete(id, (data) {
        ToastUtils.showMessage("删除成功");
        pageNum = 1;
        _initData();
      });
    } else {
      DemandCenterManager.demandCenterMyResubmit(id, (data) {
        ToastUtils.showMessage("重新发布成功");
        bus.emit("add_release", data);
        pageNum = 1;
        _initData();
      });
    }
  }
}
